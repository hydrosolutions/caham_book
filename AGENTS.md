# AGENTS.md — working on the CAHAM book

Read this first. Then read `planning/HANDOVER.md`, then the two plan files it points to.

## What this repository is

A Quarto book: "Modeling of Hydrological Systems in Semi-Arid Central Asia" (CAHAM), published at
https://hydrosolutions.github.io/caham_book/ from the `docs/` folder on `master`. Authors: Tobias Siegfried,
Beatrice Marti, Adrian Kreiner, Aidar Zhumabaev (hydrosolutions GmbH). Licence CC BY-SA 4.0. Last content
edition: 2024.Q1. A thorough update ("2027 edition") is being prepared; the review and plans are in `planning/`.

## Layout

- `*.qmd` at the root: one file per chapter, ordered in `_quarto.yml`. Parts: `hydrology_of_central_asia.qmd`,
  `data.qmd`, `hydrological_modeling.qmd` are part pages. Appendices `appendix_a..d_*.qmd`.
- `images/` (146 MB) chapter figures and screenshots; `references.bib` (110 entries), `packages.bib` (auto-written
  by `index.qmd`, do not edit by hand).
- `docs/` is the rendered site, committed by hand; `_book/` is a stale output dir. Do not edit either by hand.
- `planning/` review notes, chapter plans, handover. `tools/data/` data download scripts.
- Orphans not in `_quarto.yml`: `Watershed_delineation.qmd`, `Watershed_characterisation.qmd`,
  `real_world_examples.qmd`, `hydrological_modeling_applications.qmd`.

## Toolchain

- Quarto (site was built with 1.4.549; 1.9 is installed locally), R 4.5. No `renv.lock`, no CI, no `freeze` yet
  (adding them is Phase 0 work). `caham.Rproj` is an RStudio project.
- R packages used by the chapters: tidyverse, sf, terra, raster (legacy), rgdal (retired, fails), tmap (code is v3
  syntax; v4 is installed), timetk, exactextractr, ncdf4, stars, qmap, vembedr, slickR, budyko, riversCentralAsia
  (GitHub: hydrosolutions/riversCentralAsia, v1.1.0). Expect a full render to fail today; fix per chapter.
- Render: `quarto render` (whole book) or `quarto render <file>.qmd`. Preview: `quarto preview`.

## Data

- Evaluated chunks read `../caham_data/...` and `../HydrologicalModeling_CentralAsia_Data/REFERENCE_CaseStudyPacks/...`
  relative to the repo root. On Tobias's Mac both exist next to the repo (`caham_data` is a local 4.4 GB subset;
  the other is a symlink into Dropbox). To recreate: `tools/data/README.md`.
- Never commit data. Never add Dropbox links to the text; the plan replaces them with a DOI'd data pack.

## Conventions

- Quarto cross-references only (`@sec-…`, `@fig-…`, `@eq-…`, `@tbl-…`); no bookdown `\@ref(...)`, no
  `[text](@sec-…)`. Section ids `sec-<chapter>-<topic>`. Chunk labels for figures `fig-<topic>` with `fig-cap`
  and `fig-alt`.
- Callouts: note, tip, warning, caution, important. `callout-task` is undefined; either define it or do not use it.
- Figures and maps follow `planning/chapter_plan_long_term_water_balance.md` §4a; didactics §4b; validation §4c;
  publishing standard `planning/2026_update_review.md` §10. These apply to every chapter you touch.
- Citations: every claim and dataset cited with a DOI-verified `references.bib` entry. Cite data as data.
- British English, SI units with brackets in axis titles, BGN/PCGN transliteration of place names.
- Keep `R/` for shared functions (themes, palettes, data helper); chapters source from there.
- Work on a branch per chapter (`feature/<chapter>`), small commits, PR to `master`; do not commit `docs/` in
  feature branches (rendering and deployment move to CI in Phase 0).
- Do not rewrite text you were not asked to touch; the authors review every change.

## Known traps

- `unzip` rejects the Dropbox folder zips (root "/" entry); use `tools/data/extract_dropbox_zips.py`.
- Path case differs between code and disk in places (`Atbashy` vs `AtBashy`, `_hru` vs `_HRU`); macOS is
  case-insensitive, CI is not.
- `index.qmd` rewrites `packages.bib` on every render.
- `example_river_basins.qmd` loads data from a second, unused path; `hydrological_systems.qmd` too.
- Several chunks call `devtools::install_github()` at render time; remove when you touch them.
