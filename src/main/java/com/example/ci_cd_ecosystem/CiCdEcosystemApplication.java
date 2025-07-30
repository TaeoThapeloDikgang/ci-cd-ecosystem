package com.example.ci_cd_ecosystem;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class CiCdEcosystemApplication {

	String appTag = System.getenv("APP_TAG");

	public static void main(String[] args) {
		SpringApplication.run(CiCdEcosystemApplication.class, args);
	}

	@GetMapping("/")
	public String home() {
		return "Hello from Java CI/CD App! " + appTag + " version";
	}
}
