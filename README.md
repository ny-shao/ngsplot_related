ngsplot_related
===============

[ngs.plot](http://code.google.com/p/ngsplot/) is a useful visualization utility in the analysis of NGS data. Here are some scripts useful for the application of ngs.plot in the daily analysis.

Some of them are or will be part of ngs.plot, some of them just for the convenience of the daily usage.

* ngsplot_json.sh:

A script for the case that we need to plot multiple datasets with several gene lists, and one dataset per plot. An example of json config file is provided under misc folder.

[jq](http://stedolan.github.io/jq) is required to parse the json config file.

* genNormedNgsplotConfig.py:

A script to quickly generate configuration file needed by ngs.plot.

For example, current folder with these bam files:

```
FactorA.bam
FactorB.bam
FactorA_input.bam
FactorB_input.bam
```

```
> genNormedNgsplotConfig.py ./ > config.txt
> cat config.txt
FactorA.bam:FactorA_input.bam	-1	FactorA:FactorA_input
FactorB.bam:FactorB_input.bam	-1	FactorB:FactorB_input

```

* plotCorrGram.r:

A script to plot CorrGram of the matrix of the output from ngs.plot.

Installation:
Add bin to PATH, and ngs.plot installed.