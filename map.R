# Generate data and map for lab website

# Libraries
library(tidyverse)
library(here)
library(plotly)
library(htmlwidgets)
library(htmltools)
library(ggmap)
library(ggrepel)

# Make list of points with coordinates
## Add PR AND SAUT
site_tibble <- 
  tibble::tibble(site = c("Macaé, Brazil",
                          "Ilha do Cardoso, Brazil",
                          "Regua, Brazil",
                          "Trinidad and Tobago",
                          "Ecuador",
                          "Pitilla, Costa Rica",
                          "Vancouver, Canada",
                          "Petit Saut, French Guyana",
                          "El Verde, Puerto Rico"),
                 lat = c(-22.2954,
                         -25.072,
                         -22.4529,
                         10.6923,
                         -0.615830,
                         10.983,
                         49.2636759,
                         5.0629,
                         18.29), 
                 lon = c(-41.4847,
                         -44.923,
                         -39.7703,
                         -61.2896,
                         -77.823843,
                         -85.433,
                         -123.2501258,
                         -53.0475,
                         -65.79),
                 lablat = c(-17,
                         -29,
                         -22.4529,
                         10.6923,
                         -0.615830,
                         10.983,
                         49.2636759,
                         5.0629,
                         18.29), 
                 lablon = c(-23,
                         -23,
                         -23,
                         -35,
                         -90,
                         -107,
                         -150,
                         -22,
                         -38),
                 links = c("https://blogs.ubc.ca/srivastavalab/2024/01/16/lab-life/#Brazil",
                           "https://blogs.ubc.ca/srivastavalab/2024/01/16/lab-life/#Brazil",
                           "https://blogs.ubc.ca/srivastavalab/2024/01/16/lab-life/#Brazil",
                           "https://www.pinterest.com/pin/225461525069110466/",
                           "https://www.pinterest.com/pin/bairds-tapir--288652657340015878/",
                           "https://www.pinterest.com/pin/55732114131130278/",
                           "https://i.kym-cdn.com/entries/icons/original/000/008/342/ihave.jpg",
                           "",
                           ""))
# HTML map ----------------------------------------------------------------
# Make map
map <- 
  site_tibble %>% 
  plotly::plot_ly(type = "scattermapbox", 
                  mode = "markers",
                  lon = ~lon, 
                  lat = ~lat, 
                  marker = list(color = "chartreuse",
                                size = 10),
                  text = ~site,
                  hoverinfo = 'text',
                  customdata = ~links) %>%
  plotly::layout(mapbox = list(style = "white-bg",
                               ## Zoom and centering when opening widget
                               zoom = 2,
                               center = list(lon = -61,
                                             lat= -10),
                               ## Origin of map data
                               layers = list(list(below = 'traces',
                                                  sourcetype = "raster",
                                                  source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))))

# Activate link function upon rendering with javascript
## Calls to the custom data provided in the plotly function
map <- 
  htmlwidgets::onRender(map, 
                        "function(el, x) {
                         el.on('plotly_click', function(d) {
                         var url = d.points[0].customdata;
                         //url
                         window.open(url);
                         });
                         }")

# Save site tibble
readr::write_csv(file = here::here("site_tibble.csv"),
                 x = site_tibble)

# Save map
htmlwidgets::saveWidget(widget = map,
                        file = here::here("map.html"), 
                        # Creates single html file
                        selfcontained = TRUE)




# Image map ---------------------------------------------------------------
# List of countries to be shown on the map
countries <- 
  borders("world", 
          regions = c("Brazil", "Uruguay", "Argentina", "French Guiana", "Suriname", "Colombia", "Venezuela",
                      "Bolivia", "Ecuador", "Chile", "Paraguay", "Peru", "Guyana", "Panama", "Costa Rica", 
                       "Nicaragua", "Honduras", "El Salvador", "Belize", "Guatemala", "Mexico", "Trinidad and Tobago",
                       "Caribe", "Puerto Rico", "Dominican Republic", "Haiti", "Jamaica", "Cuba", "Bahamas", "Antiles",
                       "Dominica", "Saba", "Mexico", "Canada", "USA"), 
          fill = "grey80", colour = "grey50")

# Plot map
basemap <- 
  ggplot() + 
  countries + 
  xlab("") + 
  ylab("") + 
  xlim(-180, 0) +
  geom_point(data = site_tibble, 
             aes(x = lon, 
                 y = lat), 
             colour = "dodgerblue4",
             size = 4) +
  geom_text(data = site_tibble, 
                  aes(x = lablon, 
                      y = lablat, 
                      label = site), 
                  size = 4) +
  theme(panel.border = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_rect(fill = 'lightblue'))


# Save
ggsave(basemap,
       filename = here::here("basemap.pdf"), 
       width = 7, 
       height = 8, 
       dpi = 300)
ggsave(basemap,
       filename = here::here("basemap.png"), 
       width = 7, 
       height = 8, 
       dpi = 300)



# Session info -------------------------------------------------------------
# R version 4.3.2 (2023-10-31 ucrt)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 11 x64 (build 22631)
# 
# Matrix products: default
# 
# 
# locale:
#   [1] LC_COLLATE=French_France.utf8  LC_CTYPE=French_France.utf8    LC_MONETARY=French_France.utf8
# [4] LC_NUMERIC=C                   LC_TIME=French_France.utf8    
# 
# time zone: America/Bahia
# tzcode source: internal
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] mapdata_2.3.1     maps_3.4.2        ggmap_4.0.0       here_1.0.1        jsonlite_1.8.7   
# [6] htmltools_0.5.6   htmlwidgets_1.6.2 plotly_4.10.3     shiny_1.7.5       lubridate_1.9.2  
# [11] forcats_1.0.0     stringr_1.5.0     dplyr_1.1.3       purrr_1.0.2       readr_2.1.4      
# [16] tidyr_1.3.0       tibble_3.2.1      ggplot2_3.4.4     tidyverse_2.0.0  
# 
# loaded via a namespace (and not attached):
#   [1] utf8_1.2.4        generics_0.1.3    bitops_1.0-7      jpeg_0.1-10       stringi_1.7.12   
# [6] hms_1.1.3         digest_0.6.33     magrittr_2.0.3    grid_4.3.2        timechange_0.2.0 
# [11] fastmap_1.1.1     plyr_1.8.8        rprojroot_2.0.3   promises_1.2.1    httr_1.4.7       
# [16] fansi_1.0.5       crosstalk_1.2.0   viridisLite_0.4.2 scales_1.3.0      lazyeval_0.2.2   
# [21] cli_3.6.1         crayon_1.5.2      rlang_1.1.1       bit64_4.0.5       ellipsis_0.3.2   
# [26] munsell_0.5.0     yaml_2.3.7        withr_3.0.0       parallel_4.3.2    tools_4.3.2      
# [31] tzdb_0.4.0        colorspace_2.1-0  httpuv_1.6.11     png_0.1-8         vctrs_0.6.4      
# [36] R6_2.5.1          mime_0.12         lifecycle_1.0.4   bit_4.0.5         vroom_1.6.3      
# [41] pkgconfig_2.0.3   pillar_1.9.0      later_1.3.1       gtable_0.3.4      data.table_1.14.8
# [46] glue_1.6.2        Rcpp_1.0.11       tidyselect_1.2.0  rstudioapi_0.15.0 xtable_1.8-4     
# [51] compiler_4.3.2   
# 
# 



