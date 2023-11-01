<!DOCTYPE html>
<html>
<head>
    <title>Listado de Categorias</title>
</head>
<body>
    <h1>Listado de Categorias</h1>

    <a href="categoryInsert.php">RegistrarCategoria</a>
    <table border="1">
        <tr>
            <th>Category ID</th>
            <th>Category Name</th>
            <th>Description</th>
            <th>Picture</th>
            <th>Actions</th>
        </tr>
        
        <?php
        require("../../controller/categoryController/categoryShowController.php");
        $controller = new CategoryController();
        $categories = $controller->showCategories();

        foreach ($categories as $category) : ?>
            <tr>
                <td><?php echo $category['CategoryID']; ?></td>
                <td><?php echo $category['CategoryName']; ?></td>
                <td><?php echo $category['Description']; ?></td>
                <td><?php echo $category['Picture']; ?></td>
                <td>
                    <a href="categoryEdit.php?id=<?php echo $category['CategoryID'];?>">Editar</a>

                    <a href="../../controller/categoryController/categoryDeleteController.php?id=<?php echo $category['CategoryID']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach;
        ?>
    </table>
</body>
</html>
