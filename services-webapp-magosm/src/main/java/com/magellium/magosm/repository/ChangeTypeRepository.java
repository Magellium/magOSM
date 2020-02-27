package com.magellium.magosm.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.magellium.magosm.model.ChangeType;

@Repository
public interface ChangeTypeRepository extends JpaRepository<ChangeType, Integer>, CrudRepository<ChangeType, Integer>{

}
