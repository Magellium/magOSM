
--------------------
--vineyards_grapes--
--------------------

DROP MATERIALIZED VIEW IF EXISTS vineyards_grapes_polygon;
CREATE MATERIALIZED VIEW vineyards_grapes_polygon AS 
	SELECT 
		row_number() over() as magosm_id,
		osm_id,
		--
		landuse,
		tags->'crop' as "crop",
		---
		tags->'vine_row_orientation' as "vine_row_orientation",
		tags->'vineyard:locality' as "vineyard-locality",
		tags->'grape_variety' as "grape_variety",
		tags->'organic' as "organic",
		tags->'harvest_first_year' as "harvest_first_year",
		tags->'type' as "type",
		---
		name,
		operator,
		ref,
		---
		tags->'CLC:code' as "CLC-code",
		tags->'CLC:year' as "CLC-year",
		tags->'CLC:date' as "CLC-date",
		tags->'CLC:id' as " CLC-id",
		tags->'CLC:shapeId' as " CLC-shapeId",
		tags->'CLC:explanation' as "CLC-explanation",
		---
		tags->'description' AS description,
		tags->'website' as "website",
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
		WHERE 	landuse='vineyard';