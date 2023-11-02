<?php
require ("../../models/productModel.php");

##insert products 
    if ($_POST) {
        $productIDUpdate = $_POST['productIDUpdate'];
        $productNameUpdate = $_POST['productNameUpdate'];

        $companyNameUpdate = $_POST['companyNameUpdate'];
        $categoryNameUpdate = $_POST['categoryNameUpdate'];

        $quantityPerUnitUpdate = $_POST['quantityPerUnitUpdate'];
        $unitPriceUpdate = $_POST['unitPriceUpdate'];

        $unitsInStockUpdate = $_POST['unitsInStockUpdate'];
        $unitsOnOrderUpdate = $_POST['unitsOnOrderUpdate'];

        $reorderLevelUpdate = $_POST['reorderLevelUpdate'];
        $discontinuedUpdate = $_POST['discontinuedUpdate'];

        /* echo $productIDUpdate, $productNameUpdate, $companyNameUpdate, $categoryNameUpdate, $quantityPerUnitUpdate, $unitPriceUpdate, $unitsInStockUpdate, $unitsOnOrderUpdate, $reorderLevelUpdate, $discontinuedUpdate; */


        $productModel = new productModel();
        $productModel->updateProduct($productIDUpdate, $productNameUpdate, $companyNameUpdate, $categoryNameUpdate, $quantityPerUnitUpdate, $unitPriceUpdate, $unitsInStockUpdate, $unitsOnOrderUpdate, $reorderLevelUpdate, $discontinuedUpdate);

        header("Location: ../../views/products");
    }