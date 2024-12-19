-----------
--schools--
-----------

DROP MATERIALIZED VIEW IF EXISTS schools_point;
CREATE MATERIALIZED VIEW schools_point AS 
	SELECT
		osm_id,
		amenity,
		tags->'school:FR' AS "school-FR",
		tags->'ref:UAI' AS "ref-UAI",
		name,
		tags->'name:fr' AS "name-fr",
		tags->'short_name' AS short_name,
		tags->'official_name' AS official_name,
		tags->'alt_name' AS alt_name,
		tags->'old_name' AS old_name,
		operator,
		tags->'operator:type' as "operator-type",
		tags->'description' AS description,
		tags->'opening_hours' AS opening_hours,
		tags->'website' AS website,
		tags->'contact:website' AS "contact-website",
		tags->'url' AS url,
		tags->'phone' AS phone,
		tags->'contact:phone' AS "contact-phone",
		tags->'fax' AS "fax",
		tags->'contact:fax' AS "contact-fax",
		tags->'email' as "email",
		tags->'contact:email' AS "contact-email",
		"addr:housename" AS "addr-housename",
		"addr:housenumber" AS "addr-housenumber",
		tags->'addr:street' AS "addr-street",
		tags->'addr:city' AS "addr-city",
		tags->'addr:postcode' AS "addr-postcode",
		tags->'wheelchair' AS wheelchair,
		tags->'ref:FR:FINESS' AS "ref-FR-FINESS",
		tags->'ref:FR:SIRET' AS "ref-FR-SIRET",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom",
		'' AS "osm_original_geom",
		'node' AS "osm_type"
	FROM planet_osm_point 
	WHERE 	(amenity='school' 
		OR amenity='university' 
		OR amenity='kindergarten' 
		OR amenity='college')
	UNION
	SELECT
		osm_id,
		amenity,
		tags->'school:FR' AS "school-FR",
		tags->'ref:UAI' AS "ref-UAI",
		name,
		tags->'name:fr' AS "name-fr",
		tags->'short_name' AS short_name,
		tags->'official_name' AS official_name,
		tags->'alt_name' AS alt_name,
		tags->'old_name' AS old_name,
		operator,
		tags->'operator:type' as "operator-type",
		tags->'description' AS description,
		tags->'opening_hours' AS opening_hours,
		tags->'website' AS website,
		tags->'contact:website' AS "contact-website",
		tags->'url' AS url,
		tags->'phone' AS phone,
		tags->'contact:phone' AS "contact-phone",
		tags->'fax' AS "fax",
		tags->'contact:fax' AS "contact-fax",
		tags->'email' as "email",
		tags->'contact:email' AS "contact-email",
		"addr:housename" AS "addr-housename",
		"addr:housenumber" AS "addr-housenumber",
		tags->'addr:street' AS "addr-street",
		tags->'addr:city' AS "addr-city",
		tags->'addr:postcode' AS "addr-postcode",
		tags->'wheelchair' AS wheelchair,
		tags->'ref:FR:FINESS' AS "ref-FR-FINESS",
		tags->'ref:FR:SIRET' AS "ref-FR-SIRET",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		ST_Centroid(way) AS "the_geom",
		ST_AsEWKT(way) AS "osm_original_geom",
		'way' AS "osm_type"
	FROM planet_osm_polygon 
	WHERE 	(amenity='school' 
		OR amenity='university' 
		OR amenity='kindergarten' 
		OR amenity='college');