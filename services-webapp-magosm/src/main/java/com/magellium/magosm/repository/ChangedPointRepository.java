package com.magellium.magosm.repository;

import java.math.BigInteger;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.magellium.magosm.model.ChangedPoint;

@Repository
public interface ChangedPointRepository extends JpaRepository<ChangedPoint, Integer>, CrudRepository<ChangedPoint, Integer> {
	
	@Query("SELECT p from ChangedPoint p WHERE p.layer_old.id = :layer OR p.layer_new.id = :layer")
	List<ChangedPoint> findByThematic(@Param("layer") Integer layer);
	
	//@Query("SELECT p FROM ChangedPoint p WHERE (p.layer_old.id = :layer OR p.layer_new.id = :layer) AND p.osm_id = : osm_id")
	//List<ChangedPoint> findChangeByOsmIdByThematic(@Param("layer") Integer layer, @Param("osm_id") BigInteger osm_id);

}