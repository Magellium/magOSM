------------
--communes--
-------------

DROP MATERIALIZED VIEW IF EXISTS communes_polygon;
CREATE MATERIALIZED VIEW communes_polygon AS 
	SELECT
		osm_id,
		name,
		tags->'postal_code' as "postal_code",
		tags->'ref:INSEE' as "ref-INSEE",
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		population AS "population",
		tags->'source:population' AS "source_population",
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		tags->'addr:postcode' AS "addr_postcode",
		way AS "the_geom"
	FROM planet_osm_polygon 
	WHERE boundary ='administrative' and admin_level='8' and tags->'ref:INSEE' is not null;
CREATE INDEX communes_polygon_gist ON communes_polygon USING gist (the_geom);
