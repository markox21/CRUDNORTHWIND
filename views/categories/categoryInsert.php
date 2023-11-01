<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CategoryInsert</title>
</head>
<body>
        <form action="../../controller/categoryController/categoryInsertController.php" method="post">
            <label for="CategoryName">Category Name</label>
            <input type="text" name= "CategoryName"><br>
            <label for="Description">Description</label>
            <input type="text" name="Description"><br>
            <label for="Picture">Picture</label>
            <input type="text" name="Picture"><br>

            <button type="submit">Confirmar</button>
        </form>
</body>
</html>