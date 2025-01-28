-------------
--highways---
-------------
DROP MATERIALIZED VIEW IF EXISTS highways_line CASCADE;
CREATE MATERIALIZED VIEW highways_line AS 
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
		way AS "the_geom"
	FROM planet_osm_line 
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
			OR highway = 'footway'
			OR highway = 'path'
		);

-------------------------------
--highways_recently_modified---
-------------------------------

DROP MATERIALIZED VIEW IF EXISTS highways_line_recently_modified;
CREATE MATERIALIZED VIEW highways_line_recently_modified AS 
 SELECT highways_line.osm_id,
    highways_line.highway,
    highways_line.name,
    highways_line.ref,
    highways_line.int_ref,
    highways_line.network,
    highways_line.lanes,
    highways_line.maxspeed,
    highways_line.minspeed,
    highways_line.oneway,
    highways_line.access,
    highways_line.private,
    highways_line.foot,
    highways_line.sidewalk,
    highways_line.bicycle,
    highways_line.motorcar,
    highways_line.motor_vehicle,
    highways_line.hgv,
    highways_line.toll,
    highways_line.lit,
    highways_line.width,
    highways_line.surface,
    highways_line.smoothness,
    highways_line.tracktype,
    highways_line.destination,
    highways_line.layer,
    highways_line.bridge,
    highways_line.tunnel,
    highways_line.cutting,
    highways_line.hazard,
    highways_line.source,
    highways_line.note,
    /*highways_line.osm_uid,
    highways_line.osm_user,
    highways_line.osm_changeset,
    */
    highways_line.osm_version,
    highways_line.osm_timestamp,
    highways_line.the_geom
   FROM highways_line
  WHERE highways_line.osm_timestamp::timestamp without time zone > (now() - '7 days'::interval);