<?php 
require("../../models/orderModel.php");


$orderModel = new OrderModel();

$orderModel->deleteOrder($_GET['id']);

header("Location: ../../views/order/orderView.php");

?>