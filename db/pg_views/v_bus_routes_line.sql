--------------
--bus_routes--
--------------

DROP MATERIALIZED VIEW IF EXISTS bus_routes_line;
CREATE MATERIALIZED VIEW bus_routes_line AS 
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
		tags->'opening_hours' as "opening_hours",
		tags->'wheelchair' as "wheelchair",
		tags->'colour' as "colour",
		tags->'distance' as "distance",
		tags->'duration' as "duration",
		tags->'roundtrip' as "roundtrip",
		tags->'public_transport:version' as "public_transport-version",
		tags->'website' as "website",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		st_union(way) AS "the_geom"
	FROM planet_osm_line 
	WHERE route='bus' and osm_id<0 -- élimine erreurs de tagging avec route=bus sur un way
	GROUP BY osm_id, route, tags, name, ref, operator;