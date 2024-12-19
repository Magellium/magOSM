------------
--railways--
------------

DROP MATERIALIZED VIEW IF EXISTS railways_line;
CREATE MATERIALIZED VIEW railways_line AS 
	SELECT
		osm_id,
		railway,
		name,
		ref,
		operator,
		tags->'network' as "network",
		tags->'usage' as "usage",
		service,
		tags->'maxspeed' as "maxspeed",
		tags->'importance' as "importance",
		tags->'railway:traffic_mode' as "railway-traffic_mode",
		tags->'gauge' as "gauge",
		tags->'electrified' as "electrified",
		tags->'voltage' as "voltage",
		tags->'frequency' as "frequency",
		tags->'passenger_lines' as "passenger_lines",
		layer,
		bridge,
		tunnel,
		cutting,
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM planet_osm_line 
	WHERE 	(railway='rail' 
		OR railway='narrow_gauge')
		AND osm_id > 0;