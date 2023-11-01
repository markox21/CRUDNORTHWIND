<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CategoryInsert</title>
    <link rel="stylesheet" href="../../public/css/style.css">

</head>
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

        <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Registrar Nueva Categoria</h2>
                <form action="../../controller/categoryController/categoryInsertController.php" method="post" class="form-types">
                    <label for="CategoryName">Category Name</label>
                    <input type="text" name= "CategoryName"><br>
                    <label for="Description">Description</label>
                    <input type="text" name="Description"><br>
                    <!-- <label for="Picture">Picture</label>
                    <input type="text" name="Picture"><br> -->

                    <button type="submit" class="btn-submit">Confirmar</button>
                </form>
            </div>
        </section>
</body>
</html>