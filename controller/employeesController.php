<?php
require_once '../models/employeeModel.php';
class EmployeeController {
    public function showEmployee() {
        $employeeModel = new EmployeeModel();
        $employees = $employeeModel->getEmployees();

        return $employees;
        
        require '../views/employeeView.php';
    }
}

// $controller = new EmployeeController();
// $employees = $controller->showEmployee();