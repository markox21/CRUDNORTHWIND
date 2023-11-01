<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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

    <h1>Editar Employee</h1>

    <?php
        require("../../controller/employeeController/employeeShowController.php");

        $recibirID = $_GET['id'];

        $controller = new EmployeeController();
        $value = $controller->showOneEmployee($recibirID);
    ?>

    

    <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Editar Empleado</h2>
                <form action="../../controller/employeeController/employeeUpdateController.php" method="POST" class="form-types">

                    <input type="hidden" name="employeeIDUpdate" value="<?php echo $value->EmployeeID; ?>"> <br>
                    
                    <label for="employeeLastNameUpdate">Apellido del Empleado:</label>
                    <input type="text" name="employeeLastNameUpdate" required value="<?php echo $value->LastName; ?>"><br>
                    
                    <label for="employeeFirstNameUpdate">Nombre del Empleado:</label>
                    <input type="text" name="employeeFirstNameUpdate" required value="<?php echo $value->FirstName; ?>"><br>
                    
                    <label for="employeeTitleUpdate">Titulo:</label>
                    <input type="text" name="employeeTitleUpdate" required value="<?php echo $value->Title; ?>"><br>
                    
                    <label for="employeeTitleCourtesyUpdate">Titulo de Cortesia (DR., SR.):</label>
                    <input type="text" name="employeeTitleCourtesyUpdate" required value="<?php echo $value->TitleOfCourtesy; ?>"><br>

                    <label for="employeeBirthDateUpdate">FechaNacimiento:</label>
                    <input type="datetime"  name="employeeBirthDateUpdate" required value="<?php echo $value->BirthDate; ?>"><br>

                    <label for="employeeHireDateUpdate">Fecha de contratacion:</label>
                    <input type="datetime" name="employeeHireDateUpdate" required value="<?php echo $value->HireDate; ?>"><br>

                    <label for="employeeAdressUpdate">Direccion:</label>
                    <input type="text" name="employeeAdressUpdate" required value="<?php echo $value->Address; ?>"><br>

                    <label for="employeeCityUpdate">Ciudad:</label>
                    <input type="text" name="employeeCityUpdate" required value="<?php echo $value->City; ?>"><br>

                    <label for="employeeRegionUpdate">Region:</label>
                    <input type="text" name="employeeRegionUpdate" required value="<?php echo $value->Region; ?>"><br>
                    
                    <label for="employeePostalCodeUpdate">Postal Code:</label>
                    <input type="text" name="employeePostalCodeUpdate" required value="<?php echo $value->PostalCode; ?>"><br>

                    <label for="employeeCountryUpdate">Country:</label>
                    <input type="text" name="employeeCountryUpdate" required value="<?php echo $value->Country; ?>"><br>

                    <label for="employeeHomePhoneUpdate">Telefono de Casa:</label>
                    <input type="text" name="employeeHomePhoneUpdate" required value="<?php echo $value->HomePhone; ?>"><br>

                    <label for="employeeReportToUpdate">Encargo De:</label>
                    <input type="text" name="employeeReportToUpdate" required value="<?php echo $value->ReportsTo; ?>"><br>

                    <button type="submit" class="btn-submit">Agregar Empleado</button>

                </form>
            </div>
        </section>
</body>
</html>