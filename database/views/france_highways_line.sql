-------------
--highways---
-------------
DROP MATERIALIZED VIEW IF EXISTS france_highways_line CASCADE;
CREATE MATERIALIZED VIEW france_highways_line AS 
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
		tags->'private' as "private",
		foot,
		tags->'sidewalk' as "sidewalk",
		bicycle,
		tags->'motorcar' as "motorcar",
		tags->'motor_vehicle' as "motor_vehicle",
		tags->'hgv' as "hgv",
		tags->'toll' as "toll",
		tags->'lit' as "lit",
		tags->'width' as "width",
		surface,
		tags->'smoothness' as "smoothness",
		tags->'tracktype' as "tracktype",
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
		osm_id>0 
		AND (
			highway = 'motorway'
			OR highway = 'trunk'
			OR highway = 'primary'
			OR highway = 'secondary'
			OR highway = 'tertiary'
			OR highway = 'motorway_link' OR highway = 'trunk_link' OR highway = 'primary_link' OR highway = 'secondary_link' OR highway = 'tertiary_link' OR highway = 'motorway_link'
			OR highway = 'unclassified'
			OR highway = 'residential'
			OR highway = 'service'
			OR highway = 'pedestrian'
			OR highway = 'living_street'
			OR highway = 'track'	
		);
GRANT SELECT ON TABLE france_highways_line TO isogeo;

-------------------------------
--highways_recently_modified---
-------------------------------

DROP MATERIALIZED VIEW IF EXISTS france_highways_line_recently_modified;
CREATE MATERIALIZED VIEW france_highways_line_recently_modified AS 
 SELECT france_highways_line.osm_id,
    france_highways_line.highway,
    france_highways_line.name,
    france_highways_line.ref,
    france_highways_line.int_ref,
    france_highways_line.network,
    france_highways_line.lanes,
    france_highways_line.maxspeed,
    france_highways_line.minspeed,
    france_highways_line.oneway,
    france_highways_line.access,
    france_highways_line.private,
    france_highways_line.foot,
    france_highways_line.sidewalk,
    france_highways_line.bicycle,
    france_highways_line.motorcar,
    france_highways_line.motor_vehicle,
    france_highways_line.hgv,
    france_highways_line.toll,
    france_highways_line.lit,
    france_highways_line.width,
    france_highways_line.surface,
    france_highways_line.smoothness,
    france_highways_line.tracktype,
    france_highways_line.destination,
    france_highways_line.layer,
    france_highways_line.bridge,
    france_highways_line.tunnel,
    france_highways_line.cutting,
    france_highways_line.hazard,
    france_highways_line.source,
    france_highways_line.note,
    /*france_highways_line.osm_uid,
    france_highways_line.osm_user,
    france_highways_line.osm_changeset,
    */
    france_highways_line.osm_version,
    france_highways_line.osm_timestamp,
    france_highways_line.way
   FROM france_highways_line
  WHERE france_highways_line.osm_timestamp::timestamp without time zone > (now() - '7 days'::interval);
  
GRANT SELECT ON TABLE france_highways_line_recently_modified TO isogeo;
