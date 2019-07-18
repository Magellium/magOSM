package com.magellium.magosm.repository;

import java.math.BigInteger;
import java.sql.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.magellium.magosm.model.ChangedPoint;
import com.magellium.magosm.model.ChangedPointSummary;
import com.magellium.magosm.model.Thematic;

@Repository
public interface ChangedPointRepository extends JpaRepository<ChangedPoint, UUID>, CrudRepository<ChangedPoint, UUID> {
	List<ChangedPoint> findByThematic(Optional<Thematic> thematic);
	
	@Query(value = "select p from ChangedPoint p where p.thematic.id = :thematic "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And (st_intersects(p.theGeomNew, ST_GeomFromText(:bbox,3857)) = TRUE OR st_intersects(p.theGeomOld, ST_GeomFromText(:bbox,3857)) = TRUE)")
	List<ChangedPoint> findByThematicByPeriodByBbox(@Param("thematic") Integer thematic, @Param("date1") Date date1, @Param("date2") Date date2, @Param("bbox") String bbox);
	
	@Query(value = "select p from ChangedPoint p where p.osmId = :osm_id "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And p.thematic.id = :thematic")
	List<ChangedPoint> findByOsmIdByPeriod(@Param("osm_id") BigInteger osm_id, @Param("date1") Date date1, @Param("date2") Date date2, @Param("thematic") Integer thematic);
	
	List<ChangedPointSummary> findByOsmId(BigInteger osm_id);
}
