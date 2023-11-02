<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Clientes</title>
</head>

<?php
require("../../controller/orderController/orderShowController.php");

$recibirID = $_GET['id'];
$mostrar = new orderController;
$ordersEdit = $mostrar->showUpdateOrders($recibirID);

?>
<body>
    <h1>Editar Order</h1>

    <form action="../../controller/orderController/orderEditController.php" method="post">

        <label for="OrderIDUpdate">OrderId</label>
        <input type="text" name= "OrderIDUpdate" value="<?php echo $ordersEdit->OrderID;?>"><br>
        <label for="CustomerIDUpdate">CustomerID</label>
        <input type="text" name="CustomerIDUpdate" value="<?php echo $ordersEdit->CustomerID;?>"><br>

        <label for="EmployeeIDUpdate">EmployeeID</label>
        <input type="text" name="EmployeeIDUpdate" value="<?php echo $ordersEdit->EmployeeID;?>"><br>
        <label for="OrderDateUpdate">OrderDate</label>
        <input type="text" name="OrderDateUpdate" value="<?php echo $ordersEdit->OrderDate;?>"><br>

        <label for="RequiredDateUpdate">RequiredDate</label>
        <input type="text" name="RequiredDateUpdate" value="<?php echo $ordersEdit->RequiredDate;?>"><br>
        <label for="ShippedDateUpdate">ShippedDate</label>
        <input type="text" name="ShippedDateUpdate" value="<?php echo $ordersEdit->ShippedDate;?>"><br>
        <label for="ShipViaUpdate">ShipVia</label>
        <input type="text" name="ShipViaUpdate" value="<?php echo $ordersEdit->ShipVia;?>"><br>

        <label for="FreightUpdate">Freight</label>
        <input type="text" name="FreightUpdate" value="<?php echo $ordersEdit->Freight;?>"><br>
        <label for="ShipNameUpdate">ShipName</label>
        <input type="text" name="ShipNameUpdate" value="<?php echo $ordersEdit->ShipName;?>"><br>

        <label for="ShipAddressUpdate">ShipAddress</label>
        <input type="text" name="ShipAddressUpdate" value="<?php echo $ordersEdit->ShipAddress;?>"><br>
        <label for="ShipCityUpdate">ShipCity</label>
        <input type="text" name="ShipCityUpdate" value="<?php echo $ordersEdit->ShipCity;?>"><br>

        <label for="ShipRegionUpdate">ShipRegion</label>
        <input type="text" name="ShipRegionUpdate" value="<?php echo $ordersEdit->ShipRegion;?>"><br>
        <label for="ShipPostalCodeUpdate">ShipPostalCode</label>
        <input type="text" name="ShipPostalCodeUpdate" value="<?php echo $ordersEdit->ShipPostalCode;?>"><br>

        <label for="ShipCountryUpdate">ShipCountry</label>
        <input type="text" name="ShipCountryUpdate" value="<?php echo $ordersEdit->ShipCountry;?>"><br>
        <button type="submit">Confirmar</button>
    </form>
</body>
</html>