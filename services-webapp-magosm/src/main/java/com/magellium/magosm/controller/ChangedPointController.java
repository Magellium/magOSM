package com.magellium.magosm.controller;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.magellium.magosm.model.ChangedPoint;
import com.magellium.magosm.repository.ChangedPointRepository;

@RestController
@CrossOrigin
public class ChangedPointController {

	private final Logger log = LogManager.getLogger(ChangedPointController.class);

	@Autowired
	private ChangedPointRepository changedPointDetailledRepository;

	@GetMapping(value="/changedpointsdetailled", produces = "application/json")
	public @ResponseBody List<ChangedPoint> getAllChangedPointDetailled(){
		log.info("Tous les changements de points sont affichés avec du détail.");
		return changedPointDetailledRepository.findAll();			
	}
}
