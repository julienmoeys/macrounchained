
[R][r] package for **batch simulation of substance properties 
and application patterns** with [MACRO][macro], a model of water 
flow and solute transport in macroporous soil, 
or with the **groundwater scenario** of its regulatory variant 
[MACRO In FOCUS][macroinfocus]. 
The package makes it possible to simulate **Nth-order 
metabolites**, including **[metabolites that are the degradation 
products of several substances](https://github.com/julienmoeys/macrounchained/blob/master/inst/more_tests/test_GW_10_multiple-paths.svg)** 
and cases where **several active substances give rise to the 
same metabolite**. The substance properties and application 
patterns that can be modified are currently those relevant 
for the groundwater scenario of MACRO In FOCUS.

*   **Development status**: pre-release. Do not use for 
    production purpose, as the interface may still evolve if 
    needed, and some bugs may have come unnoticed despite all 
    the tests.
    
*   **General information**: See [DESCRIPTION](DESCRIPTION) 
    (including author(s), package-version, minimum R version 
    required, ...).
    
*   **Change log**: See [NEWS](NEWS).
    
*   **Operating system**: `macrounchained` will only work on 
    Windows, because MACRO is a Windows-only 
    program.
    
*   **License**: MIT License. See [LICENSE](LICENSE).

*   Either MACRO 5.2 or MACRO In FOCUS 5.5.4 or both need to 
    be installed for using `macrounchained` (see below).



Features
============================================================

*   MACRO In FOCUS groundwater users just need to use one 
    R command, `macrounchained::macrounchainedFocusGW_ui()`.
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
    here https://github.com/julienmoeys/macrounchained/blob/master/inst/more_tests/test_GW_09_macro.r
    
*   Several sets of substance properties can be simulated 
    in the same batch (up to 998 sets per batch). The sets 
    of substance properties don't need to be related.
    
*   For MACRO users, several `.par`-file templates can be 
    used in the same batch of simulations.
    
*   **Nth-order metabolites** can be simulated (only limited by 
    the total number of simulations) and several degradation 
    products can be simulated for the same parent substance 
    (also limited by the total number of simulations), in the 
    same batch. It also possible to simulate [metabolites that 
    are the degradation product of several substances](https://github.com/julienmoeys/macrounchained/blob/master/inst/more_tests/test_GW_10_multiple-paths.svg). 
    The parent substances can be two or more metabolites 
    and / or two or more active substances. The so called 
    'intermediate simulations' are handled automatically by 
    the package.
    
*   Two higher order functions are provided: `macrounchained()`
    and `macrounchainedFocusGW()`. The first is a generic 
    functions, the workhorse of this package, while the 
    second is designed for MACRO In FOCUS groundwater
    simulations. `macrounchained::macrounchainedFocusGW_ui()` 
    is a simple text interface for `macrounchainedFocusGW()`.
    
*   `macrounchainedFocusGW()` analyses on-the-fly the simulation 
    results and provides the user with a summary of the results, 
    in a similar fashion as fashion as standard 
    **MACRO In FOCUS groundwater** simulations.
    
*   Currently only tested on **MACRO In FOCUS 5.5.4**.
    
*   The results of `macrounchainedFocusGW()` have been 
    successfully **tested against the results of the 
    "version control" of MACRO In FOCUS 5.5.4**, and give the 
    same PECgw for all the simulations included in the version 
    control. The function has also been successfully tested 
    against the results of MACRO In FOCUS 5.5.4 for other 
    cases (two application per year; two years interval 
    between applications; Swedish and Norwegian scemario). 
    The tests are "build-in" the package, 
    and they can be run each time an important change is 
    made to the package. The test results can be 
    checked here: https://github.com/julienmoeys/macrounchained/tree/master/inst/more_tests 
    See also the "Benchmarks" section below.
    
*   As the interface of MACRO In FOCUS only allow the 
    parametrization of 1st-order metabolites, the package 
    has only been tested for 1st-order metabolites. Results 
    of 2nd-order metabolites have not been compared with 
    a reference value, because of the lack of a public 
    benchmark.
    
*   `macrounchained()` and `macrounchainedFocusGW()` output 
    an **operation log** informing the users of the operations 
    being performed. `macrounchainedFocusGW()` also 
    output a summary of the simulation results (including 
    the PECgw) in the operation log, as well as in separate 
    files.
    
*   `macrounchained()` and `macrounchainedFocusGW()` produce 
    a **`tar.gz` archive** containing all the relevant input 
    and output files of the simulation batch. This can be 
    used as an archive by the user.
    
*   The packages do not include any MACRO executable, and 
    instead use an existing MACRO or MACRO In FOCUS installation. 
    The package does not include any climate files for the 
    Swedish and Norwegian scenario. The package does not make 
    use of MACRO In FOCUS Access databases.
    
*   Extensive traceability, with MACRO-version, packages-versions 
    and revision (i.e. a machine generated code linking the 
    package to the code version control system), but also with 
    MD5 checksum for the packages and MACRO-files, reported 
    to the user, so that it is in principle possible to check 
    if a simulation was performed with an official release of 
    the packages or of the MACRO executable, or not.



How it works
============================================================

`macrounchained` is an alternative interface to MACRO 5.2 or 
MACRO In FOCUS 5.5.4. It does not require any modification 
of the core models. It creates parameter files (`.par`-files) 
that are used by MACRO or MACRO In FOCUS, via the tool 
`exeparfile.exe`. The tool uses a template `.par`-file, and 
modifies the parameters related to the substance properties, 
the application date, the applied dose and (for MACRO In FOCUS) 
the number of years interval between application years. While 
MACRO users need to provide one or several template 
`.par`-files of their choice, via `macrounchained()`, MACRO 
In FOCUS do not need template `.par`-files, as these are 
included in the tool for each groundwater scenario (but not 
surface water scenario), via `macrounchainedFocusGW()` or 
`macrounchainedFocusGW_ui()`. The tool also includes a database 
of crop parameters for each groundwater scenario, and these 
parameters are set at the same time as substance parameters. 
MACRO In FOCUS users just need to specify the name of the 
scenario and the name of the crop.

Four types of simulations can be run:

*   Active substance, that is, the substance that is 
    applied on the field. This is the 'top parent'.
    
*   Intermediate simulation for an active substance (see 
    below).
    
*   Metabolite, that is a substance that is formed from 
    the degradation of one or several other substances. 
    The parent-substance can be active substances or 
    metabolites.
    
*   Intermediate simulation for a metabolite (see below).

The algorithm in `macrounchained` is generic, in the sense 
that there is no limitation to the order of the metabolite 
(primary, secondary, ternary, etc.) or to the number of 
metabolites formed from the degradation of a given 
parent-substance. Metabolites can also be the degradation 
products of several parent-substances, and the parent-substances 
can be either one or several active substances and/or one 
or several metabolite. The only limitation is the total 
number of model run, which can not be higher than 998.

Also, it is possible to simulate different, unrelated, 
substances and scenario in the same batch of simulations.



Primary metabolites (1st order metabolites)
------------------------------------------------------------

The simulation of metabolites in MACRO In FOCUS is done in three 
steps. 

*   A simulation is run for the parent substance. 
    It is not used for the metabolite, but provide output for 
    the substance leaching to groundwater.

*   The very same simulation is run a second time, but with 
    specific output variables: the mass of substance degraded 
    for each time step and each numerical layer in the soil 
    profiles. The output of that second run is called the 
    "intermediate" output-file (or intermediate `.bin`-file).

*   A simulation is prepared for the metabolite. It uses the 
    properties of the metabolite substance and a couple of 
    other specific parameters indicating that what is simulated 
    is a metabolite, not an active substance. Among other things, 
    that simulation will use the the "intermediate" output-file 
    to internally calculate the mass of metabolite formed at each 
    time step and in each numerical layer in the soil profiles. 
    This is done with a parameter called the "conversion factor" 
    (mass of metabolite formed per mass unit of parent degraded).

The conversion factor is equal to:
```
(M_metabolite/M_parent)*formation_fraction
```

where `M_metabolite` is the molar mass of the metabolite, 
`M_parent` is the molar mass of the parent and 
`formation_fraction` is the formation fraction of the metabolite 
(mol of metabolite formed per mol of parent degraded).

In `macrounchained`, and contrary to MACRO In FOCUS, the user 
indicates the formation fraction and the molar mass of the 
metabolite, as well as the molar mass of the parent, instead 
of giving directly the conversion factor. The conversion factor 
is calculated internally.



Nth order metabolites
------------------------------------------------------------

The case of Nth order metabolites (second order, third order, 
etc.) is the same as above, except that an "intermediate" 
simulation needs to be run for the "parent-metabolite" whose 
degradation produce a higher order metabolite.



Metabolites formed from the degradation of several parent-substances
------------------------------------------------------------

In the case of metabolites formed from the degradation of 
several parent-substances, things are handled differently from 
what is described above. In such a case, `macrounchained` 
is converting and merging the intermediate output files as 
follow:

*   The intermediate output file of each parent is imported:

*   The intermediate output file of each parent is converted 
    from "mass of parent-substance degraded at each time step 
    and in each numerical layer" to "mass of metabolite formed 
    from the degradation of the parent-substance at each time 
    step and in each numerical layer", using 
    the "conversion factor" mentioned above.
    
*   All converted intermediate output files are merged (i.e. 
    "summed" time step for time step and numerical layer 
    for numerical layer) into a single file that I call 
    the "intermediate input file". This file contains the 
    "total mass of metabolite formed from the degradation of 
    all its parent-substances at each time step and in each 
    numerical layer"
    
*   This "intermediate input file" is used as a driving file 
    for the simulation of the metabolite, exactly as if it 
    was a standard, "intermediate output file", except that 
    the "conversion factor" of the simulation is set to 1 in 
    the simulation's parameter-file (as the conversion has 
    already been done outside the model).



Determining the order of the simulations
------------------------------------------------------------

In `macrounchained`, the user can provide parameters of each 
substance in any order. That is, it is possible that the row 
containing the parameters of the metabolite is before the row 
containing the parameter of its parent substance. Nonetheless, 
`macrounchained` is internally reordering the substances (and 
the simulations to be run) so that the simulation of 
parent-substances is performed before the simulation of their 
metabolites. This is done with an iterative process.

Also, the package will 'group' the simulation of substances 
that share the same active substance.



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
of R may still _try_ to install and use the package. The package 
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
address: https://rpackages.julienmoeys.info/macrounchained/ 

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
[README](https://cran.r-project.org/web/packages/devtools/readme/README.html) 
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
[bootstrap](https://en.wikipedia.org/wiki/Bootstrapping).

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



tar.exe for archiving all input and output files
------------------------------------------------------------

`macrounchained()` and `macrounchainedFocusGW()` rely on the 
executable `tar.exe` to produce an archive containing all 
the input and output files generated during the operations.

`tar.exe` should be available on Windows 10 [from Build 17063](https://techcommunity.microsoft.com/t5/Containers/Tar-and-Curl-Come-to-Windows/ba-p/382409). 
If you have an older version of Windows, the archiving may not 
work (but `macrounchained()` will not crash, just issue a 
warning). If you don't know if `tar.exe` is installed on your 
computer, open Windows command prompt (`cmd.exe`) and type 
```
echo "%tar%"
```

If the command returns `"%tar%"`, then no tar executable is 
defined in Windows Environment Variables. You can then type:
```
where tar.exe
```

If the command returns 
`INFO: Could not find files for the given pattern(s).`, then 
`tar.exe` cannot be found in Windows `PATH` environment 
variable.

If `tar.exe` is not installed on your computer and you need 
the archive functionality, contact your system administrator 
to find a solution.



Swedish and Norwegian MACRO scenario
------------------------------------------------------------

The five Swedish and Norwegian MACRO scenario (Krusenberg, 
Önnestad, Näsbygård, Heia and Rustad) require specific 
climate-files that are not delivered with MACRO In FOCUS. 
These files are not included either in `macrounchained`, and 
need to be obtained separately. See the Northern Zone Guidance 
Document for more information.

On the other hand, it is not necessary to have the Access 
database with the Norwegian MACRO scenario (Heia and Rustad), 
as their parameters are included in `macrounchained`. More 
generally, `macrounchained` does not make use of MACRO In FOCUS 
Access-files.



Benchmarks
============================================================

In order to make sure that the package results are conform 
to the output of MACRO In FOCUS 5.5.4 or MACRO 5.2, a number 
of benchmarks have been prepared. In these benchmarks, the 
output of `macrounchainedFocusGW()` is compared to the output 
of MACRO In FOCUS (PECgw and water percolation).

These benchmarks can be run at anytime, and also aim at detecting 
mistakes that could be introduced in the code when it is further 
developed (for maintenance or new features).

In some cases it is was not possible to compare the output of 
`macrounchainedFocusGW()` with MACRO In FOCUS (secondary 
metabolites, multiple transformation pathways), and the 
benchmarks is only used to detect accidental drift from the 
original output.

In these benchmarks, the parameter files (`.par`-files) produced 
by `macrounchainedFocusGW()` or `macrounchained()` are 
compared to those produced by MACRO In FOCUS 5.5.4 or MACRO 
5.2. Some differences in the parameter files have been noticed, 
that are thought to be without consequences on the output. 
The benchmark make sure there are no more differences than 
what is expected.

For reasons that are not completely clear, some small differences 
have been noted in the output files. They could be due to 
a difference in the preparation of the `indump.tmp`-file 
produced by MACRO In FOCUS 5.5.4 or MACRO 5.2 and that 
produced by the `exeparfile.exe`. Small differences may 
also be possible in the way the results are aggregated for 
each "period" (yearly flows when the pesticide is applied 
every year). In the benchmarks, the PECgw 
produced by `macrounchainedFocusGW()` are the same as those 
produced by MACRO In FOCUS 5.5.4, when rounded to three significant 
figures, but a case has been observed where the third digit 
of the PECgw differed from that of MACRO In FOCUS 5.5.4. In 
the later case, it was observed that several years had very 
close yearly-average concentrations, resulting in a different 
ranking that that obtained by  MACRO In FOCUS 5.5.4.

The benchmarks and their results are available here: 
https://github.com/julienmoeys/macrounchained/tree/master/inst/more_tests



Official FOCUS "version control"
------------------------------------------------------------

*   Châteaudun-scenario, winter cereals, application every 
    year with substances "GW-A", "GW-B", "GW-C", "Met_C" and 
    "GW-D". "Met_C" is a primary metabolite of "GW-C". All 
    these substances are so called FOCUS dummy substances.
    
*   Châteaudun-scenario, potatoes, application every 
    third year with substance "GW-D".



Other benchmarks
------------------------------------------------------------

*   Châteaudun-scenario, potatoes, application every 
    second year with substance "GW-D".
    
*   Châteaudun-scenario, winter cereals, two applications 
    per year, every year, with substance "GW-A".
    
*   Châteaudun-scenario, winter cereals, application every 
    year with a new dummy substance, GW-M, a primary metabolite 
    "Met-M1" and a secondary metabolite "Met-M2".
    
*   The three Swedish scenario (non FOCUS), Krusenberg, 
    Önnestad and Näsbygård, with spring oilseed rape, 
    grass and pome/ stone fruits, respectively, and substances 
    "GW-A", "GW-B" and "GW-C", respectively.
    
*   The two Norwegian scenario (non FOCUS), Rustad and Heia, 
    with spring cereals and legumes, respectively, and 
    substances "GW-A" and "GW-B", respectively.
    
*   Default simulation in MACRO 5.2, two year simulations, 
    with the default crop and an application every year. 
    "GW-C" and "Met_C" were simulated, and their overall 
    average leaching concentration was calculated. Notice 
    that metabolites cannot be parametrised in MACRO 5.2, 
    so the comparison only concerns the parent.
    
*   Châteaudun-scenario, spring cereals, application every 
    year with two new dummy active substance, GW-M and GW-N 
    (representing the hypothetical case of two active 
    substances included in the same plant protection product). 
    The degradation pathway can be virtualised here: 
    [inst/more_tests/test_GW_10_multiple-paths.svg](https://github.com/julienmoeys/macrounchained/blob/master/inst/more_tests/test_GW_10_multiple-paths.svg).
    GW-M has three metabolites, "Met-M0", "Met-M1" and "Met-M2", 
    and GW-N has two metabolites, "Met-N1" and "Met-N2". 
    "Met-M2" and "Met-N2" are in fact the same substance, 
    and is the degradation product of "GW-M", "Met-M1" and 
    "Met-N1". The metabolite "Met-M1" is the degradation 
    product of "GW-M" and "Met-M0". "Met-M0" is the degradation 
    product of "GW-M", and "Met-N1" is the degradation product 
    of "GW-N".



Release history
============================================================

Please check the [online version of this page](https://github.com/julienmoeys/macrounchained/blob/master/README.md) 
to make sure the information is up to date, as the package will 
not include information on its own release.

For more information on the changes, see the [NEWS](NEWS)-files 
for `macrounchained` and for its dependencies 
([rmacrolite NEWS][NEWS_rmacrolite], [macroutils2 NEWS][NEWS_macroutils2] and 
[codeinfo NEWS][NEWS_codeinfo]).

_2019-05  (release 2):_

New versions of `macrounchained` and `codeinfo`

```
1 macrounchained  0.13.0  93b0f40    2019-05-26
2     rmacrolite   0.9.7  9a38321    2019-04-15
3    macroutils2   2.2.3  ef26fd7    2019-04-17
4       codeinfo   0.1.3  a595b27    2019-05-13
```


_2019-04 (release 1):_

```
         package version revision date_packaged
1 macrounchained  0.11.2  1fc0b86    2019-04-18
2     rmacrolite   0.9.7  9a38321    2019-04-15
3    macroutils2   2.2.3  ef26fd7    2019-04-17
4       codeinfo   0.1.2  c91f2f2    2019-04-17
```



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
[NEWS_rmacrolite]: https://github.com/julienmoeys/rmacrolite/blob/master/NEWS "rmacrolite NEWS" 
[NEWS_macroutils2]: https://github.com/julienmoeys/macroutils2/blob/master/NEWS "macroutils2 NEWS" 
[NEWS_codeinfo]: https://github.com/julienmoeys/codeinfo/blob/master/NEWS "codeinfo NEWS" 
