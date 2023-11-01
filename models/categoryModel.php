<?php
require 'connection.php';

class CategoryModel {
    private $database;

    public function __construct() {
        $this->database = new Connection();
    }
    /**
     *
     * @return array
     * */

    public function getCategories() {
        $pdo = $this->database->connect();
        $query = "CALL Sp_Mostrar_Categories()";
        $stmt = $pdo->query($query);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function selectCategory($id) {
        try {
         $pdo = $this->database->connect();
         $stmt = $pdo->prepare("CALL Sp_Read_Category(:cat_ID)");
         $stmt->bindParam(':cat_ID', $id, PDO::PARAM_STR);

         $stmt-> execute();

         return $stmt->fetch(PDO::FETCH_OBJ);
         
        } catch (PDOException $e) {
         return $e->getMessage();
        }
    }

    public function insertCategory($categoryName, $categoryDescription) {
        try{
            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Ins_Categories(:cat_Name, :cat_Description)");

            $stmt->bindParam(':cat_Name', $categoryName, PDO::PARAM_STR);
            $stmt->bindParam(':cat_Description', $categoryDescription, PDO::PARAM_STR);
           /*  $stmt->bindParam(':cat_Picture', $picture, PDO::PARAM_STR); */

            return $stmt->execute();
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }


    public function editCategory($catID, $categoryName, $categoryDescription) {
        try{

            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Upd_Categories(:cat_ID, :cat_Name, :cat_Description)");
            
            $stmt->bindParam(':cat_ID', $catID, PDO::PARAM_STR);
            $stmt->bindParam(':cat_Name', $categoryName, PDO::PARAM_STR);
            $stmt->bindParam(':cat_Description', $categoryDescription, PDO::PARAM_STR);

            return $stmt->execute();
        
        }
        catch(PDOException $e){
            echo $e->getMessage();
        }
    }

    public function deleteCategory($id) {
        try{
            $pdo = $this->database->connect();

            $stmt = $pdo->prepare("CALL Sp_Del_Categories(:cat_ID)");

            $stmt->bindParam(':cat_ID', $id, PDO::PARAM_INT);

            $stmt->execute();
        }
        catch(PDOException $e){
            return $e->getMessage();
        }
    }
}