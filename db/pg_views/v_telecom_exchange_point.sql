-- Materialized View: telecom_exchange_point

DROP MATERIALIZED VIEW IF EXISTS telecom_exchange_point;
CREATE MATERIALIZED VIEW telecom_exchange_point AS 
 SELECT planet_osm_point.osm_id,
    planet_osm_point.man_made,
    planet_osm_point.operator,
    planet_osm_point.ref,
    planet_osm_point.name,
    planet_osm_point.tags -> 'owner'::text AS owner,
    planet_osm_point.tags -> 'location'::text AS location,
    planet_osm_point.tags -> 'colour'::text AS colour,
    planet_osm_point.tags -> 'ref:FR:PTT'::text AS "ref-FR-PTT",
    planet_osm_point.tags -> 'ref:FR:Orange'::text AS "ref-FR-Orange",
    planet_osm_point.tags -> 'street_cabinet'::text AS street_cabinet,
    planet_osm_point.tags -> 'telecom'::text AS telecom,
    planet_osm_point.tags -> 'telecom:medium'::text AS "telecom-medium",
    planet_osm_point.tags -> 'ref:FR:SFR'::text AS "ref-FR-SFR",
    planet_osm_point.tags -> 'description'::text AS description,
    planet_osm_point.tags -> 'note'::text AS note,
    planet_osm_point.tags -> 'source'::text AS source,
    planet_osm_point.tags -> 'osm_version'::text AS osm_version,
    planet_osm_point.tags -> 'osm_timestamp'::text AS osm_timestamp,
    planet_osm_point.way AS the_geom,
    ''::text AS osm_original_geom,
    'node'::text AS osm_type
   FROM planet_osm_point
  WHERE (planet_osm_point.tags -> 'telecom'::text) = 'central_office'::text OR (planet_osm_point.tags -> 'telecom'::text) = 'exchange'::text OR (planet_osm_point.tags -> 'man_made'::text) = 'telephone_office'::text
UNION
 SELECT planet_osm_polygon.osm_id,
    planet_osm_polygon.man_made,
    planet_osm_polygon.operator,
    planet_osm_polygon.ref,
    planet_osm_polygon.name,
    planet_osm_polygon.tags -> 'owner'::text AS owner,
    planet_osm_polygon.tags -> 'location'::text AS location,
    planet_osm_polygon.tags -> 'colour'::text AS colour,
    planet_osm_polygon.tags -> 'ref:FR:PTT'::text AS "ref-FR-PTT",
    planet_osm_polygon.tags -> 'ref:FR:Orange'::text AS "ref-FR-Orange",
    planet_osm_polygon.tags -> 'street_cabinet'::text AS street_cabinet,
    planet_osm_polygon.tags -> 'telecom'::text AS telecom,
    planet_osm_polygon.tags -> 'telecom:medium'::text AS "telecom-medium",
    planet_osm_polygon.tags -> 'ref:FR:SFR'::text AS "ref-FR-SFR",
    planet_osm_polygon.tags -> 'description'::text AS description,
    planet_osm_polygon.tags -> 'note'::text AS note,
    planet_osm_polygon.tags -> 'source'::text AS source,
    planet_osm_polygon.tags -> 'osm_version'::text AS osm_version,
    planet_osm_polygon.tags -> 'osm_timestamp'::text AS osm_timestamp,
    st_centroid(planet_osm_polygon.way) AS the_geom,
    st_asewkt(planet_osm_polygon.way) AS osm_original_geom,
    'way'::text AS osm_type
   FROM planet_osm_polygon
  WHERE (planet_osm_polygon.tags -> 'telecom'::text) = 'central_office'::text OR (planet_osm_polygon.tags -> 'telecom'::text) = 'exchange'::text OR (planet_osm_polygon.tags -> 'man_made'::text) = 'telephone_office'::text
WITH DATA;