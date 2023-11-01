<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Clientes</title>
    <link rel="stylesheet" href="../../public/css/style.css">
</head>

<?php
require("../../controller/orderController/orderShowController.php");

$recibirID = $_GET['id'];
$mostrar = new orderController;
$customersEdit = $mostrar->showUpdateOrders($recibirID);

?>
<body>
    <nav class="navBar-home">
        <ul class="list-ul-Nav">
            <li><a href="../../index.php">Home</a></li>
            <li><a href="../employee/index.php">Empleado</a></li>
            <li><a href="../customer/index.php">Cliente</a></li>
            <li><a href="../order/index.php">Order</a></li>
            <li><a href="./index.php">Categorias</a></li>
            <li><a href="../products/index.php">Productos</a></li>
        </ul>
    </nav>

    <h1>Editar Order</h1>

    

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Editar Orden</h2>
                <form action="../../controller/orderController/orderEditController.php" method="post" class="form-types">
                    <label for="OrderIDUpdate">ID customer</label>
                    <input type="text" name= "OrderIDUpdate" value="<?php echo $ordersEdit->ID_Orden;?>"><br>
                    <label for="CompanyNameUpdate">Company Name</label>
                    <input type="text" name="CompanyNameUpdate" value="<?php echo $ordersEdit->Nombre_Compañía;?>"><br>
                    <label for="ContactNameUpdate">Contact Name</label>
                    <input type="text" name="ContactNameUpdate" value="<?php echo $ordersEdit->Nombre_Contacto;?>"><br>
                    <label for="ShipperNameUpdate">Company Name</label>
                    <input type="text" name="ShipperNameUpdate" value="<?php echo $ordersEdit->Transportista;?>"><br>
                    <label for="PhoneUpdate">Phone</label>
                    <input type="text" name="PhoneUpdate" value="<?php echo $ordersEdit->Telefono;?>"><br>
                    <label for="ProductNameUpdate">Product Name</label>
                    <input type="text" name="ProductNameUpdate" value="<?php echo $ordersEdit->Nombre_Producto;?>"><br>
                    <label for="UnitPriceUpdate">Unit Price</label>
                    <input type="text" name="UnitPriceUpdate" value="<?php echo $ordersEdit->Precio_Unitario;?>"><br>
                    <label for="QuantityUpdate">Quantity</label>
                    <input type="text" name="QuantityUpdate" value="<?php echo $ordersEdit->Cantidad;?>"><br>
                    <label for="DiscountUpdate">Discount</label>
                    <input type="text" name="DiscountUpdate" value="<?php echo $ordersEdit->Descuento;?>"><br>

                    <button type="submit" class="btn-submit">Confirmar</button>
                </form>
            </div>
        </section>
</body>
</html>