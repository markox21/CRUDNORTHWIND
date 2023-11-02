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
    <table border="1">
        <tr>
            <th>Order ID</th>
            <th>Company Name</th>
            <th>Contact Name</th>
            <th>Contact Title</th>
            <th>Phone</th>
            <th>Product Name</th>
            <th>Unit Price</th>
            <th>Quantity</th>
            <th>Discount</th>
            <th>Actions</th>
        </tr>
        <?php
        require("../../controller/orderController/orderShowController.php");
        $controller = new OrderController();
        $orders = $controller->showOrders();
        
        foreach ($orders as $order) : ?>
            <tr>
                <td><?php echo $order['ID_Orden']; ?></td>
                <td><?php echo $order['Nombre_Compañía']; ?></td>
                <td><?php echo $order['Nombre_Contacto']; ?></td>
                <td><?php echo $order['Transportista']; ?></td>
                <td><?php echo $order['Telefono']; ?></td>
                <td><?php echo $order['Nombre_Producto']; ?></td>
                <td><?php echo $order['Precio_Unitario']; ?></td>
                <td><?php echo $order['Cantidad']; ?></td>
                <td><?php echo $order['Descuento']; ?></td>
                <td>
                <a href="orderEdit.php?id=<?php echo $order['ID_Orden'];?>">Editar</a>

                <a href="../../controller/orderController/orderDeleteController.php?id=<?php echo $order['ID_Orden']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
