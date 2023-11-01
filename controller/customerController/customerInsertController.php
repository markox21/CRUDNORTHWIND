<?php
    require("../../models/customerModel.php");

    if ($_POST) {
        $CompanyName = $_POST['CompanyName'];
        $ContactName = $_POST['ContactName'];
        $ContactTitle = $_POST['ContactTitle'];
        $Address = $_POST['Address'];
        $City = $_POST['City'];
        $Region = $_POST['Region'];
        $PostalCode = $_POST['PostalCode'];
        $Country = $_POST['Country'];
        $Phone = $_POST['Phone'];
        $Fax = $_POST['Fax'];

        $update = new CustomerModel;
        $result = $update->insertCustomer($CompanyName, $ContactName, $ContactTitle, $Address, $City, $Region, $PostalCode, $Country, $Phone, $Fax);

        header("location: ../../views/customer");
    }
?>