<?php
require '../../models/orderModel.php';

class OrderController {
    public function showOrders() {
        $orderModel = new OrderModel();
        $orders = $orderModel->getOrders();
        return $orders;

        require '../../views/order/orderView.php';
    }

    public function showUpdateOrders($id){
        $orderModel = new OrderModel();
        $orderController = $orderModel->selectOrder($id);
        
        return $orderController;
    }
}