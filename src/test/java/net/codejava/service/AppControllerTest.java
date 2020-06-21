package net.codejava.service;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

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
	public void viewHomePageTest() {
		Product product = new Product();
		product.setBrand("Moto");
		List<Product> productList = new ArrayList<Product>();
		productList.add(product);
		when(model.addAllAttributes(productList)).thenReturn(model);
		assertEquals("index", appController.viewHomePage(model));
	}

	@Test
	public void showNewProductPageTest() {
		Product product = new Product();
		product.setBrand("Samsung");
		product.setName("Mobile");
		model.addAttribute("product", product);
		assertEquals("new_product", appController.showNewProductPage(model));
	}

	@Test
	public void saveProductTest() {
		Product product = new Product();
		product.setBrand("Samsung");
		product.setName("Mobile");
		doNothing().when(service).save(product);
		assertEquals("redirect:/", appController.saveProduct(product));
	}

	@Test
	public void showEditProductPageTest() {
		int id = 2;
		ModelAndView mav = new ModelAndView("edit_product");
		Product product = new Product();
		product.setId(2L);
		product.setBrand("Samsung");
		product.setName("Mobile");
		when(service.get(id)).thenReturn(product);
		mav.addObject("product", product);
		assertEquals(mav.getView(), appController.showEditProductPage(id).getView());
	}

	@Test
	public void deleteProduct() {
		int id = 2;
		doNothing().when(service).delete(id);
		assertEquals("redirect:/", appController.deleteProduct(id));
	}

}
