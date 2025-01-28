--Parcs Naturels Régionaux-

DROP MATERIALIZED VIEW IF EXISTS pnr_polygon;
CREATE MATERIALIZED VIEW pnr_polygon AS 
SELECT 
--attributs principaux
osm_id AS osm_id,
name,
ref,
boundary,
tags->'ref:INPN' as "ref-inpn",
tags->'protect_class' as "protect_class",
tags->'protection_title' as "protection_title",

--denominations
tags->'short_name' AS short_name,
tags->'alt_name' AS alt_name,
tags->'old_name' AS old_name,
tags->'name:fr' AS "name-fr",
tags->'name:it' AS "name-it",
tags->'name:de' AS "name-de",
tags->'name:en' AS "name-en",
tags->'name:eu' AS "name-eu",


--liste d'attributs potentiellement intéressants issus de https://wiki.openstreetmap.org/wiki/Tag:boundary%3Dprotected_area
tags->'protection_object' as "protection_object",
tags->'protection_aim' as "protection_aim",
tags->'protection_ban' as "protection_ban",
tags->'protection_instruction' as "protection_instruction",
tags->'related_law' as "related_law",
tags->'site_zone' as "site_zone",
tags->'valid_from' as "valid_from",
tags->'valid_until' as "valid_until", --tag non documenté mais régulièrement utilisé ?
tags->'start_date' as "start_date",
tags->'end_date' as "end_date",
tags->'opening_hours' AS opening_hours,
operator AS operator,
tags->'governance_type' as "governance_type",
tags->'site_ownership' as "site_ownership",
tags->'site_status' as "site_status",
tags->'protection_award' as "protection_award",
tags->'protected' as "protected",

--attributs génériques
tags->'phone' AS phone,
tags->'contact:phone' AS "contact-phone",
tags->'fax' AS "fax",
tags->'contact:fax' AS "contact-fax",
tags->'email' as "email",
tags->'contact:email' AS "contact-email",
tags->'website' AS "website",
tags->'contact:website' AS "contact-website",
tags->'url' AS url,
tags->'url:source' AS "url-source",
tags->'wikidata' as "wikidata",
tags->'wikipedia' as "wikipedia",
tags->'description' AS description,
tags->'source' AS "source",
tags->'note' AS "note",

--metadonnees
tags->'osm_version' AS "osm_version",
tags->'osm_timestamp' AS "osm_timestamp",

--geometrie et type
way AS "the_geom",
'rel'::text AS "osm_type"

FROM planet_osm_polygon 
WHERE boundary='protected_area'
AND tags->'protection_title' = 'parc naturel régional'
AND osm_id<0;