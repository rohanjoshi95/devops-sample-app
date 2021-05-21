/*package net.codejava.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.ui.Model;

import net.codejava.controller.AppController;

@RunWith(SpringRunner.class)
public class TntegrationTest {
	
	@InjectMocks
	private AppController appController;

	@Mock
	private ProductService service;

	@Mock
	Model model;

	@Test
	public void viewHomePageIntegrationTest() {
		ChromeOptions option = new ChromeOptions();
		option.addArguments("--headless");
		option.addArguments("--no-sandbox");
		option.addArguments("--disable-dev-shm-usage");
		System.setProperty("webdriver.chrome.driver","/usr/bin/chromedriver");
		WebDriver driver = new ChromeDriver();
		driver.get("http://localhost:8081");
		
	}


}*/
