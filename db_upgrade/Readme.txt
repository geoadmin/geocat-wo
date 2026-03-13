FYI: '''Python 3.14.2 (main, Dec  8 2025, 12:14:05) [GCC 11.4.0] on linux'''

python3 -m venv .venv
source .venv/bin/activate

pip install requests

1. build a tarball with source datadir
2. shutdown target gn server
3. delete (move before delete) target datadir/ restore datadir from tarball
4. dump source db in sql
5. load sql dump locally
6. clean db locally
7. convert db locally (optional)
8. transform db locally (requiring "update metadata set schemaid='iso19115-3.2018.che' where schemaid='iso19139.che';")
9. empty target db / load dump from local db
10. restart gn server and re-index
