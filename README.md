[![Release](https://img.shields.io/github/v/release/geoschem/geos-chem?label=Latest%20Release)](http://wiki.geos-chem.org/GEOS-Chem_versions)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1343546.svg)](https://doi.org/10.5281/zenodo.1343546)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/geoschem/geos-chem/blob/master/LICENSE.txt)

## Modifications

This branch contains the __Hierarchical Shared Memory__ implementation for version 14.5.2, please follow [this link](https://github.com/Daisy0419/geos-chem/tree/shared_memory) for the implementation for the latest version.
To compile this version of __Hierarchical Shared Memory__, please:
1. Clone the source code using the following script adapted from [GCHP download instructions](https://gchp.readthedocs.io/en/14.5.2/user-guide/downloading.html).
```Bash
git clone https://github.com/geoschem/GCHP.git GCHP
cd GCHP
git checkout tags/14.5.2
git submodule set-url src/GCHP_GridComp/GEOSChem_GridComp/geos-chem https://github.com/Jordan-Sun/geos-chem.git
git submodule update --init --remote
```
2. Compile the code following the [GCHP compilation instructions](https://gchp.readthedocs.io/en/14.5.2/user-guide/compiling.html).

For other implementations, please see [Simulated-Chem](https://github.com/Jordan-Sun/simulated-chem/tree/refactor/v3) for instructions.

## Description

This repository contains the __GEOS-Chem science codebase__.  Included in this repository are:

  * The source code for GEOS-Chem science routines;
  * Scripts to create GEOS-Chem run directories;
  * Template configuration files that specify run-time options;
  * Scripts to run GEOS-Chem tests;
  * Driver routines (e.g. `main.F90`) that enable GEOS-Chem to be run in several different implementations (as GEOS-Chem "Classic", as GCHP, etc.)

### Version 12.9.3 and prior

GEOS-Chem 12.9.3 was the last version in which this "Science Codebase" repository was used in a standalone manner.

### Version 13.0.0 and later

GEOS-Chem 13.0.0 and later versions use this "Science Codebase" repository as a  submodule within the [GCClassic](https://github.com/geoschem/GCClassic) and [GCHP](https://github.com/geoschem/GCHP) repositories.

Releases for GEOS-Chem 13.0.0 and later versions will be issued at the [GCClassic](https://github.com/geoschem/GCClassic) and [GCHP](https://github.com/geoschem/GCHP) Github repositories. We will also tag and release the corresponding versions at this repository for the sake of completeness.

## User Manuals

Each implementation of GEOS-Chem has its own manual page.  For more information, please see:

* __GEOS-Chem "Classic":__ [https://geos-chem.readthedocs.io](https://geos-chem.readthedocs.io)

* __GCHP:__ [https://gchp.readthedocs.io](https://gchp.readthedocs.io)

* __WRF-GC:__ [http://wrf.geos-chem.org](http:/wrf.geos-chem.org)

* __Other documentation:__ [View related documentation @ Read TheDocs](https://geos-chem.readthedocs.io/en/latest/geos-chem-shared-docs/supplemental-guides/related-docs.html)

## About GEOS-Chem

GEOS-Chem is a global 3-D model of atmospheric chemistry driven by meteorological input from the Goddard Earth Observing System (GEOS) of the [NASA Global Modeling and Assimilation Office](http://gmao.gsfc.nasa.gov/). It is applied by [research groups around the world](http://geos-chem.org/people.html) to a wide range of atmospheric composition problems. Scientific direction of the model is provided by the international [GEOS-Chem Steering Committee](http://geos-chem.org/steering-committee.html) and by [User Working Groups](http://geos-chem.org/working-groups.html). The model is managed by the [GEOS-Chem Support Team](http://geos-chem.org/support-team.html), based at Harvard University and Washington University with support from the US NASA Earth Science Division, the Canadian National and Engineering Research Council, and the Nanjing University of Information Sciences and Technology.

GEOS-Chem is a grass-roots open-access model owned by its [users](http://geos-chem.org/people.html), and ownership implies some responsibilities as listed in our [welcome page for new users](http://geos-chem.org/welcome.html).
