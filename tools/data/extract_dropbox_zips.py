import zipfile, sys, os, pathlib
DEST = pathlib.Path(os.environ.get("CAHAM_DATA", str(pathlib.Path(__file__).resolve().parents[2] / ".." / "caham_data")))
DL = pathlib.Path(sys.argv[1])
rels = ["AmuDarya/gunt_data","AmuDarya/17050_Gunt/GIS","AmuDarya/17050_Gunt/GaugeData",
 "central_asia_domain/glaciers/RGIv60","central_asia_domain/glaciers/Farinotti","central_asia_domain/glaciers/Miles","central_asia_domain/glaciers/Hugonnet",
 "student_case_study_basins/15149_ChonKemin/GIS","student_case_study_basins/15149_ChonKemin/GaugeData","student_case_study_basins/15149_ChonKemin/RS_MINERVE",
 "SyrDarya/Atbashy/GIS","SyrDarya/Atbashy/PERMAFROST","SyrDarya/Atbashy/RSMINERVE","SyrDarya/Atbashy/GLACIERS","SyrDarya/Atbashy/SNOW",
 "central_asia_domain/climate/chelsa_v21","climate/HIST_SIM","climate/CHELSA"]
for rel in rels:
    z = DL / (rel.replace("/","_") + ".zip")
    if not z.exists(): continue
    out = DEST / rel; out.mkdir(parents=True, exist_ok=True)
    try:
        zf = zipfile.ZipFile(z); n = 0; bad = 0
        for info in zf.infolist():
            name = info.filename.lstrip("/")
            if not name or name.endswith("/"): continue
            target = out / name
            if not str(target.resolve()).startswith(str(out.resolve())): bad += 1; continue
            target.parent.mkdir(parents=True, exist_ok=True)
            with zf.open(info) as src, open(target, "wb") as dst:
                while True:
                    chunk = src.read(1 << 20)
                    if not chunk: break
                    dst.write(chunk)
            n += 1
        zf.close(); z.unlink()
        print(f"ok   {n:5d} files  {rel}" + (f"  (skipped {bad} unsafe paths)" if bad else ""))
    except Exception as e:
        print(f"FAIL {rel}: {e}")
