### Changes in version 1.9.6 (2022-01-28)
+ Addressed warning for non-ascii in cell_info2

### Changes in version 1.9.5 (2022-01-26)
+ Updated lincs_pert_info2 and cell_info2

### Changes in version 1.9.3 (2021-12-17)
+ Supported searching against the newest LINCS 2020 beta database in 
devel version
+ Modified gess_* functions to support adding customized compound annotation 
table to the GESS result table.

### Changes in version 1.9.2 (2021-12-06)
+ Move `eh` to .onLoad function 

### Changes in version 1.7.3 (2021-08-24)
+ Improved `get_targets` function by supporting different output format.

### Changes in version 1.7.2 (2021-06-14)
+ Supported automatic downloads of ExperimentHub cached files.

### Changes in version 1.5.8 (2021-05-18)
+ Added FDA phase and other information to `lincs_pert_info` from ChEMBL db.

### Changes in version 1.5.7 (2021-05-03)
+ Added `donor_sex` column in cell info 

### Changes in version 1.5.6 (2021-04-24)
+ Added `PCID` column in GESS results

### Changes in version 1.5.3 (2021-04-12)
+ Created `cellNtestPlot` function to visualize number of compounds tested in 
cell types along with primary site information
+ Added `get_treat_info` function to get the treatment information in reference database 
including `pert`, `cell`, `pert_type` columns.
+ Supported `setReadable` function and `readable` argument in TSEA functions to 
convert Entrez id to gene Symbols in the itemID column in the enrichment result table.

### Changes in version 1.5.3 (2021-03-18)
+ Supported dtnetplot on Reactome pathway

### Changes in version 1.5.2 (2021-02-22)
+ Supported 3 enrichment methods in TSEA on Reactome pathway

### Changes in version 1.2.4 (2020-08-14)
+ Supported defining gene set database from score matrix by setting higher, lower,
as well as padj cutoffs for gCMAP and Fisher GESS methods

### Changes in version 1.2.2 (2020-07-11)
+ Supported converting gmt file to HDF5 file (01 matrix) as gene set reference 
database for gCMAP and Fisher GESS methods

### Changes in version 1.0.6 (2020-04-19)
+ Supported searching refdb parallelly by using multiple cores on a single machine

### Changes in version 1.0.5 (2020-04-10)
+ Fix bug: fixed null issue and throw warning messages when up or down gene 
sets share zero identifiers with refdb for `gess_lincs` method. 

### Changes in version 1.0.4 (2020-04-02)
+ Added instructions for GESS batch queries in vignette
+ Added runWF function to run entire GESS/FEA workflow

### Changes in version 1.0.3 (2020-02-07)
+ Supported converting `feaResult` object to `enrichResult` object in the
`clusterProfiler` package so that the plotting functionalities in the latter 
package such as dotplots and gene-concept networks could be applied to the
FEA enrichment results
+ Supported searching against subset of refdb (subsetted specific columns 
(treatments) in the refdb (e.g. lincs)) for GESS methods
+ Updated `comp_fea_res` function to reduce number of characters in description
+ Added functions to draw different types of query GESs from refdb
+ Added deprof2subexpr function to get a subset of gene expression values from 
a differential expression profile

### Changes in version 1.0.2 (2020-01-21)
+ Fix bug: the enrichment results from DSEA methods and some of TSEA methods
were added an aditional 'ont' column where the GO itmes were subsetted to the 
selected ontology

### Changes in version 1.0.1 (2019-11-10)
+ Support windows by not depending `gCMAP` package
+ Deal with HDF5 files with functions in `HDF5Array` package

### Changes in version 1.0.0 (2019-10-23)
+ Initial version 

### Changes in version 0.99.20 (2019-10-22)
+ Submitted to Bioconductor
+ Major changes
  - used HDF5 file to read and write the matrix in batches
  - data stored in ExperimentHub
