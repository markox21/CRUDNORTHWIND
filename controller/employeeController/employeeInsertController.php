<?php
require ("../../models/productModel.php");

##insert products 
    $productModel = new productModel();


    $employeeLastName = $_POST['employeeLastName'];
    $employeeFirstName = $_POST['employeeFirstName'];
    $employeeTitle = $_POST['employeeTitle'];
    $employeeTitleCourtesy = $_POST['employeeTitleCourtesy'];
    $employeeBirthDate = $_POST['employeeBirthDate'];
    $employeeHireDate = $_POST['employeeHireDate'];
    $employeeAdress = $_POST['employeeAdress'];
    $employeeCity = $_POST['employeeCity'];
    $employeeRegion = $_POST['employeeRegion'];
    $employeePostalCode = $_POST['employeePostalCode'];
    $employeeCountry = $_POST['employeeCountry'];
    $employeeHomePhone = $_POST['employeeHomePhone'];
    $employeeExtension = $_POST['employeeExtension'];
    $employeePhoto = $_POST['employeePhoto'];
    $employeeNotes = $_POST['employeeNotes'];
    $employeePhotoPath = $_POST['employeePhotoPath'];



    $productModel->insertProduct($employeeLastName, $employeeFirstName, $employeeTitle, $employeeTitleCourtesy, $employeeBirthDate, $employeeHireDate, $employeeAdress, $employeeCity, $employeeRegion);

    $products = $productModel->getProducts();

    header("Location: ../../views/productosView.php");

