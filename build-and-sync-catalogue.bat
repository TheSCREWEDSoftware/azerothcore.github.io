@echo off
setlocal

set "JEKYLL_DIR=%~dp0"
set "SRC=%JEKYLL_DIR%..\git-catalogue"

cd /d "%SRC%"

if not exist node_modules (
  echo Installing dependencies, this only happens once...
  call npm ci
  if errorlevel 1 goto :end
)

echo Writing production config to src\assets\config.json...
if not exist src\assets mkdir src\assets
(
echo {
echo   "perPage": 100,
echo   "pageSize": 8,
echo   "usePreGeneratedFile": true,
echo   "preGeneratedFileUrl": "/data/catalogue.json",
echo   "globalSearch": true,
echo   "tabs": {
echo     "All": {
echo       "path": "/all"
echo     },
echo     "Modules": {
echo       "topic": "azerothcore-module",
echo       "org": "azerothcore",
echo       "path": "/module"
echo     },
echo     "Tools": {
echo       "topic": "azerothcore-tools",
echo       "org": "azerothcore",
echo       "path": "/tools"
echo     },
echo     "Lua/Eluna/ALE Scripts": {
echo       "topic": "azerothcore-lua",
echo       "org": "azerothcore",
echo       "path": "/lua"
echo     },
echo     "SQL": {
echo       "topic": "azerothcore-sql",
echo       "org": "azerothcore",
echo       "path": "/sql"
echo     },
echo     "DBC": {
echo       "topic": "azerothcore-dbc",
echo       "org": "azerothcore",
echo       "path": "/dbc"
echo     }
echo   }
echo }
) > src\assets\config.json

echo Building Angular app (production)...
call npm run build -- --configuration=production --output-hashing=none
if errorlevel 1 goto :end

echo Copying build output into the Jekyll site...
if not exist "%JEKYLL_DIR%javascripts\catalogue" mkdir "%JEKYLL_DIR%javascripts\catalogue"
copy /Y "dist\git-catalogue\runtime.js"   "%JEKYLL_DIR%javascripts\catalogue\runtime.js"
copy /Y "dist\git-catalogue\polyfills.js" "%JEKYLL_DIR%javascripts\catalogue\polyfills.js"
copy /Y "dist\git-catalogue\scripts.js"   "%JEKYLL_DIR%javascripts\catalogue\scripts.js"
copy /Y "dist\git-catalogue\main.js"      "%JEKYLL_DIR%javascripts\catalogue\main.js"
copy /Y "dist\git-catalogue\styles.css"   "%JEKYLL_DIR%stylesheets\catalogue_style.css"

if not exist "%JEKYLL_DIR%assets" mkdir "%JEKYLL_DIR%assets"
robocopy "dist\git-catalogue\assets" "%JEKYLL_DIR%assets" /E /NFL /NDL /NJH /NJS

echo.
echo Done. Refresh (or restart) jekyll serve to see your changes at
echo http://127.0.0.1:4000/catalogue
echo.

:end
pause
