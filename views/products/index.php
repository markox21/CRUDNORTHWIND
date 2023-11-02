<!DOCTYPE html>
<html>
<head>
    <title>Lista de Productos</title>
    <link rel="stylesheet" href="../../public/css/style.css">
</head>
<body>

    <nav class="navBar-home">
        <ul class="list-ul-Nav">
            <li><a href="../../index.php">Home</a></li>
            <li><a href="../employee/index.php">Empleado</a></li>
            <li><a href="../customer/index.php">Cliente</a></li>
            <li><a href="../order/index.php">Order</a></li>
            <li><a href="../categories/index.php">Categorias</a></li>
            <li><a href="./index.php">Productos</a></li>
        </ul>
    </nav>
    <h1>Lista de Productos</h1>

    <a href="productinsert.php">Registrar Producto</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Nombre del Producto</th>
            <th>Empresa</th>
            <th>Categoría</th>
            <th>Cantidad x Precio</th>
            <th>Precio Unitario</th>
            <th>Stock</th>
            <th>Orden</th>
            <th>Niveles</th>
            <th>Discontinued</th>
            <th>Acciones</th>
        </tr>
        <?php
        require("../../controller/productsController/productShowController.php");
        $controller = new ProductController();
        $products = $controller->showProducts();

        foreach ($products as $product) : ?>
            <tr>
                <td><?php echo $product['ID_P']; ?></td>
                <td><?php echo $product['Nombre_del_Producto']; ?></td>
                <td><?php echo $product['Empresa']; ?></td>
                <td><?php echo $product['Categoria']; ?></td>
                <td><?php echo $product['Cantidad_x_Precio']; ?></td>
                <td><?php echo $product['Precio_Unitario']; ?></td>
                <td><?php echo $product['Stock']; ?></td>
                <td><?php echo $product['Orden']; ?></td>
                <td><?php echo $product['Niveles']; ?></td>
                <td><?php echo $product['Discontinued']; ?></td>
                <td>
                
                    <a href="productUpdate.php?id=<?php echo $product['ID_P']; ?>">Editar</a>
                    <a href="../../controller/productsController/productDeleteController.php?id=<?php echo $product['ID_P']; ?>">Eliminar</a>

                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
