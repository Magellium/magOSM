package com.magellium.magosm.repository;

import java.math.BigInteger;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.magellium.magosm.model.ChangedLine;
import com.magellium.magosm.model.Thematic;

@Repository
public interface ChangedLineRepository extends JpaRepository<ChangedLine, Integer>, CrudRepository<ChangedLine, Integer>{
	List<ChangedLine> findByThematic(Optional<Thematic> thematic);
	
	@Query(value = "select p from ChangedLine p where p.thematic.id = :thematic "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And (st_intersects(p.theGeomNew, ST_GeomFromText(:bbox,3857)) = TRUE OR st_intersects(p.theGeomOld, ST_GeomFromText(:bbox,3857)) = TRUE)")
	List<ChangedLine> findByThematicByPeriodByBbox(@Param("thematic") Integer thematic, @Param("date1") Date date1, @Param("date2") Date date2, @Param("bbox") String bbox);
	
	@Query(value = "select p from ChangedLine p where p.osmId = :osm_id "
			+ "And p.timestamp > :date1 "
			+ "And p.timestamp < :date2 "
			+ "And p.thematic.id = :thematic")
	List<ChangedLine> findByOsmIdByPeriod(@Param("osm_id") BigInteger osm_id, @Param("date1") Date date1, @Param("date2") Date date2, @Param("thematic") Integer thematic);

}
