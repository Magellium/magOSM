package com.magellium.magosm.controller;

import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PathVariable;

import com.magellium.magosm.model.Thematic;
import com.magellium.magosm.repository.ThematicRepository;
import com.magellium.magosm.model.ChangedPoint;
import com.magellium.magosm.repository.ChangedPointRepository;

@RestController
@CrossOrigin
public class ThematicController {
	
	private final Logger log = LogManager.getLogger(ThematicController.class);

	@Autowired
	private ThematicRepository thematicRepository;
	
	@Autowired
	private ChangedPointRepository changedPointRepository;

	@GetMapping(value="/thematics", produces = "application/json")
	public @ResponseBody List<Thematic> getAllThematics(){
		log.info("Toutes les thématiques sont affichées.");
		return thematicRepository.findAll();			
	}
	
	@GetMapping(value = "/thematics/{id}", produces = "application/json")
	public @ResponseBody Optional<Thematic> getThematic(@PathVariable Integer id){
		if(!thematicRepository.existsById(id)) {
			log.error("L'id de thematic n'existe pas");
			throw new IllegalArgumentException("L'id de thematic n'existe pas");
		}
		log.info("La thématique avec l'identifiant "+ id+" est bien affichée.");
		return thematicRepository.findById(id);		
	}
	
	@GetMapping(value = "/thematics/{id}/points", produces = "application/json")
	public @ResponseBody List<ChangedPoint> getAllPointsFromThematic(@PathVariable Integer id){
		if(!thematicRepository.existsById(id)) {
			log.error("L'id de thematic n'existe pas");
			throw new IllegalArgumentException("L'id de thematic n'existe pas : "+id);
		}
		log.info("Les points liés à la thématique avec l'id " + id+ " sont bien affichés.");
		return changedPointRepository.findByThematic(id);
	}
	
	/*
	 * @GetMapping(value = "/thematics/{id}/points") public String
	 * coucou(@PathVariable Integer id){ if(!thematicRepository.existsById(id)) {
	 * log.error("L'id de thematic n'existe pas"); throw new
	 * IllegalArgumentException("L'id de thematic n'existe pas"); }
	 * log.info("Les points liés à la thématique avec l'id " + id+
	 * " sont bien affichés."); return "test"; }
	 */
	
}
