<?php
require 'connection.php';

class CustomerModel {
    private $database;

    public function __construct() {
        $this->database = new Connection();
    }
    /**
     *
     * @return array
     * */

    public function getCustomers() {
        $pdo = $this->database->connect();
        $query = "CALL Sp_Mostrar_Cliente()";
        $stmt = $pdo->query($query);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function selectCustomer($id) {
        try {
         $pdo = $this->database->connect();
         $query = "CALL Sp_Read_Cliente(:C_ID)";
         $stmt = $pdo->prepare($query);
         $stmt->bindParam(':C_ID', $id, PDO::PARAM_STR);
         $stmt-> execute();

         return $stmt->fetch(PDO::FETCH_OBJ);
         
        } catch (PDOException $e) {
         return $e->getMessage();
        }
         
    }


    public function insertCustomer($companyName, $contactName, $contactTitle, $adress, $city, $region, $postalCode, $country, $phone, $fax) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Ins_Cliente(:C_CompanyName, :C_ContactName, :C_ContactTitle, :C_Adress, :C_City, :C_Region, :C_PostalCode, :C_Country, :C_Phone, :C_Fax)");
            
            $stmt->bindParam(':C_CompanyName', $companyName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactName', $contactName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactTitle', $contactTitle, PDO::PARAM_STR);
            $stmt->bindParam(':C_Adress', $adress, PDO::PARAM_STR);
            $stmt->bindParam(':C_City', $city, PDO::PARAM_STR);
            $stmt->bindParam(':C_Region', $region, PDO::PARAM_STR);
            $stmt->bindParam(':C_PostalCode', $postalCode, PDO::PARAM_STR);
            $stmt->bindParam(':C_Country', $country, PDO::PARAM_STR);
            $stmt->bindParam(':C_Phone', $phone, PDO::PARAM_STR);
            $stmt->bindParam(':C_Fax', $fax, PDO::PARAM_STR);
           /*  $stmt->bindParam(':C_Customer', $customerID, PDO::PARAM_STR); */

            return $stmt->execute();
        
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }


 /**
     * 
     * @param string $customerID
     * @param string $categoryName
     * @param string $productName
     * @param string $quantityPerUnit
     * @param float $unitPrice
     * @param int $unitsInStock
     * @param int $unitsOnOrder
     * @param int $reorderLevel
     * @param int $discontinued
     * @return string
     */


    public function editCustomer($customerID, $companyName, $contactName, $contactTitle, $adress, $city, $region, $postalCode, $country, $phone, $fax) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Upd_Cliente(:C_ID, :C_CompanyName, :C_ContactName, :C_ContactTitle, :C_Adress, :C_City, :C_Region, :C_PostalCode, :C_Country, :C_Phone, :C_Fax)");
            
            $stmt->bindParam(':C_ID', $customerID, PDO::PARAM_STR);
            $stmt->bindParam(':C_CompanyName', $companyName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactName', $contactName, PDO::PARAM_STR);
            $stmt->bindParam(':C_ContactTitle', $contactTitle, PDO::PARAM_STR);
            $stmt->bindParam(':C_Adress', $adress, PDO::PARAM_STR);
            $stmt->bindParam(':C_City', $city, PDO::PARAM_STR);
            $stmt->bindParam(':C_Region', $region, PDO::PARAM_STR);
            $stmt->bindParam(':C_PostalCode', $postalCode, PDO::PARAM_STR);
            $stmt->bindParam(':C_Country', $country, PDO::PARAM_STR);
            $stmt->bindParam(':C_Phone', $phone, PDO::PARAM_STR);
            $stmt->bindParam(':C_Fax', $fax, PDO::PARAM_STR);

            return $stmt->execute();
        
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }


    public function deleteCustomer($id) {
        try{
            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Del_Cliente(:clienteID)");

            $stmt->bindParam(':clienteID', $id, PDO::PARAM_STR);

            return $stmt->execute();
        }
        catch(PDOException $e){
            return $e->getMessage();
        }
    }

}
