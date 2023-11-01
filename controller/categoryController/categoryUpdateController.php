<?php
    require('../../models/categoryModel.php');

    if ($_POST) {
        $CategoryIDUpdate = $_POST['CategoryIDUpdate'];
        $CategoryNameUpdate = $_POST['CategoryNameUpdate'];
        $CategoryDescriptionUpdate = $_POST['CategoryDescriptionUpdate'];
        $PictureUpdate = $_POST['PictureUpdate'];

        $update = new CategoryModel;
        $result = $update->editCategory($categoryName, $categoryDescription, $picture, $CategoryIDUpdate);

        header("location: ../../views/categories/categoryView.php");
    }
?>