------------------------
----constructions-------
----toutes géométries---
------------------------- 
DROP MATERIALIZED VIEW IF EXISTS magosm.constructions;
CREATE MATERIALIZED VIEW magosm.constructions
 AS
-- quand osm_id n'est pas unique (relations) on créé des id uniques (magosm_id ici, qui est alors la clé primaire appelée sur GéoServer) avec:
-- SELECT row_number() over() AS magosm_id, * FROM ( _requêteprincipale_ ) AS unique_id
-- '*' permet de répcupérer et d'afficher l'ensemble de la sous-requête  '_requêteprincipale_'
-- fonction row_number ne s'utilise pas directement avec UNION, pour cela qu'on le place avant la requête principale
 SELECT DISTINCT planet_osm_point.osm_id,
    planet_osm_point.construction,
--clés associées à *=construction, logique "common life cycle"
    NULL landuse,
    NULL highway,
    NULL building,
    NULL railway,
    planet_osm_point.barrier,
    planet_osm_point.public_transport,
    planet_osm_point.office,
    planet_osm_point.access,
    NULL waterway,
    planet_osm_point.leisure,
    planet_osm_point.shop,
    planet_osm_point.amenity,
    planet_osm_point.aerialway,
    NULL route,
    planet_osm_point.place,
    planet_osm_point.tags -> 'industrial'::text AS industrial,
    planet_osm_point.tags -> 'wall'::text AS wall,
    planet_osm_point.tags -> 'cycleway'::text AS cycleway,
    planet_osm_point.tags -> 'subway'::text AS subway,
    planet_osm_point.tags -> 'indoor'::text AS indoor,
    planet_osm_point.tags -> 'building:part'::text AS "building-part",
    planet_osm_point.tags -> 'cycleway:left'::text AS "cycleway-left",
--tags contextuels complémentaires "classiques"--
    planet_osm_point.name,
    planet_osm_point.tags -> 'official_name'::text AS official_name,
    planet_osm_point.operator,
    planet_osm_point.tags -> 'short_name'::text AS short_name,
    planet_osm_point.tags -> 'alt_name'::text AS alt_name,
    planet_osm_point.tags -> 'operator:type'::text AS "operator-type",
    planet_osm_point.tags -> 'source'::text AS source,
    planet_osm_point.tags -> 'note'::text AS note,
    planet_osm_point.tags -> 'note:fr'::text AS "note-fr",
    planet_osm_point.tags -> 'fixme'::text AS fixme,
    planet_osm_point.tags -> 'survey'::text AS survey,
    planet_osm_point.tags -> 'survey:date'::text AS "survey-date",
    planet_osm_point.tags -> 'description'::text AS description,
    planet_osm_point.tags -> 'wheelchair'::text AS wheelchair,
--tags contextuels complémentaires associés à construction--
    planet_osm_point.tags -> 'start_date'::text AS start_date,
    planet_osm_point.tags -> 'check_date'::text AS check_date,
    planet_osm_point.tags -> 'opening_date'::text AS opening_date,
    planet_osm_point.tags -> 'end_date'::text AS end_date,
--tags contextuels complémentaires associés à landuse, leisure--
    planet_osm_point.sport,
    planet_osm_point.area,
    planet_osm_point.tags -> 'cadastre'::text AS cadastre,
    planet_osm_point.tags -> 'architect'::text AS architect,
    planet_osm_point.tags -> 'developer'::text AS developer,
    planet_osm_point.tags -> 'type:FR:PLU'::text AS "type-FR-PLU",
    planet_osm_point.tags -> 'CLC:code'::text AS "CLC-code",
    planet_osm_point.tags -> 'CLC:id'::text AS "CLC-id",
    planet_osm_point.tags -> 'CLC:year'::text AS "CLC-year",
--tags contextuels complémentaires associés à building--
    planet_osm_point.religion,
    planet_osm_point."addr:housename" AS "addr-housename",
    planet_osm_point."addr:housenumber" AS "addr-housenumber",
    planet_osm_point.tags -> 'building:levels'::text AS "building-levels",
    planet_osm_point.tags -> 'building:material'::text AS "building-material",
    planet_osm_point.tags -> 'building:use'::text AS "building-use",
    planet_osm_point.tags -> 'addr:street'::text AS "addr-street",
    planet_osm_point.tags -> 'addr:city'::text AS "addr-city",
    planet_osm_point.tags -> 'addr:postcode'::text AS "addr-postcode",
--tags contextuels complémentaires associés à shop, office, amenity--
    planet_osm_point.tags -> 'opening_hours'::text AS opening_hours,
    planet_osm_point.tags -> 'phone'::text AS phone,
    planet_osm_point.tags -> 'contact:phone'::text AS "contact-phone",
    planet_osm_point.tags -> 'fax'::text AS fax,
    planet_osm_point.tags -> 'contact:fax'::text AS "contact-fax",
    planet_osm_point.tags -> 'email'::text AS email,
    planet_osm_point.tags -> 'contact:email'::text AS "contact-email",
    planet_osm_point.tags -> 'website'::text AS website,
    planet_osm_point.tags -> 'contact:website'::text AS "contact-website",
    planet_osm_point.tags -> 'url'::text AS url,
    planet_osm_point.tags -> 'payment'::text AS payment,
    planet_osm_point.tags -> 'capacity'::text AS capacity,
    planet_osm_point.tags -> 'parking'::text AS parking,
    planet_osm_point.tags -> 'ref:FR:NAF'::text AS "ref-FR-NAF",
    planet_osm_point.tags -> 'ref:FR:SIRET'::text AS "ref-FR-SIRET",
--tags contextuels complémentaires associés à highway--
    planet_osm_point.oneway,
    planet_osm_point.ref,
    planet_osm_point.bridge,
    planet_osm_point.layer,
    planet_osm_point.surface,
    planet_osm_point.bicycle,
    planet_osm_point.foot,
    planet_osm_point.junction,
    planet_osm_point.service,
    planet_osm_point.tunnel,
    planet_osm_point.tags -> 'maxspeed'::text AS maxspeed,
    planet_osm_point.tags -> 'minspeed'::text AS minspeed,
    planet_osm_point.tags -> 'private'::text AS private,
    planet_osm_point.tags -> 'int_ref'::text AS int_ref,
    planet_osm_point.tags -> 'width'::text AS width,
    planet_osm_point.tags -> 'lanes'::text AS lanes,
    planet_osm_point.tags -> 'lit'::text AS lit,
    planet_osm_point.tags -> 'sidewalk'::text AS sidewalk,
    planet_osm_point.tags -> 'smoothness'::text AS smoothness,
    planet_osm_point.tags -> 'motor_vehicule'::text AS motor_vehicule,
    planet_osm_point.tags -> 'piste:type'::text AS "piste-type",
    planet_osm_point.tags -> 'piste:grooming'::text AS "piste-grooming",
--tags contextuels complémentaires associés à railway--
    planet_osm_point.tags -> 'network'::text AS network,
    planet_osm_point.tags -> 'usage'::text AS usage,
    planet_osm_point.tags -> 'importance'::text AS importance,
    planet_osm_point.tags -> 'railway:traffic_mode'::text AS "railway-traffic_mode",
    planet_osm_point.tags -> 'gauge'::text AS gauge,
    planet_osm_point.tags -> 'electrified'::text AS electrified,
    planet_osm_point.tags -> 'voltage'::text AS voltage,
    planet_osm_point.tags -> 'frequency'::text AS frequency,
    planet_osm_point.tags -> 'passenger'::text AS passenger,
    planet_osm_point.tags -> 'passenger_lines'::text AS passenger_lines,
    planet_osm_point.cutting,
--tags contextuels complémentaires associés à public_transport--
    planet_osm_point.tags -> 'bus'::text AS bus,
    planet_osm_point.tags -> 'to'::text AS "to",
    planet_osm_point.tags -> 'from'::text AS "from",
    planet_osm_point.tags -> 'via'::text AS via,
    planet_osm_point.tags -> 'ref:FR:RATP'::text AS "ref-FR-RATP",
    planet_osm_point.tags -> 'public_transport:version'::text AS "public_transport-version",
--tags contextuels complémentaires associés à aerialway--
    planet_osm_point.ele,
    planet_osm_point.tourism,
    planet_osm_point.tags -> 'aerialway:capacity'::text AS "aerialway-capacity",
    planet_osm_point.tags -> 'aerialway:duration'::text AS "aerialway-duration",
    planet_osm_point.tags -> 'aerialway:access'::text AS "aerialway-access",
    planet_osm_point.tags -> 'aerialway:occupancy'::text AS "aerialway-occupancy",
    planet_osm_point.tags -> 'aerialway:length'::text AS "aerialway-length",
--tags contextuels complémentaires associés à waterway--
    planet_osm_point.intermittent,
--tags contextuels complémentaires associés à barrier--
    planet_osm_point.horse,
    planet_osm_point.tags -> 'level'::text AS level,
    planet_osm_point.tags -> 'height'::text AS height,
    planet_osm_point.tags -> 'power'::text AS power,
    planet_osm_point.tags -> 'entrance'::text AS entrance,
    planet_osm_point.tags -> 'fence_type'::text AS fence_type,
    planet_osm_point.tags -> 'material'::text AS material,
--tags de métadonnées--
    planet_osm_point.tags -> 'wikidata'::text AS wikidata,
    planet_osm_point.tags -> 'wikipedia'::text AS wikipedia,
    planet_osm_point.tags -> 'type'::text AS type,
    planet_osm_point.tags -> 'osm_version'::text AS osm_version,
    planet_osm_point.tags -> 'osm_timestamp'::text AS osm_timestamp,
--gestion de la géométrie--
    planet_osm_point.way AS the_geom,
    NULL::text AS osm_original_geom,
    'node'::text AS osm_type,
    
        CASE  -- renvoie la clé (variable const_key) quand la valeur est construction 
        -- modèle basique KEY=construction
            WHEN planet_osm_point.barrier = 'construction'::text THEN 'barrier'::text
            WHEN planet_osm_point.public_transport = 'construction'::text THEN 'public_transport'::text
            WHEN planet_osm_point.office = 'construction'::text THEN 'office'::text
            WHEN planet_osm_point.access = 'construction'::text THEN 'access'::text
            WHEN planet_osm_point.leisure = 'construction'::text THEN 'leisure'::text
            WHEN planet_osm_point.shop = 'construction'::text THEN 'shop'::text
            WHEN planet_osm_point.amenity = 'construction'::text THEN 'amenity'::text
            WHEN planet_osm_point.aerialway = 'construction'::text THEN 'aerialway'::text
            WHEN planet_osm_point.place = 'construction'::text THEN 'place'::text
        -- modèle construction:KEY=* (prefix dans le hstore)
            ELSE (hstore_prefix_filter(planet_osm_point.tags,'construction')).prefix_key 
        END AS const_key,

        CASE -- renvoye la valeur (variable const_value) quand la clé est construction
        -- modèle basique construction=VALUE 
            WHEN planet_osm_point.construction IS NOT NULL THEN planet_osm_point.construction
        -- modèle construction:*=VALUE (prefix) OU *="construction" (dans le hstore, EX: note="en construction")
            ELSE (hstore_prefix_filter(planet_osm_point.tags,'construction')).prefix_value
        -- pour + d'infos sur la fonction cf. db_public/pg_views/proc_hstore_prefix_filter
        END AS const_value

   FROM planet_osm_point
  WHERE planet_osm_point.construction IS NOT NULL 
        OR planet_osm_point.barrier = 'construction'::text 
        OR planet_osm_point.public_transport = 'construction'::text 
        OR planet_osm_point.office = 'construction'::text 
        OR planet_osm_point.access = 'construction'::text 
        OR planet_osm_point.leisure = 'construction'::text 
        OR planet_osm_point.shop = 'construction'::text 
        OR planet_osm_point.amenity = 'construction'::text 
        OR planet_osm_point.aerialway = 'construction'::text 
        OR planet_osm_point.place = 'construction'::text -- filtrage dans la logique "common life cycle"
        OR (hstore_prefix_filter(planet_osm_point.tags,'construction')).prefix_key IS NOT NULL -- filtrage dans la logique "lifecycle prefix"
        
 UNION
 SELECT DISTINCT planet_osm_line.osm_id,
    planet_osm_line.construction,
--clés associées à *=construction, logique "common life cycle"
    NULL landuse,
    planet_osm_line.highway,
    NULL building,
    planet_osm_line.railway,
    planet_osm_line.barrier,
    planet_osm_line.public_transport,
    NULL office,
    planet_osm_line.access,
    planet_osm_line.waterway,
    planet_osm_line.leisure,
    NULL shop,
    NULL amenity,
    planet_osm_line.aerialway,
    planet_osm_line.route,
    planet_osm_line.place,
    planet_osm_line.tags -> 'industrial'::text AS industrial,
    planet_osm_line.tags -> 'wall'::text AS wall,
    planet_osm_line.tags -> 'cycleway'::text AS cycleway,
    planet_osm_line.tags -> 'subway'::text AS subway,
    planet_osm_line.tags -> 'indoor'::text AS indoor,
    planet_osm_line.tags -> 'building:part'::text AS "building-part",
    planet_osm_line.tags -> 'cycleway:left'::text AS "cycleway-left",
--tags contextuels complémentaires "classiques"--
    planet_osm_line.name,
    planet_osm_line.tags->'official_name' AS official_name,
    planet_osm_line.operator,
    planet_osm_line.tags -> 'short_name'::text AS short_name,
    planet_osm_line.tags -> 'alt_name'::text AS alt_name,
    planet_osm_line.tags -> 'operator:type'::text AS "operator-type",
    planet_osm_line.tags -> 'source'::text AS source,
    planet_osm_line.tags -> 'note'::text AS note,
    planet_osm_line.tags -> 'note:fr'::text AS "note-fr",
    planet_osm_line.tags -> 'fixme'::text AS fixme,
    planet_osm_line.tags -> 'survey'::text AS survey,
    planet_osm_line.tags -> 'survey:date'::text AS "survey-date",
    planet_osm_line.tags -> 'description'::text AS description,
    planet_osm_line.tags -> 'wheelchair'::text AS wheelchair,
--tags contextuels complémentaires associés à construction--
    planet_osm_line.tags -> 'start_date'::text AS start_date,
    planet_osm_line.tags -> 'check_date'::text AS check_date,
    planet_osm_line.tags -> 'opening_date'::text AS opening_date,
    planet_osm_line.tags -> 'end_date'::text AS end_date,
--tags contextuels complémentaires associés à landuse, leisure--
    planet_osm_line.sport,
    planet_osm_line.area,
    planet_osm_line.tags -> 'cadastre'::text AS cadastre,
    planet_osm_line.tags -> 'architect'::text AS architect,
    planet_osm_line.tags -> 'developer'::text AS developer,
    planet_osm_line.tags -> 'type:FR:PLU'::text AS "type-FR-PLU",
    planet_osm_line.tags -> 'CLC:code'::text AS "CLC-code",
    planet_osm_line.tags -> 'CLC:id'::text AS "CLC-id",
    planet_osm_line.tags -> 'CLC:year'::text AS "CLC-year",
--tags contextuels complémentaires associés à building--
    planet_osm_line.religion,
    planet_osm_line."addr:housename" AS "addr-housename",
    planet_osm_line."addr:housenumber" AS "addr-housenumber",
    planet_osm_line.tags -> 'building:levels'::text AS "building-levels",
    planet_osm_line.tags -> 'building:material'::text AS "building-material",
    planet_osm_line.tags -> 'building:use'::text AS "building-use",
    planet_osm_line.tags -> 'addr:street'::text AS "addr-street",
    planet_osm_line.tags -> 'addr:city'::text AS "addr-city",
    planet_osm_line.tags -> 'addr:postcode'::text AS "addr-postcode",
--tags contextuels complémentaires associés à shop, office, amenity--
    planet_osm_line.tags -> 'opening_hours'::text AS opening_hours,
    planet_osm_line.tags -> 'phone'::text AS phone,
    planet_osm_line.tags -> 'contact:phone'::text AS "contact-phone",
    planet_osm_line.tags -> 'fax'::text AS fax,
    planet_osm_line.tags -> 'contact:fax'::text AS "contact-fax",
    planet_osm_line.tags -> 'email'::text AS email,
    planet_osm_line.tags -> 'contact:email'::text AS "contact-email",
    planet_osm_line.tags -> 'website'::text AS website,
    planet_osm_line.tags -> 'contact:website'::text AS "contact-website",
    planet_osm_line.tags -> 'url'::text AS url,
    planet_osm_line.tags -> 'payment'::text AS payment,
    planet_osm_line.tags -> 'capacity'::text AS capacity,
    planet_osm_line.tags -> 'parking'::text AS parking,
    planet_osm_line.tags -> 'ref:FR:NAF'::text AS "ref-FR-NAF",
    planet_osm_line.tags -> 'ref:FR:SIRET'::text AS "ref-FR-SIRET",
--tags contextuels complémentaires associés à highway--
    planet_osm_line.oneway,
    planet_osm_line.ref,
    planet_osm_line.bridge,
    planet_osm_line.layer,
    planet_osm_line.surface,
    planet_osm_line.bicycle,
    planet_osm_line.foot,
    planet_osm_line.junction,
    planet_osm_line.service,
    planet_osm_line.tunnel,
    planet_osm_line.tags -> 'maxspeed'::text AS maxspeed,
    planet_osm_line.tags -> 'minspeed'::text AS minspeed,
    planet_osm_line.tags -> 'private'::text AS private,
    planet_osm_line.tags -> 'int_ref'::text AS int_ref,
    planet_osm_line.tags -> 'width'::text AS width,
    planet_osm_line.tags -> 'lanes'::text AS lanes,
    planet_osm_line.tags -> 'lit'::text AS lit,
    planet_osm_line.tags -> 'sidewalk'::text AS sidewalk,
    planet_osm_line.tags -> 'smoothness'::text AS smoothness,
    planet_osm_line.tags -> 'motor_vehicule'::text AS motor_vehicule,
    planet_osm_line.tags -> 'piste:type'::text AS "piste-type",
    planet_osm_line.tags -> 'piste:grooming'::text AS "piste-grooming",
--tags contextuels complémentaires associés à railway--
    planet_osm_line.tags -> 'network'::text AS network,
    planet_osm_line.tags -> 'usage'::text AS usage,
    planet_osm_line.tags -> 'importance'::text AS importance,
    planet_osm_line.tags -> 'railway:traffic_mode'::text AS "railway-traffic_mode",
    planet_osm_line.tags -> 'gauge'::text AS gauge,
    planet_osm_line.tags -> 'electrified'::text AS electrified,
    planet_osm_line.tags -> 'voltage'::text AS voltage,
    planet_osm_line.tags -> 'frequency'::text AS frequency,
    planet_osm_line.tags -> 'passenger'::text AS passenger,
    planet_osm_line.tags -> 'passenger_lines'::text AS passenger_lines,
    planet_osm_line.cutting,
--tags contextuels complémentaires associés à public_transport--
    planet_osm_line.tags -> 'bus'::text AS bus,
    planet_osm_line.tags -> 'to'::text AS "to",
    planet_osm_line.tags -> 'from'::text AS "from",
    planet_osm_line.tags -> 'via'::text AS via,
    planet_osm_line.tags -> 'ref:FR:RATP'::text AS "ref-FR-RATP",
    planet_osm_line.tags -> 'public_transport:version'::text AS "public_transport-version",
--tags contextuels complémentaires associés à aerialway--
    planet_osm_line.tags -> 'ele' AS ele,
    planet_osm_line.tourism,
    planet_osm_line.tags -> 'aerialway:capacity'::text AS "aerialway-capacity",
    planet_osm_line.tags -> 'aerialway:duration'::text AS "aerialway-duration",
    planet_osm_line.tags -> 'aerialway:access'::text AS "aerialway-access",
    planet_osm_line.tags -> 'aerialway:occupancy'::text AS "aerialway-occupancy",
    planet_osm_line.tags -> 'aerialway:length'::text AS "aerialway-length",
--tags contextuels complémentaires associés à waterway--
    planet_osm_line.intermittent,
--tags contextuels complémentaires associés à barrier--
    planet_osm_line.horse,
    planet_osm_line.tags -> 'level'::text AS level,
    planet_osm_line.tags -> 'height'::text AS height,
    planet_osm_line.tags -> 'power'::text AS power,
    planet_osm_line.tags -> 'entrance'::text AS entrance,
    planet_osm_line.tags -> 'fence_type'::text AS fence_type,
    planet_osm_line.tags -> 'material'::text AS material,
--tags de métadonnées--
    planet_osm_line.tags -> 'wikidata'::text AS wikidata,
    planet_osm_line.tags -> 'wikipedia'::text AS wikipedia,
    planet_osm_line.tags -> 'type'::text AS type,
    planet_osm_line.tags -> 'osm_version'::text AS osm_version,
    planet_osm_line.tags -> 'osm_timestamp'::text AS osm_timestamp,
 --gestion de la géométrie--
    planet_osm_line.way AS the_geom,
    NULL::text AS osm_original_geom,
    'way'::text AS osm_type,
        CASE  -- renvoie la clé (variable const_key) quand la valeur est construction 
        -- modèle basique KEY=construction
            WHEN planet_osm_line.highway = 'construction'::text THEN 'highway'::text
            WHEN planet_osm_line.railway = 'construction'::text THEN 'railway'::text
            WHEN planet_osm_line.barrier = 'construction'::text THEN 'barrier'::text
            WHEN planet_osm_line.public_transport = 'construction'::text THEN 'public_transport'::text
            WHEN planet_osm_line.access = 'construction'::text THEN 'access'::text
            WHEN planet_osm_line.waterway = 'construction'::text THEN 'waterway'::text
            WHEN planet_osm_line.leisure = 'construction'::text THEN 'leisure'::text
            WHEN planet_osm_line.aerialway = 'construction'::text THEN 'aerialway'::text
            WHEN planet_osm_line.route = 'construction'::text THEN 'route'::text
            WHEN planet_osm_line.place = 'construction'::text THEN 'place'::text
        -- modèle construction:KEY=* (prefix dans le hstore)
            ELSE (hstore_prefix_filter(planet_osm_line.tags,'construction')).prefix_key
        END AS const_key,
        CASE -- renvoye la valeur (variable const_value) quand la clé est construction
        -- modèle basique construction=VALUE 
            WHEN planet_osm_line.construction IS NOT NULL THEN planet_osm_line.construction
        -- modèle construction:*=VALUE (prefix) OU *="construction" (dans le hstore, EX: note="en construction")
            ELSE (hstore_prefix_filter(planet_osm_line.tags,'construction')).prefix_value 
        -- pour + d'infos sur la fonction cf. db_public/pg_views/proc_hstore_prefix_filter
        END AS const_value
   FROM planet_osm_line
  WHERE planet_osm_line.construction IS NOT NULL 
    OR planet_osm_line.highway = 'construction'::text 
    OR planet_osm_line.railway = 'construction'::text 
    OR planet_osm_line.barrier = 'construction'::text 
    OR planet_osm_line.public_transport = 'construction'::text 
    OR planet_osm_line.access = 'construction'::text 
    OR planet_osm_line.waterway = 'construction'::text 
    OR planet_osm_line.leisure = 'construction'::text 
    OR planet_osm_line.aerialway = 'construction'::text 
    OR planet_osm_line.route = 'construction'::text 
    OR planet_osm_line.place = 'construction'::text -- filtrage dans la logique "common life cycle"
    OR (hstore_prefix_filter(planet_osm_line.tags,'construction')).prefix_key IS NOT NULL -- filtrage dans la logique "lifecycle prefix"
UNION
SELECT DISTINCT planet_osm_polygon.osm_id,
    planet_osm_polygon.construction,
--clés associées à *=construction, logique "common life cycle"
    planet_osm_polygon.landuse,
    NULL highway,
    planet_osm_polygon.building,
    NULL railway,
    planet_osm_polygon.barrier,
    planet_osm_polygon.public_transport,
    planet_osm_polygon.office,
    planet_osm_polygon.access,
    planet_osm_polygon.waterway,
    planet_osm_polygon.leisure,
    planet_osm_polygon.shop,
    planet_osm_polygon.amenity,
    planet_osm_polygon.aerialway,
    NULL route,
    planet_osm_polygon.place,
    planet_osm_polygon.tags -> 'industrial'::text AS industrial,
    planet_osm_polygon.tags -> 'wall'::text AS wall,
    planet_osm_polygon.tags -> 'cycleway'::text AS cycleway,
    planet_osm_polygon.tags -> 'subway'::text AS subway,
    planet_osm_polygon.tags -> 'indoor'::text AS indoor,
    planet_osm_polygon.tags -> 'building:part'::text AS "building-part",
    planet_osm_polygon.tags -> 'cycleway:left'::text AS "cycleway-left",
--tags contextuels complémentaires "classiques"--
    planet_osm_polygon.name,
    planet_osm_polygon.tags->'official_name' AS official_name,
    planet_osm_polygon.operator,
    planet_osm_polygon.tags -> 'short_name'::text AS short_name,
    planet_osm_polygon.tags -> 'alt_name'::text AS alt_name,
    planet_osm_polygon.tags -> 'operator:type'::text AS "operator-type",
    planet_osm_polygon.tags -> 'source'::text AS source,
    planet_osm_polygon.tags -> 'note'::text AS note,
    planet_osm_polygon.tags -> 'note:fr'::text AS "note-fr",
    planet_osm_polygon.tags -> 'fixme'::text AS fixme,
    planet_osm_polygon.tags -> 'survey'::text AS survey,
    planet_osm_polygon.tags -> 'survey:date'::text AS "survey-date",
    planet_osm_polygon.tags -> 'description'::text AS description,
    planet_osm_polygon.tags -> 'wheelchair'::text AS wheelchair,
--tags contextuels complémentaires associés à construction--
    planet_osm_polygon.tags -> 'start_date'::text AS start_date,
    planet_osm_polygon.tags -> 'check_date'::text AS check_date,
    planet_osm_polygon.tags -> 'opening_date'::text AS opening_date,
    planet_osm_polygon.tags -> 'end_date'::text AS end_date,
--tags contextuels complémentaires associés à landuse, leisure--
    planet_osm_polygon.sport,
    planet_osm_polygon.area,
    planet_osm_polygon.tags -> 'cadastre'::text AS cadastre,
    planet_osm_polygon.tags -> 'architect'::text AS architect,
    planet_osm_polygon.tags -> 'developer'::text AS developer,
    planet_osm_polygon.tags -> 'type:FR:PLU'::text AS "type-FR-PLU",
    planet_osm_polygon.tags -> 'CLC:code'::text AS "CLC-code",
    planet_osm_polygon.tags -> 'CLC:id'::text AS "CLC-id",
    planet_osm_polygon.tags -> 'CLC:year'::text AS "CLC-year",
--tags contextuels complémentaires associés à building--
    planet_osm_polygon.religion,
    planet_osm_polygon."addr:housename" AS "addr-housename",
    planet_osm_polygon."addr:housenumber" AS "addr-housenumber",
    planet_osm_polygon.tags -> 'building:levels'::text AS "building-levels",
    planet_osm_polygon.tags -> 'building:material'::text AS "building-material",
    planet_osm_polygon.tags -> 'building:use'::text AS "building-use",
    planet_osm_polygon.tags -> 'addr:street'::text AS "addr-street",
    planet_osm_polygon.tags -> 'addr:city'::text AS "addr-city",
    planet_osm_polygon.tags -> 'addr:postcode'::text AS "addr-postcode",
--tags contextuels complémentaires associés à shop, office, amenity--
    planet_osm_polygon.tags -> 'opening_hours'::text AS opening_hours,
    planet_osm_polygon.tags -> 'phone'::text AS phone,
    planet_osm_polygon.tags -> 'contact:phone'::text AS "contact-phone",
    planet_osm_polygon.tags -> 'fax'::text AS fax,
    planet_osm_polygon.tags -> 'contact:fax'::text AS "contact-fax",
    planet_osm_polygon.tags -> 'email'::text AS email,
    planet_osm_polygon.tags -> 'contact:email'::text AS "contact-email",
    planet_osm_polygon.tags -> 'website'::text AS website,
    planet_osm_polygon.tags -> 'contact:website'::text AS "contact-website",
    planet_osm_polygon.tags -> 'url'::text AS url,
    planet_osm_polygon.tags -> 'payment'::text AS payment,
    planet_osm_polygon.tags -> 'capacity'::text AS capacity,
    planet_osm_polygon.tags -> 'parking'::text AS parking,
    planet_osm_polygon.tags -> 'ref:FR:NAF'::text AS "ref-FR-NAF",
    planet_osm_polygon.tags -> 'ref:FR:SIRET'::text AS "ref-FR-SIRET",
--tags contextuels complémentaires associés à highway--
    planet_osm_polygon.oneway,
    planet_osm_polygon.ref,
    planet_osm_polygon.bridge,
    planet_osm_polygon.layer,
    planet_osm_polygon.surface,
    planet_osm_polygon.bicycle,
    planet_osm_polygon.foot,
    planet_osm_polygon.junction,
    planet_osm_polygon.service,
    planet_osm_polygon.tunnel,
    planet_osm_polygon.tags -> 'maxspeed'::text AS maxspeed,
    planet_osm_polygon.tags -> 'minspeed'::text AS minspeed,
    planet_osm_polygon.tags -> 'private'::text AS private,
    planet_osm_polygon.tags -> 'int_ref'::text AS int_ref,
    planet_osm_polygon.tags -> 'width'::text AS width,
    planet_osm_polygon.tags -> 'lanes'::text AS lanes,
    planet_osm_polygon.tags -> 'lit'::text AS lit,
    planet_osm_polygon.tags -> 'sidewalk'::text AS sidewalk,
    planet_osm_polygon.tags -> 'smoothness'::text AS smoothness,
    planet_osm_polygon.tags -> 'motor_vehicule'::text AS motor_vehicule,
    planet_osm_polygon.tags -> 'piste:type'::text AS "piste-type",
    planet_osm_polygon.tags -> 'piste:grooming'::text AS "piste-grooming",
--tags contextuels complémentaires associés à railway--
    planet_osm_polygon.tags -> 'network'::text AS network,
    planet_osm_polygon.tags -> 'usage'::text AS usage,
    planet_osm_polygon.tags -> 'importance'::text AS importance,
    planet_osm_polygon.tags -> 'railway:traffic_mode'::text AS "railway-traffic_mode",
    planet_osm_polygon.tags -> 'gauge'::text AS gauge,
    planet_osm_polygon.tags -> 'electrified'::text AS electrified,
    planet_osm_polygon.tags -> 'voltage'::text AS voltage,
    planet_osm_polygon.tags -> 'frequency'::text AS frequency,
    planet_osm_polygon.tags -> 'passenger'::text AS passenger,
    planet_osm_polygon.tags -> 'passenger_lines'::text AS passenger_lines,
    planet_osm_polygon.cutting,
--tags contextuels complémentaires associés à public_transport--
    planet_osm_polygon.tags -> 'bus'::text AS bus,
    planet_osm_polygon.tags -> 'to'::text AS "to",
    planet_osm_polygon.tags -> 'from'::text AS "from",
    planet_osm_polygon.tags -> 'via'::text AS via,
    planet_osm_polygon.tags -> 'ref:FR:RATP'::text AS "ref-FR-RATP",
    planet_osm_polygon.tags -> 'public_transport:version'::text AS "public_transport-version",
--tags contextuels complémentaires associés à aerialway--
    planet_osm_polygon.tags -> 'ele' AS ele,
    planet_osm_polygon.tourism,
    planet_osm_polygon.tags -> 'aerialway:capacity'::text AS "aerialway-capacity",
    planet_osm_polygon.tags -> 'aerialway:duration'::text AS "aerialway-duration",
    planet_osm_polygon.tags -> 'aerialway:access'::text AS "aerialway-access",
    planet_osm_polygon.tags -> 'aerialway:occupancy'::text AS "aerialway-occupancy",
    planet_osm_polygon.tags -> 'aerialway:length'::text AS "aerialway-length",
--tags contextuels complémentaires associés à waterway--
    planet_osm_polygon.intermittent,
--tags contextuels complémentaires associés à barrier--
    planet_osm_polygon.horse,
    planet_osm_polygon.tags -> 'level'::text AS level,
    planet_osm_polygon.tags -> 'height'::text AS height,
    planet_osm_polygon.tags -> 'power'::text AS power,
    planet_osm_polygon.tags -> 'entrance'::text AS entrance,
    planet_osm_polygon.tags -> 'fence_type'::text AS fence_type,
    planet_osm_polygon.tags -> 'material'::text AS material,
--tags de métadonnées--
    planet_osm_polygon.tags -> 'wikidata'::text AS wikidata,
    planet_osm_polygon.tags -> 'wikipedia'::text AS wikipedia,
    planet_osm_polygon.tags -> 'type'::text AS type,
    planet_osm_polygon.tags -> 'osm_version'::text AS osm_version,
    planet_osm_polygon.tags -> 'osm_timestamp'::text AS osm_timestamp,
 --gestion de la géométrie--
    st_centroid(planet_osm_polygon.way) AS the_geom,
    st_asewkt(planet_osm_polygon.way) AS osm_original_geom,
    'way'::text AS osm_type,
        CASE  -- renvoie la clé (variable const_key) quand la valeur est construction 
        -- modèle basique KEY=construction
            WHEN planet_osm_polygon.landuse = 'construction'::text THEN 'landuse'::text
            WHEN planet_osm_polygon.building = 'construction'::text THEN 'building'::text
            WHEN planet_osm_polygon.barrier = 'construction'::text THEN 'barrier'::text
            WHEN planet_osm_polygon.public_transport = 'construction'::text THEN 'public_transport'::text
            WHEN planet_osm_polygon.office = 'construction'::text THEN 'office'::text
            WHEN planet_osm_polygon.access = 'construction'::text THEN 'access'::text
            WHEN planet_osm_polygon.waterway = 'construction'::text THEN 'waterway'::text
            WHEN planet_osm_polygon.leisure = 'construction'::text THEN 'leisure'::text
            WHEN planet_osm_polygon.shop = 'construction'::text THEN 'shop'::text
            WHEN planet_osm_polygon.amenity = 'construction'::text THEN 'amenity'::text
            WHEN planet_osm_polygon.aerialway = 'construction'::text THEN 'aerialway'::text
            WHEN planet_osm_polygon.place = 'construction'::text THEN 'place'::text
        -- modèle construction:KEY=* (prefix dans le hstore)
            ELSE (hstore_prefix_filter(planet_osm_polygon.tags,'construction')).prefix_key
        END AS const_key,
        CASE -- renvoye la valeur (variable const_value) quand la clé est construction
        -- modèle basique construction=VALUE 
            WHEN planet_osm_polygon.construction IS NOT NULL THEN planet_osm_polygon.construction
        -- modèle construction:*=VALUE (prefix) OU *="construction" (dans le hstore, EX: note="en construction")
            ELSE (hstore_prefix_filter(planet_osm_polygon.tags,'construction')).prefix_value
        -- pour + d'infos sur la fonction cf. db_public/pg_views/proc_hstore_prefix_filter
        END AS const_value
   FROM planet_osm_polygon
  WHERE planet_osm_polygon.construction IS NOT NULL 
    OR planet_osm_polygon.landuse = 'construction'::text 
    OR planet_osm_polygon.building = 'construction'::text 
    OR planet_osm_polygon.barrier = 'construction'::text 
    OR planet_osm_polygon.public_transport = 'construction'::text 
    OR planet_osm_polygon.office = 'construction'::text 
    OR planet_osm_polygon.access = 'construction'::text 
    OR planet_osm_polygon.waterway = 'construction'::text 
    OR planet_osm_polygon.leisure = 'construction'::text 
    OR planet_osm_polygon.shop = 'construction'::text 
    OR planet_osm_polygon.amenity = 'construction'::text 
    OR planet_osm_polygon.aerialway = 'construction'::text 
    OR planet_osm_polygon.place = 'construction'::text -- filtrage dans la logique "common life cycle"
    OR (hstore_prefix_filter(planet_osm_polygon.tags,'construction')).prefix_key IS NOT NULL -- filtrage dans la logique "lifecycle prefix"
--) AS unique_id |car SELECT row_number() demande d'être stocké dans une variable 		
 WITH DATA;