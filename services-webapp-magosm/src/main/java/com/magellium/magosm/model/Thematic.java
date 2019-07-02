package com.magellium.magosm.model;

import java.util.List;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * The persistent class for the Views database table.
 * 
 */

@Entity
@Table(name = "views", schema = Parameters.MAGOSM_DATA_SCHEMA)
@NamedQuery(name = "Thematic.findAll", query = "SELECT t FROM Thematic t")
public class Thematic {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "name", unique=true)
	private String name;
	
	@Column(name = "osm2pgsql_request")
	private String osm2pgsql_request;
	
	@Column(name = "changes_request")
	private String changes_request;



	/*
	 * @OneToMany(mappedBy = "layer_old", cascade = CascadeType.ALL)
	 * private List<ChangedPoint> points;
	 */
	
	public Integer getId() {
		return this.id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getChangesRequest() {
		return this.changes_request;
	}
	
	public void setChangesRequest(String changes_request) {
		this.changes_request = changes_request;
	}
	
	
	
}
