From rocker/verse

RUN Rscript -e "install.packages(c('gridExtra', 'reshape2', 'splines','tidyverse'))"

WORKDIR /workspace
