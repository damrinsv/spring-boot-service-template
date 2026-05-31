package org.damrin.springbootservicetemplate;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class SpringBootServiceTemplate {
    public static void main(String[] args) {
        SpringApplication.run(SpringBootServiceTemplate.class, args);
    }

}