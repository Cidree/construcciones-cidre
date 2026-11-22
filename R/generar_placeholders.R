# ------------------------------------------------------------------
# Genera las imágenes provisionales (SVG) de la web:
#   - images/hero.svg      fondo de muro de mampostería para la portada
#   - images/familia.svg   hueco para la foto de "Sobre nosotros"
#   - images/trabajo-*.svg huecos de la galería
#   - images/logo.svg      logotipo provisional
#
# Uso (desde la raíz del proyecto):  Rscript R/generar_placeholders.R
# Cuando tengas fotos reales, guárdalas en images/ y cambia la ruta
# correspondiente en index.qmd (p. ej. images/trabajo-bano.jpg).
# ------------------------------------------------------------------

set.seed(1999)

piedras <- c("#8F877A", "#A39A8A", "#B8AE9C", "#7D766B", "#9C8F7B", "#B3A58D", "#6E6A63", "#C2B8A6")
mortero <- "#4A4540"

# Muro de piedra: filas de altura variable con piedras de ancho aleatorio
muro_svg <- function(ancho, alto, escala = 1) {
  rects <- character()
  y <- 0
  while (y < alto) {
    h <- round(runif(1, 48, 82) * escala)
    x <- -round(runif(1, 0, 60) * escala)
    while (x < ancho) {
      w <- round(runif(1, 85, 175) * escala)
      gap <- round(5 * escala)
      rx <- round(runif(1, 6, 16) * escala)
      col <- sample(piedras, 1)
      op <- round(runif(1, 0.85, 1), 2)
      rects <- c(rects, sprintf(
        '<rect x="%d" y="%d" width="%d" height="%d" rx="%d" fill="%s" fill-opacity="%s"/>',
        x + gap, y + gap, w - gap, h - gap, rx, col, op
      ))
      x <- x + w
    }
    y <- y + h
  }
  paste0(
    sprintf('<rect width="%d" height="%d" fill="%s"/>', ancho, alto, mortero),
    paste(rects, collapse = "")
  )
}

escribir <- function(ruta, contenido) {
  writeLines(contenido, ruta, useBytes = TRUE)
  message("Escrito: ", ruta)
}

# ---- Portada ----
escribir("images/hero.svg", sprintf(
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 1000" preserveAspectRatio="xMidYMid slice">%s</svg>',
  muro_svg(1600, 1000)
))

# ---- Marcadores de foto ----
marcador <- function(ruta, titulo, ancho = 800, alto = 600) {
  svg <- sprintf(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %1$d %2$d">
  %3$s
  <rect width="%1$d" height="%2$d" fill="#2E3A40" fill-opacity="0.55"/>
  <g font-family="Georgia, serif" text-anchor="middle" fill="#F7F3EC">
    <circle cx="%4$d" cy="%5$d" r="38" fill="none" stroke="#F7F3EC" stroke-width="4"/>
    <rect x="%6$d" y="%7$d" width="56" height="36" rx="6" fill="none" stroke="#F7F3EC" stroke-width="4"/>
    <circle cx="%4$d" cy="%8$d" r="10" fill="none" stroke="#F7F3EC" stroke-width="4"/>
    <text x="%4$d" y="%9$d" font-size="34" font-weight="bold">%10$s</text>
    <text x="%4$d" y="%11$d" font-size="20" font-family="sans-serif" fill-opacity="0.85">Foto provisional · sustituir por imagen real</text>
  </g>
</svg>',
    ancho, alto, muro_svg(ancho, alto, escala = 0.7),
    ancho / 2, alto / 2 - 50,
    ancho / 2 - 28, alto / 2 - 68, alto / 2 - 50,
    alto / 2 + 40, titulo, alto / 2 + 78
  )
  escribir(ruta, svg)
}

trabajos <- c(
  "trabajo-bano"        = "Reforma de baño",
  "trabajo-piedra"      = "Muro de piedra",
  "trabajo-rehabilitacion" = "Rehabilitación de casa rural",
  "trabajo-tejado"      = "Tejado de pizarra",
  "trabajo-obra-nueva"  = "Vivienda de obra nueva",
  "trabajo-cementerio"  = "Restauración de panteón"
)
for (i in seq_along(trabajos)) {
  marcador(file.path("images", paste0(names(trabajos)[i], ".svg")), trabajos[[i]])
}
marcador("images/familia.svg", "La familia Cidre en obra", 800, 900)

# ---- Logotipo provisional: tejado + muro + inicial ----
escribir("images/logo.svg", '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 64 64">
  <rect width="64" height="64" rx="12" fill="#8B5A2B"/>
  <path d="M10 30 L32 12 L54 30" fill="none" stroke="#F7F3EC" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
  <g fill="#F7F3EC">
    <rect x="15" y="34" width="15" height="8" rx="2"/><rect x="33" y="34" width="16" height="8" rx="2"/>
    <rect x="15" y="45" width="9" height="8" rx="2"/><rect x="27" y="45" width="22" height="8" rx="2"/>
  </g>
</svg>')
