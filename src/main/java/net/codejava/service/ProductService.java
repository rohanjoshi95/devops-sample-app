package net.codejava.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.codejava.dao.ProductRepository;
import net.codejava.model.Product;

@Service
@Transactional
public class ProductService {

	@Autowired
	private ProductRepository repo;
	
	public List<Product> listAll() {
		return repo.findAll();
	}
	
	public void save(Product product) {
		repo.save(product);
	}
	
	public Product get(long id) {
		Product product = new Product();
		Optional<Product> productList= repo.findById(id);
		if (productList.isPresent()) {
			product = productList.get();
		}
		return product;
	}
	
	public void delete(long id) {
		repo.deleteById(id);
	}
}
