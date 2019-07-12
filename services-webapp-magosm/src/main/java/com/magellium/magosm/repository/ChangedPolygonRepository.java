package com.magellium.magosm.repository;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.magellium.magosm.model.ChangedPolygon;
import com.magellium.magosm.model.Thematic;

public interface ChangedPolygonRepository extends JpaRepository<ChangedPolygon, Integer>, CrudRepository<ChangedPolygon, Integer>{
	List<ChangedPolygon> findByThematic(Optional<Thematic> thematic);
	
	@Query(value = "select p from ChangedPolygon p where p.thematic.id = :thematic "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And (st_intersects(p.the_geom_new, ST_GeomFromText(:bbox,3857)) = TRUE OR st_intersects(p.the_geom_old, ST_GeomFromText(:bbox,3857)) = TRUE)")
	List<ChangedPolygon> findByThematicByPeriodByBbox(@Param("thematic") Integer thematic, @Param("date1") Date date1, @Param("date2") Date date2, @Param("bbox") String bbox);

}
