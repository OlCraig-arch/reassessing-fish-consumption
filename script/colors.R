# ============================================================
# Shared colour palette for all figures
# Reassessing prehistoric fish consumption - Journal of Archaeological Science
# ============================================================
#
# Built entirely on the 8-colour Okabe-Ito qualitative palette
# (Okabe & Ito 2008, "Color Universal Design"), which is colorblind-safe
# and holds up well when figures are printed in greyscale.
#
# Source this file at the top of every Rmd (after library(here)) with:
#   source(here('script','colors.R'))
# so every figure in the manuscript draws from exactly the same colours.

# ---- Site colours (used for human sample points, aes(fill = Site)) ----
site_cols <- c(
  "Jabuticabeira II" = "#56B4E9",  # sky blue
  "Moraes"           = "#009E73",  # bluish green
  "Piaçaguera"       = "#E69F00",  # orange
  "Morro do Ouro"    = "#F0E442"   # yellow
)
site_order <- names(site_cols)

# ---- Faunal / dietary category colours (fauna points, aes(fill/colour = category)) ----
category_cols <- c(
  "marine_fauna"          = "#0072B2",  # blue
  "terrestrial_herbivore" = "#D55E00",  # vermillion
  "terrestrial_omnivore"  = "#CC79A7"   # reddish purple
)

# ---- Combined palette ----
# Several figures show fauna (coloured/filled by category) and humans (filled
# by Site) together in the same panel/legend, e.g. Fig3a-d in
# Figures_2_3_4_5_6.Rmd. Use this combined vector + order wherever both
# appear together.
combined_cols  <- c(site_cols, category_cols)
combined_order <- c(site_order, names(category_cols))

# ---- Reference / baseline producer category colours ----
# Used for the primary-producer "fingerprinting" reference database
# (C_fingerprinting.csv), shown as the x-axis marginal density curve (xdens)
# in Fig2d / Fig3d, grouped by the fine-grained `Category` column.
# NOTE: intuitive (not strictly Okabe-Ito) hues by request - red algae reads as
# red, green/terrestrial plants as two distinct greens, phytoplankton as blue.
ref_cols <- c(
  "C3_terrestrial_plant" = "#1B7837",  # dark green
  "phytoplankton"        = "#0072B2",  # blue
  "green algae"          = "#4DAF4A",  # medium green
  "brown algae"          = "#E69F00",  # orange
  "red algae"            = "#D7191C"   # red
)

# ---- Reference producer colours, coarser Group1 grouping ----
# Used for the N_fingerprinting.csv reference data, shown as the y-axis
# marginal density curve (ydens) in Fig2d / Fig3d, grouped by the coarser
# `Group1` column (Terrestrial plants / Phytoplankton / Macroalgae) rather
# than the finer `Category` column used for ref_cols. Terrestrial plants and
# Phytoplankton share ref_cols' colours (same Code: TP / Phyto) for visual
# consistency between the x- and y-density panels.
ref_group1_cols <- c(
  "Terrestrial plants" = "#1B7837",  # dark green (matches ref_cols TP)
  "Phytoplankton"      = "#0072B2",  # blue (matches ref_cols phytoplankton)
  "Macroalgae"         = "#E69F00"   # orange
)
