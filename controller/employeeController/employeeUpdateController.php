<?php
require ("../../models/employeeModel.php");

##insert Employee
    
    if ($_POST) {
        $employeeIDUpdate = $_POST['employeeIDUpdate'];
        $employeeLastNameUpdate = $_POST['employeeLastNameUpdate'];
        $employeeFirstNameUpdate = $_POST['employeeFirstNameUpdate'];
        $employeeTitleUpdate = $_POST['employeeTitleUpdate'];
        $employeeTitleCourtesyUpdate = $_POST['employeeTitleCourtesyUpdate'];
        $employeeBirthDateUpdate = $_POST['employeeBirthDateUpdate'];
        $employeeHireDateUpdate = $_POST['employeeHireDateUpdate'];
        $employeeAddressUpdate = $_POST['employeeAdressUpdate'];
        $employeeCityUpdate = $_POST['employeeCityUpdate'];
        $employeeRegionUpdate = $_POST['employeeRegionUpdate'];
        $employeePostalCodeUpdate = $_POST['employeePostalCodeUpdate'];
        $employeeCountryUpdate = $_POST['employeeCountryUpdate'];
        $employeeHomePhoneUpdate = $_POST['employeeHomePhoneUpdate'];
        $employeeReportToUpdate = $_POST['employeeReportToUpdate'];



        /* echo $employeeIDUpdate, $employeeLastNameUpdate, $employeeFirstNameUpdate, $employeeTitleUpdate,
        $employeeTitleCourtesyUpdate, $employeeBirthDateUpdate,  $employeeHireDateUpdate,
        $employeeAddressUpdate, $employeeCityUpdate, $employeeRegionUpdate, $employeePostalCodeUpdate,
        $employeeCountryUpdate, $employeeHomePhoneUpdate, $employeeReportToUpdate; */

        $productModel = new EmployeeModel();
        $productModel->updateEmployee(
            $employeeIDUpdate, $employeeLastNameUpdate, $employeeFirstNameUpdate, $employeeTitleUpdate,
            $employeeTitleCourtesyUpdate, $employeeBirthDateUpdate,  $employeeHireDateUpdate,
            $employeeAddressUpdate, $employeeCityUpdate, $employeeRegionUpdate, $employeePostalCodeUpdate,
            $employeeCountryUpdate, $employeeHomePhoneUpdate, $employeeReportToUpdate
        );


    header("Location: ../../views/employee"); 
    }