<?php
require '../../models/customerModel.php';

class CustomerController {
    public function showCustomers() {
        $customerModel = new CustomerModel();
        $customers = $customerModel->getCustomers();

        return $customers;
    
        require '../../views/customer/index.php';
    }

    public function showUpdateCustomer($id) {
        $customerModel = new CustomerModel();
        $customerController = $customerModel->selectCustomer($id);

        return $customerController;
    }
}
