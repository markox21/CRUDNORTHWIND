<!DOCTYPE html>
<html>
<head>
    <title>Lista de Trabajadores</title>
    <link rel="stylesheet" href="../../public/css/style.css">
</head>
<body>

    <nav class="navBar-home">
        <ul class="list-ul-Nav">
            <li><a href="../../index.php">Home</a></li>
            <li><a href="./index.php">Empleado</a></li>
            <li><a href="../customer/index.php">Cliente</a></li>
            <li><a href="../order/index.php">Order</a></li>
            <li><a href="../categories/index.php">Categorias</a></li>
            <li><a href="../products/index.php">Productos</a></li>
        </ul>
    </nav>

    <h1>Lista de Trabajadores</h1>

    <a href='employeeInsertView.php'> Ingresar Registro </a>
    <table>
        <tr>
            <th>EmployeeID</th>
            <th>LastName</th>
            <th>FirstName</th>
            <th>Title</th>
            <!-- <th>TerritoryDescription</th> -->
            <th>TitleOfCourtesy</th>
            <th>BirthDate</th>
            <th>HireDate</th>
            <th>Address</th>
            <th>City</th>
            <th>Region</th>
            <th>PostalCode</th>
            <th>Country</th>
            <th>HomePhone</th>
            <th>ReportsToName</th>
            <th>Actions</th>

        </tr>
        <?php
        require("../../controller/employeeController/employeeShowController.php");
        $controller = new EmployeeController();
        $employees = $controller->showEmployee();
        
        foreach ($employees as $employee) : ?>
            <tr>
                <td><?php echo $employee['EmployeeID']; ?></td>
                <td><?php echo $employee['LastName']; ?></td>
                <td><?php echo $employee['FirstName']; ?></td>
                <td><?php echo $employee['Title']; ?></td>
                <td><?php echo $employee['TitleOfCourtesy']; ?></td>
                <td><?php echo $employee['BirthDate']; ?></td>
                <td><?php echo $employee['HireDate']; ?></td>
                <td><?php echo $employee['Address']; ?></td>
                <td><?php echo $employee['City']; ?></td>
                <!-- <td><?php /* echo $employee['Territorio']; */ ?></td> -->
                <td><?php echo $employee['Region']; ?></td>
                <td><?php echo $employee['PostalCode']; ?></td>
                <td><?php echo $employee['Country']; ?></td>
                <td><?php echo $employee['HomePhone']; ?></td>
                <td><?php echo $employee['ReportsToName']; ?></td>
                <td>
                <a href="employeeUpdateView.php?id=<?php echo $employee['EmployeeID']; ?>">Editar</a>
                <a href="../../controller/employeeController/employeeDeleteController.php?id=<?php echo $employee['EmployeeID']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>