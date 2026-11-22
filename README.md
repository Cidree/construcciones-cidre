# Construcciones y Reformas Cidre — web

Web de una sola página hecha con [Quarto](https://quarto.org) y R.

## Estructura

| Archivo | Para qué sirve |
|---|---|
| `index.qmd` | Contenido de la web (textos, servicios, galería, contacto) |
| `_variables.yml` | **Datos de contacto** (teléfono, WhatsApp, email, dirección, horario, años de experiencia). Se usan en toda la página |
| `_quarto.yml` | Configuración del sitio y menú |
| `styles/theme.scss` | Colores, tipografías y diseño |
| `R/mapa_zona.R` | Mapa de la zona de trabajo ({mapgl}). Edita la tabla `localidades` o el radio |
| `R/generar_placeholders.R` | Genera las imágenes provisionales de `images/` |
| `images/` | Logo, fondo de portada y fotos |
| `netlify.toml` | Configuración de publicación en Netlify |

## Tareas pendientes antes de publicar

1. **Datos reales**: edita `_variables.yml` (los actuales son ficticios).
2. **Fotos**: copia tus fotos en `images/` (p. ej. `trabajo-bano.jpg`) y cambia la ruta en `index.qmd`
   (sección *Trabajos realizados* y la foto de *Sobre nosotros*). Recomendado: JPG de ~1600 px de ancho y < 400 KB.
   Para la portada, sustituye `images/hero.svg` en la primera línea `::: {#inicio .hero ...}` de `index.qmd`.
3. **Logo**: reemplaza `images/logo.svg` si tienes uno propio.
4. Revisa textos (años de experiencia, año de inicio, cita, pueblos).

## Renderizar y previsualizar

```bash
quarto preview      # vista previa con recarga automática
quarto render       # genera la web en _site/
```

(Si `quarto` no está en el PATH, viene con RStudio: `/usr/lib/rstudio/resources/app/bin/quarto/bin/quarto`.)

Paquetes de R necesarios: `mapgl`, `sf`, `knitr`, `rmarkdown`.

## Publicar en Netlify

Netlify no tiene R ni Quarto, así que la web se genera en local y se sube la carpeta `_site/`:

- **Opción A (más sencilla)**: arrastra la carpeta `_site/` a <https://app.netlify.com/drop>.
- **Opción B (CLI)**: `netlify deploy --prod --dir=_site`
- **Opción C (Git)**: haz commit de `_site/` y conecta el repositorio en Netlify; `netlify.toml` ya indica
  que publique `_site` sin comando de build. Acuérdate de ejecutar `quarto render` antes de cada commit.
