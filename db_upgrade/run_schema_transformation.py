from typing import Any
import requests
import datetime


class Loader:
    def __init__(self):
        self.url = "http://localhost:8080/geonetwork"
        self.username = "admin"
        self.password = "admin"
        self.session = None

    def login(self) -> "Loader":
        self.session = requests.Session()
        r = self.session.get(self.url)
        xsrf_token = r.cookies["XSRF-TOKEN"]
        r = self.session.post(
            self.url + "/signin",
            params={
                "username": self.username,
                "password": self.password,
                "_csrf": xsrf_token,
            },
            headers={"Cookie": r.headers["Set-Cookie"]},
            )
        return self

    def convert(self, uuid):
        r = self.session.post(
            self.url + "/srv/api/processes/convert-to-iso19115-3.2018.che",
            params={
                "uuids": uuid,
                "updateDateStamp": "true",
                "index": "false",
            },
            headers=self.build_headers("application/xml"),
            )
        if b'update-fixed-info.xsl' in r.content:
            print ('update fixed info error for ' + uuid)
        return r.status_code

    def read_uuids(self):
        with open("md_and_subtemplate_uuid.json", "r", encoding="utf-8") as f:
            query = f.read()
        r = self.session.post(
            self.url + "/srv/api/search/records/_search",
            data=query,
            headers=self.build_headers("application/json"),
            )
        result = r.json()
        hits = result.get("hits", {}).get("hits", [])
        return [
            hit["_source"].get("uuid")
            for hit in hits
            if "_source" in hit
        ]

    # psql -At -h localhost -p 5433 -U postgres -W -d gn -c "select uuid from metadata where (istemplate='s' or istemplate='n') and schemaid='iso19115-3.2018.che' ;" > uuids.txt
    def read_uuids_from_file(self):
        with open("uuids_errored.txt", "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]


    def build_headers(self, content_type) -> dict[str, str | Any]:
        headers = {
            "Accept": "application/json",
            "X-XSRF-TOKEN": self.session.cookies["XSRF-TOKEN"],
            "Cookie": "XSRF-TOKEN=%s; JSESSIONID=%s"
                      % (
                          self.session.cookies["XSRF-TOKEN"],
                          self.session.cookies["JSESSIONID"],
                      ),
        }
        if content_type is not None:
            headers["Content-Type"] = content_type
        return headers

print (datetime.datetime.now())

loader = Loader()
loader.login()
uuids = loader.read_uuids_from_file()
for x in uuids:
    s = loader.convert(x)
    print (x + " : " + str(s))

print (datetime.datetime.now())

# select count(*) from metadata where data like '%<mdb%' or data like '%<gex%' or data like '%<cit%';
# select count(*) from metadata where data like '%<gmd%';