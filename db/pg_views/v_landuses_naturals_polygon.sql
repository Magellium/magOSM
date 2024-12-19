-----------------------------------------------------
--landuse, natural, wetland, wood, leisure, tourism--
-----------------------------------------------------

DROP MATERIALIZED VIEW IF EXISTS landuses_naturals_polygon;
CREATE MATERIALIZED VIEW landuses_naturals_polygon AS 
	SELECT 
		osm_id,
		landuse,
		"natural",
		wetland,
		wood,
		leisure,
		tourism,
		aeroway,
		name,
		ref,
		--https://taginfo.openstreetmap.org/keys/landuse#combinations
		tags->'meadow' as "meadow",
		tags->'leaf_type' as "leaf_type",
		tags->'leaf_cycle' as "leaf_cycle",
		tags->'species' as "species",
		tags->'genus' as "genus",
		tags->'height' as "height",
		tags->'circumference' as "circumference",
		--
		tags->'CLC:code' as "CLC-code",
		tags->'CLC:year' as "CLC-year",
		tags->'CLC:id' as "CLC-id",
		tags->'CLC:explanation' as "CLC-explanation",
		tags->'name:botanical' as "name-botanical",
		tags->'residential' as "residential",
		barrier,
		tags->'crop' as "crop",
		operator,
		place,
		tags->'golf' as "golf",
		tags->'denotation' as "denotation",
		--
		water,
		tags->'seasonal' as "seasonal",
		tags->'tidal' as "tidal",
		tags->'ref:corine_land_cover' as "ref-corine_land_cover",
		tags->'addr:street' AS "addr-street",
		tags->'addr:city' AS "addr-city",
		tags->'addr:postcode' AS "addr-postcode",
		--
		sport,
		surface,
		--
		tags->'information' AS "information",
		tags->'website' as "website",
		tags->'hiking' as "hiking",
		--
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source_ref' as "source_ref",
		tags->'source' AS "source",
		tags->'note' AS "note",
		/*tags->'osm_user' AS "osm_user",
		tags->'osm_uid' AS "osm_uid",
		tags->'osm_changeset' AS "osm_changeset",*/
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
		FROM planet_osm_polygon
		WHERE 	landuse IS NOT NULL
			OR "natural" IS NOT NULL
			OR wetland IS NOT NULL
			OR wood IS NOT NULL
			OR leisure IS NOT NULL
			OR tourism IS NOT NULL
			OR aeroway IS NOT NULL;