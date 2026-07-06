# =====================================================
# MAP OF SELECTED HUMAN ISOTOPE SITES
# Southern Brazil
# Includes topography with geodata/terra
# Includes ocean bathymetry with marmap
# Includes Brazil inset map
#
# Plotted sites:
# Piaçaguera
# Morro do Ouro
# Moraes
# Jabuticabeira II
# =====================================================

library(readxl)
library(ggplot2)
library(dplyr)
library(sf)
library(giscoR)
library(geodata)
library(terra)
library(marmap)
library(ggnewscale)
library(cowplot)
library(grid)

# =====================================================
# LOAD DATA
# =====================================================

human <- read_excel("human_isotopes.xlsx")

names(human) <- trimws(names(human))

# =====================================================
# OPTIONS: SELECT SITES
# =====================================================

selected_sites <- c(
  "Piaçaguera",
  "Morro do Ouro",
  "Moraes",
  "Jabuticabeira II"
)

# =====================================================
# OPTIONS: MANUAL MAP EXTENT
# Longitude = x axis
# Latitude  = y axis
# =====================================================

use_manual_extent <- TRUE

long_min <- -50
long_max <- -46

lat_min <- -29
lat_max <- -23

x_buffer <- 2
y_buffer <- 2

# =====================================================
# CLEAN DATA
# =====================================================

human_sites <- human %>%
  mutate(
    Site = trimws(as.character(Site)),
    Region = trimws(as.character(Region)),
    LAT = as.numeric(gsub(",", ".", LAT)),
    LONG = as.numeric(gsub(",", ".", LONG))
  ) %>%
  filter(
    Site %in% selected_sites,
    !is.na(Site),
    !is.na(Region),
    !is.na(LAT),
    !is.na(LONG)
  ) %>%
  distinct(Site, Region, LAT, LONG)

# Check selected sites
cat("Selected human sites retained:\n")
print(human_sites)

cat("\nSites not found in the spreadsheet:\n")
print(setdiff(selected_sites, unique(human_sites$Site)))

# =====================================================
# DEFINE MAP EXTENT
# =====================================================

if (use_manual_extent) {
  x_min <- long_min
  x_max <- long_max
  y_min <- lat_min
  y_max <- lat_max
} else {
  x_min <- min(human_sites$LONG, na.rm = TRUE) - x_buffer
  x_max <- max(human_sites$LONG, na.rm = TRUE) + x_buffer
  y_min <- min(human_sites$LAT, na.rm = TRUE) - y_buffer
  y_max <- max(human_sites$LAT, na.rm = TRUE) + y_buffer
}

# =====================================================
# VECTOR BORDERS
# =====================================================

countries <- c("BRA", "ARG", "URY", "PRY")

borders <- gisco_get_countries(
  country = countries,
  resolution = "01",
  update_cache = TRUE
)

brazil <- gisco_get_countries(
  country = "BRA",
  resolution = "01",
  update_cache = TRUE
)

# =====================================================
# TOPOGRAPHY WITH geodata + terra
# =====================================================

dir.create("elevation_data", showWarnings = FALSE)

topo <- geodata::elevation_30s(
  country = "BRA",
  path = "elevation_data"
)

topo <- terra::crop(
  topo,
  terra::ext(x_min, x_max, y_min, y_max)
)

topo_df <- as.data.frame(
  topo,
  xy = TRUE,
  na.rm = TRUE
)

colnames(topo_df)[3] <- "elevation"

# =====================================================
# BATHYMETRY
# =====================================================

bath <- marmap::getNOAA.bathy(
  lon1 = x_min,
  lon2 = x_max,
  lat1 = y_min,
  lat2 = y_max,
  resolution = 1
)

bath_df <- marmap::fortify.bathy(bath) %>%
  filter(z <= 0)

depth_breaks <- c(
  -5000, -4000, -3000, -2000, -1000,
  -500, -200, -100, -50, 0
)

bath_colours <- colorRampPalette(
  c("#08306b", "#2171b5", "#6baed6", "#deebf7")
)(length(depth_breaks) - 1)

# =====================================================
# REGION COLOURS
# =====================================================

human_region_colours <- c(
  "Babitonga Bay" = "#1f77b4",
  "Camacho-Jaguaruna-Laguna region" = "#2ca02c",
  "Guaratuba Bay" = "#d62728",
  "Maré Guaratiba Plain" = "#9467bd",
  "Paranaguá Bay" = "#8c564b",
  "Ribeira valley" = "#e377c2",
  "Santa Catarina Island and mainland" = "#7f7f7f",
  "Santos Coastal Plain" = "#bcbd22",
  "Saquarema" = "#17becf"
)

# =====================================================
# THEMES
# =====================================================

map_theme <- theme_minimal() +
  theme(
    axis.title = element_text(size = 11, colour = "black"),
    axis.text = element_text(size = 9, colour = "black"),
    axis.ticks = element_line(colour = "black"),
    panel.grid = element_line(colour = "grey85", linewidth = 0.2),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 0.5),
    plot.title = element_text(size = 13, hjust = 0.5),
    legend.title = element_text(size = 9),
    legend.text = element_text(size = 8),
    legend.position = "right"
  )

inset_theme <- theme_void() +
  theme(
    panel.border = element_rect(
      colour = "black",
      fill = NA,
      linewidth = 0.5
    ),
    plot.margin = unit(c(0, 0, 0, 0), "pt")
  )

# =====================================================
# BASE MAP
# =====================================================

base_map <- ggplot() +
  geom_tile(
    data = topo_df,
    aes(x = x, y = y, fill = elevation)
  ) +
  scale_fill_gradient(
    low = "#cde7ca",
    high = "#4b514a",
    name = "Elevation"
  ) +
  ggnewscale::new_scale_fill() +
  geom_contour_filled(
    data = bath_df,
    aes(x = x, y = y, z = z),
    breaks = depth_breaks,
    alpha = 0.75
  ) +
  scale_fill_manual(
    values = bath_colours,
    name = "Depth"
  ) +
  geom_sf(
    data = borders,
    fill = NA,
    colour = "black",
    linewidth = 0.4
  ) +
  coord_sf(
    xlim = c(x_min, x_max),
    ylim = c(y_min, y_max),
    expand = FALSE
  )

# =====================================================
# BRAZIL INSET MAP
# =====================================================

inset_map <- ggplot() +
  geom_sf(
    data = brazil,
    fill = "#cde7ca",
    colour = "#4b514a",
    linewidth = 0.25
  ) +
  geom_rect(
    aes(
      xmin = x_min,
      xmax = x_max,
      ymin = y_min,
      ymax = y_max
    ),
    colour = "red",
    fill = NA,
    linewidth = 0.8
  ) +
  coord_sf(
    xlim = c(-75, -32),
    ylim = c(-35, 6),
    expand = FALSE
  ) +
  inset_theme

# =====================================================
# HUMAN MAP — SELECTED SITES ONLY
# =====================================================

human_map_core <- base_map +
  ggnewscale::new_scale_fill() +
  geom_point(
    data = human_sites,
    aes(
      x = LONG,
      y = LAT,
      fill = Region
    ),
    shape = 21,
    size = 4.5,
    stroke = 0.55,
    colour = "black",
    alpha = 0.95
  ) +
  geom_text(
    data = human_sites,
    aes(
      x = LONG,
      y = LAT,
      label = Site
    ),
    nudge_y = 0.25,
    size = 3,
    colour = "black"
  ) +
  scale_fill_manual(
    values = human_region_colours,
    name = "Region"
  ) +
  labs(
    title = "Selected human isotope sites",
    x = "Longitude",
    y = "Latitude"
  ) +
  map_theme

# =====================================================
# ADD INSET TO MAP
# =====================================================

final_map <- ggdraw() +
  draw_plot(human_map_core) +
  draw_plot(
    inset_map,
    x = 0.68,
    y = 0.62,
    width = 0.23,
    height = 0.28
  )

final_map

# =====================================================
# SAVE
# =====================================================

ggsave(
  "selected_human_isotope_sites_southern_brazil_with_inset.png",
  final_map,
  width = 10,
  height = 8,
  dpi = 300
)

ggsave(
  "selected_human_isotope_sites_southern_brazil_with_inset.pdf",
  final_map,
  width = 10,
  height = 8
)