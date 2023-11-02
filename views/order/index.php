<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Clientes</title>
</head>
<body>
    <h1>Listado de Ordenes</h1>

    <a href="orderInsert.php"> Registrar Order </a>

    <table border="1">
        <tr>
            <th>OrderID</th>
            <th>CustomerID</th>
            <th>EmployeeID</th>
            <th>OrderDate</th>
            <th>RequiredDate</th>
            <th>ShippedDate</th>
            <th>ShipVia</th>
            <th>Freight</th>
            <th>ShipName</th>
            <th>ShipCity</th>
            <th>ShipAddress</th>
            <th>ShipRegion</th>
            <th>ShipPostalCode</th>
            <th>ShipCountry</th>
            <th>Action</th>
        </tr>
        <?php
        require("../../controller/orderController/orderShowController.php");
        $controller = new OrderController();
        $orders = $controller->showOrders();
        
        foreach ($orders as $order) : ?>
            <tr>
                <td><?php echo $order['OrderID']; ?></td>
                <td><?php echo $order['CustomerID']; ?></td>
                <td><?php echo $order['EmployeeID']; ?></td>
                <td><?php echo $order['OrderDate']; ?></td>
                <td><?php echo $order['RequiredDate']; ?></td>
                <td><?php echo $order['ShippedDate']; ?></td>
                <td><?php echo $order['ShipVia']; ?></td>
                <td><?php echo $order['Freight']; ?></td>
                <td><?php echo $order['ShipName']; ?></td>
                <td><?php echo $order['ShipAddress']; ?></td>
                <td><?php echo $order['ShipCity']; ?></td>
                <td><?php echo $order['ShipRegion']; ?></td>
                <td><?php echo $order['ShipPostalCode']; ?></td>
                <td><?php echo $order['ShipCountry']; ?></td>
                <td>
                <a href="orderEdit.php?id=<?php echo $order['OrderID']; ?>">Editar</a>

                <a href="../../controller/orderController/orderDeleteController.php?id=<?php echo $order['OrderID']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
