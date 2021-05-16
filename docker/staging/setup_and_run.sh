#!/bin/bash
set -e
cd /srv/repo/src/open_survey_tool

# run migration
python3 manage.py migrate
echo "Migration successful"

python3 manage.py loaddata surveys/fixtures/example.json
echo "Fixture loading successful"

python3 manage.py collectstatic --no-input --clear
echo "Collected static files"

cd open_survey_tool/

uwsgi --ini uwsgi.ini
