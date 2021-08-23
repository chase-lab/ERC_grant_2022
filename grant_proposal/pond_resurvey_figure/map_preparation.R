library(ggplot2)
library(sf)

# map preparation script
df <- read.csv("./grant_proposal/pond_resurvey_figure/resampling_sites.csv", encoding = "UTF-8")

df$Latitude <- parzer::parse_lat(df$Latitude)
df$Longitude <- parzer::parse_lon(df$Longitude)

sp::coordinates(df) <- ~Longitude+Latitude

# Converting data ----
mp <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), agr = "constant")
mp <- sf::st_sf(mp,  crs = 4326, agr = "constant")

# Plotting maps ----
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

theme_set(theme_bw())

disp_win_wgs84 <- st_sfc(st_point(c(-168, -54)), # xmin, ymin
                         st_point(c(180, 78)), # xmax, ymax
                         crs = 4326
)
sf::sf_use_s2(TRUE)
ggplot() +
  geom_sf(data = world, bg = "lightgray") +
  geom_sf(data = mp, shape = -as.hexmode("2605"), col = "red", size = 5) + # hexadecimal unicode
  # coord_sf(
  #   xlim = st_coordinates(disp_win_wgs84)[, "X"],
  #   ylim = st_coordinates(disp_win_wgs84)[, "Y"]
  # ) +
  coord_sf(crs = st_crs('+proj=wag6 +lat_0=90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m no_defs')) +
  theme_gray() +
  theme(
    panel.grid.major = element_line(
      color = gray(.5), size = 0.5), #, linetype = 'dashed'
    panel.ontop = FALSE,
    panel.background = element_rect(fill = NA),
    legend.box = NULL
  )

