# Data tooling

The book's evaluated code reads from `../caham_data` (relative to the repo root) and from
`../HydrologicalModeling_CentralAsia_Data/REFERENCE_CaseStudyPacks/` (three subfolders only).

## Getting the render-time data subset (≈ 4.4 GB)

The subset is served, folder by folder, as zip files from the public Dropbox share of `caham_data`
(share tokens are hard-coded in the script and were valid on 2026-11-02).

```bash
bash tools/data/download_caham_subset.sh /tmp/caham_dl      # downloads 18 zips (≈ 4.3 GB)
python3 -I tools/data/extract_dropbox_zips.py /tmp/caham_dl   # unpacks into ../caham_data
```

`unzip` fails on these zips because Dropbox adds a "/" root entry; the Python extractor skips it.
The script also removes a `../caham_data` symlink if one exists and creates a real folder.

Set `CAHAM_DATA=/path/to/caham_data` to override the destination.

## What is in the subset

See `planning/2026_update_review.md` §8 for the measured per-folder sizes and for which chapter
reads which folder. Everything in `eval: false` chunks (CMIP6 FUT_SIM, PyGEM, Atbashy CLIMATE,
the other eight student packs) is deliberately not included.

## Long-term water balance chapter data

Siegfried et al. (2024) data and code: Zenodo 10.5281/zenodo.10125163 (DATA_ZENODO.zip 2.45 GB,
CODE_ZENODO.zip, METHODS_ZENODO.zip). See `planning/chapter_plan_long_term_water_balance.md` §3.
