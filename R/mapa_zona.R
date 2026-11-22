# ------------------------------------------------------------------
# Mapa de la zona de trabajo con {mapgl} (MapLibre, sin token).
# Para añadir o quitar localidades, edita la tabla `localidades`.
# ------------------------------------------------------------------

localidades <- data.frame(
  nombre = c("Escairón", "Monforte de Lemos", "Chantada", "Ferreira de Pantón",
             "Sober", "Taboada", "Bóveda", "Os Peares", "Carballedo"),
  lon = c(-7.6596, -7.5146, -7.7710, -7.6230, -7.5850, -7.7630, -7.4810, -7.7200, -7.8400),
  lat = c(42.5876, 42.5218, 42.6085, 42.5090, 42.4620, 42.7150, 42.6290, 42.4520, 42.5330),
  sede = c(TRUE, rep(FALSE, 8))
)

mapa_zona <- function(radio_km = 25, alto = "460px") {
  pts <- sf::st_as_sf(localidades, coords = c("lon", "lat"), crs = 4326)

  # Área de cobertura: círculo alrededor de Escairón (en metros, ETRS89 / UTM 29N)
  zona <- pts[pts$sede, ] |>
    sf::st_transform(25829) |>
    sf::st_buffer(radio_km * 1000, nQuadSegs = 60) |>
    sf::st_transform(4326)

  mapgl::maplibre(
    style = mapgl::carto_style("voyager"),
    center = c(-7.66, 42.585),
    zoom = 9.1,
    height = alto,
    width = "100%",
    scrollZoom = FALSE,
    attributionControl = list(compact = TRUE)
  ) |>
    mapgl::add_fill_layer(
      id = "zona", source = zona,
      fill_color = "#8B5A2B", fill_opacity = 0.12
    ) |>
    mapgl::add_line_layer(
      id = "zona-borde", source = zona,
      line_color = "#8B5A2B", line_width = 2.5, line_dasharray = c(2, 2)
    ) |>
    mapgl::add_circle_layer(
      id = "localidades", source = pts,
      circle_color = mapgl::match_expr("sede", values = c(TRUE, FALSE),
                                       stops = c("#8B5A2B", "#2E3A40")),
      circle_radius = mapgl::match_expr("sede", values = c(TRUE, FALSE),
                                        stops = c(10, 6)),
      circle_stroke_color = "#FFFFFF", circle_stroke_width = 2,
      tooltip = "nombre"
    ) |>
    mapgl::add_symbol_layer(
      id = "etiquetas", source = pts,
      text_field = mapgl::get_column("nombre"),
      text_font = list("Open Sans Bold"),
      text_size = 13,
      text_offset = c(0, 1.25),
      text_anchor = "top",
      text_color = "#2E3A40",
      text_halo_color = "#FFFFFF",
      text_halo_width = 1.5
    ) |>
    mapgl::add_navigation_control(show_compass = FALSE) |>
    mapgl::add_fullscreen_control()
}
