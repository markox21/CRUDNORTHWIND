<?php
require '../../models/productModel.php';

class ProductController {
    public function showProducts() {
        $productModel = new ProductModel();
        $products = $productModel->getProducts();

        return $products;
    }
    
}


// $controller = new ProductController(new ProductModel());
// $products = $controller->showProducts();