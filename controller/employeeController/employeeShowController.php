<?php
require '../../models/employeeModel.php';
class EmployeeController {
    public function showEmployee() {
        $employeeModel = new EmployeeModel();
        $employees = $employeeModel->getEmployees();

        return $employees;
        
    }

    public function showOneEmployee($id) {
        $employeeModel = new EmployeeModel();
        $employees = $employeeModel->getOneEmployee($id);

        return $employees;
    }
}

// $controller = new EmployeeController();
// $employees = $controller->showEmployee();