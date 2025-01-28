------------
--buildings--
-------------

DROP MATERIALIZED VIEW IF EXISTS buildings_polygon;
CREATE MATERIALIZED VIEW buildings_polygon AS 
	SELECT
		osm_id,
		building,
		amenity,
		name,
		operator,
		tags->'wall' AS wall,
		tags->'height' AS height,
		tags->'building:levels' AS "building-levels",
		tags->'building:material' AS "building-material",
		tags->'building:use' AS "building-use",
		tags->'roof:colour' AS "roof-colour",
		tags->'roof:material' AS "roof-material",
		tags->'roof:orientation' AS "roof-orientation",
		tags->'roof:levels' AS "roof-levels",
		tags->'description' AS description,
		tags->'start_date' AS start_date,
		tags->'opening_hours' AS opening_hours,
		"addr:housename" AS "addr-housename",
		"addr:housenumber" AS "addr-housenumber",
		tags->'addr:street' AS "addr-street",
		tags->'addr:city' AS "addr-city",
		tags->'addr:postcode' AS "addr-postcode",
		tags->'wheelchair' AS wheelchair,
		tags->'religion' AS religion,
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM planet_osm_polygon 
	WHERE building IS NOT NULL;
CREATE INDEX buildings_polygon_gist ON buildings_polygon USING gist (the_geom);
