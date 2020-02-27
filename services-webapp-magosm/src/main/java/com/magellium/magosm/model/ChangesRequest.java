package com.magellium.magosm.model;

import java.sql.Date;
import java.util.Calendar;

import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.vividsolutions.jts.geom.Geometry;

public class ChangesRequest {
	
	private Integer thematic;
	
	private Date beginDate;
	
	private Date endDate;
	
//	@JsonSerialize(using = GeometrySerializer.class)
//	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
//	private Geometry bbox;
	
	private String bbox;
	
	public String getBbox() {
		return bbox;
	}

	public void setBbox(String bbox) {
		this.bbox = bbox;
	}

	//Getters and Setters
	public Integer getThematic() {
		return thematic;
	}

	public void setThematic(Integer thematic) {
		this.thematic = thematic;
	}


	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

//	public Geometry getBbox() {
//		return bbox;
//	}
//
//	public void setBbox(Geometry bbox) {
//		this.bbox = bbox;
//	}

}
