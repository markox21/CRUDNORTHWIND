<?php

require("../../models/employeeModel.php");

$employeeModel = new EmployeeModel();

$employeeModel->deleteEmployee($_GET['id']);

header("Location: ../../views/employee");

?>