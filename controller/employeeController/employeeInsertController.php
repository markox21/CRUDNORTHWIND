<?php
require ("../../models/employeeModel.php");

##insert Employee
    
    if ($_POST) {
        $employeeLastName = $_POST['employeeLastName'];
        $employeeFirstName = $_POST['employeeFirstName'];
        $employeeTitle = $_POST['employeeTitle'];
        $employeeTitleCourtesy = $_POST['employeeTitleCourtesy'];
        $employeeBirthDate = $_POST['employeeBirthDate'];
        $employeeHireDate = $_POST['employeeHireDate'];
        $employeeAddress = $_POST['employeeAdress'];
        $employeeCity = $_POST['employeeCity'];
        $employeeRegion = $_POST['employeeRegion'];
        $employeePostalCode = $_POST['employeePostalCode'];
        $employeeCountry = $_POST['employeeCountry'];
        $employeeHomePhone = $_POST['employeeHomePhone'];
        $employeeReportTo = $_POST['employeeReportTo'];



        /* echo $employeeLastName, $employeeFirstName, $employeeTitle,
        $employeeTitleCourtesy, $employeeBirthDate,  $employeeHireDate,
        $employeeAddress, $employeeCity, $employeeRegion, $employeePostalCode,
        $employeeCountry, $employeeHomePhone, $employeeReportTo; */

        $productModel = new EmployeeModel();
        $productModel->insertEmployee(
            $employeeLastName, $employeeFirstName, 
            $employeeTitle, $employeeTitleCourtesy, 
            $employeeBirthDate, $employeeHireDate, 
            $employeeAddress, $employeeCity, 
            $employeeRegion, $employeePostalCode, 
            $employeeCountry, $employeeHomePhone, 
            $employeeReportTo
        );


    header("Location: ../../views/employee"); 
    }

