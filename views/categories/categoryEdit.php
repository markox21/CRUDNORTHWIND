<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Categorias</title>
</head>

<?php
require("../../controller/categoryController/categoryShowController.php");

$recibirID = $_GET['id'];
$mostrar = new categoryController;
$categoryEdit = $mostrar->showUpdateCategory($recibirID);

?>

<body>

    <h1>Editar Categoria</h1>

    <form action="../../controller/categoryController/categoryUpdateController.php" method="post">
        <label for="CategoryIDUpdate">ID customer</label>
        <input type="hidden" name= "CategoryIDUpdate"  value="<?php echo $categoryEdit->CategoryID;?>"><br>
        <label for="CategoryNameUpdate">Category Name</label>
        <input type="text" name="CategoryNameUpdate" value="<?php echo $categoryEdit->CategoryName;?>"><br>
        <label for="CategoryDescriptionUpdate">Description</label>
        <input type="text" name="CategoryDescriptionUpdate" value="<?php echo $categoryEdit->Description;?>"><br>
<!--         <label for="CategoryImageUpdate">Picture</label>
        <input type="text" name="CategoryImageUpdate" value="<?php /* echo $categoryEdit->Picture; */?>"><br> -->

        <button type="submit">Confirmar</button>
    </form>
</body>
</html>
