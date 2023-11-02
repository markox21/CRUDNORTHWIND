<?php
    require('../../models/orderModel.php');

    if ($_POST) {
        $OrderIDUpdate = $_POST['OrderIDUpdate'];
        $CustomerIDUpdate = $_POST['CustomerIDUpdate'];

        $EmployeeIDUpdate = $_POST['EmployeeIDUpdate'];
        $OrderDateUpdate = $_POST['OrderDateUpdate'];

        $RequiredDateUpdate = $_POST['RequiredDateUpdate'];
        $ShippedDateUpdate = $_POST['ShippedDateUpdate'];
        $ShipViaUpdate = $_POST['ShipViaUpdate'];

        $FreightUpdate = $_POST['FreightUpdate'];
        $ShipNameUpdate = $_POST['ShipNameUpdate'];

        $ShipAddressUpdate = $_POST['ShipAddressUpdate'];
        $ShipCityUpdate = $_POST['ShipCityUpdate'];

        $ShipRegionUpdate = $_POST['ShipRegionUpdate'];
        $ShipPostalCodeUpdate = $_POST['ShipPostalCodeUpdate'];

        $ShipCountryUpdate = $_POST['ShipCountryUpdate'];

        $update = new OrderModel;
        $result = $update->editOrders($OrderIDUpdate, $CustomerIDUpdate, $EmployeeIDUpdate, $OrderDateUpdate, $RequiredDateUpdate, $ShippedDateUpdate, $ShipViaUpdate, $FreightUpdate, $ShipNameUpdate, $ShipAddressUpdate, $ShipCityUpdate, $ShipRegionUpdate, $ShipPostalCodeUpdate, $ShipCountryUpdate);

        header("location: ../../views/order");
    }
?>