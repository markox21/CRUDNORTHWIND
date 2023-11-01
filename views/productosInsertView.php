<!DOCTYPE html>
<html>
<head>
    <title>Ingresar Producto</title>
</head>
<body>
    <h1>Ingresar Producto</h1>
    <form action="../controller/productosController/productInsertController.php" method="POST">
        
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

        <button type="submit">Ingresar Producto</button>
    </form>
</body>
</html>
