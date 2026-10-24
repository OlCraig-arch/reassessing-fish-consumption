# reassessing-fish-consumption

R code and data to accompany the article "Reassessing prehistoric fish consumption in Southern Brazil"

Authors: Oliver E. Craig, Marjolein Admiraal, Annie Bones, Krista McGrath, Dione da Rocha Bandeira, Kerry Louise Sayle, Helen M. Talbot, André C. Colonese et al.

The R code contained in this repository enables the replication of the analysis and modelling described in this paper. All the data is available here.

## Repository structure

The repository consists of four folders:

- `data` - the input data files (csv/xlsx):
  - `Dataset_S1.csv` - sample-level bulk collagen, amino acid (δ13C, δ15N) and δ34S data for the human and faunal samples (supplementary Dataset S1)
  - `Dataset_S2.csv` - previously published bulk collagen data compiled for comparison in Fig 1B (supplementary Dataset S2)
  - `Site_coords.xlsx` - site coordinates used for the Fig 1A map
  - `C_fingerprinting.csv`, `N_fingerprinting.csv` - primary producer amino acid reference data (Δ13C Val-Phe and Δ15N Lys-Phe) shown as the marginal density curves in Fig 2D and Fig 3D
- `script` - the R scripts, as R Markdown (.Rmd), plus a shared colour palette (`colors.R`):
  - `Figures_2_3_4_5_6.Rmd` - produces the main manuscript figures (Fig1-Fig6); includes the MixSIAR/JAGS mixing model run
  - `Supplementary_figures.Rmd` - produces the supplementary figures (CSIA quality control, PCA)
  - `diagnostics.txt`, `summary_final.txt` - MixSIAR convergence diagnostics (Gelman-Rubin, Heidelberger-Welch, Geweke) and posterior summary from the model run reported in the paper; the script rewrites these when the model is re-run
- `figures` - the figures used in the article and supplementary material (SVG, PDF, PNG and EPS)
- `mixingmodel` - the input files for the mixing model (`Sources.csv`, `Discr.csv`, `Humans.csv`) and the merged model output (`Result_mix.csv`); `Figures_2_3_4_5_6.Rmd` writes all of these

## Running the code

Tested with R 4.5.1, JAGS 4.3.2 (required by MixSIAR) and MixSIAR 3.1.12 on macOS. Install [JAGS](https://mcmc-jags.sourceforge.io/) first, then the R packages used by the scripts:

```r
install.packages(c("cowplot", "dplyr", "geodata", "ggnewscale", "ggplot2", "ggpubr",
                   "ggrepel", "here", "janitor", "marmap", "MixSIAR", "png",
                   "R2jags", "readxl", "rnaturalearth", "scales", "sf", "terra",
                   "knitr", "rmarkdown"))
# not on CRAN - high-resolution coastline data used for Fig 1A
install.packages("rnaturalearthhires", repos = "https://ropensci.r-universe.dev")
```

1. Download or clone the repository and keep the folder structure intact. The scripts locate files with the `here` package, which uses the `.here` file in the repository root.
2. Run `script/Supplementary_figures.Rmd` (a few seconds) and `script/Figures_2_3_4_5_6.Rmd`.

Notes:

- `Figures_2_3_4_5_6.Rmd` takes about 30 minutes, almost all of it the MixSIAR "very long" MCMC run.
- The first run downloads SRTM elevation data (via `geodata`) and NOAA bathymetry (via `marmap`) for Fig 1A into `elevation_data/`, which is not tracked in git, so an internet connection is needed.
- Running the scripts overwrites the files in `figures/` and `mixingmodel/` and the MixSIAR output files in `script/`. In a test run from a fresh clone, the figures and model outputs were reproduced identically.

## Licence and citation

- Code (the R Markdown scripts and `colors.R` in `script/`) is released under the MIT licence (`LICENSE`).
- Data (`data/`, `mixingmodel/`) and figures (`figures/`) are released under the Creative Commons Attribution 4.0 International licence, CC BY 4.0 (`LICENSE-data`).
- Please cite this repository using `CITATION.cff` (GitHub shows a "Cite this repository" option) and the associated article.
