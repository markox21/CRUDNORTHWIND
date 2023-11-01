<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Categorias</title>
    <link rel="stylesheet" href="../../public/css/style.css">

</head>

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

<?php
require("../../controller/categoryController/categoryShowController.php");

$recibirID = $_GET['id'];
$mostrar = new categoryController;
$categoryEdit = $mostrar->showUpdateCategory($recibirID);

?>

<body>

    <h1>Editar Categoria</h1>

    

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <form action="../../controller/categoryController/categoryUpdateController.php" method="post" class="form-types">
                    <label for="CategoryIDUpdate">ID customer</label>
                    <input type="hidden" name= "CategoryIDUpdate"  value="<?php echo $categoryEdit->CategoryID;?>"><br>
                    <label for="CategoryNameUpdate">Category Name</label>
                    <input type="text" name="CategoryNameUpdate" value="<?php echo $categoryEdit->CategoryName;?>"><br>
                    <label for="CategoryDescriptionUpdate">Description</label>
                    <input type="text" name="CategoryDescriptionUpdate" value="<?php echo $categoryEdit->Description;?>"><br>
            <!--         <label for="CategoryImageUpdate">Picture</label>
                    <input type="text" name="CategoryImageUpdate" value="<?php /* echo $categoryEdit->Picture; */?>"><br> -->

                    <button type="submit" class="btn-submit">Confirmar</button>
                </form>
            </div>
        </section>
</body>
</html>
