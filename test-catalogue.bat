@echo off
setlocal

set BUNDLE_GEMFILE=.env-files\Gemfile.github

if not exist _data mkdir _data
(
echo data_updated_at: "2026-09-13T18:30:00Z"
echo git_updated_at: "2026-09-13T18:00:00Z"
echo total_repositories: 123
) > _data\catalogue_status.yml

echo Test status file written to _data\catalogue_status.yml
echo Installing gems...
call bundle install
if errorlevel 1 goto :end

echo Starting Jekyll... open http://127.0.0.1:4000/catalogue
call bundle exec jekyll serve

:end
pause
