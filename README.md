# GN vanilla-wo
GeoNetwork vanilla - war overlay

# Starting Geonetwork with PostGIS and Elasticsearch
docker run --network="host" -p 8080:8080 -e GEONETWORK_DB_HOST=localhost -e GEONETWORK_DB_PORT=5433 -e GEONETWORK_DB_USERNAME=postgres -e GEONETWORK_DB_PASSWORD=postgres -e GEONETWORK_DB_NAME=gn -e JAVA_OPTS="-Des.protocol=http -Des.host=localhost -Des.port=9200" -e GEONETWORK_DB_TYPE=postgres-postgis-hikari ghcr.io/camptocamp/swiss-gn-wo/gn-with-swiss-overlay:4.4.9-41

To include Geonetwork dir persistence: a volume can be mounted and geonetwork.dir can be set using the environment variable GEONETWORK_DIR.

docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "xpack.security.enabled=false" -e "xpack.security.enrollment.enabled=false"  -e "ES_JAVA_OPTS=-Xms1G -Xmx1G" docker.elastic.co/elasticsearch/elasticsearch:8.14.3

Please note that the chosen config-editor.xml implies that "Enable XLink resolution" must be checked.