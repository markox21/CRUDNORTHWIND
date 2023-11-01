<?php
require 'connection.php';

class ProductModel {
    private $database;

    public function __construct() {
        $this->database = new Connection();
    }

    /**
     * @return array
     */
    public function getProducts() {
        try {
            $pdo = $this->database->connect();
            $query = "CALL Sp_Mostrar_Prod()";
            $stmt = $pdo->query($query);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);

        } catch (PDOException $e) {
            return "Error al insertar el producto: " . $e->getMessage();
        } 
    }

    public function getOneProduct($id) {
        try {
            $pdo = $this->database->connect();
            $query = "CALL Sp_Read_Productos(:PRO_ID)";
            $stmt = $pdo->prepare($query);
            $stmt->bindParam(':PRO_ID', $id, PDO::PARAM_STR);
            $stmt-> execute();
   
            return $stmt->fetch(PDO::FETCH_OBJ);

        } catch (PDOException $e) {
            return $e->getMessage();
        } 
    }

    /**
     * 
     * @param string $companyName
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
    public function insertProduct($productName, $companyName, $categoryName, $quantityPerUnit, $unitPrice, $unitsInStock, $unitsOnOrder, $reorderLevel, $discontinued) {
        try {
            $pdo = $this->database->connect();
        
            $stmt = $pdo->prepare("CALL Sp_Ins_Producto(:P_ProductName, :P_CompanyName, :P_CategoryName, :P_QuantityPerUnit, :P_UnitPrice, :P_UnitsInStock, :P_UnitsOnOrder, :P_ReorderLevel, :P_Discontinued)");
    
            $stmt->bindParam(':P_ProductName', $productName, PDO::PARAM_STR);
            $stmt->bindParam(':P_CompanyName', $companyName, PDO::PARAM_STR);
            $stmt->bindParam(':P_CategoryName', $categoryName, PDO::PARAM_STR);
            $stmt->bindParam(':P_QuantityPerUnit', $quantityPerUnit, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitPrice', $unitPrice, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitsInStock', $unitsInStock, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitsOnOrder', $unitsOnOrder, PDO::PARAM_STR);
            $stmt->bindParam(':P_ReorderLevel', $reorderLevel, PDO::PARAM_STR);
            $stmt->bindParam(':P_Discontinued', $discontinued, PDO::PARAM_STR);
    
            return $stmt->execute();

        } catch (PDOException $e) {
            return "Error al insertar el producto: " . $e->getMessage();
        }
    }

    public function updateProduct($productId, $productName, $companyName, $categoryName, $quantityPerUnit, $unitPrice, $unitsInStock, $unitsOnOrder, $reorderLevel, $discontinued) {
        try {
            $pdo = $this->database->connect();
        
            $stmt = $pdo->prepare("CALL Sp_Upd_Producto(:P_ProductID, :P_ProductName, :P_CompanyName, :P_CategoryName, :P_QuantityPerUnit, :P_UnitPrice, :P_UnitsInStock, :P_UnitsOnOrder, :P_ReorderLevel, :P_Discontinued)");
    
            $stmt->bindParam(':P_ProductID', $productId, PDO::PARAM_STR);
            $stmt->bindParam(':P_ProductName', $productName, PDO::PARAM_STR);
            $stmt->bindParam(':P_CompanyName', $companyName, PDO::PARAM_STR);
            $stmt->bindParam(':P_CategoryName', $categoryName, PDO::PARAM_STR);
            $stmt->bindParam(':P_QuantityPerUnit', $quantityPerUnit, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitPrice', $unitPrice, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitsInStock', $unitsInStock, PDO::PARAM_STR);
            $stmt->bindParam(':P_UnitsOnOrder', $unitsOnOrder, PDO::PARAM_STR);
            $stmt->bindParam(':P_ReorderLevel', $reorderLevel, PDO::PARAM_STR);
            $stmt->bindParam(':P_Discontinued', $discontinued, PDO::PARAM_STR);
    
            return $stmt->execute();

        } catch (PDOException $e) {
            return "Error al insertar el producto: " . $e->getMessage();
        }
    }
    

    public function deleteProduct($id) {
        try {
            $pdo = $this->database->connect();
        
            $stmt = $pdo->prepare("CALL Sp_Del_Producto(:productoID)");
        
            $stmt->bindParam(':productoID', $id, PDO::PARAM_INT);
                
            $stmt->execute();

        } catch (PDOException $e) {
            return $e->getMessage();
        }
    }
    
}