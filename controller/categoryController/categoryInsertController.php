<?php
    require("../../models/categoryModel.php");

    if ($_POST) {
        $CategoryName = $_POST['CategoryName'];
        $Description = $_POST['Description'];
        $Picture = $_POST['Picture'];

        $update = new CategoryModel;
        $result = $update->insertCategory($CategoryName, $Description, $Picture);

        header("location: ../../views/categories/categoryView.php");
    }
?>