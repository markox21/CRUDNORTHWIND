<?php 
require("../../models/customerModel.php");


$customerModel = new customerModel();

$customerModel->deleteCustomer($_GET['id']);

header("Location: ../../views/customer/index.php");

?>