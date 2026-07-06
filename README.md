# reassessing-fish-consumption
R code to accompany the article "Reassessing prehistoric fish consumption in Southern Brazil"
Authors: Oliver E. Craig, Marjolein Admiraal, Annie Bones, Krista McGrath, Dione da Rocha Bandeira, Kerry Louise Sayle, Helen M. Talbot, André C. Colonese et al. 
The R code contained in this repository enables the replication of the analysis and modelling described in this paper.
All the data is available here. 
The repository consists of four folders:
- `data` - the raw data files (csv)
- `script` - the R scripts, as R Markdown (.Rmd), plus a shared colour palette (`colors.R`):
  - `Figures_2_3_4_5_6.Rmd` - produces the main manuscript figures (Fig2-Fig6); includes the MixSIAR/JAGS mixing model run
  - `Supplementary_figures.Rmd` - produces the supplementary figures (CSIA quality control, PCA)
- `figures` - the figures used in the article and supplementary material (SVG and PDF)
- `mixingmodel` - the input and output files for the mixing model

