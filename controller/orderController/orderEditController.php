<?php
    require('../../models/orderModel.php');

    if ($_POST) {
        $OrderIDUpdate = $_POST['OrderIDUpdate'];
        $CompanyNameUpdate = $_POST['CompanyNameUpdate'];
        $ContactNameUpdate = $_POST['ContactNameUpdate'];
        $ShipperNameUpdate = $_POST['ShipperNameUpdate'];
        $PhoneUpdate = $_POST['PhoneUpdate'];
        $ProductNameUpdate = $_POST['ProductNameUpdate'];
        $UnitPriceUpdate = $_POST['UnitPriceUpdate'];
        $QuantityUpdate = $_POST['QuantityUpdate'];
        $DiscountUpdate = $_POST['DiscountUpdate'];

        $update = new OrderModel;
        $result = $update->editOrders($OrderIDUpdate, $CompanyNameUpdate, $ContactNameUpdate, $ShipperNameUpdate, $PhoneUpdate, $ProductNameUpdate, $UnitPriceUpdateUpdate, $PostalCodeUpdate, $CountryUpdate, $PhoneUpdate, $FaxUpdate);

        header("location: ../../views/orderView");
    }
?>