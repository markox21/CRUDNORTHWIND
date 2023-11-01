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
        

        <section  class="section-all-container">
            <div class="content-registrer-form">
                <h2>Registrar Cliente</h2>
                    <form action="../../controller/customerController/customerInsertController.php" method="post" class="form-types">
                    <!--  <label for="CustomerID">ID customer</label>
                        <input type="text" name= "CustomerID"><br> -->
                        <label for="CompanyName">Company Name</label>
                        <input type="text" name="CompanyName"><br>
                        <label for="ContactName">Contact Name</label>
                        <input type="text" name="ContactName"><br>
                        <label for="ContactTitle">Contact Title</label>
                        <input type="text" name="ContactTitle"><br>
                        <label for="Address">Address</label>
                        <input type="text" name="Address"><br>
                        <label for="City">City</label>
                        <input type="text" name="City"><br>
                        <label for="Region">Region</label>
                        <input type="text" name="Region"><br>
                        <label for="PostalCode">Posta Code</label>
                        <input type="text" name="PostalCode"><br>
                        <label for="Country">Country</label>
                        <input type="text" name="Country"><br>
                        <label for="PhoneUpdate">Phone</label>
                        <input type="text" name="Phone"><br>
                        <label for="Fax">Fax</label>
                        <input type="text" name="Fax"><br>

                        <button type="submit" class="btn-submit">Confirmar</button>
                    </form>
            </div>
        </section>
</body>
</html>