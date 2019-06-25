package fr.magellium.magosm;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin
public class MagosmController {

	
	@GetMapping(value="/hello")
	public String hello() {
		
		return "test 2";
	}
}
