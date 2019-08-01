package com.magellium.magosm.model;

import java.util.List;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**
 * The persistent class for the Views database table.
 * 
 */

@Entity
@Table(name = "thematics", schema = Parameters.MAGOSM_DICTIONNARY_SCHEMA)
@NamedQuery(name = "Thematic.findAll", query = "SELECT t FROM Thematic t")
public class Thematic {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "name", unique=true)
	private String name;
	
	@Column(name = "view_name")
	private String viewName;
	
	@JsonIgnore
	@Column(name = "osm2pgsql_request")
	private String osm2pgsql_request;
	
	@JsonIgnore
	@Column(name = "changes_request")
	private String changes_request;
	
	public ThematicCategory getCategory() {
		return category;
	}

	public void setCategory(ThematicCategory category) {
		this.category = category;
	}

	@ManyToOne(fetch=FetchType.EAGER)
	@JoinColumn(name="id_category")
	private ThematicCategory category;
	
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

	public String getViewName() {
		return viewName;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public String getOsm2pgsql_request() {
		return osm2pgsql_request;
	}

	public void setOsm2pgsql_request(String osm2pgsql_request) {
		this.osm2pgsql_request = osm2pgsql_request;
	}

	public String getChanges_request() {
		return changes_request;
	}

	public void setChanges_request(String changes_request) {
		this.changes_request = changes_request;
	}
	

}
