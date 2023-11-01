<!DOCTYPE html>
<html>
<head>
    <title>Ingresar Empleado</title>
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

    <h1>Ingresar Empleado</h1>
    

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Registrar Empleado</h2>
                <form action="../../controller/employeeController/employeeInsertController.php" method="POST" class="form-types">
        
                    <label for="employeeLastName">Apellido del Empleado:</label>
                    <input type="text" name="employeeLastName" required><br>
                    
                    <label for="employeeFirstName">Nombre del Empleado:</label>
                    <input type="text" name="employeeFirstName" required><br>
                    
                    <label for="employeeTitle">Titulo:</label>
                    <input type="text" name="employeeTitle" required><br>
                    
                    <label for="employeeTitleCourtesy">Titulo de Cortesia (DR., SR.):</label>
                    <input type="text" name="employeeTitleCourtesy" required><br>

                    <label for="employeeBirthDate">FechaNacimiento:</label>
                    <input type="datetime"  name="employeeBirthDate" required><br>

                    <label for="employeeHireDate">Fecha de contratacion:</label>
                    <input type="datetime" name="employeeHireDate" required><br>

                    <label for="employeeAdress">Direccion:</label>
                    <input type="text" name="employeeAdress" required><br>

                    <label for="employeeCity">Ciudad:</label>
                    <input type="text" name="employeeCity" required><br>

                    <label for="employeeRegion">Region:</label>
                    <input type="text" name="employeeRegion" required><br>
                    
                    <label for="employeePostalCode">Postal Code:</label>
                    <input type="text" name="employeePostalCode" required><br>

                    <label for="employeeCountry">Country:</label>
                    <input type="text" name="employeeCountry" required><br>

                    <label for="employeeHomePhone">Telefono de Casa:</label>
                    <input type="text" name="employeeHomePhone" required><br>

                    <label for="employeeReportTo">Encargo De:</label>
                    <input type="text" name="employeeReportTo" required><br>

                    <button type="submit" class="btn-submit">Agregar Empleado</button>
                </form>
            </div>
        </section>
</body>
</html>
