    select 
            osm_id,
            man_made,
            operator,
            ref,
            name,
            tags -> 'owner'::text AS owner,
            tags -> 'location'::text AS location,
            tags -> 'colour'::text AS colour,
            tags -> 'ref:FR:ARCEP'::text AS ref-FR-ARCEP,
            tags -> 'ref:FR:Orange'::text AS ref-FR-Orange,
            tags -> 'ref:FR:Orange:NRO'::text AS ref-FR-Orange-NRO,
            tags -> 'street_cabinet'::text AS street_cabinet,
            tags -> 'telecom'::text AS telecom,
            tags -> 'telecom:medium'::text AS telecom-medium,
            tags -> 'ref:FR:SFR'::text AS ref-FR-SFR,
            tags -> 'description'::text AS description,
            tags -> 'note'::text AS note,
            way AS "the_geom",
            '' AS "osm_original_geom",
            'node' AS "osm_type"
        FROM france_point
        WHERE telecom = 'connection_point'::text AND telecom-medium = 'fibre'::text
    UNION
        select 
            osm_id,
            man_made,
            operator,
            ref,
            name,
            building,
            tags -> 'owner'::text AS owner,
            tags -> 'location'::text AS location,
            tags -> 'colour'::text AS colour,
            tags -> 'ref:FR:ARCEP'::text AS ref-FR-ARCEP,
            tags -> 'ref:FR:Orange'::text AS ref-FR-Orange,
            tags -> 'ref:FR:Orange:NRO'::text AS ref-FR-Orange-NRO,
            tags -> 'street_cabinet'::text AS street_cabinet,
            tags -> 'telecom'::text AS telecom,
            tags -> 'telecom:medium'::text AS telecom-medium,
            tags -> 'ref:FR:SFR'::text AS ref-FR-SFR,
            tags -> 'description'::text AS description,
            tags -> 'note'::text AS note,
            ST_Centroid(way) AS "the_geom",
            ST_AsEWKT(way) AS "osm_original_geom",
    'way' AS "osm_type"
        FROM france_polygon
        WHERE telecom = 'connection_point'::text AND telecom-medium = 'fibre'::text
