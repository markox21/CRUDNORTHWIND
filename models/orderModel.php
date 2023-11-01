<?php
require 'connection.php';

class OrderModel {

    private $database;
    public function __construct() {
        $this->database = new Connection();
    
    }

    public function getOrders() {
        $pdo = $this->database->connect();
        $query = "CALL Sp_Mostrar_Orden()";
        $stmt = $pdo->query($query);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function selectOrder($id) {
        try {
         $pdo = $this->database->connect();
         $stmt = $pdo->prepare("SELECT * FROM orders WHERE OrderID = ?");
         $stmt-> execute([$id]);
         return $stmt->fetch(PDO::FETCH_OBJ);
        } catch (PDOException $e) {
         return $e->getMessage();
        }
    }

    public function editOrders($orderID, $companyName, $contactName, $shipper, $phone, $productName, $unitPrice, $quantity, $discount) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Upd_Orders(:ord_ID, :)");
            
            $stmt->bindParam(':C_Customer', $orderID, PDO::PARAM_STR);
            $stmt->bindParam(':C_CompanyName', $companyName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactName', $contactName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactTitle', $shipper, PDO::PARAM_STR);
            $stmt->bindParam(':C_Adress', $phone, PDO::PARAM_STR);
            $stmt->bindParam(':C_City', $productName, PDO::PARAM_STR);
            $stmt->bindParam(':C_Region', $unitPrice, PDO::PARAM_STR);
            $stmt->bindParam(':C_PostalCode', $quantity, PDO::PARAM_STR);
            $stmt->bindParam(':C_Country', $discount, PDO::PARAM_STR);

            $stmt->execute();
        
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }


    public function deleteOrder($id) {
        try{
            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Del_Orders(:ord_ID)");

            $stmt->bindParam(':ord_ID', $id, PDO::PARAM_STR);

            $stmt->execute();
        }
        catch(PDOException $e){
            return $e->getMessage();
        }
    }
}
