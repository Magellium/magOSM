
 -----------------------------------
 -- fonction hstore_prefix_filter --
 -----------------------------------
 -- permet de filtrer les tags utilisant un préfixe type "construction:key=value" (logique lifecycle prefix) et d'en renvoyer seulement la clé et la valeur 
 -- ATTENTION pour l'utilisation de la fonction bien penser aux '' autours du préfixe filtrant, EX: SELECT osm_id, (hstore_prefix_filter(tags, 'proposed')).* FROM...

CREATE OR REPLACE FUNCTION hstore_prefix_filter(tags HSTORE, prefix TEXT, OUT prefix_key TEXT, OUT prefix_value TEXT) AS $$
	BEGIN 	
		SELECT key, value INTO prefix_key, prefix_value 
			FROM each(tags) --fonction 'each' renvoye chaque |key|value| d'un hstrore dans deux colonnes distinctes

		WHERE ((key LIKE CONCAT('%',prefix,'_%') OR key LIKE CONCAT('%',prefix,':%')) AND key NOT LIKE CONCAT('%:',prefix,'%')) 
		-- prends en compte les formes prefix_* OU prefix:* mais pas les *:prefix 
				OR value LIKE CONCAT('%en_',prefix,'%');
				-- prends en compte les objets contenant 'en_construction' dans leur valeur, i.e. ceux où key=note/fixme/descriptions
		
		prefix_key = REPLACE(REPLACE(REPLACE(prefix_key,  (CONCAT(prefix,'_')), ''::text), (CONCAT(prefix,':')), ''::text), prefix, ''::text); 
		-- supprirme le prefix en sortie pour n'afficher que la clé/ la valeur 
	END; 
$$ LANGUAGE plpgsql;