# Changelog

This file documents all notable changes to the GEOS-Chem repository starting in version 14.0.0, including all GEOS-Chem Classic and GCHP run directory updates.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased 14.2.0]
### Added
- Added a printout of GEOS-Chem species and indices
- Added `NcdfUtil/README.md` file directing users to look for netCDF utility scripts at https://github.com/geoschem/netcdf-scripts
- Restored sink reactions for HOI, IONO, IONO2 (fullchem, custom mechanisms)
- S(IV) + HOBr and S(IV) + HOCl reactions to `KPP/fullchem/fullchem.eqn`
- Added setting in GCHP setCommonRunSettings.sh to require species in restarts
- Added setting in GCHP HISTORY.rc to control whether output can be overwritten
- Activated nitrate photolysis
- Added `LightingClimatology` option to HEMCO_Config.rc
- Added run configuration files for WRF-GC
- Added new files `photolysis_mod.F90`, `phot_container_mod.F90`, and `fjx_interface_mod.F90`
- Added photolysis toggle in `geoschem_config.yml` and `Input_Opt` variable Do_Photolysis
- Added speed of light and Planck's constant to PhysConstants module
- Added `GFED4_CLIMATOLOGY` option to HEMCO_Config.rc

### Changed
- Most printout has been converted to debug printout (toggled by `debug_printout: true` in `geoschem_config.yml`
- `HEMCO_Config.rc` template files now use `Verbose: true` to toggle debug printout
- Turn on sea salt debromination via switches in `HEMCO_config.rc`
- If KPP integration fails, reset to prior concentrations and set `RSTATE(3) = 0` before retrying
- Suppress integration errors after 20 errors have been printed to stdout
- Simplified and added comments for bimolecular reactions in clouds in function CloudHet2R
- `HEMCO_Config.rc` and `ExtData.rc` templates now point `HEMCO/GFED4/v2023-03`
- Updated GCHP carbon simulation Global Cl and P(CO) inputs to use 14.0.0 files
- Write GCHP restart files directory to Restarts subdirectory
- Rename GCHP mid-run checkpoint files to standard GEOS-Chem restart format
- Rules for species in restarts files are now the same in GCHP as in GC-Classic
- Moved parts of `CMN_FJX_Mod.F90` not used in original Fast-JX to new container State_Chm%Phot
- Restructured photolysis to create generic photolysis module, interface with Fast-JX, and module containing original Fast-JX analogous to Cloud-J
- Moved UVFlux diagnostics out of JValues collection and into new collection called UVFlux
- In the user registration process:
  - Now ask for both first and last names of the user
  - Now state that user registration is needed for GEOS-Chem support
- Updated `HEMCO_Config.rc` templates to read HEMCO restarts from the `Restarts` rundir folder
- In fullchem simulations, set CO2 to 421 ppm (avg global conc in 2022) everywhere
- Updated CH4 simulation to use CH4 loss frequencies from GCClassic 14.0.0 10-year benchmarks instead of GMI
- Updated CH4 global anthropogenic emission inventory from EDGARv6 to EDGARv7
- Updated `AUTHORS.txt` for version 14.2.0
- Updated links in `README.md` to point to `http://geos-chem.org`

### Removed
- `Warnings: 1` is now removed from `HEMCO_Config.rc.*` template files
- Removed the `NcdfUtil/perl` folder
- Removed `X-HRS` output from log file
- IONO2 recycling (fullchem, custom mechanisms)
- Deleted unused file set_prof_o3.F90

### Fixed
- Fixed typo in `GCClassic/createRunDir.sh` preventing benchmark run script from being copied to the run directory
- Fixed divide by zero bug in sulfur chemistry introduced in 14.1.0
- Updates for 0.5 x 0.625 degree GCClassic integration & parallel tests
  - Use `CYS` in `HEMCO_Config.rc` so that missing species in `GC_BCs` will not stop simulations
  - Tests now run for 20 model minutes instead of an hour
- Fixed divide by zero bug in sulfur chemistry introduced in 14.1.0
- Restore seasalt alkalinity to heterogeneous acid-catalyzed reactions of halogens on seasalt aerosols.
- Fixed GCHP `HISTORY.rc` issue preventing running with over 3000 cores
- Fixed GCHP `ExtData.rc` error in tagged ozone simulation
- Fixed GCHP `HISTORY.rc` issue preventing diagnostic file overwrite
- Update GCHP interactive run script to fix error handling silent bugs
- Rewrote subroutine calls in `carbon_mod.F90` and `seasalt_mod.F90` to prevent array temporaries.
- Prevent repeated printing of KPP integrate errors to the stdout stream.
- Fixed selection of troposphere-stratosphere boundary in `global_ch4_mod.F90`
- Removed operator splitting in CH4 simulation that was biasing diagnostics

## [14.1.1] - 2023-03-03
### Added
- New integration test functions in `test/GCClassic/integration` and `test/GCHP/integration`
- New parallelization test functions in `test/GCClassic/parallel`
- Added `README.md` files for integration and parallelization tests in the `test` folder structure
- Added GCHP integration test for the tagO3 simulation
- Added GCHP and GCClassic integration tests for the carbon simulation
- Integration and parallelization test folders have been separated into subdirectories to minimize clutter.
- GEOS-only updates
- Add `about` to GitHub issue templates (ensures they will be displayed)
- Added `.github/ISSUE_TEMPLATE/config.yml` file w/ Github issue options

### Changed
- GCClassic integration tests now use a single set of scripts
- GCHP integration tests now use a single set of scripts
- Integration test run directories are created with the default names assigned by `createRunDir.sh`
- Several bash functions in `test/shared/commonFunctionsForTests.sh` have been combined so that they will work for both GCClassic and GCHP integration tests
- `./cleanRunDir.sh` functions now take an argument for non-interactive execution (facilitates integration & parallelization tests)
- Moved several module variables from `GeosCore/ucx_mod.F90` to `Headers/state_chm_mod.F90`.  This facilitates using GEOS-Chem in CESM.
- Time cycle flags EFYO are changed to CYS for all GCClassic integration/parallel tests, and for GCClassic fullchem_benchmarksimulations.
- Ask users for the name of their research institution at registration
- Ask users for the name of their PI at registration
- Do not compile GCHP for tagO3 integration tests; use the default build instead
- Moved GC-Classic sample run scripts to operational_examples/harvard_cannon
- The GitHub PR template is now named `./github/PULL_REQUEST_TEMPLATE.md`

### Fixed
- Fixed bug in where writing species metadata yaml file write was always attempted
- Prevent a warning from being generated when compiling `gckpp_Jacobian.F90`
- Fixed a bug in routine GET_IJ where X and Y were swapped in an IF comparison.
- Fixed bug in GFAS pFe by applying work-around in config files


### Removed
- Removed `intTest*_slurm.sh`, `intTest_*lsf.sh`, and `intTest*_interactive.sh` integration test scripts
- Removed State_Met%LWI and input meteorology LWI from carbon simulation run config files
- Removed function `CLEANUP_UCX`; deallocations are now done in `state_chm_mod.F90`

## [14.1.0] - 2023-02-01
### Added
- Added dry deposition updates to Hg0 from Feinberg22 ESPI publication + AMAP emissions
- Added MO2 + NO3 = NO2 + CH2O + HO2 reaction
- Added capability to write species metadata to YAML file
- Added satellite diagnostic (SatDiagn) collection, to archive several fields within a user-defined local-time interval. CAVEAT: For now, only one local-time interval is permitted.
- Added adaptive solver (`rosenbrock_autoreduce`) option for fullchem mechanism
- Added entries for BALD, BENZP, BZCO3H, NPHEN to JValues collection in HISTORY.rc for GCHP
- Added GCHP run script and environment files for MIT clusters Hex and Svante
- Added operational GCHP and GCClassic environment and run scripts for the University of York cluster, Viking
- Added tagO3 run directory for GCHP
- Added upwards mass flux diagnostic to GCHP History collection LevelEdgeDiags
- Added timestep menu to GCHP `geoschem_config.yml` template files
- Added HTAPv3 inventory as a global emissions option (off by default)
- Added carbon simulation and KPP mechanism for CO-CO2-CH4-OCS
- Added GCHP run script and environment file for UCI Australia cluster Gadi
- Added GFAS entries in GCHP config file ExtData.rc

### Changed
- Moved in-module variables in global_ch4_mod.F90 to State_Chm
- Moved in-module variables in hco_interface_gc_mod.F90 to State_Met and State_Chm
- Modified SpeciesConc diagnostic to include option to output units in v/v or molec/cm3
- Rebuilt fullchem and Hg mechanisms with KPP 3.0.0
- Changed HEMCO timecycle flag for QFED and offline emissions from EF to EFY
- Updated the time refresh settings for `O3_PROD` and `O3_LOSS` in `ExtData.rc.tagO3` to read data on the first of each month.

### Fixed
- Fixed sign of Arrhenius "A" coefficient in reaction ETO = HO2 + 2CH2O
- Fixed products in HOBr + SO2 and HOCl + SO2 reactions
- Changed MW_g value of CH4 from 16.05 to 16.04
- Added "WD_CoarseAer:true" for SO4s and NITs in species_database.yml
- Fixed bug in computing State_Met surface type logicals (IsLand, IsWater, etc)
- Fixed bug where State_Met%FRSNO (fraction snow) was all zeros in GCHP
- Fixed HCFC141b and HCFC142b names in GCHP HISTORY.rc
- Fixed list of complex SOA species checked in input_mod.F90
- Now use a string array for reading the list of ObsPack diagnostic species (in `GeosCore/input_mod.F90`)
- Fixed bug in logic that caused restart files not to be linked to the Restarts/ folder of the GCHP tagO3 run directory
- Fixed timestamp for GCClassic History diagnostic so time-averaged collections match the reference time
- Fixed double-titration of seasalt alkalinity
- Fixed bug in GFAS pFe by applying work-around in config files

### Removed
- Removed LRED_JNO2 and AERO_HG2_PARTITON switches from HEMCO_Config.rc (and related code)

## [14.0.2] - 2022-11-29
### Fixed
- Added fix for writing dry-run header to log file
- Updated KPP diagnostics archive flags
- Rewrote code to avoid memory leaks (identified by the code sanitizer)
- Updated EDGAR v6 CH4 emission files to correct timestamp issue
- Updated CH4 Lakes emission files to correct time unit issue
- Added fix for CH4_RICE emissions from EDGAR v6
- Fixed indentation error in the `legacy_bpch` section of `geoschem_config.yml` template files
- Removed "dry air" from the metadata of fields `State_Met%AIRVOL` and `State_Met%BXHEIGHT`
- Applied fixes for CESM runs: Turned off sea salt emissions; Modified time cycle flag for YUAN_MODIS_LAI

### Changed
- Updated CESM HISTORY.rc to work with new CESM-GC diagnostics interface
- Updated sample fullchem restart files copied to run directories to 14.0.0 10-year benchmark output


### Changed
- Use met-field surface type fractions instead of input land-water-ice (LWI) index

### Removed
- Removed State_Met%LWI and LWI as a met-field input

## [14.0.1] - 2022-10-31
### Fixed
- Corrected units in metadata for State_Met%AirNumDen and State_Met%PHIS
- Fixed file path for AEIC2019_DAILY emissions for aerosol-only simulations
- Fixed GCHP bug to populate non-species data in mid-run restart files
- Fixed typo preventing ND51 satellite diagnostic from turning on

### Changed
- Documented and cleaned up GCHP run script operational examples
- Updated README.md and AUTHORS.txt
- Set species concentration arrays as pointers to internal state in GCHP
- Updated Restart collection in HISTORY.rc to save out BXHEIGHT and TROPLEV for all simulations


## [14.0.0] - 2022-10-25
### Added
- Added user registration with dynamodb database during run directory creation
- Added Hg simulation with KPP
- Added yaml-format config file geoschem_config.yml which replaces input.geos
- Added native GEOS-FP and mass fluxes options to GCHP run directory creation
- Added cap_restart file to GCHP run directories to set simulation start time
- Added updates for compatibility with CESM, GEOS, and WRF-GC

### Fixed
- Fixed missing output boundary conditions on first timestep of run
- Added missing entries for POG1, POG2, and pFe to HEMCO_Config.rc
- Reverted GC-Classic pressure fixer to v13.3 to fix bug in v13.4
- Fixed dry deposition of methanol over oceans
- Fixed issues in creating run directory for GCAP2
- Removed duplicate species for SO4 in aciduptake.eqn
- Fixed CEDS_CO2_SHP emissions in HEMCO_Config.rc file for CO2 simulation
- Fixed Volcano_Table entry in HEMCO config template for GCHP
- Fixed transport tracers simulation in GCHP
- Applied fix to avoid divide-by-zero in routine MMR_Compute_FLux
- Fixed HEMCO diagnostic counter zero warnings in full chemistry simulation
- Fixed bug in totalOC diagnostic
- Fixed bugs causing differences when splitting up GC-Classic and GCHP simulations in time
- Fixed bug setting GEOS-FP meteorology in GCHP run directories

### Changed
- Updated KPP to version 2.5.0
- Updated GCHP run scripts to easily segment runs in time
- Changed GCHP restart filename convention to exclude seconds
- Updated offline biogenic VOC and soil NOx emissions
- Reduced root logging level for MAPL from INFO to WARNING
- Changed 4D State_Chm%Species array to vector of 3D concentration arrays
- Renamed GCHP config file runConfig.sh to setCommonRunSettings.sh
- Moved restart file location in run directory to Restarts subdirectory
- Updated sample restart files copied to run directories to 14.0.0 1-year benchmark output

### Removed
- Removed TMPU1, SPHU1, PS1_WET, and PS1_DRY from GC-Classic restart file
- Removed input.geos; replaced with geoschem_config.yml
- Removed HEMCO.log output file; HEMCO log info now sent to main GEOS-Chem log