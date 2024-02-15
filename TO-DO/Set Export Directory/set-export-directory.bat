

@echo off
set "search=C:\"

for /f "delims=" %%a in (umodel.cfg) do (
  for %%b in (%%a) do (
    echo %%b|find "%search%"
  )
)

pause

ExportPath = "C:\umodel_win32\UmodelExport\"