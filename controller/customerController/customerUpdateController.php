<?php
    require('../../models/customerModel.php');

    if ($_POST) {
        $CustomerIDUpdate = $_POST['CustomerIDUpdate'];
        $CompanyNameUpdate = $_POST['CompanyNameUpdate'];
        $ContactNameUpdate = $_POST['ContactNameUpdate'];
        $ContactTitleUpdate = $_POST['ContactTitleUpdate'];
        $AddressUpdate = $_POST['AddressUpdate'];
        $CityUpdate = $_POST['CityUpdate'];
        $RegionUpdate = $_POST['RegionUpdate'];
        $PostalCodeUpdate = $_POST['PostalCodeUpdate'];
        $CountryUpdate = $_POST['CountryUpdate'];
        $PhoneUpdate = $_POST['PhoneUpdate'];
        $FaxUpdate = $_POST['FaxUpdate'];

        $update = new CustomerModel;
        $result = $update->editCustomer(
            $CustomerIDUpdate, $CompanyNameUpdate, 
            $ContactNameUpdate, $ContactTitleUpdate, 
            $AddressUpdate, $CityUpdate, 
            $RegionUpdate, $PostalCodeUpdate, 
            $CountryUpdate, $PhoneUpdate, 
            $FaxUpdate
        );

        header("location: ../../views/customer");
    }
?>