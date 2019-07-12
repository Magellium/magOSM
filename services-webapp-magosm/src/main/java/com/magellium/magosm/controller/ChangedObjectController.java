package com.magellium.magosm.controller;

import java.util.List;
import java.util.Optional;
import java.util.jar.JarException;

import javax.security.auth.callback.UnsupportedCallbackException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.magellium.magosm.model.ChangedLine;
import com.magellium.magosm.model.ChangedObject;
import com.magellium.magosm.model.ChangedPoint;
import com.magellium.magosm.model.ChangedPolygon;
import com.magellium.magosm.model.ChangesRequest;
import com.magellium.magosm.model.Thematic;
import com.magellium.magosm.repository.ChangedLineRepository;
import com.magellium.magosm.repository.ChangedPointRepository;
import com.magellium.magosm.repository.ChangedPolygonRepository;
import com.magellium.magosm.repository.ThematicRepository;

@RestController
@CrossOrigin
public class ChangedObjectController {
	
	private final Logger log = LogManager.getLogger(ChangedObjectController.class);

//	@Autowired
//	private ChangedObjectRepository changedObjectRepository;
	
	@Autowired
	private ChangedPolygonRepository changedPolygonRepository;
	@Autowired
	private ChangedPointRepository changedPointRepository;
	@Autowired
	private ChangedLineRepository changedLineRepository;
	@Autowired
	private ThematicRepository thematicRepository;

	@GetMapping(value="/changedobjects/{id}", produces = "application/json")
	public @ResponseBody List<ChangedObject> getAllChangedObjectsByThematic(@PathVariable Integer id){
		Optional<Thematic> thematic = thematicRepository.findById(id);
		List<ChangedPoint> points = changedPointRepository.findByThematic(thematic);
		List<ChangedPolygon> polygons = changedPolygonRepository.findByThematic(thematic);
		List<ChangedLine> lines = changedLineRepository.findByThematic(thematic);

		List<ChangedObject> objets = ChangedObject.test(points);
		List<ChangedObject> objetsPolygon = ChangedObject.test(polygons);
		List<ChangedObject> objetsLine = ChangedObject.test(lines);
		objets.addAll(objetsPolygon);
		objets.addAll(objetsLine);
		log.info("Tous les changements points+polygons+lines sont affichés avec du détail.");
		return objets;	
	}
	
	@PostMapping(path="/changesrequest", consumes = "application/json", produces = "application/json")
	public @ResponseBody List<ChangedObject> getAllChangedObjectsByThematicByBboxByPeriod(@RequestBody ChangesRequest changesRequest) throws JarException, UnsupportedCallbackException{
		log.info("Thematic id : " + changesRequest.getThematic());
		log.info("Date : " + changesRequest.getBeginDate());
		log.info("Date : " + changesRequest.getEndDate());
		log.info("Box : " + changesRequest.getBbox());
		List<ChangedPoint> points = changedPointRepository.findByThematicByPeriodByBbox(changesRequest.getThematic(), changesRequest.getBeginDate(), changesRequest.getEndDate(), changesRequest.getBbox());
		List<ChangedPolygon> polygons = changedPolygonRepository.findByThematicByPeriodByBbox(changesRequest.getThematic(), changesRequest.getBeginDate(), changesRequest.getEndDate(), changesRequest.getBbox());
		List<ChangedLine> lines = changedLineRepository.findByThematicByPeriodByBbox(changesRequest.getThematic(), changesRequest.getBeginDate(), changesRequest.getEndDate(), changesRequest.getBbox());
		List<ChangedObject> objets = ChangedObject.test(points);
		List<ChangedObject> objetsPolygon = ChangedObject.test(polygons);
		List<ChangedObject> objetsLine = ChangedObject.test(lines);
		objets.addAll(objetsPolygon);
		objets.addAll(objetsLine);
		log.info(objets.size() + " changements points+polygons+lines sur une période et une thématique sont affichés avec du détail.");
		return objets;
		}
}
