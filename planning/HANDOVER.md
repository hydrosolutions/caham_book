# Handover: CAHAM book update (prepared 2026-11-02)

Prepared by Claude (Fable 5.1) for the agent taking over the book update. Nothing described here is committed yet
unless the git log says otherwise. Read `AGENTS.md` first.

## 1. Where things stand

- Full editorial review of the 2024.Q1 edition is done: `planning/2026_update_review.md` (sections 1–7 findings,
  8 data inventory, 9 water-balance chapter sources, 10 publishing standard). Confirmed errors are in §2; every
  item carries file:line.
- A detailed plan exists for the first chapter to rebuild, Part III "Long-term Water Balance Modeling"
  (`long_term_water_balance_modeling.qmd`): `planning/chapter_plan_long_term_water_balance.md`, including the
  figure standard (§4a), didactic standard (§4b) and validation protocol (§4c) that then apply book-wide.
- The render-time data subset (4.4 GB, 3,962 files) is on Tobias's Mac at `../caham_data` and verified from R;
  `tools/data/` recreates it anywhere.
- The authors' decisions still open: scope (correctness release first vs. straight to new edition), R-only vs. R
  plus Python track, RS Minerve GUI vs. scriptable model as the reference, one primary case basin, fate of the
  79-screenshot QGIS appendix (review §7), plus the five chapter-level decisions in the chapter plan §7, and the
  AI-use statement (§10).
- Quota note from the authors: book work must not crowd out other projects; prefer short, focused sessions and
  cheaper models for mechanical work.

## 2. Suggested order of work

Phase 0 (make it buildable, mechanical):
1. `renv::init()` + lockfile; `execute: freeze: auto` in `_quarto.yml`; GitHub Actions render + deploy to
   `gh-pages`; remove `docs/` and `_book/` from git; `.gitignore` for `_freeze/`? (no: commit `_freeze/`).
2. Data helper `R/caham_data.R` that fetches a chapter's files from a DOI (Zenodo) into a cache; replace every
   `../caham_data` literal and every Dropbox link.
3. Package migration: `raster`/`sp`/`rgdal` → `terra`/`sf`; tmap v3 → v4; drop `vembedr`/`slickR` for Quarto
   `{{< video >}}`; remove `install_github()` from chunks; define `callout-task` or remove it.
4. Cross-reference repair (review §2, §3), orphan files, heading levels (`glacier_modeling.qmd` starts with `##`),
   duplicate bib keys, dead links (RS Minerve → https://www.crealp.ch/rs-minerve/, Posit, QGIS LTR).
5. Shared figure infrastructure: `R/theme_caham.R`, `R/tm_caham.R`, `R/caham_palettes.R` per chapter plan §4a.
6. Validation tooling: citation audit script, prerequisite ledger template, cold-reader review prompt, validation
   report template (`planning/validation/`).

Phase 1 (correctness release "2026.Q4"): fix the confirmed errors (review §2 and §6), repair the study guide,
mark unfinished sections honestly, new "What's new", edition tag, DOI, citation block.

Phase 2 (new edition, chapter by chapter): start with the water-balance chapter per its plan; then the
climate-change chapter (half empty), glacier chapter (OGGM/PyGEM), predictive-inference chapter (hindcast design,
skill scores, ML), Part II data refresh (RGI 7, Copernicus DEM, WorldCover, ERA5-Land, CHELSA-W5E5), new
operational-hydrology chapter (SAPPHIRE, iEasyHydro, SnowMapper, Taqsim), study guide rewrite.

## 3. Facts discovered that are not obvious from the repo

- The whole `caham_data` folder is publicly shared on Dropbox through the link commented out at
  `glacier_modeling.qmd:345`. The "fut_sim" share linked at `climate_data.qmd:327` now contains only a MeteoSwiss
  PDF; the GCM data link is broken for readers.
- The CMIP6 files in `caham_data/climate` are domain clips of 11–62 MB, not global; the biggest item in the folder
  is a 7.6 GB PyGEM file used only in an `eval: false` chunk.
- The Dropbox folder on Tobias's Mac is online-only with legacy zero-byte placeholders; reading them from a script
  does not download them. The public share serves each subfolder as a zip (tokens in `tools/data/`).
- Measured formula errors (verified in source): RMSE without square (`hydraulic_hydrological_modeling.qmd:535`),
  Nash denominator uses simulated flow (`:359`), objective without square (`:385`), `P(t_1)+P(t_1)` (`:162`),
  Choudhury exponent sign (`long_term_water_balance_modeling.qmd:96`), Gunt glacier volume 699 km³ = Erasov on
  total area (`example_river_basins.qmd:160`), "CHELSA elevation-dependent warming" plotted from bias-corrected
  GFDL SSP5-8.5 (`climate_data.qmd:956`).
- The water-balance study (Siegfried et al. 2024, Climatic Change) uses the Porporato stochastic soil-moisture
  model, not Budyko–Choudhury. Its runoff coefficient ρ(Φ, γ) = Φ γ^(γ/Φ−1) e^(−γ) / [Γ(γ/Φ) − Γ(γ/Φ, γ)] was
  computed in Mathematica for precision; a log-space R version
  `exp(log(Φ) + (a−1)·log(γ) − γ − lgamma(a) − pgamma(γ, a, log.p = TRUE))` with a = γ/Φ is stable over the
  whole range (tested 2026-11-02; validate against the paper's `g_mathematica_*.csv` before use).
- Zenodo record for that study: 10.5281/zenodo.10125163 (DATA 2.45 GB, CODE, METHODS). Dropbox working copy:
  `1_HSOL_PROJECTS/PROJECTS/2021_03_TW Hydro4U/PUBLICATIONS/wet_central_asia/`.
- hydrosolutions' current tools relevant to new chapters (GitHub org): SAPPHIRE_Forecast_Tools, long-term-forecasting,
  ieasyhydro-python-sdk, MCASS, kaz/taj_snowmapper_dashboard, taqsim, delineator, airGR_GM, glaciermapper-ca,
  zarafshan-taqsim-course, ZRB-groundwater-model-public.
- GitHub traffic is low (≈ 1 clone/day, 10 stars, 9 open issues from 2022–2024; issues #28–#34 are still
  relevant todo items).

## 4. Files produced in this handover

- `AGENTS.md` (repo root) — conventions and traps for agents.
- `planning/2026_update_review.md` — review, data inventory, publishing standard.
- `planning/chapter_plan_long_term_water_balance.md` — chapter plan with figure, didactic and validation standards.
- `planning/HANDOVER.md` — this file.
- `tools/data/download_caham_subset.sh`, `tools/data/extract_dropbox_zips.py`, `tools/data/README.md`.

None of the chapter files were modified.
