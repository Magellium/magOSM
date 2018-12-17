--------------------------------------
----------CREATION DES INDEXS---------
--------------------------------------
CREATE INDEX railway_index
  ON france_line
  USING btree
  (railway COLLATE pg_catalog."default");

CREATE INDEX highway_index
  ON france_line
  USING BTREE
  (route COLLATE pg_catalog."default");

CREATE INDEX tags_index
  ON france_line
  USING GIST (tags);

CREATE INDEX route_index
  ON france_line
  USING btree
  (route COLLATE pg_catalog."default");
  
CREATE INDEX amenity_point_index
  ON france_point
  USING btree
  (amenity COLLATE pg_catalog."default");
  
CREATE INDEX amenity_polygon_index
  ON france_point
  USING btree
  (amenity COLLATE pg_catalog."default");

CREATE INDEX shop_point_index
  ON france_point
  USING BTREE
  (shop COLLATE pg_catalog."default");

CREATE INDEX shop_poly_index
  ON france_polygon
  USING BTREE
  (shop COLLATE pg_catalog."default");

CREATE INDEX building_index
  ON france_polygon
  USING btree
  (building COLLATE pg_catalog."default");
  
CREATE INDEX landuse_index
  ON france_polygon
  USING btree
  (landuse COLLATE pg_catalog."default");

CREATE INDEX natural_index
  ON france_polygon
  USING btree
  ("natural" COLLATE pg_catalog."default");

CREATE INDEX wetland_index
  ON france_polygon
  USING btree
  (wetland COLLATE pg_catalog."default");

CREATE INDEX wood_index
  ON france_polygon
  USING btree
  (wood COLLATE pg_catalog."default");

CREATE INDEX osm_id_index
  ON france_line
  USING GIST (osm_id);
