#!/bin/bash

#------------------------------------------------------------------------------
#                  GEOS-Chem Global Chemical Transport Model                  !
#------------------------------------------------------------------------------
#BOP
#
# !MODULE: integrationTest.sh
#
# !DESCRIPTION: Runs integration tests on the various GCHP run directories
# (interactively, or with a scheduler).
#\\
#\\
# !CALLING SEQUENCE:
#  ./integrationTest.sh -d root-dir -e env-file [-h] [-p partition] [-q] [-s scheduler]
#
#  Where the command-line arguments are as follows:
#
#    -d root-dir  : Specify the root folder for integration tests
#    -e env-file  : Specify the environment file (w/ module loads)
#    -h           : Display a help message
#    -p partition : Select partition for SLURM or LSF schedulers
#    -q           : Run a quick set of integration tests (for testing)
#    -s scheduler : Specify the scheduler (SLURM or LSF)
#
#  NOTE: you can also use the following long name options:
#
#    --directory root-dir  (instead of -d root-directory)
#    --env-file  env-file  (instead of -e env-file      )
#    --help                (instead of -h               )
#    --partition partition (instead of -p partition     )
#    --quick               (instead of -q               )
#    --scheduler scheduler (instead of -s scheduler     )
#EOP
#------------------------------------------------------------------------------
#BOC

#=============================================================================
# Initialize
#=============================================================================
this="$(basename ${0})"
usage="Usage: ${this} -d root-directory -e env-file [-h] [-p partition] [-s] [-q]"
itRoot="none"
envFile="none"
scheduler="none"
sedCmd="none"
quick="no"

#=============================================================================
# Parse command-line arguments
# See https://www.baeldung.com/linux/bash-parse-command-line-arguments
#=============================================================================

# Call Linux getopt function to specify short & long input options
# (e.g. -d or --directory, etc).  Exit if not succesful
validArgs=$(getopt --options d:e:hp:qs: \
  --long directory:,env-file:,help,partition:,quick,scheduler: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

# Parse arguments and set variables accordingly
eval set -- "${validArgs}"
while [ : ]; do
    case "${1}" in

	# -d or --directory specifies the root folder for tests
	-d | --directory)
	    itRoot="${2}"
            shift 2
            ;;

	# -e or --env-file specifies the environment file
	-e | --env-file)
	    envFile="${2}"
            shift 2
            ;;

	# -h or --help prints a help message
	-h | --help)
            echo "$usage"
            exit 1
            ;;

	# -p or --partition replaces REQUESTED_PARTITION with the user's choice
	-p | --partition)
	    sedCmd="s/REQUESTED_PARTITION/${2}/"
	    shift 2
	    ;;

	# -q or --quick runs a quick set of integration tests (for testing)
	-q | --quick)
	    quick="yes"
            shift
	    ;;
	
	# -s or --scheduler selects the scheduler
	-s | --slurm)
	    scheduler="${2^^}"
            shift 2
            ;;

	--) shift;
            break
            ;;
    esac
done

# Error check integration tests root path
if [[ "x${itRoot}" == "xnone" ]]; then
    echo "ERROR: The integration test root directory has not been specified!"
    echo "${usage}"
    exit 1
fi

# Error check environment file
if [[ "x${envFile}" == "xnone" ]]; then
    echo "ERROR: The enviroment file (module loads) has not been specified!"
    echo "${usage}"
    exit 1
fi

# Exit if no partition has been selected for SLURM
if [[ "x${scheduler}" == "xSLURM" && "x${sedCmd}" == "xnone" ]]; then
    echo "ERROR: You must specify a partition for SLURM."
    echo "${usage}"
    exit 1
fi

# Exit if no partition has been selected for SLURM
if [[ "x${scheduler}" == "xLSF" && "x${sedCmd}" == "xnone" ]]; then
    echo "ERROR: You must specify a partition for LSF."
    echo "${usage}"
    exit 1
fi

#=============================================================================
# Load file with utility functions to setup configuration files
#=============================================================================

# Current directory
thisDir=$(pwd -P)

# Load common functions
. "${thisDir}/commonFunctionsForTests.sh"

#=============================================================================
# Create integration test directories in the root folder
#=============================================================================

# Convert integration test root folder to an absolute path
itRoot=$(absolute_path "${itRoot}")

# Create GEOS-Chem run directories in the integration test root folder
./integrationTestCreate.sh "${itRoot}" "${envFile}" "${quick}"
if [[ $? -ne 0 ]]; then
   echo "ERROR: Could not create integration test run directories!"
   exit 1
fi

# Change to the integration test root folder
if [[ -d "${itRoot}" ]]; then
    cd "${itRoot}"
else
    echo "ERROR: ${itRoot} is not a valid directory!  Exiting..."
    exit 1
fi

#=============================================================================
# Compile the code and run the integration tests
#=============================================================================
if [[ "x${scheduler}" == "xSLURM" ]]; then

    #-------------------------------------------------------------------------
    # Integration tests will run via SLURM
    #-------------------------------------------------------------------------

    # Remove LSF #BSUB tags
    sed_ie '/#BSUB -q REQUESTED_PARTITION/d' "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#BSUB -n 8/d'                   "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#BSUB -W 01:30/d'               "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#BSUB -o lsf-%J.txt/d'          "${itRoot}/integrationTestCompile.sh"
    sed_ie \
	'/#BSUB -R "rusage\[mem=8GB\] span\[ptile=1\] select\[mem < 1TB\]"/d' \
	"${itRoot}/integrationTestCompile.sh"
    sed_ie \
	"/#BSUB -a 'docker(registry\.gsc\.wustl\.edu\/sleong\/esm\:intel\-2021\.1\.2)'/d" \
	"${itRoot}/integrationTestCompile.sh"
    sed_ie '/#BSUB -q REQUESTED_PARTITION/d' "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#BSUB -n 24/d'                  "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#BSUB -W 3:30/d'                "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#BSUB -o lsf-%J.txt/d'          "${itRoot}/integrationTestExecute.sh"
    sed_ie \
	'/#BSUB -R "rusage\[mem=90GB\] span\[ptile=1\] select\[mem < 2TB\]"/d' \
	"${itRoot}/integrationTestExecute.sh"
    sed_ie \
	"/#BSUB -a 'docker(registry\.gsc\.wustl\.edu\/sleong\/esm\:intel\-2021\.1\.2)'/d" \
	"${itRoot}/integrationTestExecute.sh"

    # Replace "REQUESTED_PARTITION" with the partition name
    sed_ie "${sedCmd}" "${itRoot}/integrationTestCompile.sh"
    sed_ie "${sedCmd}" "${itRoot}/integrationTestExecute.sh"

    # Submit compilation tests script
    output=$(sbatch integrationTestCompile.sh)
    output=($output)
    cmpId=${output[3]}

    # Submit execution tests script as a job dependency
    output=$(sbatch --dependency=afterok:${cmpId} integrationTestExecute.sh)
    output=($output)
    exeId=${output[3]}

    echo ""
    echo "Compilation tests submitted as SLURM job ${cmpId}"
    echo "Execution   tests submitted as SLURM job ${exeId}"

elif [[ "x${scheduler}" == "xLSF" ]]; then

    #-------------------------------------------------------------------------
    # Integration tests will run via LSF
    #-------------------------------------------------------------------------

    # Remove SLURM #SBATCH tags
    sed_ie '/#SBATCH -c 8/d'                   "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH -N 1/d'                   "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH -t 0-01:30/d'             "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH -p REQUESTED_PARTITION/d' "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH --mem=8000/d'             "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH -p REQUESTED_PARTITION/d' "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH --mail-type=END/d'        "${itRoot}/integrationTestCompile.sh"
    sed_ie '/#SBATCH -c 24/d'                  "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#SBATCH -N 1/d'                   "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#SBATCH -t 0-03:30/d'             "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#SBATCH -p REQUESTED_PARTITION/d' "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#SBATCH --mem=90000/d'            "${itRoot}/integrationTestExecute.sh"
    sed_ie '/#SBATCH --mail-type=END/d'        "${itRoot}/integrationTestExecute.sh"

    # Replace "REQUESTED_PARTITION" with the partition name
    sed_ie "${sedCmd}" "${itRoot}/integrationTestCompile.sh"
    sed_ie "${sedCmd}" "${itRoot}/integrationTestExecute.sh"

    # Submit compilation tests script
    output=$(bsub integrationTestCompile.sh)
    output=($output)
    cmpId=${output[1]}
    cmpId=${cmpId/<}
    cmpId=${cmpId/>}

    # Submit execution tests script as a job dependency
    output=$(bsub -w "exit(${cmpId},0)" integrationTestExecute.sh)
    output=($output)
    exeId=${output[1]}
    exeId=${exeId/<}
    exeId=${exeId/>}

    echo ""
    echo "Compilation tests submitted as LSF job ${cmpId}"
    echo "Execution   tests submitted as LSF job ${exeId}"

else

    #-------------------------------------------------------------------------
    # Integration tests will run interactively
    #-------------------------------------------------------------------------

    # Run compilation tests
    echo ""
    echo "Compiliation tests are running..."
    ./integrationTestCompile.sh

    # Change back to this directory
    cd "${thisDir}"

fi

#=============================================================================
# Cleanup and quit
#=============================================================================

# Free local variables
unset cmpId
unset envFile
unset exeId
unset itRoot
unset quick
unset output
unset scheduler
unset thisDir

# Free imported variables
unset FILL
unset SEP_MAJOR
unset SEP_MINOR
unset CMP_PASS_STR
unset CMP_FAIL_STR
unset EXE_PASS_STR
unset EXE_FAIL_STR
#EOC
