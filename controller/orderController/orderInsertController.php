<?php
    require('../../models/orderModel.php');

    if ($_POST) {
        $OrderID = $_POST['OrderID'];
        $CustomerID = $_POST['CustomerID'];

        $EmployeeID = $_POST['EmployeeID'];
        $OrderDate = $_POST['OrderDate'];

        $RequiredDate = $_POST['RequiredDate'];
        $ShippedDate = $_POST['ShippedDate'];
        $ShipVia = $_POST['ShipVia'];

        $Freight = $_POST['Freight'];
        $ShipName= $_POST['ShipName'];

        $ShipAddress = $_POST['ShipAddress'];
        $ShipCity = $_POST['ShipCity'];

        $ShipRegion = $_POST['ShipRegion'];
        $ShipPostalCode = $_POST['ShipPostalCode'];

        $ShipCountry = $_POST['ShipCountry'];

        $update = new OrderModel;
        $result = $update->insertOrders($OrderID, $CustomerID, $EmployeeID, $OrderDate, $RequiredDate, $ShippedDate, $ShipVia, $Freight, $ShipName, $ShipAddress, $ShipCity, $ShipRegion, $ShipPostalCode, $ShipCountry);

        header("location: ../../views/order");
    }
?>