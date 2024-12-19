-------------------------------
------STRUCTURES SOCIALES------
------service social-----------
------centre associatif--------
------centre communautaire-----
-------------------------------

DROP MATERIALIZED VIEW IF EXISTS social_facility_point;
CREATE MATERIALIZED VIEW social_facility_point AS 
  SELECT planet_osm_point.osm_id,
    planet_osm_point.amenity,
    planet_osm_point.office, -- tag relatif  aux "centres associatifs" type NGO/union/association
    planet_osm_point.name,
    planet_osm_point.operator,
-- tags relatifs  aux "services sociaux"
    planet_osm_point.tags -> 'social_facility'::text AS social_facility,
    planet_osm_point.tags -> 'social_facility:for'::text AS "social_facility-for", 
-- tags relatifs  aux "centres communautaires"
    planet_osm_point.tags -> 'community_centre'::text AS community_centre,
    planet_osm_point.tags -> 'community_centre:for'::text AS "community_centre-for",
-- type et ref :FR:FINESS permettent de distinguer respectivement le la catégorie et le numéro de l'établissement social/ médico-social 
    planet_osm_point.tags -> 'ref:FR:FINESS'::text AS "ref-frfiness",
    planet_osm_point.tags -> 'type:FR:FINESS'::text AS "type-FR-FINESS",
    planet_osm_point.tags -> 'operator:type'::text AS "operator-type",
    planet_osm_point.tags -> 'short_name'::text AS short_name,
    planet_osm_point.tags -> 'official_name'::text AS official_name,
--tags relatifs à l'accessibilité du lieu 
    planet_osm_point.tags -> 'building'::text AS building,
    planet_osm_point.tags -> 'dispensing'::text AS dispensing,
    planet_osm_point.tags -> 'capacity'::text AS capacity,
    planet_osm_point.tags -> 'beds'::text AS beds,
    planet_osm_point.tags -> 'opening_hours'::text AS opening_hours,
    planet_osm_point.tags -> 'emergency'::text AS emergency,
    planet_osm_point.tags -> 'wheelchair'::text AS wheelchair,
    planet_osm_point.tags -> 'ref:FR:NAF'::text AS "ref-fr-NAF",
    planet_osm_point.tags -> 'ref:FR:SIRET'::text AS "ref-fr-SIRET",
    planet_osm_point.tags -> 'website'::text AS website,
    planet_osm_point.tags -> 'contact:website'::text AS "contact-website",
    planet_osm_point.tags -> 'url'::text AS url,
    planet_osm_point.tags -> 'contact:url'::text AS "contact-url",
    planet_osm_point.tags -> 'phone'::text AS phone,
    planet_osm_point.tags -> 'contact:phone'::text AS "contact-phone",
    planet_osm_point.tags -> 'fax'::text AS fax,
    planet_osm_point.tags -> 'contact:fax'::text AS "contact-fax",
    planet_osm_point.tags -> 'email'::text AS email,
    planet_osm_point.tags -> 'contact:email'::text AS "contact-email",
    planet_osm_point."addr:housename" AS "addr-housename",
    planet_osm_point."addr:housenumber" AS "addr-housenumber",
    planet_osm_point.tags -> 'addr:street'::text AS "addr-street",
    planet_osm_point.tags -> 'addr:city'::text AS "addr-city",
    planet_osm_point.tags -> 'addr:postcode'::text AS "addr-postcode",
--métadonnées
    planet_osm_point.tags -> 'wikidata'::text AS wikidata,
    planet_osm_point.tags -> 'wikipedia'::text AS wikipedia,
    planet_osm_point.tags -> 'description'::text AS description,
    planet_osm_point.tags -> 'source'::text AS source,
    planet_osm_point.tags -> 'note'::text AS note,
    planet_osm_point.tags -> 'osm_version'::text AS osm_version,
    planet_osm_point.tags -> 'osm_timestamp'::text AS osm_timestamp,
--gestion de la géométrie 
    planet_osm_point.way AS the_geom,
    ''::text AS osm_original_geom,
    'node'::text AS osm_type
   FROM planet_osm_point
  WHERE (planet_osm_point.amenity = 'social_facility'::text 
    OR planet_osm_point.amenity = 'community_centre'::text 
    OR planet_osm_point.amenity = 'social_centre'::text 
    OR (planet_osm_point.tags -> 'social_facility'::text) IS NOT NULL -- permet de récupérer les social_facility=* qui sont stockés dans le hstore
    OR (planet_osm_point.tags -> 'community_centre'::text) IS NOT NULL -- permet de récupérer les community_centre=* qui sont stockés dans le hstore
    OR planet_osm_point.office = 'ngo'::text 
    OR planet_osm_point.office = 'association'::text 
    OR planet_osm_point.office = 'union'::text)
    AND planet_osm_point.osm_id > 0 -- n'inclu pas les relations
UNION
 SELECT planet_osm_polygon.osm_id,
    planet_osm_polygon.amenity,
    planet_osm_polygon.office,
    planet_osm_polygon.name,
    planet_osm_polygon.operator,
    planet_osm_polygon.tags -> 'social_facility'::text AS social_facility,
    planet_osm_polygon.tags -> 'social_facility:for'::text AS "social_facility-for",
    planet_osm_polygon.tags -> 'community_centre'::text AS community_centre,
    planet_osm_polygon.tags -> 'community_centre:for'::text AS "community_centre-for",
    planet_osm_polygon.tags -> 'ref:FR:FINESS'::text AS "ref-FR-FINESS",
    planet_osm_polygon.tags -> 'type:FR:FINESS'::text AS "type-FR-FINESS",
    planet_osm_polygon.tags -> 'operator:type'::text AS "operator-type",
    planet_osm_polygon.tags -> 'short_name'::text AS short_name,
    planet_osm_polygon.tags -> 'official_name'::text AS official_name,
    planet_osm_polygon.tags -> 'building'::text AS building,
    planet_osm_polygon.tags -> 'dispensing'::text AS dispensing,
    planet_osm_polygon.tags -> 'capacity'::text AS capacity,
    planet_osm_polygon.tags -> 'beds'::text AS beds,
    planet_osm_polygon.tags -> 'opening_hours'::text AS opening_hours,
    planet_osm_polygon.tags -> 'emergency'::text AS emergency,
    planet_osm_polygon.tags -> 'wheelchair'::text AS wheelchair,
    planet_osm_polygon.tags -> 'ref:FR:NAF'::text AS "ref-fr-NAF",
    planet_osm_polygon.tags -> 'ref:FR:SIRET'::text AS "ref-fr-SIRET",
    planet_osm_polygon.tags -> 'website'::text AS website,
    planet_osm_polygon.tags -> 'contact:website'::text AS "contact-website",
    planet_osm_polygon.tags -> 'url'::text AS url,
    planet_osm_polygon.tags -> 'contact:url'::text AS "contact-url",
    planet_osm_polygon.tags -> 'phone'::text AS phone,
    planet_osm_polygon.tags -> 'contact:phone'::text AS "contact-phone",
    planet_osm_polygon.tags -> 'fax'::text AS fax,
    planet_osm_polygon.tags -> 'contact:fax'::text AS "contact-fax",
    planet_osm_polygon.tags -> 'email'::text AS email,
    planet_osm_polygon.tags -> 'contact:email'::text AS "contact-email",
    planet_osm_polygon."addr:housename" AS "addr-housename",
    planet_osm_polygon."addr:housenumber" AS "addr-housenumber",
    planet_osm_polygon.tags -> 'addr:street'::text AS "addr-street",
    planet_osm_polygon.tags -> 'addr:city'::text AS "addr-city",
    planet_osm_polygon.tags -> 'addr:postcode'::text AS "addr-postcode",
    planet_osm_polygon.tags -> 'wikidata'::text AS wikidata,
    planet_osm_polygon.tags -> 'wikipedia'::text AS wikipedia,
    planet_osm_polygon.tags -> 'description'::text AS description,
    planet_osm_polygon.tags -> 'source'::text AS source,
    planet_osm_polygon.tags -> 'note'::text AS note,
    planet_osm_polygon.tags -> 'osm_version'::text AS osm_version,
    planet_osm_polygon.tags -> 'osm_timestamp'::text AS osm_timestamp,
    st_centroid(planet_osm_polygon.way) AS the_geom, -- calcul le centroide des way (ici des bâtiments principalement) pour alléger les calculs de géométrie
    st_asewkt(planet_osm_polygon.way) AS osm_original_geom,
    'way'::text AS osm_type
   FROM planet_osm_polygon
  WHERE (planet_osm_polygon.amenity = 'social_facility'::text 
    OR planet_osm_polygon.amenity = 'community_centre'::text 
    OR planet_osm_polygon.amenity = 'social_centre'::text 
    OR (planet_osm_polygon.tags -> 'social_facility'::text) IS NOT NULL 
    OR (planet_osm_polygon.tags -> 'community_centre'::text) IS NOT NULL 
    OR planet_osm_polygon.office = 'ngo'::text 
    OR planet_osm_polygon.office = 'association'::text 
    OR planet_osm_polygon.office = 'union'::text)
    AND planet_osm_polygon.osm_id > 0 ;