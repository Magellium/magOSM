--------------
--motorways---
--------------

DROP MATERIALIZED VIEW IF EXISTS france_motorways_line;
CREATE MATERIALIZED VIEW france_motorways_line AS 
	SELECT
		osm_id,
		highway,
		name,
		ref,
		tags->'int_ref' as "int_ref",
		tags->'network' as "network",
		tags->'lanes' as "lanes",
		tags->'maxspeed' as "maxspeed",
		tags->'minspeed' as "minspeed",
		oneway,
		"access",
		tags->'motorcar' as "motorcar",
		tags->'motor_vehicle' as "motor_vehicle",
		tags->'hgv' as "hgv",
		tags->'toll' as "toll",
		tags->'lit' as "lit",
		surface,
		tags->'smoothness' as "smoothness",
		tags->'destination' as "destination",
		layer,
		bridge,
		tunnel,
		cutting,
		tags->'hazard' AS "hazard",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way
	FROM france_line 
	WHERE 
		(highway='motorway'
		OR highway='motorway_link'
		OR highway='motorway_junction')
		AND osm_id>0;
GRANT SELECT ON TABLE france_motorways_line TO isogeo;