package com.magellium.magosm.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.MappedSuperclass;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.magellium.magosm.controller.ChangedObjectController;


@MappedSuperclass
public interface ChangedObject {
		
	public String getType();

	
	public static List<ChangedObject> getObjectsListFromList(List<?> list){
		Logger log = LogManager.getLogger(ChangedObject.class);
		List<ChangedObject> objets = new ArrayList<ChangedObject>();
		for (int i=0; i<list.size() ;i++) {
			ChangedObject objet = null;
			objet = (ChangedObject)list.get(i);
			objets.add(objet);	
		}
		return objets;
	}

}
