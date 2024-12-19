--------------------------------------
----------CREATION DES INDEXS---------
--------------------------------------


-- osm_id
CREATE INDEX IF NOT EXISTS osm_id_point_index
  ON planet_osm_point
  USING GIST (osm_id);

CREATE INDEX IF NOT EXISTS osm_id_index
  ON planet_osm_line
  USING GIST (osm_id);

CREATE INDEX IF NOT EXISTS osm_id_polygon_index
  ON planet_osm_polygon
  USING GIST (osm_id);

-- shop
CREATE INDEX IF NOT EXISTS shop_point_index
  ON planet_osm_point
  USING BTREE
  (shop COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS shop_poly_index
  ON planet_osm_polygon
  USING BTREE
  (shop COLLATE pg_catalog."default");

-- tags (hstore column -> GIST index)
CREATE INDEX IF NOT EXISTS tags_point_index
  ON planet_osm_point
  USING GIST (tags);

CREATE INDEX IF NOT EXISTS tags_index
  ON planet_osm_line
  USING GIST (tags);

CREATE INDEX IF NOT EXISTS tags_polygon_index
  ON planet_osm_polygon
  USING GIST (tags);

-- railway
CREATE INDEX IF NOT EXISTS railway_index
  ON planet_osm_line
  USING btree
  (railway COLLATE pg_catalog."default");

-- highway
CREATE INDEX IF NOT EXISTS highway_index
  ON planet_osm_line
  USING BTREE
  (highway COLLATE pg_catalog."default");

-- route
CREATE INDEX IF NOT EXISTS route_index
  ON planet_osm_line
  USING btree
  (route COLLATE pg_catalog."default");
  
-- building
CREATE INDEX IF NOT EXISTS building_index
  ON planet_osm_polygon
  USING btree
  (building COLLATE pg_catalog."default");

-- landuse
CREATE INDEX IF NOT EXISTS landuse_index
  ON planet_osm_polygon
  USING btree
  (landuse COLLATE pg_catalog."default");

-- natural
CREATE INDEX IF NOT EXISTS natural_index
  ON planet_osm_polygon
  USING btree
  ("natural" COLLATE pg_catalog."default");

-- wetland
CREATE INDEX IF NOT EXISTS wetland_index
  ON planet_osm_polygon
  USING btree
  (wetland COLLATE pg_catalog."default");

-- wood
CREATE INDEX IF NOT EXISTS wood_index
  ON planet_osm_polygon
  USING btree
  (wood COLLATE pg_catalog."default");

-- boundary
CREATE INDEX IF NOT EXISTS boundary_index
  ON planet_osm_polygon
  USING btree
  (boundary COLLATE pg_catalog."default");

-- barrier
CREATE INDEX IF NOT EXISTS barrier_point_index
  ON planet_osm_point
  USING btree
  (barrier COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS barrier_line_index
  ON planet_osm_line
  USING btree
  (barrier COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS barrier_polygon_index
  ON planet_osm_polygon
  USING btree
  (barrier COLLATE pg_catalog."default");

-- public_transport
CREATE INDEX IF NOT EXISTS public_transport_point_index
  ON planet_osm_point
  USING btree
  (public_transport COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS public_transport_line_index
  ON planet_osm_line
  USING btree
  (public_transport COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS public_transport_polygon_index
  ON planet_osm_polygon
  USING btree
  (public_transport COLLATE pg_catalog."default");

-- office
CREATE INDEX IF NOT EXISTS office_point_index
  ON planet_osm_point
  USING btree
  (office COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS office_polygon_index
  ON planet_osm_polygon
  USING btree
  (office COLLATE pg_catalog."default");

-- access
CREATE INDEX IF NOT EXISTS access_point_index
  ON planet_osm_point
  USING btree
  (access COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS access_line_index
  ON planet_osm_line
  USING btree
  (access COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS access_polygon_index
  ON planet_osm_polygon
  USING btree
  (access COLLATE pg_catalog."default");

-- leisure
CREATE INDEX IF NOT EXISTS leisure_point_index
  ON planet_osm_point
  USING btree
  (leisure COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS leisure_line_index
  ON planet_osm_line
  USING btree
  (leisure COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS leisure_polygon_index
  ON planet_osm_polygon
  USING btree
  (leisure COLLATE pg_catalog."default");

-- amenity
CREATE INDEX IF NOT EXISTS amenity_point_index
  ON planet_osm_point
  USING btree
  (amenity COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS amenity_polygon_index
  ON planet_osm_polygon
  USING btree
  (amenity COLLATE pg_catalog."default");

-- aerialway
CREATE INDEX IF NOT EXISTS aerialway_point_index
  ON planet_osm_point
  USING btree
  (aerialway COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS aerialway_line_index
  ON planet_osm_line
  USING btree
  (aerialway COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS aerialway_polygon_index
  ON planet_osm_polygon
  USING btree
  (aerialway COLLATE pg_catalog."default");

-- place
CREATE INDEX IF NOT EXISTS place_point_index
  ON planet_osm_point
  USING btree
  (place COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS place_line_index
  ON planet_osm_line
  USING btree
  (place COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS place_polygon_index
  ON planet_osm_polygon
  USING btree
  (place COLLATE pg_catalog."default");

-- waterway
CREATE INDEX IF NOT EXISTS waterway_line_index
  ON planet_osm_line
  USING btree
  (waterway COLLATE pg_catalog."default");

CREATE INDEX IF NOT EXISTS waterway_polygon_index
  ON planet_osm_polygon
  USING btree
  (waterway COLLATE pg_catalog."default");