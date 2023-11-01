<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Listado de Clientes</title>
</head>
<body>
    <h1>Listado de Clientes</h1>

    <a href="customerInsert.php">Registrar</a>
    <table border="1">
        <tr>
            <th>Customer ID</th>
            <th>Company Name</th>
            <th>Contact Name</th>
            <th>Contact Title</th>
            <th>Address</th>
            <th>City</th>
            <th>Region</th>
            <th>Postal Code</th>
            <th>Country</th>
            <th>Phone</th>
            <th>Fax</th>
            <th>Actions</th>
        </tr>
        
        <?php
        require("../../controller/customerController/customerShowController.php");
        $controller = new CustomerController();
        $customers = $controller->showCustomers();

        foreach ($customers as $customer) : ?>
            <tr>
                <td><?php echo $customer['CustomerID']; ?></td>
                <td><?php echo $customer['CompanyName']; ?></td>
                <td><?php echo $customer['ContactName']; ?></td>
                <td><?php echo $customer['ContactTitle']; ?></td>
                <td><?php echo $customer['Address']; ?></td>
                <td><?php echo $customer['City']; ?></td>
                <td><?php echo $customer['Region']; ?></td>
                <td><?php echo $customer['PostalCode']; ?></td>
                <td><?php echo $customer['Country']; ?></td>
                <td><?php echo $customer['Phone']; ?></td>
                <td><?php echo $customer['Fax']; ?></td>
                <td>
                    <a href="customerEdit.php?id=<?php echo $customer['CustomerID'];?>">Editar</a>

                    <a href="../../controller/customerController/customerDeleteController.php?id=<?php echo $customer['CustomerID']; ?>">Eliminar</a>
                </td>
            </tr>
        <?php endforeach;
        ?>
    </table>
</body>
</html>
