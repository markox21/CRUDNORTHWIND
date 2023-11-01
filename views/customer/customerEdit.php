<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Clientes</title>
</head>

<?php
require("../../controller/customerController/customerShowController.php");

$recibirID = $_GET['id'];
$mostrar = new customerController;
$customersEdit = $mostrar->showUpdateCustomer($recibirID);

?>  

<body>

    <h1>Editar Registro Customer</h1>

    <form action="../../controller/customerController/customerUpdateController.php" method="post">
        <label for="CustomerIDUpdate">ID customer</label>
        <input type="text" name= "CustomerIDUpdate" DISABLED value="<?php echo $recibirID;?>"><br>
        <label for="CompanyNameUpdate">Company Name</label>
        <input type="text" name="CompanyNameUpdate" DISABLED value="<?php echo $customersEdit->CompanyName;?>"><br>
        <label for="ContactNameUpdate">Contact Name</label>
        <input type="text" name="ContactNameUpdate" value="<?php echo $customersEdit->ContactName;?>"><br>
        <label for="ContactTitleUpdate">Contact Title</label>
        <input type="text" name="ContactTitleUpdate" value="<?php echo $customersEdit->ContactTitle;?>"><br>
        <label for="AddressUpdate">Address</label>
        <input type="text" name="AddressUpdate" value="<?php echo $customersEdit->Address;?>"><br>
        <label for="CityUpdate">City</label>
        <input type="text" name="CityUpdate" value="<?php echo $customersEdit->City;?>"><br>
        <label for="RegionUpdate">Region</label>
        <input type="text" name="RegionUpdate" value="<?php echo $customersEdit->Region;?>"><br>
        <label for="PostalCodeUpdate">Posta Code</label>
        <input type="text" name="PostalCodeUpdate" value="<?php echo $customersEdit->PostalCode;?>"><br>
        <label for="CountryUpdate">Country</label>
        <input type="text" name="CountryUpdate" value="<?php echo $customersEdit->Country;?>"><br>
        <label for="PhoneUpdate">Phone</label>
        <input type="text" name="PhoneUpdate" value="<?php echo $customersEdit->Phone;?>"><br>
        <label for="FaxUpdate">Fax</label>
        <input type="text" name="FaxUpdate" value="<?php echo $customersEdit->Fax;?>"><br>

        <button type="submit">Confirmar</button>
    </form>
</body>
</html>
