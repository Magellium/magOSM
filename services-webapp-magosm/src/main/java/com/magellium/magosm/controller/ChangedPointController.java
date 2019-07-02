package com.magellium.magosm.controller;

import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;


import com.magellium.magosm.model.ChangedPoint;
import com.magellium.magosm.repository.ChangedPointRepository;

@RestController
@CrossOrigin
public class ChangedPointController {

	private final Logger log = LogManager.getLogger(ChangedPointController.class);

	@Autowired
	private ChangedPointRepository changedPointRepository;

	@GetMapping(value="/changedpoints", produces = "application/json")
	public @ResponseBody List<ChangedPoint> getAllChangedPoint(){
		log.info("Toutes les changements de points sont affichés.");
		List<ChangedPoint> test = changedPointRepository.findAll();
		System.out.println(test);
		return changedPointRepository.findAll();			
	}
	
	@GetMapping(value = "/changedpoints/{id}", produces = "application/json")
	public @ResponseBody Optional<ChangedPoint> getChangedPoint(@PathVariable Integer id){
		if(!changedPointRepository.existsById(id)) {
			log.error("L'id de changement n'existe pas");
			throw new IllegalArgumentException("L'id de changement n'existe pas");
		}
		log.info("Le changement avec l'identifiant "+ id+" est bien affiché.");
		return changedPointRepository.findById(id);		
	}
	
}
