package com.magellium.magosm.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;


import com.magellium.magosm.model.Thematic;

@Repository
public interface ThematicRepository extends JpaRepository<Thematic, Integer>, CrudRepository<Thematic, Integer> {

}
