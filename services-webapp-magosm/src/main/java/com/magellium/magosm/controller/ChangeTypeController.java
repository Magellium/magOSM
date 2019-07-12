package com.magellium.magosm.controller;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.magellium.magosm.model.ChangeType;
import com.magellium.magosm.repository.ChangeTypeRepository;

@RestController
@CrossOrigin
public class ChangeTypeController {

	private final Logger log = LogManager.getLogger(ChangeTypeController.class);
	
	@Autowired
	private ChangeTypeRepository changeTypeRepository;
	
	@GetMapping(value="/change_types", produces = "application/json")
	public @ResponseBody List<ChangeType> getAllChangeTypes(){
		log.info("Toutes les types de changements sont affichées.");
		return changeTypeRepository.findAll();			
	}
}
