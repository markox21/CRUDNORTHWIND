<?php
require '../models/productModel.php';

class ProductController {
    private $productModel;
    
    public function __construct($productModel) {
        $this->productModel = $productModel;
    }

    public function showProducts() {
        $productModel = new ProductModel();
        $products = $productModel->getProducts();

        return $products;

        require '../views/productosView.php';
    }

}


// $controller = new ProductController(new ProductModel());
// $products = $controller->showProducts();