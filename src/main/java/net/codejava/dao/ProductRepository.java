package net.codejava.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import net.codejava.model.Product;

public interface ProductRepository extends JpaRepository<Product, Long> {

}
