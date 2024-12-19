----------------
--train_routes_line--
----------------

DROP MATERIALIZED VIEW IF EXISTS train_routes_line;
CREATE MATERIALIZED VIEW train_routes_line AS 
	SELECT
		-osm_id as osm_id,
		route,
		tags->'type' as "type",
		name,
		ref,
		operator,
		tags->'public_transport:version' as "public_transport-version",
		tags->'to' as "to",
		tags->'from' as "from",
		tags->'via' as "via",
		tags->'network' as "network", --permet de distinguer TER/RER/Transilien
		service,
		tags->'colour' as "colour",
		tags->'bicycle' as "bicycle",
		tags->'wheelchair' as "wheelchair",
		tags->'air_conditioning' as "air_conditioning",
		tags->'by_night' as "by_night",	
		tags ->'passenger' as "passenger",
		tags->'name:en' as "name:en",	
		tags->'usage' as "usage",
		tags->'gauge' as "gauge",
		tags->'electrified' as "electrified",
		tags->'importance' as "importance",
		tags->'railway:traffic_mode' as "railway-traffic_mode",
		tags->'frequency' as "frequency",
		tags->'interval' as "interval",
		tags->'passenger_lines' as "passenger_lines",
		tags->'url' as "url",
		tags->'website' as "website",
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
	WHERE route='train'AND osm_id < 0-- élimine erreurs de tagging avec route=train sur un way
	GROUP BY osm_id, route, tags, name, ref, operator, service;