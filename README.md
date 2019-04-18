
[R][r] package for **batch simulation of substance properties 
and application patterns** with [MACRO][macro], a model of water 
flow and solute transport in macroporous soil, 
or its regulatory variant [MACRO In FOCUS][macroinfocus], 
including simulation of **Nth-order metabolites**. 
The substance properties and application patterns that can 
be modified are currently those relevant for the groundwater 
scenario of MACRO In FOCUS.

*   **Development status**: pre-release. Do not use for 
    production purpose, as the interface may still evolve if 
    needed, and some bugs may I come unnoticed despite all 
    the tests.
    
*   **General information**: See [DESCRIPTION](DESCRIPTION) 
    (including author(s), package-version, minimum R version 
    required, ...).
    
*   **Change log**: See [NEWS](NEWS).
    
*   **Operating system**: `macrounchained` will only work on 
    Windows, because MACRO is a Windows-only 
    program.
    
*   **License**: MIT License. See [LICENSE](LICENSE).

Either MACRO or MACRO In FOCUS or both need to be installed 
for using `macrounchained` (see below).



Features
============================================================

*   MACRO In FOCUS groundwater users just need to use one 
    R command, `macrounchained::``macrounchainedFocusGW_ui()`.
    The command starts a text user interface that allows the 
    users to obtain a copy of example 
    Excel-files for the input-parameters, or to run 
    MACRO In FOCUS simulations after importing input parameters 
    from an Excel-file they have prepared. It is possible 
    to include multiple scenario, crops and substance 
    parameters sets (with or without metabolites). It is 
    also possible to simulate several applications per year and 
    applications every other or every third year. The 
    scenario currently included as Châteaudun, the three 
    Swedish scenario (Näsbygård, Önnestad and Krusenberg), 
    and the two Norwegian scenario (Heia and Rustad).

*   MACRO users need in the first place to export a template 
    `.par`-file (a text file containing the parameters for 
    a MACRO simulation) from MACRO, and 
    will use that template as an input for `macrounchained`
    to modify the substance properties and application 
    patterns (doses and application dates). 
    All other parameters such as those concerting the soil 
    properties, the climate, the crop or the number of applications 
    cannot be modified by `macrounchained`. MACRO users may 
    just use `macrounchained` to run MACRO simulations and 
    analyse the results separately, or use their own R 
    functions to analyse and summarise simulation results 
    'on the fly'. An example for MACRO 5.2 is available 
    here [inst\more_tests\test_GW_09_macro.r]()
    
*   Several sets of substance properties can be simulated 
    in the same batch (up to 998 sets per batch). The sets 
    of substance properties don't need to be related.
    
*   For MACRO users, several `.par`-file templates can be 
    used in the same batch of simulations.
    
*   **Nth-order metabolites** can be simulated (only limited by 
    the total number of simulations) and several degradation 
    products can be simulated for the same parent substance 
    (also limited by the total number of simulations), in the 
    same batch. It is nonetheless not possible to simulate 
    degradation products originating from several parent 
    substances. The so called 'intermediate simulations' are 
    handled automatically by the package.
    
*   Two higher order functions are provided: `macrounchained()`
    and `macrounchainedFocusGW()`. The first is a generic 
    functions, the workhorse of this package, while the 
    second is designed for MACRO In FOCUS groundwater
    simulations. `macrounchained::``macrounchainedFocusGW_ui()` 
    is a simple text interface for `macrounchainedFocusGW()`.
    
*   `macrounchainedFocusGW()` analyses on-the-fly the simulation 
    results and provides the user with a summary of the results, 
    in a similar fashion as fashion as standard 
    **MACRO In FOCUS groundwater** simulations.
    .
*   Currently only tested on **MACRO In FOCUS 5.5.4**.
    
*   The results of `macrounchainedFocusGW()` have been 
    successfully tested against the results of the 
    "version control" of MACRO In FOCUS 5.5.4, and give the 
    same PECgw for all the simulations included in the version 
    control. The function has also been successfully tested 
    against the results of MACRO In FOCUS 5.5.4 for other 
    cases (two application per year; two years interval 
    between applications; Swedish and Norwegian scemario). 
    The tests are "build-in" the package, 
    and they can be run each time an important change is 
    made to the package. The test results can be 
    checked here: [https://github.com/julienmoeys/macrounchained/tree/master/inst/more_tests][]
    
*   As the interface of MACRO In FOCUS only allow the 
    parametrization of 1st-order metabolites, the package 
    has only been tested for 1st-order metabolites. Results 
    of 2nd-order metabolites have not been compared with 
    a reference value, because of the lack of a public 
    benchmark.
    
*   `macrounchained()` and `macrounchainedFocusGW()` output 
    an operation log informing the users of the operations 
    being performed. `macrounchainedFocusGW()` also 
    output a summary of the simulation results (including 
    the PECgw) in the operation log, as well as in separate 
    files.
    
*   `macrounchained()` and `macrounchainedFocusGW()` produce 
    a `tar.gz` archive containing all the relevant input 
    and output files of the simulation batch. This can be 
    used as an archive by the user.
    
*   The packages do not include any MACRO executable, and 
    instead use an existing MACRO or MACRO In FOCUS installation.
    
*   Extensive traceability, with MACRO-version, packages-versions 
    and revision (i.e. a machine generated code linking the 
    package to the code version control system), but also with 
    MD5 checksum for the packages and MACRO-files, reported 
    to the user, so that it is in principle possible to check 
    if a simulation was performed with an official release of 
    the packages or of the MACRO executable, or not.



Installation
============================================================

End-users should manually install the package from Windows 
binary package (a `.zip`-archive). The binary package 
provided on the website indicated below are presumably 
stable versions of the package, for release or pre-release 
(see status above).

Experienced users and developers may prefer to install the 
development version of the package, from [GitHub][github]. 
The later should not be seen as a stable version and may 
not work at all.

Before you install the package, check in the 
[DESCRIPTION](DESCRIPTION)-file what is the minimum version 
of R needed to run this package (field "Depends", see 
"R (>= ...)"). For convenience, the minimum R version required 
has been set to R >= 3.1, so that user with an old version 
of R may still try to install and use the package. The package 
has nonetheless not been tested on that version, but instead 
on R 3.5.1 (at the time of writing this text). Some problems 
may therefore occur on older versions.

If needed, the code can be loaded as an R-script instead of 
installed as a package (see below), and used on any 
R-version presumably compatible with the code.



Installing the package from Windows binaries
------------------------------------------------------------

Windows binary-installer (a `.zip` file) and source tar of the 
package (a `.tar.gz` file) can be downloaded from the following 
address: https://rpackages.julienmoeys.info/macrounchained/.

Choose both the binary-installer for `macrounchained`, 
`rmacrolite`, `macroutils2` and `codeinfo`.

Save the files to a local folder on your computer.

As I cannot guarantee the integrity of the website above, 
it is recommended to scan the file(s) with an antivirus, not 
least if you work in a corporation or a public institution.

Do not unpack the `.zip` archive (nor the `.tar.gz` archive) 
before installing the package.

See also: https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Windows-packages 



_Method 1_ (R graphical user interface for Windows):

Open R graphical user interface for Windows. Click on the 
'Packages'-menu and select 'Install package(s) from local zip 
file...'. Select the package `.zip` binary package that you just 
downloaded, so that it is installed. 

When done, type
```
library("codeinfo)
library("macroutils2")
library("rmacrolite")
library("macrounchained")
```
to check if the installation was successful.



_Method 2_ (install the zip binary package using the command 
line):

Open R command line prompt or R graphical user interface for 
Windows and type:

```
install.packages( 
    pkgs = "C:/path/to/binary/file/codeinfo_x.y.z.zip", 
    repos = NULL ) 
install.packages( 
    pkgs = "C:/path/to/binary/file/macroutils2_x.y.z.zip", 
    repos = NULL ) 
install.packages( 
    pkgs = "C:/path/to/binary/file/rmacrolite_x.y.z.zip", 
    repos = NULL ) 
install.packages( 
    pkgs = "C:/path/to/binary/file/macrounchained_x.y.z.zip", 
    repos = NULL ) 
```

where `C:/path/to/binary/file/` should be replaced by 
the actual path to the folder where the binary package was 
downloaded and `codeinfo_x.y.z.zip`, `macroutils2_x.y.z.zip`, 
`rmacrolite_x.y.z.zip` and `macrounchained_x.y.z.zip` by the 
actual file-names (`x.y.z` being the version number, different 
for different packages). It is important to use a 
slash (`/`) as path separator, or alternatively a double 
backslash (`\\`), instead of a single backslash (`\`; Windows 
standard), as the later is a reserved character in R.



_Method 3_ (install the source package using the command 
line:

Open R command line prompt or R graphical user interface for 
Windows and type:

```
install.packages( 
    pkgs = "C:/path/to/source/file/codeinfo_x.y.z.tar.gz", 
    repos = NULL, type = "source" ) 
install.packages( 
    pkgs = "C:/path/to/source/file/macroutils2_x.y.z.tar.gz", 
    repos = NULL, type = "source" ) 
install.packages( 
    pkgs = "C:/path/to/source/file/rmacrolite_x.y.z.tar.gz", 
    repos = NULL, type = "source" ) 
install.packages( 
    pkgs = "C:/path/to/source/file/macrounchained_x.y.z.tar.gz", 
    repos = NULL, type = "source" ) 
```

where `C:/path/to/source/file/` should be replaced by 
the actual path to the folder where the source package was 
downloaded and `codeinfo_x.y.z.tar.gz`, `macroutils2_x.y.z.tar.gz`, 
`rmacrolite_x.y.z.tar.gz` and `macrounchained_x.y.z.tar.gz` 
by the actual file-name 
(`x.y.z` being the version number). See above the remark on 
the path separator.



Installing the package from GitHub
------------------------------------------------------------

This method is reserved for experienced R users and developers. 
If you don't know what you are doing, choose one of the 
installation method above.

The development version of `macroutils2` is publicly available 
on [GitHub][github] ([here][macroutils2]), as well as the 
development version of `rmacrolite` ([here][rmacrolite]) and 
`codeinfo` ([here][codeinfo]), 

to install the development version of the packages, you will 
need to install the package [devtools][] first. It is 
available on CRAN and can be easily installed. Simply type 
`install.packages("devtools")` in R command prompt. See also 
the package 
[README][https://cran.r-project.org/web/packages/devtools/readme/README.html] 
page.

You can then install the development version of `codeinfo`, 
`macroutils2` and `rmacrolite` by typing in R command prompt:

```
devtools::install_github("julienmoeys/codeinfo")
devtools::install_github("julienmoeys/macroutils2")
devtools::install_github("julienmoeys/rmacrolite")
devtools::install_github("julienmoeys/macrounchained")
```



Source the package as an R script instead of installing the package 
------------------------------------------------------------

It is also possible to source the package as an R-script instead 
of installing the package. This method has some drawbacks 
(help pages not available; R workspace polluted with many 
objects otherwise invisible to end-users; sourced-code may 
be accidentally modified by the user; lack of traceability), 
but may be useful to some users, for example with restricted 
possibilities to install new R packages, as a 
[bootstrap][https://en.wikipedia.org/wiki/Bootstrapping].

First, open the following `.r`-file 
https://raw.githubusercontent.com/julienmoeys/macrounchained/master/R/macrounchained.r 
and save it on your computer. This file contains the full 
R source code of the package.

Open R command line prompt or R graphical user interface for 
Windows and type:

```
library("codeinfo") 
library("macroutils2") 
library("rmacrolite") 
source( "C:/path/to/file/macrounchained.r" ) 
```

where `C:/path/to/file/` should be replaced by 
the actual path to the folder where the file was 
downloaded. See above the remark on the path separator.



About
============================================================

This package is a personal project of the author. It is not 
funded or supported by any corporation or public body.



Report issues
------------------------------------------------------------

Your are very welcome to report any (suspected) error or issue 
on this page: https://github.com/julienmoeys/macrounchained/issues 

Before reporting on this page, try to reproduce the issue on 
a generic example that you can provide together with your 
issue.



User Support
------------------------------------------------------------

Currently, I cannot provide user-support for this tool. In 
my experience, many questions are general R questions 
rather than questions specific to my R packages, so it may 
help to get support from an experienced R programmer.



Disclaimer
------------------------------------------------------------

This tool is **not an official or officious regulatory tool**.

It is **not endorsed** by [FOCUS DG SANTE][focusdgsante], 
[SLU/CKB][ckb] or the author's [employer][kemi]. 

It does not engage these institutions nor reflects 
any official position on regulatory exposure assessment. 

Indeed, the website of [FOCUS DG SANTE][focusdgsante] 
"_is the one and only definitive source of the currently 
approved version of the FOCUS scenarios and associated models 
and input files._". Thus, please refer to 
[FOCUS DG SANTE][focusdgsante] or to the competent authorities 
in each EU regulatory zone for guidance on officially accepted 
tools and methods.

As stated in the [LICENSE](LICENSE), the package is provided 
**without any warranty**.


<!-- LIST OF LINKS -->

[r]: https://www.r-project.org/ "The R Project for Statistical Computing"
[r_packages]: https://en.wikipedia.org/wiki/R_(programming_language)#Packages "R packages (Wikipedia)"
[macro]: https://www.slu.se/en/Collaborative-Centres-and-Projects/centre-for-chemical-pesticides-ckb1/models/macro-52/ "MACRO 5.2 (SLU/CKB)"
[macroinfocus]: https://esdac.jrc.ec.europa.eu/projects/macro "MACRO In FOCUS (FOCUS DG SANTE)"
[slu]: https://www.slu.se/ "Swedish University of Agricultural Sciences (SLU)"
[ckb]: https://www.slu.se/ckb "Centre for Chemical Pesticides (CKB)"
[codeinfo]: https://github.com/julienmoeys/codeinfo "R package codeinfo (GitHub)"
[macroutils2]: https://github.com/julienmoeys/macroutils2 "R package macroutils2 (GitHub)"
[rmacrolite]: https://github.com/julienmoeys/rmacrolite "R package rmacrolite (GitHub)"
[macrounchained]: https://github.com/julienmoeys/macrounchained "R package macrounchained (GitHub)"
[macroutils]: https://github.com/julienmoeys/macroutils "R package macroutils (GitHub)"
[github]: https://github.com/ "GitHub development platform"
[focusdgsante]: https://esdac.jrc.ec.europa.eu/projects/focus-dg-sante "FOrum for the Co-ordination of pesticide fate models and their USe"
[devtools]: https://CRAN.R-project.org/package=devtools "R package devtools (CRAN)"
[cran]: https://cran.r-project.org/ "The Comprehensive R Archive Network" 
[kemi]: https://www.kemi.se/en "Swedish Chemicals Agency"
