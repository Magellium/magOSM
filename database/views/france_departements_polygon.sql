------------
--departements--
-------------

DROP MATERIALIZED VIEW IF EXISTS france_departements_polygon;
CREATE MATERIALIZED VIEW france_departements_polygon AS 
	SELECT
		osm_id,
		name,
		tags->'border_type' as border_type,
		tags->'ref:NUTS' as "ref-NUTS",
		tags->'ISO3166-2' as "ISO3166-2",
		tags->'ref:INSEE' as "ref-INSEE",
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way
	FROM france_polygon 
	WHERE boundary ='administrative' and admin_level='6' and tags->'ref:INSEE' is not null;
GRANT SELECT ON TABLE france_departements_polygon TO isogeo;
CREATE INDEX france_departements_polygon_gist ON france_departements_polygon USING gist (way);
