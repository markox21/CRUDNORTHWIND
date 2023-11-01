<?php
    require('../../models/categoryModel.php');

    if ($_POST) {
        $CategoryIDUpdate = $_POST['CategoryIDUpdate'];
        $CategoryNameUpdate = $_POST['CategoryNameUpdate'];
        $CategoryDescriptionUpdate = $_POST['CategoryDescriptionUpdate'];
        /* $PictureUpdate = $_POST['PictureUpdate']; */

        $update = new CategoryModel;
        $result = $update->editCategory(
            $CategoryIDUpdate, $CategoryNameUpdate, 
            $CategoryDescriptionUpdate);

        header("location: ../../views/categories"); 
    }
?>