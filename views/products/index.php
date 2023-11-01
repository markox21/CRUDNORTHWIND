<!DOCTYPE html>
<html>
<head>
    <title>Lista de Productos</title>
</head>
<body>
    <h1>Lista de Productos</h1>
    <table border="1">
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
                <a href="../../controller/productsController/productDeleteController.php?id=<?php echo $product['ID_P']; ?>">Eliminar</a>

                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
