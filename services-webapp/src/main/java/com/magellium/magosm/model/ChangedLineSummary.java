package com.magellium.magosm.model;

import java.math.BigInteger;
import java.sql.Timestamp;

import com.bedatadriven.jackson.datatype.jts.serialization.GeometryDeserializer;
import com.bedatadriven.jackson.datatype.jts.serialization.GeometrySerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.vividsolutions.jts.geom.Geometry;

public interface ChangedLineSummary extends ChangedObject {
	BigInteger getOsmId();
	Integer getChangeType();
	Timestamp getTimestamp();
	
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	Geometry getTheGeomNew();
	
	@JsonSerialize(using = GeometrySerializer.class)
	@JsonDeserialize(contentUsing = GeometryDeserializer.class)
	Geometry getTheGeomOld();
	
	String getType();

}
