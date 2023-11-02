<?php
require ("../../models/productModel.php");

##insert products 
    if ($_POST) {
        $productName = $_POST['productName'];
        $companyName = $_POST['companyName'];
        $categoryName = $_POST['categoryName'];
        $quantityPerUnit = $_POST['quantityPerUnit'];
        $unitPrice = $_POST['unitPrice'];
        $unitsInStock = $_POST['unitsInStock'];
        $unitsOnOrder = $_POST['unitsOnOrder'];
        $reorderLevel = $_POST['reorderLevel'];
        $discontinued = $_POST['discontinued'];

        /* echo $productName, $companyName, $categoryName, $quantityPerUnit, $unitPrice, $unitsInStock, $unitsOnOrder, $reorderLevel, $discontinued; */


       $productModel = new productModel();
        $productModel->insertProduct($productName, $companyName, $categoryName, $quantityPerUnit, $unitPrice, $unitsInStock, $unitsOnOrder, $reorderLevel, $discontinued);

        header("Location: ../../views/products");
    }
    