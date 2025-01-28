package com.magellium.magosm.model;


import java.util.HashMap;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.hibernate.annotations.Type;


@Entity
@Table(name = "changes_types", schema = Parameters.MAGOSM_DICTIONNARY_SCHEMA)
@NamedQuery(name = "ChangeType.findAll", query = "SELECT t FROM ChangeType t ORDER BY name")
public class ChangeType {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Integer id;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "short_name")
	private String short_name;
	
	@Column(name = "label")
	private String label;
	
	@Column(name = "ref")
	private String ref;

	@Type(type = "hstore")
	@Column(name = "color")
	private Map<String, String> color = new HashMap<>();

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getShort_name() {
		return short_name;
	}

	public void setShort_name(String short_name) {
		this.short_name = short_name;
	}

	
	public String getRef() {
		return ref;
	}

	public void setRef(String ref) {
		this.ref = ref;
	}

	public Map<String, String> getColor() {
		return color;
	}

	public void setColor(Map<String, String> color) {
		this.color = color;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}
	
	

}
