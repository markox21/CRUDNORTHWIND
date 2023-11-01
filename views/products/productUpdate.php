<!DOCTYPE html>
<html>
<head>
    <title>Ingresar Producto</title>
</head>
<body>
    <h1>Editar Producto</h1>

    <?php
        require("../../controller/productsController/productShowController.php");

        $recibirID = $_GET['id'];
        $product = new ProductController();
        $value = $product->showOneProduct($recibirID);


    ?>

    <form action="../../controller/productsController/productUpdateController.php" method="POST">
        
        <input type="hidden" name="productIDUpdate" value= "<?php echo $value->ProductID; ?>">

        <label for="productNameUpdate">Nombre del Producto:</label>
        <input type="text" name="productNameUpdate" required value= "<?php echo $value->ProductName; ?>"><br>
        
        <label for="companyNameUpdate">Nombre de la Compañía:</label>
        <input type="text" name="companyNameUpdate" required value= "<?php echo $value->SupplierID; ?>"><br>
        
        <label for="categoryNameUpdate">Id de la categoria:</label>
        <input type="text" name="categoryNameUpdate" required value= "<?php echo $value->CategoryID; ?>"><br>

        <label for="quantityPerUnitUpdate">Cantidad por Unidad:</label>
        <input type="text" name="quantityPerUnitUpdate" required value= "<?php echo $value->QuantityPerUnit; ?>"><br>

        <label for="unitPriceUpdate">Precio Unitario:</label>
        <input type="number" step="0.01" name="unitPriceUpdate" required value= "<?php echo $value->UnitPrice; ?>"><br>

        <label for="unitsInStockUpdate">Unidades en Stock:</label>
        <input type="number" name="unitsInStockUpdate" required value= "<?php echo $value->UnitsInStock; ?>"><br>

        <label for="unitsOnOrderUpdate">Unidades en Orden:</label>
        <input type="number" name="unitsOnOrderUpdate" required value= "<?php echo $value->UnitsOnOrder; ?>"><br>

        <label for="reorderLevelUpdate">Nivel de Reorden:</label>
        <input type="number" name="reorderLevelUpdate" required value= "<?php echo $value->ReorderLevel; ?>"><br>

        <label for="discontinuedUpdate">Descontinuado:</label>
        <input type="number" name="discontinuedUpdate" value= "<?php echo $value->Discontinued; ?>"><br>

        <button type="submit">Editar</button>
    </form>
</body>
</html>
