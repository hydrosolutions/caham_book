# CAHAM Book – Review for the 2026/27 Edition

Date of review: 2026-11-02. Reviewed state: `master` at 9e6168d (content last changed 2024-02-19).
This file collects the detailed findings behind the update plan. Line numbers refer to the files as they are at that commit.

## 1. State of the project

| Item | Finding |
|---|---|
| Last content change | 2024-02-19 (2024.Q1 edition). Only a README edit since (2026-01). README declares "Maintenance Mode / project concluded". |
| Size | 26 `.qmd` files, ~78k words, 203 R code chunks, 110 bib entries (newest 2023). |
| Build | Quarto 1.4.549 rendered the published site; local toolchain is now Quarto 1.9.36 / R 4.5.2. No `freeze`, no `renv.lock`, no CI. Rendered HTML (`docs/`, 169 MB) is committed by hand; `_book/` is a stale second output dir. Repo pack is 251 MB. |
| Data | All evaluated code reads `../caham_data/...` (not in repo, not on this machine, not documented). Student packs and demo data live on 14 Dropbox share links (all still resolve today, but none are citable or guaranteed). |
| R packages | `rgdal` (retired 2023), `raster` (superseded by `terra`), `vembedr`, `slickR`, `budyko`, `tidymodels` not installed locally; `tmap` is now v4 (API changed); `install_github()` runs inside evaluated chunks. |
| External links | RS Minerve URLs (crealp.ch/fr/accueil/...) return 404 in preface, study guide, appendix A; site moved to https://www.crealp.ch/rs-minerve/. QGIS manual pinned to 3.16. RStudio links predate Posit. |
| GitHub | 9 open issues (2022–2024), 10 stars, 4 forks, ~1 clone/day. `riversCentralAsia` last pushed 2024-05, v1.1.0. |
| Orphans | `Watershed_delineation.qmd`, `Watershed_characterisation.qmd` (verbatim duplicates of parts of the climate-change chapter), `real_world_examples.qmd`, `hydrological_modeling_applications.qmd` are not in `_quarto.yml`. |

## 2. Confirmed technical errors (fix regardless of edition scope)

- `hydraulic_hydrological_modeling.qmd:162` – discretised water balance reads `P(t_1)+P(t_1)`; should be `P(t_1)+P(t_2)`.
- `hydraulic_hydrological_modeling.qmd:359` – Nash–Sutcliffe denominator uses `Q_sim(t) - mean(Q_obs)`; must be `Q_obs(t) - mean(Q_obs)`.
- `hydraulic_hydrological_modeling.qmd:385` – calibration objective sums raw residuals (no square / abs).
- `hydraulic_hydrological_modeling.qmd:535` – `RMSE = sqrt(mean(Obs-Sim))` has no square; computes nonsense (NaN for negative mean).
- `hydraulic_hydrological_modeling.qmd:737-747` – Hugonnet `dmdtda` (m w.e. a⁻¹) compared directly to GSM ice thickness change; units mismatch.
- `long_term_water_balance_modeling.qmd:96` – Choudhury equation outer exponent should be `-1/n`.
- `Climate_change_impact_study.qmd:47` – water balance `P + SM − ET − I − Q = 0` double counts snowmelt and lacks a storage term.
- `modeling_using_predictive_inference.qmd:963` – in-sample lag-1 regression presented as "astonishing" predictive skill; no out-of-sample validation anywhere in the chapter.
- `modeling_using_predictive_inference.qmd:415` – "19169" → 1969; `:224,255` station 38471 vs 38464; `:676` caption says temperature for a P–Q plot.
- Leftover bookdown syntax `\@ref(...)` in 10 places (hydraulic:40; budyko:15,83,99; example_river_basins; predictive:432,467,498,672) and `[text](@sec-...)` links render as literal text (hydraulic:342,438; glacier:3,43).

## 3. Structural gaps and placeholders

- `Climate_change_impact_study.qmd:244-280` – headline chapter is half empty: Parts 3–4 of the exercise, model setup, CHELSA/GCM forcing, bias correction, baseline model, scenarios, discussion are empty headings. "Introductory words." placeholder at 266, `[insert figure number]` at 260, Exercise 3 titled "Chirchik" inside a Zarafshan chapter (252).
- `modeling_using_predictive_inference.qmd:1049-1061` – benchmark, out-of-sample and ML sections are "work in progress".
- `long_term_water_balance_modeling.qmd:137-143` – Results and Discussion are placeholders; chapter has no code and no exercise. Open issue #29.
- `glacier_modeling.qmd` – starts with `##` (not a chapter heading); ~540 of 825 lines are HTML-commented out, including the whole Atbashy demonstration. Promised RS Minerve coupling not delivered. Evaluated chunk runs `install_github` (139); `library(raster)` (134).
- `snow_and_glacier_data.qmd:130` – "15. February 2024: More information coming soon!" (SLF SWE model, issue #31).
- `study_guide_materials.qmd` – wrong chapter numbers (cites Ch. 14/15/17; actual 9/8/none), "TODO LINK" at 204, references to a non-existent "Chapter 1: A Short History of Water", DKU 2021/2022 and Moodle deadlines hard-coded, only 8 of 10 days, undefined `callout-task` class (no CSS/extension defines it), empty callouts.
- `appendix_d_exercise_solutions.qmd` – solutions for exercises that no longer exist as exercise callouts in any chapter; render-time `read.delim()` from Dropbox (102, 113); broken `@sec-data-snow-cover` (85); invalid ID with a space (95).
- `appendix_c_quick_guides.qmd` – 79 screenshots, QGIS 3.16 era (2021 Windows UI); `geospatial_data.qmd:96-99` notes the Graphical Modeler model built in QGIS 3.24 no longer runs on 3.34 (issue #28). Stray `bucket_video.textClipping` in images.
- `appendix_a_free_software.qmd` – 2021 RS Minerve screenshot and dead URL; no R/Quarto/Python/Positron guidance; dead anchors at 7 and 30.
- `hydrological_modeling.qmd:13` – dead link to `#sec-modeling-using-predictive-inference` (chapter id is `sec-em`); promises seasonal forecasting and climate-impact content that the chapters do not deliver.
- Front matter – preface and index are hard-wired to "2024.Q1"; single concept DOI from 2022; no "How to cite"; `knitr::write_bib` chunk in index rewrites `packages.bib` on every render; `sharing: [facebook, linkedin]`.

## 4. Scientific and data staleness

- Glaciers: RGI 6.0 + Farinotti 2019 thickness throughout Part II/III; current practice is RGI 7.0, Millan 2022 thickness, Hugonnet 2021 (still fine), and projections from OGGM / PyGEM (Rounce et al. 2023, CMIP6/SSP) instead of the Rounce 2020 RCP output used in hydraulic:834-973 and volume–area scaling in glacier_modeling.
- Climate: CHELSA V2.1 and CMIP6 handled via per-HRU empirical quantile mapping (`qmap`, climate_data.qmd:895), which does not preserve GCM trends; trend-preserving QDM / ISIMIP3BASD or pre-corrected CHELSA-W5E5 / ISIMIP3b forcing is the current standard. ERA5-Land, CHELSA-W5E5, and the SLF/SnowMapper SWE products deserve first-class treatment.
- Topography/land cover: SRTM via QGIS plugin and Copernicus 2019 land cover; Copernicus DEM GLO-30, ESA WorldCover 2021, MERIT-Hydro / HydroSHEDS v2 / HydroATLAS and the mghydro `delineator` (which hydrosolutions now maintains) are the modern path and remove most of Appendix C.
- Forecasting: predictive-inference chapter stops at in-sample linear regression; no time-series CV, skill scores (CRPS), probabilistic/conformal intervals, gradient boosting or LSTM (NeuralHydrology). hydrosolutions' own operational stack (SAPPHIRE Forecast Tools, long-term-forecasting, iEasyHydro SDK, SnowMapper dashboards, MCASS) is absent from the book, although `real_world_examples.qmd` was meant for exactly that.
- RS Minerve: version 2.9.1 (hydraulic:48), "at the time of writing March 2022" caveats (glacier:3, hydraulic:232-238, 436) need re-checking against the current release; RSMinerveR exists but calibration is still screenshot-driven.
- Budyko chapter: gauge data to 2018, CHELSA to 2011, RGI 6, Whitebox 2.0.

## 5. Pedagogy and the LLM era

- The chapters mix solid narrative (hydraulic chapter, data-preparation sections of the predictive chapter, Part I) with long un-narrated code dumps (climate_data, snow_and_glacier_data). Many code chunks are `eval: false` and hide the non-reproducible steps.
- The study guide, exercises and solutions have drifted apart; nothing links exercise → solution.
- Exercises are "reproduce these steps" tasks, written for a world where the code had to be typed. With assistants available, the valuable skills shift to: specifying the problem, judging data and model adequacy, critiquing a calibration, validating generated code, and documenting decisions. The book does not yet teach or exploit that.
- 79 QGIS screenshots for routine operations are the most expensive part to maintain and the least valuable to a student who can ask an assistant for current menu paths.


## 6. Part I / II specific findings (verified where marked ✔)

- ✔ `example_river_basins.qmd:160` – Gunt total glacier volume 699 km³ = 0.027·875^1.5, i.e. Erasov scaling applied to the basin total instead of per glacier (implies ~800 m mean ice thickness). Recompute per glacier or use Farinotti/Millan thickness.
- ✔ `climate_data.qmd:956-985` – "CHELSA shows elevation-dependent warming" is plotted from a quantile-mapped GFDL-ESM4 SSP5-8.5 forcing file; the signal is a GCM/QM artefact, not a CHELSA observation. Reframe or remove.
- ✔ `climate_data.qmd:895-905` – empirical `qmap` "QUANT", pooled over seasons, no wet-day correction; zeros in Kelvin temperature replaced by last observation carried forward.
- `climate_data.qmd` – CHELSA described inconsistently (1979–2016 / ERA-Interim / ERA5 / 1979–2011); "4 models" vs 5-row table (311–319) vs MPI in text vs IPSL in code; Stamen basemap tiles (103) retired in 2023; absurd relative path at 422; gauge elevation hard-coded 550 (629); `#| caption:` invalid option (201).
- `hydrological_systems.qmd` – best prose in the book. Table statistics from 2017/18 with a German header; "Islamic Emirate" naming (94, 116) to revisit; "Runoff Coeff. (l/(s km²))" is specific runoff (268); weather-type figures appear swapped (150–152); loads data from a second, unused path `../HydrologicalModeling_CentralAsia_Data` (35–86); scheme-less `www.hydrosolutions.ch` links (237–245).
- `example_river_basins.qmd` – quarterly min/mean/max plotting block copy-pasted three times; station-code and caption mismatches (367, 572, 757, 844, 908, 912, 922); Koksu section (912–1016) is an empty stub; `sp`/`+init=epsg` and tmap v3 syntax; install_github at render (24).
- `data_sources.qmd` – catalogue dated: MODIS "through 2021", RGI 6, GOODD (→ Global Dam Watch 2024), SRTM plugin (→ Copernicus GLO-30), LC100 2019 (→ WorldCover), CHELSA daily "on request" (now public). Missing: ERA5-Land, HydroATLAS, GRDC portal, HMASR, MSWEP, ISIMIP3b. Line 41 about hydromets' knowledge of gauge locations is diplomatically risky.
- `discharge_station_data.qmd` – `library(rgdal)` (22) fails on current CRAN; imputation via `rlm` with no holdout, no non-negativity, no seasonality (203–205); "larger alpha" text vs smaller value in code (379/391); record ends 2015.
- `geospatial_data.qmd` – QGIS Graphical Modeler `.model3` flagged broken (96–99); SRTM plugin; Erasov scaling again (194); subbasins called HRUs (162) conflicts with elevation-band HRUs; missing anchors (42, 140).
- `snow_and_glacier_data.qmd` – good chapter, but RGI 7 only in a footnote, Millan 2022 mentioned not used, Rounce 2023 claimed but CMIP5 PyGEM shown (325–329), Obu 2019 static permafrost map (→ ESA Permafrost_cci), 14 GB Dropbox download (17), `raster` + manual flip/transposes for HMASR (65–112), `# References` as level-1 heading (368), ablation plotted on a diverging scale centred at 0 (311–316).

## 7. Proposed plan (for discussion)

### Guiding choices to settle first
1. **Scope**: (a) correctness/maintenance release only, or (b) a genuine new edition (recommended: do (a) as a milestone inside (b), so a trustworthy book is online within weeks while the rewrite proceeds).
2. **Language/tooling**: keep R-only; R with optional Python tabs; or Python-first. hydrosolutions' current stack (SAPPHIRE, long-term-forecasting, taqsim, delineator, airGR_GM, glaciermapper-ca, ZRB MODFLOW) is Python/R-mixed and Colab-based (zarafshan-taqsim-course). Recommendation: R stays the narrative language for Parts I–II, Part III gains Python where the operational tools live.
3. **Core rainfall-runoff tool**: RS Minerve GUI (current, screenshot-bound, not reproducible) vs. a scriptable model (airGR + CemaNeige + glacier module as in `airGR_GM`, or RSMinerveR to drive RS Minerve). Recommendation: keep an RS Minerve track for hydromet practitioners but make the book's own calibration examples scripted and reproducible.
4. **Case basins**: the book currently drifts between Gunt, Chirchik, Nauvalisoy, Chon Kemin, Atbashy and Zarafshan. Pick one primary basin for the end-to-end thread (Zarafshan now has the richest hydrosolutions material: Taqsim course, groundwater model, CCI chapter) plus Gunt/Chirchik for Part I.
5. **Data hosting**: Zenodo data pack with version DOI (replaces 14 Dropbox links), downloaded by a single helper function; `freeze: auto` so rendering never needs the raw data on CI.
6. **Pedagogy in the LLM era**: reframe exercises from "reproduce these clicks" to "specify, generate, verify, critique"; add assistant-prompt boxes; drop most QGIS screenshot guides in favour of scripted delineation (MERIT-Hydro `delineator`, whitebox) with a short, maintained QGIS primer.

### Phase 0 – Make it buildable again (1–2 weeks, mostly mechanical, can be done by an agent)
- Locate/assemble `caham_data`; create Zenodo pack; replace Dropbox links and `../caham_data` with a data helper.
- `renv.lock`, `freeze: auto`, GitHub Actions render + deploy; drop committed `docs/` and `_book/` from git; shrink repo (images 146 MB).
- Migrate `raster`/`sp`/`rgdal` → `terra`/`sf`; tmap v3 → v4; remove `install_github` from evaluated chunks; replace `vembedr`/`slickR` with Quarto `{{< video >}}`/lightbox; define or drop `callout-task`.
- Fix all cross-references (`\@ref`, `(@sec-…)`, dead anchors), orphan files, heading levels, duplicate bib keys.
- Update dead links (RS Minerve → crealp.ch/rs-minerve, Posit, QGIS LTR).

### Phase 1 – Correctness release "2026.Q4" (2–3 weeks, author review of each change)
- Fix the confirmed formula and data errors (Sections 2 and 6).
- Repair the study guide (chapter numbers, generic course framing, exercise→solution links).
- Remove or clearly mark unfinished sections; update "What's New", edition tag, DOI, citation note, cover.

### Phase 2 – New edition, chapter by chapter (3–6 months, agent drafts + author science review)
- Part II refresh: RGI 7 / Millan / GlaMBIE, Copernicus DEM, WorldCover, ERA5-Land, CHELSA-W5E5/ISIMIP3b, public CHELSA daily, HMASR, SnowMapper/MCASS; cloud-native access (STAC/GEE) instead of multi-GB downloads.
- Climate-change chapter completed end-to-end with trend-preserving bias correction (QDM/ISIMIP3BASD or pre-corrected forcing).
- Glacier chapter rebased on OGGM/PyGEM (Rounce 2023) output as model sources; drop volume–area scaling as primary method.
- Predictive-inference chapter: proper hindcast design, time-series CV, skill scores, probabilistic/ML models; connect to SAPPHIRE/long-term-forecasting.
- Budyko chapter finished as reproducible notebook over the gauge set.
- New chapter "Operational hydrology in practice": iEasyHydro, SAPPHIRE Forecast Tools, SnowMapper dashboards, Taqsim; closes the loop promised by `real_world_examples.qmd`.
- Study guide rewritten with learning tracks that include assistant-supported work and assessment criteria that reward judgement over reproduction.

### Phase 3 – Launch
- New version DOI, announcement, YouTube refresh, translation check (RU), invite hydromet reviewers (issue #7 style feedback round).

## 8. Data folder inventory (2026-11-02)

Location (Dropbox, online-only on this Mac): `hydrosolutions Dropbox/Tobias Siegfried/1_HSOL_PROJECTS/PROJECTS/[2020-06-TW] Currricula Strengthening CA/CourseMaterials/Handbook/`
containing `caham_data/` (≈7,000 files) and `HydrologicalModeling_CentralAsia_Data/REFERENCE_CaseStudyPacks/` (76k files, 72 GB, fully local).
Exact sizes of online-only files cannot be read locally (placeholders report 0 bytes) nor from the public share pages (folder sizes hidden). Dropbox app → Preferences → Sync → "Choose folders" shows them.

Note: `caham_data` as a whole is publicly shared (link in glacier_modeling.qmd:345, commented out). The "fut_sim" share linked at climate_data.qmd:327 now contains only a MeteoSwiss PDF, so the GCM-data link readers are sent to is effectively broken.

### Measured sizes (read from the public share listing, 2026-11-02)

Evaluated at render time (must be present to rebuild the book):

| Folder (relative to caham_data) | Size | Note |
|---|---|---|
| climate/CHELSA/CHELSA_pr_1979_55_85_30_50_V.2.1.nc | 1.31 GB | largest single input; only opened for a figure in climate_data.qmd:269 |
| SyrDarya/Atbashy/SNOW | 0.52 GB | two HMASR tiles (248 + 266 MB) + SWE.RData |
| central_asia_domain/glaciers/Hugonnet + SyrDarya/Atbashy/GLACIERS/Hugonnet | 0.28 GB × 2 | same CSV stored twice |
| central_asia_domain/climate/chelsa_v21 (climatologies/hist_obs 282 MB, monthly ≈ 0.25 GB est., ai tif 43 MB) | ≈ 0.58 GB | |
| AmuDarya/gunt_data/geospatial | 0.23 GB | DEM 150 MB + hillshade 84 MB |
| AmuDarya/17050_Gunt/GIS + GaugeData | 0.15 GB | one 150 MB raster |
| central_asia_domain/glaciers/RGIv60 + Farinotti RData + Miles | 0.10 GB | |
| SyrDarya/Atbashy/GLACIERS/Farinotti (3,762 tiles, ≈10 KB each) + GIS + PERMAFROST + RSMINERVE | ≈ 0.07 GB | |
| student_case_study_basins/15149_ChonKemin/{GIS, GaugeData, RS_MINERVE} | ≈ 0.06 GB | |
| climate/HIST_SIM/pr_day_GFDL-ESM4_historical…nc | 0.02 GB | |
| **Total to hydrate** | **≈ 3.6 GB** | plus 0.6 GB of REFERENCE_CaseStudyPacks already local |

Not needed for rendering (eval: false or unused):
- central_asia_domain/glaciers/PyGEM: 7.57 GB (single HMA RCP2.6 netCDF) — the biggest item in the whole folder.
- climate/FUT_SIM 0.75 GB + HIST_SIM 0.14 GB, and an identical copy under central_asia_domain/climate — the CMIP6 files are domain clips of 11–62 MB each, not global.
- SyrDarya/Atbashy/CLIMATE 0.62 GB (qmapped glacier tas).
- student_case_study_basins: 9 basins; Zarafshan/Climatology alone ≈ 3 GB (62 CHELSA yearly clips of 50 MB); others not measured.
- Not measured: agriculture, copernicus_land_cover, gauges_basins, permafrost, Chirchiq, basins, discharge, GIS, the other 8 student packs, 17050_Gunt/{CODE, Climatology, Landcover, RS_MINERVE, Glaciers}.

Whole caham_data: order of 15–25 GB (lower bound from measured items ≈ 15 GB).

### What the rendered book actually reads (by chapter)
| Chapter | Folder (relative to caham_data unless noted) | Files | Likely size |
|---|---|---|---|
| hydrological_systems | REFERENCE_CaseStudyPacks/{GRDC, CENTRAL_ASIA_DOMAIN/RIVER_BASINS, COMPLETE_FINAL_BASIN_DATA} | 433 | 0.6 GB (local) |
| example_river_basins | AmuDarya/gunt_data/{geospatial, station_data} | 18 | small |
| climate_data | AmuDarya/17050_Gunt/{GIS, GaugeData}; central_asia_domain/climate/chelsa_v21/climatologies; student_case_study_basins/15149_ChonKemin/{GIS, GaugeData, RS_MINERVE} | ~80 | small |
| climate_data:269,273 | climate/CHELSA/CHELSA_pr_1979_55_85_30_50_V.2.1.nc; climate/HIST_SIM/pr_day_GFDL-ESM4_historical_…nc | 2 | several GB (the only large evaluated inputs) |
| snow_and_glacier_data | SyrDarya/Atbashy/{GIS, SNOW (4 HMASR nc), GLACIERS (3,762 Farinotti tifs + Hugonnet/Miles csv), PERMAFROST} | ~3,780 | ~1–5 GB (HMASR dominates) |
| hydraulic_hydrological_modeling | SyrDarya/Atbashy/SNOW/SWE.RData; central_asia_domain/glaciers/Hugonnet | 2 | small |
| glacier_modeling | central_asia_domain/glaciers/{RGIv60, Farinotti/*.RData} | 6 | small |

### Only needed by readers reproducing `eval: false` code
- `climate/HIST_SIM` + `climate/FUT_SIM` (40 global daily CMIP6 netCDFs: 4 GCMs × tas/pr × hist + 4 SSPs) and an identical copy under `central_asia_domain/climate/{hist_sim,fut_sim}`. These are almost certainly the bulk of the folder (order of 1–5 GB per file).
- `central_asia_domain/glaciers/PyGEM` (HMA RCP nc), `SyrDarya/Atbashy/CLIMATE`, `AmuDarya/17050_Gunt/{RS_MINERVE, Glaciers}`.
- `student_case_study_basins/*` (9 basins; Zarafshan alone has 62 × 50 MB CHELSA yearly clips ≈ 3 GB).

### Recommendation
Hydrate only the evaluated set above (~22 subfolders, measured ≈ 3.6 GB), skip the GCM copies entirely, and in Phase 0 replace the two large evaluated reads with pre-extracted small files so that a frozen render needs no multi-GB inputs. Publish the evaluated set plus one case-study pack as the Zenodo "book data pack"; keep raw CMIP6 out of it and point to ESGF/ISIMIP instead.

## 9. Long-term water balance chapter: source study and data (2026-11-02)

Study: Siegfried, Mujahid, Marti, Molnar, Karger, Yakovlev et al. (2024), "Unveiling the future water pulse of Central Asia: a comprehensive 21st century hydrological forecast from stochastic water balance modeling", Climatic Change 177:141, open access, DOI 10.1007/s10584-024-03799-y.

Key facts for the chapter:
- 221 mountain subcatchments (> 200 km²) from 295 gauges (CA-discharge norms, Marti et al. 2023); 423,099 km²; runoff ratio ≈ 0.42.
- Method is the Porporato steady-state stochastic soil-moisture model (PSM, Porporato 2004 / Daly 2019), not Budyko–Choudhury: runoff coefficient ρ(Φ, γ) with aridity index Φ = Ep/P and storage index γ = w0/α; Q = P·ρ + Q_glacier. No calibration; α, λ from CHELSA daily (1 mm wet-day threshold), w0 from rooting depth × (porosity, s1, sw). ρ computed in Mathematica at high precision (hypergeometric function), hence the g_mathematica / gamma_and_phi CSVs.
- Inputs: CHELSA V2.1 daily P and T 1979–2011; Oudin PET bias-corrected to CHELSA Penman; CMIP6 (UKESM1-0-LL, IPSL-CM6A-LR, MRI-ESM2-0, GFDL-ESM4) × SSP1-2.6/2-4.5/3-7.0/5-8.5, qmap-corrected, periods 2011–40 / 2041–70 / 2071–2100; HiHydroSoil v2 (WCsat, WCpF4.2); Fan 2017 rooting depth rescaled with Copernicus LC100 2019 and Hauser 2022; Rounce 2023 glacier runoff (17,993 glaciers, RGI 6); SRTM; HydroLAKES; GRDC WMOBB basins; GADM 4.1.
- Headline results: P +5.5…+10.1 % by 2100; T +1.9…+5.6 °C; Ep +5.7…+19 %; E +7.3…+17.4 %; specific Q change by period/scenario between −2.7 % and +5.6 %; glacier contribution +24…+29 % (2011–40) then −11…−14 % (2071–2100); Tien Shan basins drying, Pamir/Gissar-Alay increasing.

Data and code:
- Zenodo 10.5281/zenodo.10125163 (concept 10.5281/zenodo.10125162), CC-BY 4.0: DATA_ZENODO.zip 2.45 GB, CODE_ZENODO.zip 0.3 MB (qmd 01–07 + two Mathematica notebooks), METHODS_ZENODO.zip. This is the citable source to use in the book; no Dropbox dependency needed.
- Dropbox working copy (online-only): `1_HSOL_PROJECTS/PROJECTS/2021_03_TW Hydro4U/PUBLICATIONS/wet_central_asia/{CODE, CODE_ZENODO, DATA (261 files), DATA_ZENODO (88 files)}`. DATA_ZENODO contents: basins_latlon_prep.gpkg; climate/bc_{hist_obs,hist_sim,fut_sim}_{pr,tas}*.Rds; pet_oudin_qmapped.rds; pr_characteristics.rds; gamma_and_phi_* and g_mathematica_* per period/scenario; rasters (LC100 2019, HiHydroSoil WCsat/WCpF4.2 top/subsoil, rooting depth Fan/Yang/Stocker, GLHYMPS porosity, dem_ca, hill_ca); shapes (CA-discharge.gpkg, GADM, HydroLAKES, RGI6 by basin, WMOBB river nets); tas_basin_scenario_summary_tbl.Rds. The working DATA folder additionally holds sensitivity runs (fan_d66/d80/d95/d99, stocker, yang), CMIP6 soil-moisture/evap checks (CMIP6_SM_E, 32 nc), results CSVs (delta_q_long, dqq_per_basin_period_table, res_cc, q_periods_gcm_ensemble_mean_TUM) and a QGIS project (wet_and_hot_paper.qgz).
- The current chapter text (long_term_water_balance_modeling.qmd) derives Budyko/Choudhury; the study uses PSM. Rewrite the chapter as "Long-term water balance modeling": Budyko as conceptual intro → PSM as the worked, reproducible example (scripts 01, 05, 07, 09 from CODE), driven from the Zenodo pack via a download helper, with the Chu/Naryn drying vs Pamir increase as the teaching narrative.

Minimum file set for a teaching version (≈ 100 MB, not the 2.45 GB pack): basins_latlon_prep.gpkg, shapes/CA-discharge.gpkg, gamma_and_phi_bl.csv + gamma_and_phi_{1,2,3}_ssp*.csv, g_mathematica_bl.csv + g_mathematica_{1,2,3}_ssp*.csv, pr_characteristics.rds, pet_oudin_qmapped.rds, tas_basin_scenario_summary_tbl.Rds, climate/bc_*_basin-mean Rds, raster/dem_ca.tif + hill_ca.tif, shapes/wmobb_rivnets_*. Exact sizes to be read from the Zenodo zip listing.

### Local data state (2026-11-02, evening)
- `../caham_data` is now a real local folder (not a Dropbox link) holding the render-time subset: 4.4 GB, 3,962 files, downloaded as zips from the public share and unpacked with a Python extractor (Dropbox zips carry a "/" root entry that makes macOS `unzip` return an error). Measured per-folder: CHELSA daily 1979 1.3 GB, chelsa_v21 climatologies 978 MB (monthly pr/tas/pet tifs were larger than estimated), Atbashy SNOW 532 MB, AmuDarya 459 MB, Atbashy GLACIERS 351 MB, Hugonnet 289 MB, student ChonKemin 281 MB, HIST_SIM 144 MB.
- `../HydrologicalModeling_CentralAsia_Data` is a symlink to the Dropbox folder; the three subfolders the book reads there are fully local (0.6 GB).
- The legacy Dropbox online-only placeholders in `Handbook/caham_data` are NOT hydrated by reading them from a script; a Finder "Make available offline" would be needed. Not required now.
- Download scripts: scratchpad `download_subset.sh` + `extract.py` (folder tokens of the public share hard-coded).

### Phase 0 addition: book-wide figure standard
Adopt the figure and map standard defined in planning/chapter_plan_long_term_water_balance.md §4a for all chapters: shared `theme_caham()`, `tm_caham()` map layout, one palette registry (viridis/scico sequential, zero-centred diverging, Okabe–Ito categorical, AR6 scenario colours), uncertainty always shown, SVG export with units, captions and alt text, and the eight-point figure checklist. Existing figures are redrawn chapter by chapter during Phase 2; the 79 appendix screenshots are out of scope for this standard.

### Phase 0 addition: book-wide didactic and validation standard
Adopt §4b (didactic) and §4c (validation) of planning/chapter_plan_long_term_water_balance.md for every chapter: explicit prerequisites box and notation table, explain-then-formalise, worked→faded→independent exercise pattern, check-yourself boxes, glossary with Russian equivalents, full DOI-verified citations, and the four-part validation (technical, citation, cold-reader didactic review in English and via Russian machine translation, author sign-off). Build the shared tooling once in Phase 0: citation audit script, prerequisite ledger template, cold-reader review prompt, validation report template.

## 10. Publishing standard for the new edition (book-wide)

Beyond figures (§4a), didactics (§4b) and validation (§4c) of the chapter plan, an open-access textbook of this kind should meet the following, grouped by what they protect.

**Identity and citability**
- One concept DOI for the book and a new version DOI per edition (Zenodo), shown on the title page with a "How to cite" block; `CITATION.cff` in the repo; ORCID iDs for all authors; CRediT roles for contributors; an ISBN for the PDF/print edition (needed for library cataloguing and DOAB listing).
- Edition naming by year and number (e.g. "2027.1"), git tag per release, archived PDF per edition, errata page, changelog in the front matter.

**Rights and licences**
- Keep CC BY-SA 4.0 for the text; record per-figure and per-dataset licences in a Rights and Data statement (CHELSA, Copernicus, NASA, OSM basemaps, GRDC, hydromet gauge data, screenshots of RS MINERVE and QGIS); confirm that hydromet-provided gauge data may be published, and name the agreements.
- Trademark attributions (RS MINERVE, QGIS, Posit) in the colophon.

**Formats and production**
- HTML as the primary edition; a print-ready PDF (A4, Quarto typst or LaTeX) with identical numbering, cross-references and figure quality; EPUB optional. One render pipeline on CI for all formats; render from a lockfile (`renv`) and a container image so the edition can be rebuilt years later.
- Front matter: title page, authors and affiliations, preface, how to use the book, learning tracks, acknowledgments with grant numbers (SDC Blue Peace, EU Hydro4U 101022905), notation list, glossary EN/RU. Back matter: solutions, bibliography, index, colophon with toolchain and package versions.

**Editorial quality**
- A written style sheet: spelling variant (recommend British English as in the current text), SI units and number formatting, transliteration standard for Central Asian names (BGN/PCGN, with the Russian/local form at first mention), consistent river and basin names, hyphenation, abbreviations list.
- One copy-edit pass and one proofreading pass per edition after the didactic review; a terminology check against the glossary.

**Review and integrity**
- External peer review by two or three regional experts (hydromet, university) per edition, acknowledged in the front matter; reviewer comments archived.
- An AI-use statement in the front matter describing how language models were used (drafting, code porting, review) and that all content was verified by the authors, in line with COPE guidance.
- Author contributions, funding and conflict-of-interest statements; plagiarism/self-text-reuse check against the source papers.

**Open science and reproducibility**
- Data pack and code with DOIs, FAIR metadata (README, variable dictionaries, units, provenance); software citations with versions; reproducibility statement per chapter listing data, code and runtime.
- Contribution guide, code of conduct, issue templates for errata; a maintenance policy that replaces the current "project concluded" notice (support period, release cadence, contact).

**Accessibility and reach**
- WCAG 2.2 AA for the HTML: alt text on every figure, colour contrast, logical heading order, keyboard navigation, accessible math (MathJax with assistive settings), language tags.
- Metadata for discovery: schema.org/Dublin Core and Google Scholar tags in the HTML head, sitemap, registration with DOAB/OAPEN once an ISBN exists, deposit in an institutional or national repository, and a Russian-language landing page and glossary; consider a full Russian edition of Part I and the study guide given the audience.

**Pedagogical packaging**
- Instructor resources: syllabus mapping to chapters, slide decks, exercise data packs, rubrics, learning-outcome matrix; a student-facing "how to study this book" page with time estimates.
