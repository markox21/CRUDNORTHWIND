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

    public function getOneOrder($id) {
        try {
            $pdo = $this->database->connect();
            $query = "CALL Sp_Read_Orden(:ORD_ID)";
            $stmt = $pdo->prepare($query);
            $stmt->bindParam(':ORD_ID', $id, PDO::PARAM_STR);
            $stmt-> execute();
   
            return $stmt->fetch(PDO::FETCH_OBJ);
            
           } catch (PDOException $e) {
            return $e->getMessage();
           }
    }

    public function insertOrders($CustomerID, $EmployeeID, $OrderDate, $RequiredDate, $ShippedDate, $ShipVia, $Freight, $ShipName, $ShipAddress, $ShipCity, $ShipRegion, $ShipPostalCode, $ShipCountry) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Ins_Order(:ord_CustomerID :ord_EmployeeID, :ord_ShipVia, :ord_OrderDate, :ord_RequiredDate, :ord_ShippedDate, :ord_Freight, :ord_ShipName, :ord_ShipAddress, :ord_ShipCity, :ord_ShipRegion, :ord_ShipPostalCode, :ord_ShipCountry,)");
            
            $stmt->bindParam(':ord_CustomerID', $CustomerID, PDO::PARAM_STR);
            $stmt->bindParam(':ord_EmployeeID', $EmployeeID, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipVia', $OrderDate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_OrderDate', $RequiredDate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_RequiredDate', $ShippedDate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShippedDate', $ShipVia, PDO::PARAM_STR);
            $stmt->bindParam(':ord_Freight', $Freight, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipName', $ShipName, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipAddress', $ShipAddress, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipCity', $ShipCity, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipRegion', $ShipRegion, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipPostalCode', $ShipPostalCode, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipCountry', $ShipCountry, PDO::PARAM_STR);

            $stmt->execute();
        
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }

    public function editOrders($OrderIDUpdate, $CustomerIDUpdate, $EmployeeIDUpdate, $OrderDateUpdate, $RequiredDateUpdate, $ShippedDateUpdate, $ShipViaUpdate, $FreightUpdate, $ShipNameUpdate, $ShipAddressUpdate, $ShipCityUpdate, $ShipRegionUpdate, $ShipPostalCodeUpdate, $ShipCountryUpdate) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Upd_Order(:ord_OrderID, :ord_CustomerContactName, :ord_EmployeeFullName, :ord_ShipViaCompanyName, :ord_OrderDate, :ord_RequiredDate, :ord_ShippedDate, :ord_Freight, :ord_ShipName, :ord_ShipAddress, :ord_ShipCity, :ord_ShipRegion, :ord_ShipPostalCode, :ord_ShipCountry)");
            
            $stmt->bindParam(':ord_OrderID', $OrderIDUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_CustomerContactName', $CustomerIDUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_EmployeeFullName', $EmployeeIDUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipViaCompanyName', $OrderDateUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_OrderDate', $RequiredDateUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_RequiredDate', $ShippedDateUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShippedDate', $ShipViaUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_Freight', $FreightUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipName', $ShipNameUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipAddress', $ShipAddressUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipCity', $ShipCityUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipRegion', $ShipRegionUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipPostalCode', $ShipPostalCodeUpdate, PDO::PARAM_STR);
            $stmt->bindParam(':ord_ShipCountry', $ShipCountryUpdate, PDO::PARAM_STR);

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
