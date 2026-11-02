# Plan: rebuilding "Long-term Water Balance Modeling" (Part III, Ch. 9)

Status: proposal, 2026-11-02. Source study: Siegfried et al. (2024), Climatic Change 177:141, doi 10.1007/s10584-024-03799-y. Data and code: Zenodo 10.5281/zenodo.10125163 (CC-BY 4.0).

## 1. What the chapter should become

Today the file is a Budyko/Choudhury derivation followed by an outdated data inventory and two "check back later" placeholders; it has no code, no figure, no exercise. The rebuilt chapter keeps the Budyko framework as the conceptual entry point and uses the published study as the worked, fully reproducible regional application: 221 mountain catchments, baseline 1979–2011, CMIP6 projections to 2100.

Learning outcomes:
1. Explain the long-term water balance and the Budyko space; place any catchment in it from norm discharge, P and Ep.
2. Understand why a one-parameter curve is not enough, and how the stochastic soil-moisture model (PSM) replaces the free parameter n with two physically defined indices: aridity Φ = Ep/P and storage γ = w0/α.
3. Compute the runoff coefficient ρ(Φ, γ) in R, validate it against observed norm discharge, and interpret the errors.
4. Run a delta-change climate impact assessment for the region and read the spatial pattern (Tien Shan drying, Pamir/Gissar-Alay wetting, glacier peak water).
5. Judge the model's limits (no snow, no permafrost, steady state, Poisson rainfall) and know when to reach for a daily rainfall-runoff model instead (link to Ch. 8 and Ch. 12).

## 2. Proposed structure

| § | Title | Content | Source |
|---|---|---|---|
| 9.1 | Why long-term water balances | Keep current prose (water balance, energy balance, Bowen ratio, aridity index), fix the Choudhury exponent (−1/n) and the dead `\@ref` links; add a real Budyko-space figure of the 221 Central Asian catchments instead of the commented-out US figure | current text; script 01 §X.9 |
| 9.2 | Data: Central Asian catchments and their climate | CA-discharge (Marti et al. 2023): 295 gauges → 221 catchments > 200 km²; CHELSA V2.1 daily P, T; Oudin Ep bias-corrected to CHELSA Penman; HiHydroSoil, rooting depth, land cover, RGI 6 + Rounce 2023 glacier runoff; table of catchment statistics (Table 1 of the paper) | script 01 §B–C, §3, §4; 05_pet_oudin |
| 9.3 | From Budyko to a process model: the PSM | α, λ, Φ, γ, w0 definitions; the analytical ρ(Φ, γ); its limits (γ→∞ gives the Budyko-like curve, Φ→0 gives ρ→1); numerical pitfalls and the log-space R implementation (replaces Mathematica) | paper Eqs. 2–5; script 01 §5.8, §X.8; new code |
| 9.4 | Baseline water balance 1979–2011 | Per-catchment Φ, γ, ρ; modelled vs observed norm Q (Fig. 3); error map; discussion of Afghan, Arys and Talas outliers; glacier term Q = Pρ + Q_G | script 01 §6.1, §X.9, METHODS/plot_* |
| 9.5 | Climate change impacts to 2100 | Delta-change theory (§7.1 of script); changes in T, P, α, λ, Ep, w0 by period and scenario (Fig. 2, 4); ΔQ by period/scenario (Fig. 5, Table 2); maps (Fig. 6); basin-level summary (Table 3) | script 01 §7, §X.1–X.7; METHODS/delta_change*.R, dqq_*.R |
| 9.6 | What the model cannot tell you | Snow and permafrost storage, steady-state assumption, Poisson rainfall, groundwater; how the daily models of Ch. 8 and 12 complement it | paper §4 |
| 9.7 | Exercises | see §5 below | new |

Chapter length target: ~6,000 words plus ~12 figures, all rendered from code.

## 3. Data strategy

Two tiers, both DOI-addressable:

1. **Teaching pack (target ≤ 150 MB)**, extracted from DATA_ZENODO and shipped in the book's own Zenodo data pack:
   - `basins_latlon_prep.gpkg` (221 catchments with all baseline attributes), `shapes/CA-discharge.gpkg` (gauges, basins, norms), `shapes/wmobb_rivnets_*`, `shapes/GADM36_*`, `shapes/HydroLAKES_*`, `shapes/large_river_basins_rgi_glaciers_v6_both_regions.*`
   - `gamma_and_phi_{bl,1..3_ssp*}.csv` and `g_mathematica_{bl,1..3_ssp*}.csv` (paper's ρ values, used to validate the R implementation)
   - `pr_characteristics.rds`, `pet_oudin_qmapped.rds`, `tas_basin_scenario_summary_tbl.Rds`, basin-mean climate series (`climate/bc_*` are per-catchment lists; check size, otherwise reduce to basin means)
   - `raster/dem_ca.tif`, `raster/hill_ca.tif` (for maps; downsample if > 50 MB)
   - glacier runoff per catchment and period (derive once from the Rounce 2023 product inside script 01 §6 and save as a small table)
2. **Full reproduction**: the 2.45 GB Zenodo pack and the seven scripts, cited in a callout; the raster-level derivations (rooting depth rescaling, HiHydroSoil, GLHYMPS) are shown as `eval: false` "deep dive" chunks with the Zenodo script as reference.

Loading goes through a single helper (`caham_data("ch09/basins_latlon_prep.gpkg")`) that downloads from the DOI on first use and caches locally; the same helper serves the other chapters in Phase 0. Rendering uses `freeze: auto`, so CI never needs the data.

## 4. Code plan

- New R functions (in the book's `R/` folder or riversCentralAsia): `rho_psm(Phi, gamma)` in log space (`exp(log Φ + (a−1)log γ − γ − lgamma(a) − pgamma(γ, a, log.p = TRUE))`, a = γ/Φ), `eps_psm()`, `delta_change()` ported from METHODS. Validate `rho_psm` against `g_mathematica_*.csv` for all 221 × 13 period/scenario cases; report max abs error in the chapter.
- Port plotting from METHODS/*.R to tmap v4 and ggplot2; drop `magick`, `pdftools`, `CharFunToolR`, `npreg`, `budyko` unless needed.
- Keep the paper's object names (Φ, γ, α, λ, w0) and periods (2011–40, 2041–70, 2071–2100) so the chapter and the paper read as one.
- Chunks that exceed a few seconds get cached results in the teaching pack.

## 4a. Figure and map standard (applies to this chapter first, then book-wide in Phase 0)

Every figure is produced by code from a shared theme so that the whole book looks like one publication. The standard follows the Nature/AGU figure guidelines, the IPCC AR6 visual style guide and Crameri, Shephard & Heron (2020) on scientific colour maps.

**Shared infrastructure (new, in `R/`):**
- `theme_caham()` for ggplot2: one typeface (system sans, e.g. Source Sans or Helvetica), base size 11 pt for web, 9 pt for print export; no gridlines heavier than 0.25 pt; no panel borders; axis titles with units in square brackets ("Specific discharge [mm a⁻¹]"); legend titles with units; no titles inside the plot (the caption carries the title).
- `tm_caham()` layout for tmap v4: equal-area projection for regional maps (Albers equal-area for the 55–85°E / 30–50°N domain; UTM 42N or 43N for single basins), hillshade basemap at reduced contrast, national borders in thin grey, large-basin outlines, graticule with labelled degree ticks, scale bar, north arrow only when the map is not north-up, inset locator map on the first map of each chapter, legend outside the map frame with units and class breaks chosen by quantiles or Jenks and stated in the caption.
- One palette registry (`caham_palettes.R`): sequential = `viridis`/`scico::batlow` (perceptually uniform, colour-blind safe); diverging = `scico::vik` or ColorBrewer RdBu centred exactly at zero with symmetric limits; categorical ≤ 8 classes from Okabe–Ito; SSP scenarios in the IPCC AR6 colours (SSP1-2.6 #1D3354, SSP2-4.5 #EADD3D, SSP3-7.0 #F21111, SSP5-8.5 #840B22, or the equivalent AR6 set) and the three periods in a fixed light-to-dark ramp so that the same scenario and period always have the same colour across the book. Never rainbow/jet; never red–green pairs.
- Uncertainty is always shown: ensemble spread as boxplots or quantile ribbons, never only the median; n is stated in the caption.
- Maps of change show the baseline value as a companion panel or inset, so the reader can see absolute context next to relative change.
- Direct labelling where possible (basin names on maps, scenario labels at line ends); legends only when direct labels do not fit.
- Export: Quarto renders SVG for the web (`fig-format: svg` for plots, PNG at 300 dpi for raster-heavy maps), consistent figure widths (full width 7.5 in, half width 3.6 in), `fig-dpi: 300`, `fig-cap` with data source, period and statistic, and `fig-alt` text for accessibility.
- Panels labelled a, b, c in bold lower case at top left; identical axis ranges across panels that are meant to be compared; shared legends for multi-panel figures (patchwork `guides = "collect"`).
- Tables via `gt` with units in column headers, significant figures matched to data precision, and no vertical rules.

**Figure checklist (run before a figure is accepted):**
1. Does the caption say what, where, when, which statistic, which data source?
2. Are all units present and SI (mm a⁻¹, km², °C, m a.s.l.)?
3. Is the colour map perceptually uniform or correctly diverging about a meaningful zero?
4. Would the figure read in greyscale and for deuteranopia (check with `colorblindr::cvd_grid()`)?
5. Is uncertainty visible?
6. Are text sizes ≥ 7 pt at the final rendered size, and is nothing overplotted?
7. Does the map have projection, scale, graticule, borders, legend outside the frame?
8. Is every number in the figure reproducible from the chunk that draws it?

**For this chapter specifically**, the paper's figures are re-drawn, not reused: the ρ(Φ, γ) surface as a contour plot with the 221 catchments overlaid; Budyko space with the Budyko, Choudhury (n fitted) and PSM curves and catchments coloured by storage index; the validation scatter with 1:1 line, regression, R², and the error map side by side; the ΔQ maps as a 3 × 4 period × scenario plate with one shared diverging legend; basin-level changes as dot-and-range plots rather than bar charts. Each is produced by a function in `R/fig_ch09.R` so that students can call it on their own catchment.

## 4b. Didactic standard (this chapter first, then book-wide)

The audience is an early-career water professional or a Master student in Central Asia, often reading through browser translation, with uneven prior exposure to hydrology, statistics and R. The chapter therefore assumes nothing beyond secondary-school mathematics and the book's Part I, and it declares every other prerequisite explicitly.

**Design principles (grounded in learning research):**
- *Constructive alignment* (Biggs & Tang 2011): the learning outcomes in §1 drive the section order, the worked examples and the exercises; nothing is included that does not serve an outcome.
- *Explain first, formalise second*: every section opens with a plain-language explanation and a Central Asian example (a named river, a real number) before any symbol appears. A formula is only introduced after the reader has seen the idea in words and in a figure.
- *No silent prerequisites*: a "Before you start" box at the chapter head lists what is assumed (Ch. 1 and 2 of this book, basic R, the notion of a mean and a ratio) and links to where each is covered. Every concept used later (aridity index, potential evaporation, Poisson process, steady state, quantile mapping) is either defined where it first appears or linked to its definition. A notation table with symbol, meaning, unit and first-use section sits at the start of §9.3.
- *Manage cognitive load* (Sweller): one new idea per subsection; long derivations go into collapsible "Deep dive" callouts; code is shown in short, commented chunks with the output immediately below; the full analysis script is linked, not inlined.
- *Worked → faded → independent* (Renkl & Atkinson 2003): §9.4 is a complete worked example on one catchment, §9.5 repeats the pattern on all catchments with parts of the code left for the reader, and the exercises require independent application.
- *Retrieval and reflection*: a "Check yourself" box with two or three short questions closes each section; answers in Appendix D. A "Take home" box of at most four sentences closes the chapter.
- *Gentle entry*: §9.1 begins from the bucket picture already used in Ch. 8 (rain in, evaporation and river out, storage change) and reaches the Budyko curve in three steps, each with a figure. The first code chunk the reader meets loads one table and prints five rows.
- *Language*: short sentences, active voice, one idea per sentence, no idioms; consistent terminology (a glossary entry fixes one English term and gives the Russian equivalent for the key concepts, since most readers translate). Reading time per section is stated at the top.
- *Honesty about uncertainty and limits*: §9.6 is not an afterthought; the limitations of the method are taught as part of the method, with concrete consequences for a user in Central Asia.

**Citation standard:**
- Every factual claim, dataset, method and number taken from the literature carries a citation with a resolvable DOI in `references.bib`; the bib entry is verified against Crossref (title, authors, year, journal) before merge. No "well known" statements without a source.
- Datasets are cited as data (product, version, DOI, access date) and software as software (package, version, DOI where available), following the FORCE11 data citation principles.
- The chapter head credits the source study and all its authors; text that is adapted from the paper is marked as adapted, not re-cited sentence by sentence.
- Figures state their data source and licence in the caption; redrawn figures say "redrawn after Siegfried et al. (2024)".
- Duplicate bib keys (`mcvicar2012`/`mcvicar_2012`, `rihai_2017`/`riahi_shared_2017`) are merged in Phase 0.

## 4c. Validation protocol ("validate all")

Nothing in the chapter is accepted on trust. Four independent checks, each producing a written report in `planning/validation/ch09_*.md`:

1. **Technical validation** (agent, automated). Every chunk executes in a clean session with the lockfile; every number quoted in prose is produced by inline R from the same objects as the figures (no hand-typed results); `rho_psm()` matches the Mathematica tables within a stated tolerance for all 221 catchments and all 13 period/scenario cases; the figure checklist of §4a is run on every figure; links and cross-references resolve (Quarto `--strict` plus a link checker).
2. **Citation audit** (agent, automated + manual spot check). All `@keys` resolve; each DOI resolves and the Crossref metadata matches the bib entry; each claim in the text is traced to its source and the source is checked to actually say that; a list of uncited claims is produced and either sourced or removed.
3. **Didactic review** (agent "cold reader" + humans). A reviewer agent with the persona of a second-year hydrology student at a Central Asian university reads the chapter in order, twice: once in English and once through machine translation into Russian, and reports every term, symbol or step it cannot follow from the text alone, plus the time taken. The prerequisite ledger (every concept, where introduced) must be complete. Then two or three real readers (a DKU or ZRB-course student, a hydromet colleague, one co-author) work through the chapter and the exercises; their stumbling points are fixed before release.
4. **Scientific review** (authors). Tobias checks method and claims against the paper, Bea and Aziz the data and the glacier term; sign-off recorded in the validation folder.

Acceptance means all four reports are green. The same protocol is reused for every rewritten chapter in Phase 2.

## 5. Exercises (with solutions in Appendix D)

1. Place your case-study basin (Ch. 2 Gunt or Chirchik, or the student pack basin) in the Budyko space using its norm Q, CHELSA P and Ep; compare with the regional cloud.
2. Sensitivity: recompute ρ for the Chon Kemin catchment with rooting depth D66, D95 and Stocker S0 (the paper's sensitivity files) and explain the spread.
3. Derivation (assistant-supported): ask an AI assistant to derive the limits of ρ(Φ, γ) for γ→∞ and Φ→0, then verify numerically with `rho_psm()`; grade on the verification, not the derivation.
4. Critique (assistant-supported): give the assistant the chapter's ΔQ map and ask it to explain the Tien Shan versus Pamir contrast; identify two claims it makes that the chapter's data cannot support.
5. Transfer: what would change in the method for a lowland irrigated catchment (Zone of water use, Ch. 1)? Written answer, 300 words.

## 6. Work steps and effort

| Step | What | Effort | Who |
|---|---|---|---|
| 1 | Download DATA_ZENODO (2.45 GB), build and measure the teaching pack, write the data helper | 0.5 day | agent |
| 2 | Implement and validate `rho_psm()` against the Mathematica tables | 0.5 day | agent |
| 3 | Draft §9.1–9.6 with code and figures redrawn to the figure standard (§4a) | 2.5 days | agent |
| 4 | Exercises, check-yourself boxes, glossary entries and solutions | 1 day | agent |
| 4v | Validation: technical run, citation audit, cold-reader review (§4c) | 1 day | agent |
| 5 | Science review, wording, what to leave out | 0.5–1 day | Tobias (+ Bea, Aziz for method details) |
| 6 | Publish teaching pack on Zenodo under the book's record, final render | 0.5 day | agent + Tobias (Zenodo account) |

Total about 6 agent-days plus one to two author-days (review plus the didactic read by two or three real readers), spread over 2–3 weeks of review turnaround.

## 7. Decisions needed from the authors

1. Keep the Choudhury curve at all? Recommendation: keep it as a one-paragraph bridge, fit n to the 221 catchments in one chunk, then show why PSM is preferable.
2. Which catchment carries the exercises: Chon Kemin (already in the student pack and used in Ch. 7) or Gunt (used in Ch. 2)? Recommendation: Chon Kemin.
3. Glacier term: present Rounce 2023 output as given data (short) or derive per-catchment series in the chapter (long)? Recommendation: given data, with a pointer to Ch. 11.
4. Teaching pack hosting: new Zenodo record for the whole book (preferred, one DOI for all chapters) or a chapter-specific record.
5. Authorship line of the chapter: the paper's author list should be cited at the top of the chapter.

## 8. Risks

- `rho_psm` may deviate from the 200-digit Mathematica values for extreme γ/Φ; the validation step decides whether a few catchments need `Rmpfr`.
- `bc_*` climate lists may be too large for the teaching pack; fallback is basin-mean series only.
- The Rounce 2023 glacier product is not in DATA_ZENODO; the per-catchment glacier runoff must be recovered from the paper's intermediate results (basins_latlon_prep.gpkg should hold q_glac columns; verify).
