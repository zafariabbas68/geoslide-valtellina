
# GeoSlide Valtellina

**Landslide Susceptibility Mapping & Population Exposure Assessment**
Italian Alps — Valtellina valley, south of Bormio (Lombardy)

> **🔗 Live site:** [geoslide-valtellina.vercel.app](https://geoslide-valtellina.vercel.app)
> **📦 GitHub:** [github.com/zafariabbas68/geoslide-valtellina](https://github.com/zafariabbas68/geoslide-valtellina)

[![Live Demo](https://img.shields.io/badge/Live-Demo-success)](https://geoslide-valtellina.vercel.app)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-181717)](https://github.com/zafariabbas68/geoslide-valtellina)

---

## Overview

GeoSlide Valtellina is a data-driven landslide susceptibility model and
population exposure assessment for a 140 km² alpine catchment in the Italian
Alps. The project combines **QGIS**, **R (ModelMap)**, and an open-source
**Leaflet WebGIS** to map landslide hazard and estimate how many people live
in medium-to-high risk zones.

**Study area**
- Location: Valtellina valley, Lombardy, Italy (~46.35° N, 10.4° E)
- Area: **140.79 km²** (14,078.95 ha)
- Elevation: **943 – 3,414 m**
- Spatial resolution: **5 m / pixel**
- CRS: **EPSG:32632** (UTM Zone 32N)

**Headline results**
- Overall model accuracy: **0.69**
- Sample points: **1,000** (700 training / 300 testing)
- Population in medium-to-very-high susceptibility: **> 10 %**
- Conditioning layers: **10** — DTM, slope, aspect, plan & profile curvature,
  DUSAF, NDVI, faults, rivers, roads

---

## Live Pages

| Page | URL | Description |
|---|---|---|
| **Home** | [geoslide-valtellina.vercel.app](https://geoslide-valtellina.vercel.app) | Landing — study area, layers, pipeline, key results |
| **Methodology** | [/pages/methodology](https://geoslide-valtellina.vercel.app/pages/methodology) | Datasets, preprocessing, R model, exposure |
| **WebGIS** | [/pages/webgis](https://geoslide-valtellina.vercel.app/pages/webgis) | Interactive Leaflet WebGIS with 10 layers |
| **Results** | [/pages/results](https://geoslide-valtellina.vercel.app/pages/results) | Error matrix, exposure charts, prospects |

---

## WebGIS Features

- **Basemap switcher:** OpenStreetMap / OpenTopoMap / Esri Satellite
- **10 toggleable raster layers** (each with a custom color palette)
- **Susceptibility overlay** with 4-class legend
- **Opacity slider** for the susceptibility layer
- **Click-to-sample:** elevation and susceptibility at any point
- **Draw ROI:** area in km², mean susceptibility, min/max
- **Zoom locked** to the DEM extent — no wandering off the study area
- **Dark theme** with red accent

---

## Tech Stack

| Component | Used for |
|---|---|
| **QGIS** | Raster preprocessing, sampling, buffer analysis |
| **R + ModelMap** | Generalized linear model for susceptibility |
| **GDAL / gdal2tiles** | Reprojection and XYZ tiling |
| **rio-cogeo** | Cloud-Optimized GeoTIFFs for click-to-sample |
| **Leaflet 1.9** | Interactive WebGIS |
| **Leaflet-Geoman** | Draw ROI tools |
| **georaster / geoblaze** | Client-side raster sampling |
| **proj4js** | UTM ↔ WGS84 conversion |
| **Vercel** | Static hosting & edge caching |

---

## Data Sources

| Layer | Source | Scale |
|---|---|---|
| Digital Terrain Model | Regional LiDAR | 5 m raster |
| Land use (DUSAF) | Lombardy Region | 1:10,000 |
| Landslide inventory | IFFI catalogue | 1:10,000 |
| Roads & rivers | OpenStreetMap | vector |
| Geological faults | GeoPortale Lombardia | vector |
| NDVI | Sentinel-2 | 10 m |
| Population | WorldPop | 100 m |

---

## Run Locally

```bash
# Clone the repo
git clone https://github.com/zafariabbas68/geoslide-valtellina.git
cd geoslide-valtellina

# Serve locally
python -m http.server 5500
```

Then open:
- http://localhost:5500/ — Home
- http://localhost:5500/pages/webgis.html — WebGIS
- http://localhost:5500/pages/methodology.html — Methodology
- http://localhost:5500/pages/results.html — Results

> ⚠️ Use `http://` — do not open HTML with `file://` (COG loading fails).

---

## Repository Layout

```
geoslide-valtellina/
├── index.html                       # Landing page
├── vercel.json                      # Deployment config
├── README.md
├── LICENSE                          # MIT
├── .gitignore
│
├── pages/
│   ├── methodology.html
│   ├── webgis.html
│   └── results.html
│
├── assets/
│   ├── css/
│   │   ├── custom-styles.css        # Dark red theme
│   │   └── main.css
│   └── js/
│
├── images/
│   ├── processed layers/            # 10 layer previews
│   ├── Error_Matrix.jpg
│   ├── pop_pie_chart.jpg
│   └── population_counts.jpg
│
└── data/
    ├── tiles/                       # Susceptibility XYZ tiles
    ├── hillshade/                   # Hillshade XYZ tiles
    ├── layers/                      # 10 preprocessing rasters
    ├── susceptibility_cog.tif
    └── dtm_cog.tif
```

---

## Deployment

The site is deployed on **Vercel** and auto-redeploys on every push to `main`.

```bash
# Manual redeploy (if needed)
npm i -g vercel
vercel --prod
```

**Vercel project:** [vercel.com/geo-enrich-core/geoslide-valtellina](https://vercel.com/geo-enrich-core/geoslide-valtellina)

---

## License

Released under the [MIT License](LICENSE).

---

## Author

**Ghulam Abbas Zafari** · GIS Project · 2026


