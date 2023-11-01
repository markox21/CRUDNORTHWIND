<?php 
require ("../../models/categoryModel.php");

$recibirID = $_GET['id'];

$categoryModel = new categoryModel();

$categoryModel->deleteCategory($recibirID);

header("Location: ../../views/categories");

?>