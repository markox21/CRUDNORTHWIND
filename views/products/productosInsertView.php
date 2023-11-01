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
            <li><a href="./index.php">Categorias</a></li>
            <li><a href="../products/index.php">Productos</a></li>
        </ul>
    </nav>
    <h1>Ingresar Producto</h1>
    

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Registrar Producto</h2>
                <form action="../controller/productosController/productInsertController.php" method="POST" class="form-types">
        
                    <label for="productName">Nombre del Producto:</label>
                    <input type="text" name="productName" required><br>
                    
                    <label for="companyName">Nombre de la Compañía:</label>
                    <input type="text" name="companyName" required><br>
                    
                    <label for="categoryName">Nombre de la Categoría:</label>
                    <input type="text" name="categoryName" required><br>

                    <label for="quantityPerUnit">Cantidad por Unidad:</label>
                    <input type="text" name="quantityPerUnit" required><br>

                    <label for="unitPrice">Precio Unitario:</label>
                    <input type="number" step="0.01" name="unitPrice" required><br>

                    <label for="unitsInStock">Unidades en Stock:</label>
                    <input type="number" name="unitsInStock" required><br>

                    <label for="unitsOnOrder">Unidades en Orden:</label>
                    <input type="number" name="unitsOnOrder" required><br>

                    <label for="reorderLevel">Nivel de Reorden:</label>
                    <input type="number" name="reorderLevel" required><br>

                    <label for="discontinued">Descontinuado:</label>
                    <input type="number" name="discontinued"><br>

                    <button type="submit" class="btn-submit">Ingresar Producto</button>
                </form>
            </div>
        </section>
</body>
</html>
