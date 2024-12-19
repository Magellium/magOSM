--------------
--cycleways--
--------------

DROP VIEW IF EXISTS cycleways_line;
CREATE OR REPLACE VIEW cycleways_line AS 
	SELECT
		osm_id,
		name,
		ref,
		tags->'network' as "network",
		highway,
		tags->'cycleway' as "cycleway",
		tags->'cycleway:left' as "cycleway-left",
		tags->'cycleway:right' as "cycleway-right",
		tags->'cycleway:both' as "cycleway-both",
		bicycle,
		layer,
		bridge,
		tunnel,
		cutting,
		oneway,
		tags->'oneway:bicycle' as "oneway-bicycle",
		"access",
		tags->'motor_vehicle' as "motor_vehicle",
		foot,
		tags->'segregated' as "segregated",
		tags->'lanes' as "lanes",
		tags->'maxspeed' as "maxspeed",
		tags->'lit' as "lit",
		width,
		surface,
		tags->'smoothness' as "smoothness",
		tags->'mtb:scale' as "mtb-scale",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM planet_osm_line 
	WHERE 
		highway='cycleway'
		OR bicycle='designated'
		OR (tags ? 'cycleway' AND tags->'cycleway' != 'no')
		OR (tags ? 'cycleway:left' AND tags->'cycleway:left' != 'no')
		OR (tags ? 'cycleway:right' AND tags->'cycleway:right' != 'no')
		OR (tags ? 'cycleway:both' AND tags->'cycleway:both' != 'no')
		AND osm_id > 0;