package net.codejava.service;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.ui.Model;

import net.codejava.controller.AppController;
import net.codejava.model.Product;

@RunWith(SpringRunner.class)
public class AppControllerTest {
	
	@InjectMocks
	private AppController appController;
	
	@Mock
	private ProductService service;
	
	@Mock
	Model model;
	
	@Test
	public void viewHomePageTest(){
		Product product = new Product();
		product.setBrand("Moto");
		List<Product> productList = new ArrayList<Product>();
		productList.add(product);
		when(model.addAllAttributes(productList)).thenReturn(model);
		assertEquals("index",appController.viewHomePage(model));
	}

}
