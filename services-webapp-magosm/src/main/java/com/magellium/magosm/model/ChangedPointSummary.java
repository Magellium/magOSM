package com.magellium.magosm.model;

import java.math.BigInteger;

public interface ChangedPointSummary {
	BigInteger getOsmId();
	Integer getChangeType();
	Integer getId();
}
