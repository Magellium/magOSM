------------
--epcis--
-------------

DROP MATERIALIZED VIEW IF EXISTS epcis_polygon;
CREATE MATERIALIZED VIEW epcis_polygon AS 
	SELECT
		osm_id,
		name,
		tags->'local_authority:FR' as "local_authority-FR",
		tags->'website' as "website",
		tags->'ref:FR:SIREN' as "ref-FR-SIREN",
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM planet_osm_polygon 
	WHERE boundary ='local_authority'  and tags->'ref:FR:SIREN' is not null;
CREATE INDEX epcis_polygon_gist ON epcis_polygon USING gist (the_geom);
