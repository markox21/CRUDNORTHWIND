<?php
require 'connection.php';

class EmployeeModel {
    public function getEmployees() {
        $database = new Connection();
        $pdo = $database->connect();
        $query = "CALL Sp_Mostrar_Emple()";
        $stmt = $pdo->query($query);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function deleteEmployee($id) {

        $database = new Connection();
        $pdo = $database->connect();
        $query = "CALL Sp_Del_Empleado(:empleadoID)";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":empleadoID", $id, PDO::PARAM_INT);
        $stmt->execute();
    
    }
}