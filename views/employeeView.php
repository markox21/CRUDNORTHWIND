<!DOCTYPE html>
<html>
<head>
    <title>Lista de Trabajadores</title>
</head>
<body>
    <h1>Lista de Trabajadores</h1>
    <table border="1">
        <tr>
            <th>EmployeeID</th>
            <th>Reports To</th>
            <th>Last Name</th>
            <th>First Name</th>
            <th>Title</th>
            <th>TerritoryDescription</th>
            <th>RegionDescription</th>
            <th>Action</th>
        </tr>
        <?php
        require("../controller/employeesController.php");
        $controller = new EmployeeController();
        $employees = $controller->showEmployee();
        
        foreach ($employees as $employee) : ?>
            <tr>
                <td><?php echo $employee['ID_Empleado']; ?></td>
                <td><?php echo $employee['Encargado']; ?></td>
                <td><?php echo $employee['Apellidos']; ?></td>
                <td><?php echo $employee['Nombre']; ?></td>
                <td><?php echo $employee['Titulo']; ?></td>
                <td><?php echo $employee['Territorio']; ?></td>
                <td><?php echo $employee['Region']; ?></td>
                <td>
                <a href="../controller/employeeController/employeeDeleteController.php?id=<?php echo $employee['ID_Empleado']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>