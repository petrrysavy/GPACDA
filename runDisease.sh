#!/bin/bash
echo "$@"
start=`date +%s`

#ml R
Rscript runDiseases.R "$@"

end=`date +%s`
runtime=$((end-start))
echo "Runtime of the program: $runtime s"
