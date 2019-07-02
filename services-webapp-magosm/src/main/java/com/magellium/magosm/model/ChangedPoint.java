package com.magellium.magosm.model;

import javax.persistence.*;

import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.vividsolutions.jts.geom.Geometry;
import com.vladmihalcea.hibernate.type.basic.PostgreSQLHStoreType;

import com.magellium.magosm.model.Thematic;

/**
 * The persistent class for the ChangedPoint database table.
 * 
 */

@Entity
@Table(name = "mp_changes_analysis_point", schema = Parameters.MAGOSM_DATA_SCHEMA)
@TypeDef(name = "hstore", typeClass = PostgreSQLHStoreType.class)
@NamedQuery(name = "ChangedPoint.findAll", query = "SELECT p FROM ChangedPoint p")
public class ChangedPoint {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "osm_id")
	private BigInteger osm_id;
	
	@Column(name = "change_type")
	private Integer change_type;
	
	@Column(name = "timestamp")
	private String timestamp;
	
	@Column(name = "version_old")
	private Integer version_old;
	
	@Column(name = "version_new")
	private Integer version_new;
	
	@JsonIgnore
	@ManyToOne(fetch=FetchType.EAGER)
	@JoinColumn(name="layer_old")
	private Thematic layer_old;
	
	@JsonIgnore
	@ManyToOne(fetch=FetchType.EAGER)
	@JoinColumn(name="layer_new")
	private Thematic layer_new;
	
	@Column(name = "the_geom_old")
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	private Geometry the_geom_old;
	
	@Column(name = "the_geom_new")
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	private Geometry the_geom_new;

	@Type(type = "hstore")
	@Column(name = "tags_old")
	private Map<String, String> tags_old = new HashMap<>();
	
	@Type(type = "hstore")
	@Column(name = "tags_new")
	private Map<String, String> tags_new = new HashMap<>();
	
	public Integer getId() {
		return this.id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public BigInteger getOsm_id() {
		return osm_id;
	}

	public void setOsm_id(BigInteger osm_id) {
		this.osm_id = osm_id;
	}

	public Integer getChange_type() {
		return change_type;
	}

	public void setChange_type(Integer change_type) {
		this.change_type = change_type;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public Integer getVersion_old() {
		return version_old;
	}

	public void setVersion_old(Integer version_old) {
		this.version_old = version_old;
	}

	public Integer getVersion_new() {
		return version_new;
	}

	public void setVersion_new(Integer version_new) {
		this.version_new = version_new;
	}

	public Thematic getLayer_old() {
		return layer_old;
	}

	public void setLayer_old(Thematic layer_old) {
		this.layer_old = layer_old;
	}

	public Thematic getLayer_new() {
		return layer_new;
	}

	public void setLayer_new(Thematic layer_new) {
		this.layer_new = layer_new;
	}

	public Geometry getThe_geom_old() {
		return the_geom_old;
	}

	public void setThe_geom_old(Geometry the_geom_old) {
		this.the_geom_old = the_geom_old;
	}

	public Geometry getThe_geom_new() {
		return the_geom_new;
	}

	public void setThe_geom_new(Geometry the_geom_new) {
		this.the_geom_new = the_geom_new;
	}

	public Map<String, String> getTags_new() {
		return tags_new;
	}

	public void setTags_new(Map<String, String> tags_new) {
		this.tags_new = tags_new;
	}

	public Map<String, String> getTags_old() {
		return tags_old;
	}

	public void setTags_old(Map<String, String> tags_old) {
		this.tags_old = tags_old;
	}

}

