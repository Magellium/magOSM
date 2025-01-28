#!/bin/bash

## Author: Axel Dumont

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed

# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../conf/.env

##### READ ME #####
# This scripts adds new tables and new functions to a DB already initialized with osm2pgsql #
## Thoses tables and scripts allows to track the changes of the osm2pgsql DB, and store them into 3 tables : changes_analysis_point, line and polygon ##
##############
##### Organisation of the document
# 1. First PSQL command :
#   1. Dictionnary tables created in a schema named "dictionnary" : thematics, thematics_categories, changes_types.
#       /!\ It is very important to look at the syntax of the thematic's request, it is not trivial.
#   2. Function 'changes_analysis' is created : This function takes all the elements in tables "trigger_info_line/point/polygon" (one changes = several lines) and constitute changes
#       in tables "changes_analysis_point/line/polygon" (One line = one changes)
#   3. Function "getlayerofhstore" : hstore contains all tags of an OSM object. With those tags and the table "dictionnary.thematics", the function determine if this object
#       belongs to one or several magOSM's thematics, and return an array of number 
#   4. Trigger function "audit_table()" which is called each time an object is inserted or deleted from tables point/line/polygon. This function generate the hstore of tags, timestamp, geometry, version, etc 
#   and add ONE line each time in tables "trigger_info_point/line/polygon".
# 2. Then, we have a "for loop" with point/line/polygon. It's not possible to use the same functions for those 3 types because some columns are a bit different, like Geometry.
#    That's why this loop create specific functions for each type
# 3. Second PSQL command : 
#   1. Trigger_info and changes_analysis functions are created
#   2. Function "get${type}hstore(entity)" is created : this function is called into the trigger function and return the hstore with all the tags
#   3. Function "get${type}rowvalue" is created : this function is called in the previous function.
#   4. Trigger is created
#   5. Function "set${type}Analysis" is created. This function is the MOST important and is called in the function {}_changes_analysis().
#       The function regroups all entities from trigger_info_${type} with the same OSM_ID and analyzes them to create ONE UNIQUE ENTITY in table changes_analysis_{type} 
##########

BEFORE=$SECONDS
echo ---------
echo Creating the required tables...
echo ---------
psql -U ${DBPG_USER_MAGOSM_USERNAME} -d ${DBPG_DATABASE_NAME}  << EOF
CREATE SCHEMA IF NOT EXISTS dictionnary AUTHORIZATION ${DBPG_USER_MAGOSM_USERNAME};
GRANT ALL ON SCHEMA dictionnary TO ${DBPG_USER_MAGOSM_USERNAME};
DROP TABLE IF EXISTS dictionnary.thematics, dictionnary.changes_types, dictionnary.thematics_categories CASCADE;

/* Categories like in magOSM */
CREATE TABLE dictionnary.thematics_categories(
    id serial PRIMARY KEY NOT NULL,
    name character varying(100)
);

INSERT INTO dictionnary.thematics_categories (name)
VALUES
('Points d''intérêt'),
('Routes/Itinéraires'),
('Bâti/Occupation du sol'),
('Télécommunications');

/* The same thematics as in magOSM */
CREATE TABLE dictionnary.thematics
(
	id serial NOT NULL PRIMARY KEY,
    id_category integer NOT NULL references dictionnary.thematics_categories(id),
    name character varying(100),
	view_name character varying(100),
	osm2pgsql_request text,
	changes_request text
);

-- \$1 hstore tags, \$2 osm_id, \$3 table_name
INSERT INTO dictionnary.thematics (name, id_category, view_name, changes_request) 
VALUES 
('Itinéraires cyclables',2,'bicycle_mtb_routes_line', 'SELECT \$2<0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' IN (''bicycle'', ''mtb'')'),
('Bâtiments',3,'buildings_polygon', 'SELECT \$3 LIKE ''%polygon'' AND \$1 ? ''building'''),
('Itinéraires de bus',2,'bus_route_line','SELECT \$2<0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' = ''bus'''),
('Cliniques',1,'clinics_point','SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''clinic'''),
('Réseau cyclable',2,'cycleways_line','SELECT \$2>0 AND \$3 LIKE ''%line'' AND ((\$1 ? ''highway'' AND \$1 -> ''highway'' = ''cycleway'') OR (\$1 ? ''bicycle'' AND \$1 -> ''bicycle'' = ''designated'') OR (\$1 ? ''cycleway'' AND \$1 -> ''cycleway'' != ''no'') OR (\$1 ? ''cycleway:left'' AND \$1 -> ''cycleway:left'' != ''no'') OR (\$1 ? ''cycleway:right'' AND \$1 -> ''cycleway:right'' != ''no'') OR (\$1 ? ''cycleway:both'' AND \$1 -> ''cycleway:both'' != ''no''))'),
('Réseau routier',2,'highways_line', 'SELECT \$2 > 0 AND \$3 LIKE ''%line'' AND \$1 ? ''highway'' AND \$1 -> ''highway'' IN (''motorway'', ''trunk'', ''primary'', ''secondary'', ''tertiary'', ''motorway_link'',''trunk_link'',''primary_link'',''secondary_link'',''tertiary_link'', ''unclassified'', ''residential'', ''service'', ''pedestrian'', ''living_street'', ''track'')'),
('Itinéraires de randonnée',2,'hiking_foot_routes_line', 'SELECT \$2 <0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' IN (''hiking'', ''foot'')'),
('Hôpitaux',1,'hospitals_point', 'SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''hospital'''),
('Occupation du sol',3,'landuses_naturals_polygon', 'SELECT \$3 LIKE ''%polygon'' AND (\$1 ? ''natural'' OR \$1 ? ''landuse'' OR \$1 ? ''wetland'' OR \$1 ? ''wood'' OR \$1 ? ''leisure'' OR \$1 ? ''tourism'' OR \$1 ? ''aeroway'')'),
('Autoroutes',2,'motorways_line', 'SELECT \$3 LIKE ''%line'' AND \$2 > 0 AND \$1 ? ''highway'' AND \$1 -> ''highway'' IN (''motorway'',''motorway_link'',''motorway_junction'')'),
('Pharmacies',1,'pharmacies_point', 'SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''pharmacy'''),
('Parcs Naturels Régionaux',3,'pnr_polygon', 'SELECT \$2 < 0 AND \$3 LIKE ''%polygon'' AND \$1 ? ''boundary'' AND \$1 -> ''boundary'' = ''protected_area'' AND \$1 ? ''protection_title'' AND \$1 -> ''protection_title'' = ''parc naturel régional'''),
('Polices et Gendarmeries',1,'police_point', 'SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''police'''),
('Voies ferrées',2,'railways_line', 'SELECT \$3 LIKE ''%line'' AND \$2 > 0 AND \$1 ? ''railway'' AND \$1 -> ''railway'' IN (''rail'',''narrow_gauge'')' ),
('Ecoles',1,'schools_point', 'SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''amenity'' AND \$1 -> ''amenity'' IN (''school'', ''university'', ''kindergarten'', ''college'')'),
('Magasins',1,'shops_point', 'SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''shop'''),
('Itinéraires de métro',2,'subway_routes_line', 'SELECT \$2<0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' = ''subway'''),
('Sous-répartiteurs cuivre',4,'telecom_copper_connection_point','SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''telecom'' AND \$1 -> ''telecom'' = ''connection_point'' AND \$1 ? ''telecom:medium'' AND \$1 -> ''telecom:medium'' = ''copper'''),
('Noeuds de raccordement',4,'telecom_exchange_point','SELECT \$3 NOT LIKE ''%line'' AND ((\$1 ? ''telecom'' AND \$1 -> ''telecom'' IN (''central_office'', ''exchange'')) OR (\$1 ? ''man_made'' AND \$1 -> ''man_made'' = ''telephone_office''))'),
('Points de mutualisation fibre',4,'telecom_fibre_connection_point','SELECT \$3 NOT LIKE ''%line'' AND \$1 ? ''telecom'' AND \$1 -> ''telecom'' = ''connection_point'' AND \$1 ? ''telecom:medium'' AND \$1 -> ''telecom:medium'' = ''fibre'''),
('Itinéraires de tramway',2,'tram_ltr_routes_line','SELECT \$2<0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' IN (''light_rail'',''tram'')'),
('Itinéraires de train',2,'train_routes_line','SELECT \$2<0 AND \$3 LIKE ''%line'' AND \$1 ? ''route'' AND \$1 -> ''route'' = ''train'''),
('Structures sociales',1,'social_amenity_point','SELECT \$3 NOT LIKE ''%line'' AND ((\$1 ? ''amenity'' AND \$1 -> ''amenity'' IN (''social_facility'', ''community_centre'', ''social_centre'')) OR (\$1 ? ''social_facility'') OR (\$1 ? ''community_centre'') OR (\$1 ? ''office'' AND \$1 -> ''office'' IN (''ngo'', ''association'', ''union'')))'),
('Constructions en cours',3,'constructions','SELECT \$1 ? ''construction'' OR (\$1 ? ''landuse'' AND \$1 -> ''landuse'' = ''construction'') OR (\$1 ? ''highway'' AND \$1 -> ''highway'' = ''construction'') OR (\$1 ? ''building'' AND \$1 -> ''building'' = ''construction'') OR (\$1 ? ''railway'' AND \$1 -> ''railway'' = ''construction'') OR (\$1 ? ''barrier'' AND \$1 -> ''barrier'' = ''construction'') OR (\$1 ? ''public_transport'' AND \$1 -> ''public_transport'' = ''construction'') OR (\$1 ? ''office'' AND \$1 -> ''office'' = ''construction'') OR (\$1 ? ''access'' AND \$1 -> ''access'' = ''construction'') OR (\$1 ? ''waterway'' AND \$1 -> ''waterway'' = ''construction'') OR (\$1 ? ''leisure'' AND \$1 -> ''leisure'' = ''construction'') OR (\$1 ? ''shop'' AND \$1 -> ''shop'' = ''construction'') OR (\$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''construction'') OR (\$1 ? ''aerialway'' AND \$1 -> ''aerialway'' = ''construction'') OR (\$1 ? ''route'' AND \$1 -> ''route'' = ''construction'') OR (\$1 ? ''place'' AND \$1 -> ''place'' = ''construction'') OR (hstore_prefix_filter(\$1,''construction'')).prefix_key IS NOT NULL OR (hstore_prefix_filter(\$1,''construction'')).prefix_value IS NOT NULL'),
('Propositions de constructions',3,'proposed','SELECT \$1 ? ''proposed'' OR (\$1 ? ''landuse'' AND \$1 -> ''landuse'' = ''proposed'') OR (\$1 ? ''highway'' AND \$1 -> ''highway'' = ''proposed'') OR (\$1 ? ''building'' AND \$1 -> ''building'' = ''proposed'') OR (\$1 ? ''railway'' AND \$1 -> ''railway'' = ''proposed'') OR (\$1 ? ''barrier'' AND \$1 -> ''barrier'' = ''proposed'') OR (\$1 ? ''public_transport'' AND \$1 -> ''public_transport'' = ''proposed'') OR (\$1 ? ''office'' AND \$1 -> ''office'' = ''proposed'') OR (\$1 ? ''access'' AND \$1 -> ''access'' = ''proposed'') OR (\$1 ? ''waterway'' AND \$1 -> ''waterway'' = ''proposed'') OR (\$1 ? ''leisure'' AND \$1 -> ''leisure'' = ''proposed'') OR (\$1 ? ''shop'' AND \$1 -> ''shop'' = ''proposed'') OR (\$1 ? ''amenity'' AND \$1 -> ''amenity'' = ''proposed'') OR (\$1 ? ''aerialway'' AND \$1 -> ''aerialway'' = ''proposed'') OR (\$1 ? ''route'' AND \$1 -> ''route'' = ''proposed'') OR (\$1 ? ''place'' AND \$1 -> ''place'' = ''proposed'') OR (hstore_prefix_filter(\$1,''proposed'')).prefix_key IS NOT NULL OR (hstore_prefix_filter(\$1,''proposed'')).prefix_value IS NOT NULL');



GRANT ALL ON TABLE dictionnary.thematics TO ${DBPG_USER_MAGOSM_USERNAME};

CREATE TABLE dictionnary.changes_types
(
	id integer NOT NULL,
	short_name character varying(50),
    name TEXT,
    ref TEXT,
	label TEXT,
    color hstore,
	CONSTRAINT changes_types_pkey PRIMARY KEY (id)
);

INSERT INTO dictionnary.changes_types (id, ref, short_name, name, label, color) VALUES
	(1,'creation','Création','Création','objet qui est ajouté à la base et qui rentre dans la requête','"B"=>"0", "G"=>"128", "R"=>"0"'),
	(2,'ajout','Ajout','Ajout','objet déja présent dans la base et qui rentre dans la requête','"B"=>"0", "G"=>"128", "R"=>"0"'),
	(3,'modif-tag','Modif. de tag(s) uniq.','Modification de tag(s) uniquement','objet dans la requête au début et à la fin, qui a au moins un changement d''attribut parmi ceux dans la vue SQL','"B"=>"0", "G"=>"165", "R"=>"255"'),
	(4,'modif-geom','Modif. de géométrie uniq.','Modification de géométrie uniquement','objet dans la requête au début et à la fin, qui change de géométrie (déplacement, membres)','"B"=>"0", "G"=>"165", "R"=>"255"'),
	(5,'retrait','Retrait','Retrait','objet qui sort de la requête mais reste dans la base','"B"=>"0", "G"=>"0", "R"=>"255"'),
	(6,'suppression','Suppression','Suppression','objet supprimé de la base','"B"=>"0", "G"=>"0", "R"=>"255"'),
	(34, 'modif-tag-et-geom','Modif. de tag(s) et de géométrie','Modification de tag(s) et de géométrie','objet dans la requête au début et à la fin, qui a au moins un changement d''attribut ET un changement de géométrie','"B"=>"0", "G"=>"165", "R"=>"255"'),
    (7, 'autre','Autre','Autre','objet sans changement de géométrie ni de tags, mais dont la version change quand même --> membres modifiés, changement de sens, etc','"B"=>"130", "G"=>"0", "R"=>"75"');

CREATE OR REPLACE FUNCTION changes_analysis()
  RETURNS void AS
\$BODY\$
DECLARE
	point_ids CURSOR IS SELECT DISTINCT osm_id FROM trigger_info_point WHERE layers != '{}';
	line_ids CURSOR IS SELECT DISTINCT osm_id FROM trigger_info_line WHERE layers != '{}';
	polygon_ids CURSOR IS SELECT DISTINCT osm_id FROM trigger_info_polygon WHERE layers != '{}';
	object_id BIGINT;
    timestamp_max TEXT;
BEGIN
    /* For points */
	SELECT MAX(timestamp) FROM trigger_info_line INTO timestamp_max;
    OPEN point_ids;
	LOOP
		FETCH point_ids INTO object_id;
		EXIT WHEN NOT FOUND;
		EXECUTE setPointAnalysis(object_id, timestamp_max);
	END LOOP;
	CLOSE point_ids;
    /* For lines */
	OPEN line_ids;
	LOOP
		FETCH line_ids INTO object_id;
		EXIT WHEN NOT FOUND;
		EXECUTE setLineAnalysis(object_id, timestamp_max);
	END LOOP;
	CLOSE line_ids;
    /* For polygons */
	OPEN polygon_ids;
	LOOP
		FETCH polygon_ids INTO object_id;
		EXIT WHEN NOT FOUND;
		EXECUTE setpolygonAnalysis(object_id, timestamp_max);
	END LOOP;
	CLOSE polygon_ids;
END
\$BODY\$
  LANGUAGE plpgsql;

-- Get the magOSM'layer, 0 if no layer.
CREATE OR REPLACE FUNCTION getlayerofhstore(tags hstore, osm_id bigint, table_name text)
  RETURNS integer[] AS
\$BODY\$
DECLARE
	layers_of_hstore INTEGER[] = '{}';
	thematics_table CURSOR IS SELECT * FROM dictionnary.thematics;
	thematic dictionnary.thematics;
	b BOOLEAN;
BEGIN
	OPEN thematics_table;
	LOOP
		FETCH thematics_table INTO thematic;
		EXIT WHEN NOT FOUND;
		EXECUTE thematic.changes_request USING tags, osm_id, table_name INTO b; /* Test if the list of tags allows the object to belongs to this thematic */
		IF b THEN
			layers_of_hstore := thematic.id || layers_of_hstore;
		END IF;
	END LOOP;
	CLOSE thematics_table;
	RETURN layers_of_hstore;
END
\$BODY\$
  LANGUAGE plpgsql;
COMMENT ON FUNCTION getLayerOfHstore(hstore, bigint, text) IS 'args: a_tags_hstore, a_osm_id, a_table_name - Return the list of magOSM Layers (from the table dictionnary.thematics), 0 if no.';

CREATE OR REPLACE FUNCTION audit_table()
  RETURNS trigger AS
\$BODY\$
DECLARE
	sql_action TEXT;
	row RECORD;
	row_hstore HSTORE;
	geometry GEOMETRY(Geometry,3857);
	version INTEGER;
	timestamp TEXT;
	layers INTEGER[];
	type TEXT;
BEGIN
	sql_action := TG_OP;
    CASE 
		WHEN sql_action = 'DELETE' THEN row := OLD;
		WHEN sql_action = 'INSERT' THEN row := NEW;
		ELSE row := NULL;
	END CASE;

    CASE
	    WHEN TG_TABLE_NAME LIKE '%point%' THEN type := 'point';
	    WHEN TG_TABLE_NAME LIKE '%line%' THEN type := 'line';
	    ELSE type := 'polygon';
	END CASE;
	
	EXECUTE format('SELECT get%Ihstore(\$1)', type) USING row INTO row_hstore;

	IF (row_hstore != '') THEN
		geometry := row.way;
		version := CAST((row_hstore -> 'osm_version') AS INTEGER);
		timestamp := ''''||(row_hstore -> 'osm_timestamp')::TEXT||'''';
		row_hstore := delete(row_hstore, ARRAY['osm_version', 'osm_timestamp','way']);
	END IF;

	SELECT getLayerOfHstore(row_hstore, row.osm_id, TG_TABLE_NAME) INTO layers;
	
	EXECUTE format('INSERT INTO trigger_info_%I (osm_id, timestamp, version, tags, the_geom, sql_action, layers) VALUES (\$1, \$2, \$3, \$4, \$5, \$6, \$7);',type)
	USING row.osm_id, timestamp, version, row_hstore, geometry, sql_action, layers;

	RETURN row;
END
\$BODY\$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION array_distinct(anyarray)
RETURNS anyarray AS \$\$
  SELECT ARRAY(SELECT DISTINCT unnest(\$1))
\$\$ LANGUAGE sql;

EOF
for type in point line polygon
do
    if [ $type == point ]
        then geometry=Point
    else geometry=Geometry
    fi
    echo -------------- Creating tables and functions for ${type}s
    psql -U ${DBPG_USER_MAGOSM_USERNAME} -d ${DBPG_DATABASE_NAME} << EOF
    DROP TABLE IF EXISTS trigger_info_${type};
    DROP TABLE IF EXISTS changes_analysis_${type};

    CREATE TABLE trigger_info_${type}
    (
        id serial PRIMARY KEY NOT NULL,
        osm_id bigint,
        tags hstore,
        the_geom geometry(${geometry},3857),
        timestamp text,
        sql_action character varying(10),
        version integer,
        layers integer[]
    );

    CREATE INDEX trigger_info_${type}_id ON trigger_info_${type} (osm_id, sql_action);
    CREATE INDEX trigger_info_${type}_geom ON trigger_info_${type} USING GIST (the_geom);

    CREATE TABLE changes_analysis_${type}
    (
        id serial PRIMARY KEY NOT NULL,
        osm_id bigint,
        change_type integer references dictionnary.changes_types(id),
        timestamp TIMESTAMP WITH TIME ZONE,
        version_old integer,
        version_new integer,
        thematic integer references dictionnary.thematics(id),
        the_geom_old geometry(${geometry},3857),
        the_geom_new geometry(${geometry},3857),
        tags_new hstore,
        tags_old hstore
    );

    CREATE INDEX changes_analysis_${type}_the_geom_new ON changes_analysis_${type} USING GIST (the_geom_new);
    CREATE INDEX changes_analysis_${type}_the_geom_old ON changes_analysis_${type} USING GIST (the_geom_old);
    CREATE INDEX changes_analysis_${type}_request ON changes_analysis_${type} (thematic, timestamp);

    CREATE OR REPLACE FUNCTION get${type}hstore(entity planet_osm_${type})
    RETURNS hstore AS
    \$BODY\$
    DECLARE
        h HSTORE := '';
        field_names CURSOR IS SELECT column_name from information_schema.columns where table_name='planet_osm_${type}';
        field_name VARCHAR;
        val VARCHAR;
        tag HSTORE;
    BEGIN	
        OPEN field_names;
        LOOP
            FETCH field_names INTO field_name;
            EXIT WHEN NOT FOUND;
            IF (field_name != 'osm_id' AND field_name !='z_order' AND field_name != 'way_area' AND field_name != 'way') THEN
                IF (field_name != 'tags') THEN
                    val := get${type}RowValue(entity, field_name);
                    IF (LENGTH(val::varchar) != 0) THEN
                        h := h || hstore(field_name,val);
                    END IF;
                ELSE
                    h := h || entity.tags; /* Add the tags which have already been in a hstore */
                END IF;
            END IF;
        END LOOP;
        CLOSE field_names; 
        RETURN h;
    END
    \$BODY\$
    LANGUAGE plpgsql;

    -- apt-get install postgresql-pltcl-9.6
    -- CREATE EXTENSION pltcl;
    -- The use of PLTCL is required to get the entity(field) value, it doesn't work with PLPGSQL
    CREATE OR REPLACE FUNCTION get${type}rowvalue(
        entity planet_osm_${type},
        field character varying)
    RETURNS character varying AS
    \$BODY\$
        set value ""
        catch {set value \$1(\$2)}
        return [quote \$value]
    \$BODY\$
    LANGUAGE pltcl;

    DROP TRIGGER IF EXISTS ${type}_audit ON planet_osm_${type}; 
    CREATE TRIGGER ${type}_audit
    AFTER INSERT OR DELETE
    ON planet_osm_${type}
    FOR EACH ROW
    EXECUTE PROCEDURE audit_table();

    CREATE OR REPLACE FUNCTION set${type}Analysis(object_id BIGINT, timestamp_max TEXT)
    RETURNS void AS
    \$BODY\$
    DECLARE
        insert_record RECORD;
        delete_record RECORD;
        insertB BOOLEAN;
        deleteB BOOLEAN;
        areTagsEqual BOOLEAN;
        areGeomEqual BOOLEAN;
        change_type INTEGER := 0;
        all_layers INTEGER[];
        layer INTEGER;
        -- If there is a 'Suppression', there is no 'Insertion', so we do not have the timestamp of the change. It is the same if the version of the object doesn't change.
        -- We take the youngest timestamp of the table, so we have a precision of 24 hours.
        time TEXT;
    BEGIN
        /* Select all the lift of all entity with the same osm_id */
        SELECT osm_id, tags, st_union(the_geom) as the_geom, timestamp, MAX(version) AS version, layers
                    FROM trigger_info_${type} INTO insert_record
                    WHERE object_id = trigger_info_${type}.osm_id AND sql_action='INSERT'
                    GROUP BY osm_id, tags, timestamp, layers
                    ORDER BY version DESC;
        SELECT osm_id, tags, st_union(the_geom) as the_geom, MIN(timestamp) as timestamp, MIN(version) AS version, layers 
                    FROM trigger_info_${type} INTO delete_record
                    WHERE object_id = trigger_info_${type}.osm_id AND sql_action='DELETE'
                    GROUP BY osm_id, tags, layers
                    ORDER BY timestamp ASC;
        
        insertB := insert_record IS NOT NULL;
        deleteB := delete_record IS NOT NULL;
        IF insertB THEN
            IF deleteB THEN
                all_layers := array_distinct(array_cat(insert_record.layers,delete_record.layers));
            ELSE 
                all_layers := insert_record.layers;
            END IF;
        ELSE
            all_layers := delete_record.layers;
        END IF;
        /* Now we have the list of all thematics(=layers) concerned by this OSM object */
        FOREACH layer IN ARRAY all_layers
        LOOP
            IF NOT(deleteB) THEN
                INSERT INTO changes_analysis_${type}
                (osm_id, change_type, thematic, tags_new, the_geom_new, timestamp, version_new)
                VALUES
                (object_id, 1, layer, insert_record.tags, insert_record.the_geom, insert_record.timestamp::timestamp, insert_record.version);
            ELSIF NOT(insertB) THEN
                INSERT INTO changes_analysis_${type}
                (osm_id, change_type, thematic, tags_old, the_geom_old, timestamp, version_old)
                VALUES
                (object_id, 6, layer, delete_record.tags, delete_record.the_geom, timestamp_max::timestamp, delete_record.version);
            ELSE
                areTagsEqual := delete(insert_record.tags, ARRAY['osm_user','osm_changeset','osm_uid']) = delete(delete_record.tags, ARRAY['osm_user','osm_changeset','osm_uid']) ;
                areGeomEqual := ST_EQUALS(insert_record.the_geom, delete_record.the_geom);
                IF array_position(delete_record.layers, layer) IS NULL THEN
                    change_type := 2;
                ELSIF array_position(insert_record.layers, layer) IS NULL THEN
                    change_type := 5;
                ELSE
                    IF NOT(areTagsEqual) THEN
                        IF NOT(areGeomEqual) THEN
                            change_type := 34;
                        ELSE
                            change_type := 3;
                        END IF;
                    ELSIF NOT(areGeomEqual) THEN 
                        change_type := 4;
                    ELSIF insert_record.version != delete_record.version THEN
                        change_type := 7;
                    END IF;
                END IF;
                IF change_type > 0 THEN
                    IF delete_record.version = insert_record.version THEN
                        time = timestamp_max;
                    ELSE
                        time := insert_record.timestamp;
                    END IF; 
                    INSERT INTO changes_analysis_${type}
                        (osm_id, change_type, thematic, tags_new, tags_old, the_geom_new, the_geom_old, timestamp, version_new, version_old)
                        VALUES
                        (object_id, change_type, layer, insert_record.tags, delete_record.tags, insert_record.the_geom, delete_record.the_geom, time::timestamp, insert_record.version, delete_record.version);
                END IF;
            END IF;
        END LOOP;
    END
    \$BODY\$
        LANGUAGE plpgsql;
EOF
done
ELAPSED=$(($SECONDS-$BEFORE))
echo ---------
echo Initialisation successful in $ELAPSED seconds
echo ---------