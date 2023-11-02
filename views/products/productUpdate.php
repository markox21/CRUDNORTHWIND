<!DOCTYPE html>
<html>
<head>
    <title>Ingresar Producto</title>
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
    <h1>Editar Producto</h1>

    <?php
        require("../../controller/productsController/productShowController.php");

        $recibirID = $_GET['id'];
        $product = new ProductController();
        $value = $product->showOneProduct($recibirID);


    ?>

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Registrar Producto</h2>
                <form action="../../controller/productsController/productUpdateController.php" method="POST" class="form-types">
        
                    <input type="hidden" name="productIDUpdate" value= "<?php echo $value->ProductID; ?>">

                    <label for="productNameUpdate">Nombre del Producto:</label>
                    <input type="text" name="productNameUpdate" required value= "<?php echo $value->ProductName; ?>"><br>
                    
                    <label for="companyNameUpdate">Nombre de la Compañía:</label>
                    <input type="text" name="companyNameUpdate" required value= "<?php echo $value->SupplierName; ?>"><br>
                    
                    <label for="categoryNameUpdate">Id de la categoria:</label>
                    <input type="text" name="categoryNameUpdate" required value= "<?php echo $value->CategoryName; ?>"><br>

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

                    <button type="submit" class="btn-submit">Editar</button>
                </form>
            </div>
        </section>
</body>
</html>
