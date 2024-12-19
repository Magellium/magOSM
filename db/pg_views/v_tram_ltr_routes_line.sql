
----------------
--tram_ltr_routes--
----------------

DROP VIEW IF EXISTS tram_ltr_routes_line;
CREATE OR REPLACE VIEW tram_ltr_routes_line AS 
	SELECT
		-osm_id as osm_id,
		route,
		tags->'type' as "type",
		name,
		ref,
		operator,
		tags->'network' as "network",
		tags->'to' as "to",
		tags->'from' as "from",
		tags->'via' as "via",
		tags->'description' as "description",
		tags->'opening_hours' as "opening_hours",
		tags->'wheelchair' as "wheelchair",
		tags->'colour' as "colour",
		tags->'by_night' as "by_night",
		tags->'public_transport:version' as "public_transport-version",
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
	WHERE (route='light_rail' OR route='tram') and osm_id<0
	GROUP BY osm_id, route, tags, name, ref, operator; -- élimine erreurs de tagging avec route=bus sur un way

