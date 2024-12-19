
----------------------
--bicycle_mtb_routes--
----------------------

DROP MATERIALIZED VIEW IF EXISTS bicycle_mtb_routes_line;
CREATE MATERIALIZED VIEW bicycle_mtb_routes_line AS 
	SELECT
		-osm_id as osm_id,
		route,
		tags->'type' as "type",
		name,
		tags->'short_name' as "short_name",
		ref,
		operator,
		tags->'network' as "network",
		tags->'proposed' as "proposed",
		tags->'state' as "state",
		highway,
		tags->'to' as "to",
		tags->'from' as "from",
		tags->'description' as "description",
		tags->'bicycle' as "bicycle",
		tags->'mtb' as "mtb",
		tags->'foot' as "foot",
		tags->'surface' as "surface",
		tags->'tracktype' as "tracktype",
		tags->'mtb:type' as "mtb-type",
		tags->'mtb:scale' as "mtb-scale",
		tags->'distance' as "distance",
		tags->'duration' as "duration",
		tags->'roundtrip' as "roundtrip",
		tags->'complete' as "complete",
		tags->'colour' as "colour",
		tags->'website' as "website",
		tags->'url' as "url",
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		st_union(way) AS "the_geom"
	FROM planet_osm_line 
	WHERE (route='bicycle' OR route='mtb') and osm_id<0
	GROUP BY osm_id, route, tags, name, ref, operator,highway;