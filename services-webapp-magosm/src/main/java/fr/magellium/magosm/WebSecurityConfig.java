package fr.magellium.magosm;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	

	@Override
	protected void configure(HttpSecurity http) throws Exception {

		/*
		 * .disable() .exceptionHandling() .authenticationEntryPoint(new
		 * Http403ForbiddenEntryPoint() { })
		 */

	
			http.csrf().disable().authorizeRequests()
			.anyRequest().permitAll().and().formLogin();
		
	}

	
}
