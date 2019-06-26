package com.magellium.magosm.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import com.magellium.magosm.model.User;

public interface UserRepository extends JpaRepository<User, Integer>, CrudRepository<User, Integer> {

}
