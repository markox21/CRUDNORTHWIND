<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <h1>Registrar Order</h1>

    <form action="../../controller/orderController/orderEditController.php" method="post">

        <label for="OrderID">OrderId</label>
        <input type="text" name= "OrderID"><br>
        <label for="CustomerID">CustomerID</label>
        <input type="text" name="CustomerID"><br>

        <label for="EmployeeID">EmployeeID</label>
        <input type="text" name="EmployeeID"><br>
        <label for="OrderDate">OrderDate</label>
        <input type="text" name="OrderDate"><br>

        <label for="RequiredDate">RequiredDate</label>
        <input type="text" name="RequiredDate"><br>
        <label for="ShippedDate">ShippedDate</label>
        <input type="text" name="ShippedDate"><br>
        <label for="ShipVia">ShipVia</label>
        <input type="text" name="ShipVia"><br>

        <label for="Freight">Freight</label>
        <input type="text" name="Freight"><br>
        <label for="ShipName">ShipName</label>
        <input type="text" name="ShipName"><br>

        <label for="ShipAddress">ShipAddress</label>
        <input type="text" name="ShipAddress"><br>
        <label for="ShipCity">ShipCity</label>
        <input type="text" name="ShipCity"><br>

        <label for="ShipRegionUpdate">ShipRegion</label>
        <input type="text" name="ShipRegion" ><br>
        <label for="ShipPostalCode">ShipPostalCode</label>
        <input type="text" name="ShipPostalCode" ><br>

        <label for="ShipCountry">ShipCountry</label>
        <input type="text" name="ShipCountry"><br>
        
        <button type="submit">Confirmar</button>
    </form>
</body>
</html>