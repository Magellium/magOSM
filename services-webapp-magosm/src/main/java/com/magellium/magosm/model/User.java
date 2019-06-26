package com.magellium.magosm.model;

import javax.persistence.*;

/**
 * The persistent class for the User database table.
 * 
 */

@Entity
@Table(name = "user", schema = Parameters.MAIN_APPLICATION_SCHEMA)
@NamedQuery(name = "User.findAll", query = "SELECT u FROM User u")
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "username", unique=true)
	private String username;

}
