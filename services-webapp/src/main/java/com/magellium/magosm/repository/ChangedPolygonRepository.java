package com.magellium.magosm.repository;

import java.math.BigInteger;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.magellium.magosm.model.ChangedPolygon;
import com.magellium.magosm.model.ChangedPolygonSummary;
import com.magellium.magosm.model.Thematic;

public interface ChangedPolygonRepository extends JpaRepository<ChangedPolygon, Integer>, CrudRepository<ChangedPolygon, Integer>{
	List<ChangedPolygon> findByThematic(Optional<Thematic> thematic);
	
	@Query(value = "select p from ChangedPolygon p where p.thematic.id = :thematic "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And (st_intersects(p.theGeomNew, ST_GeomFromText(:bbox,3857)) = TRUE OR st_intersects(p.theGeomOld, ST_GeomFromText(:bbox,3857)) = TRUE)")
	List<ChangedPolygonSummary> findByThematicByPeriodByBbox(@Param("thematic") Integer thematic, @Param("date1") Date date1, @Param("date2") Date date2, @Param("bbox") String bbox);
	
	@Query(value = "select p from ChangedPolygon p where p.osmId = :osm_id "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And p.thematic.id = :thematic")
	List<ChangedPolygon> findByOsmIdByPeriod(@Param("osm_id") BigInteger osm_id, @Param("date1") Date date1, @Param("date2") Date date2, @Param("thematic") Integer thematic);

	
	ChangedPolygon findFirstByOrderByTimestampDesc();
}
