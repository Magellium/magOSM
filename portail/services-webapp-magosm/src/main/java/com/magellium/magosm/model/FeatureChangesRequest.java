package com.magellium.magosm.model;

import java.math.BigInteger;
import java.sql.Date;

public class FeatureChangesRequest {
	private Date beginDate;
	
	private Date endDate;
	
	private BigInteger osm_id;
	
	private String type;
	
	private Integer thematic;

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

	public BigInteger getOsm_id() {
		return osm_id;
	}

	public void setOsm_id(BigInteger osm_id) {
		this.osm_id = osm_id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	} 
	
}
