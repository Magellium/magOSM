package com.magellium.magosm.model;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.vividsolutions.jts.geom.Geometry;
import com.vladmihalcea.hibernate.type.basic.PostgreSQLHStoreType;

@Entity
@Table(name = "changes_analysis_line", schema = Parameters.MAGOSM_DATA_SCHEMA)
@TypeDef(name = "hstore", typeClass = PostgreSQLHStoreType.class)
@NamedQuery(name = "ChangedLine.findAll", query = "SELECT l FROM ChangedLine l")
public class ChangedLine implements ChangedObject {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private Integer id;
	
	@Column(name = "osm_id")
	private BigInteger osmId;
	
	@Column(name = "change_type")
	private Integer changeType;
	
	@Column(name = "timestamp")
	private Timestamp timestamp;
	
	@JsonIgnore
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="thematic")
	private Thematic thematic;
	
	@Column(name = "the_geom_old")
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	private Geometry theGeomOld;
	
	@Column(name = "the_geom_new")
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	private Geometry theGeomNew;

	@Column(name = "version_old")
	private Integer versionOld;
	
	@Column(name = "version_new")
	private Integer versionNew;
	
	@Type(type = "hstore")
	@Column(name = "tags_old")
	private Map<String, String> tagsOld = new HashMap<>();
	
	@Type(type = "hstore")
	@Column(name = "tags_new")
	private Map<String, String> tagsNew = new HashMap<>();
	
	private final static String type = "Line";
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public BigInteger getOsmId() {
		return osmId;
	}

	public void setOsmId(BigInteger osmId) {
		this.osmId = osmId;
	}

	public Integer getChangeType() {
		return changeType;
	}

	public void setChangeType(Integer changeType) {
		this.changeType = changeType;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Timestamp timestamp) {
		this.timestamp = timestamp;
	}

	public Thematic getThematic() {
		return thematic;
	}

	public void setThematic(Thematic thematic) {
		this.thematic = thematic;
	}

	public Geometry getTheGeomOld() {
		return theGeomOld;
	}

	public void setTheGeomOld(Geometry theGeomOld) {
		this.theGeomOld = theGeomOld;
	}

	public Geometry getTheGeomNew() {
		return theGeomNew;
	}

	public void setTheGeomNew(Geometry theGeomNew) {
		this.theGeomNew = theGeomNew;
	}

	public Integer getVersionOld() {
		return versionOld;
	}

	public void setVersionOld(Integer versionOld) {
		this.versionOld = versionOld;
	}

	public Integer getVersionNew() {
		return versionNew;
	}

	public void setVersionNew(Integer versionNew) {
		this.versionNew = versionNew;
	}

	public Map<String, String> getTagsOld() {
		return tagsOld;
	}

	public void setTagsOld(Map<String, String> tagsOld) {
		this.tagsOld = tagsOld;
	}

	public Map<String, String> getTagsNew() {
		return tagsNew;
	}

	public void setTagsNew(Map<String, String> tagsNew) {
		this.tagsNew = tagsNew;
	}

	@Override
	public String getType() {
		return "Line";
	}

}