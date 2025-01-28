------------
--departements--
-------------
-- le département du rhone tel qu'il est representé 
-- sur le geoportail IGN n'est plus un département mais une circonscription départementale
-- dans OSM ce niveau est le niveau 5 
-- On choisi donc de faire une exception pour le rhone et de prendre le niveau 5 pour coller à la representation usuelle 
-- des départements même si le departement 69 a été à priori remplacé par les départements 69M et 69D 

DROP MATERIALIZED VIEW IF EXISTS departements_polygon;
CREATE MATERIALIZED VIEW departements_polygon AS 
	SELECT
		osm_id,
		name,
		tags->'border_type' as border_type,
		tags->'ref:NUTS' as "ref-NUTS",
		tags->'ISO3166-2' as "ISO3166-2",
		tags->'ref:INSEE' as "ref-INSEE",
		tags->'wikidata' as "wikidata",
		tags->'wikipedia' as "wikipedia",
		tags->'source' AS "source",
		tags->'note' AS "note",
		tags->'osm_version' AS "osm_version",
		tags->'osm_timestamp' AS "osm_timestamp",
		way AS "the_geom"
	FROM planet_osm_polygon 
	WHERE boundary ='administrative' and 
	( (admin_level='6' and not tags->'ref:INSEE' like '69%') 
		or (admin_level='5' and tags->'ref:INSEE' like '69%') 
	)
	
	and tags->'ref:INSEE' is not null;
CREATE INDEX departements_polygon_gist ON departements_polygon USING gist (the_geom);
