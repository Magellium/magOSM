-- Materialized View: magosm.france_telecom_exchange_point

-- DROP MATERIALIZED VIEW magosm.france_telecom_exchange_point;

CREATE MATERIALIZED VIEW magosm.france_telecom_exchange_point AS 
 SELECT france_point.osm_id,
    france_point.man_made,
    france_point.operator,
    france_point.ref,
    france_point.name,
    france_point.tags -> 'owner'::text AS owner,
    france_point.tags -> 'location'::text AS location,
    france_point.tags -> 'colour'::text AS colour,
    france_point.tags -> 'ref:FR:PTT'::text AS "ref-FR-PTT",
    france_point.tags -> 'ref:FR:Orange'::text AS "ref-FR-Orange",
    france_point.tags -> 'street_cabinet'::text AS street_cabinet,
    france_point.tags -> 'telecom'::text AS telecom,
    france_point.tags -> 'telecom:medium'::text AS "telecom-medium",
    france_point.tags -> 'ref:FR:SFR'::text AS "ref-FR-SFR",
    france_point.tags -> 'description'::text AS description,
    france_point.tags -> 'note'::text AS note,
    france_point.tags -> 'source'::text AS source,
    france_point.tags -> 'osm_version'::text AS osm_version,
    france_point.tags -> 'osm_timestamp'::text AS osm_timestamp,
    france_point.way AS the_geom,
    ''::text AS osm_original_geom,
    'node'::text AS osm_type
   FROM magosm.france_point
  WHERE (france_point.tags -> 'telecom'::text) = 'central_office'::text OR (france_point.tags -> 'telecom'::text) = 'exchange'::text OR (france_point.tags -> 'man_made:medium'::text) = 'telephone_office'::text
UNION
 SELECT france_polygon.osm_id,
    france_polygon.man_made,
    france_polygon.operator,
    france_polygon.ref,
    france_polygon.name,
    france_polygon.tags -> 'owner'::text AS owner,
    france_polygon.tags -> 'location'::text AS location,
    france_polygon.tags -> 'colour'::text AS colour,
    france_polygon.tags -> 'ref:FR:PTT'::text AS "ref-FR-PTT",
    france_polygon.tags -> 'ref:FR:Orange'::text AS "ref-FR-Orange",
    france_polygon.tags -> 'street_cabinet'::text AS street_cabinet,
    france_polygon.tags -> 'telecom'::text AS telecom,
    france_polygon.tags -> 'telecom:medium'::text AS "telecom-medium",
    france_polygon.tags -> 'ref:FR:SFR'::text AS "ref-FR-SFR",
    france_polygon.tags -> 'description'::text AS description,
    france_polygon.tags -> 'note'::text AS note,
    france_polygon.tags -> 'source'::text AS source,
    france_polygon.tags -> 'osm_version'::text AS osm_version,
    france_polygon.tags -> 'osm_timestamp'::text AS osm_timestamp,
    st_centroid(france_polygon.way) AS the_geom,
    st_asewkt(france_polygon.way) AS osm_original_geom,
    'way'::text AS osm_type
   FROM magosm.france_polygon
  WHERE (france_polygon.tags -> 'telecom'::text) = 'central_office'::text OR (france_polygon.tags -> 'telecom'::text) = 'exchange'::text OR (france_polygon.tags -> 'man_made:medium'::text) = 'telephone_office'::text
WITH DATA;

ALTER TABLE magosm.france_telecom_exchange_point
  OWNER TO magosm;
GRANT ALL ON TABLE magosm.france_telecom_exchange_point TO magosm;
GRANT SELECT ON TABLE magosm.france_telecom_exchange_point TO isogeo;
