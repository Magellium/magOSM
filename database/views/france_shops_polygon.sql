
DROP VIEW france_shops_polygon;
CREATE OR REPLACE VIEW france_shops_polygon AS 
	SELECT
		osm_id,
		shop,
		building,
		name,
		tags->'short_name' AS short_name,
		tags->'alt_name' AS alt_name,
		operator,
		brand,
		tags->'opening_hours' AS opening_hours,
		tags->'wheelchair' AS "wheelchair",
		tags->'internet_access' AS "internet_access",
		tags->'origin' AS "origin",
		tags->'wholesale' AS "wholesale",
		tags->'second_hand' AS "second_hand",
		tags->'payment' AS "payment",
		tags->'ref:FR:NAF' AS "ref-FR-NAF",
		tags->'ref:FR:SIRET' AS "ref-FR-SIRET",
		tags->'website' AS "website",
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
		tags->'description' AS description,
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM france_polygon 
	WHERE shop IS NOT NULL;
GRANT SELECT ON TABLE france_shops_polygon TO isogeo;