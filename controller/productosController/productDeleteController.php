<?php
require "../../models/productModel.php";


$productModel = new productModel();

$productModel->deleteProduct($_GET['id']);

header("Location: ../../views/productosView.php");

?>