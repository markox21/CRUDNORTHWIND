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

    public function getOneEmployee($id) {
        try {
            $database = new Connection();
            $pdo = $database->connect();
            $query = "CALL Sp_Read_Empleado(:EMP_ID)";
            $stmt = $pdo->prepare($query);
            $stmt->bindParam(':EMP_ID', $id, PDO::PARAM_STR);
            $stmt-> execute();
   
            return $stmt->fetch(PDO::FETCH_OBJ);
            
           } catch (PDOException $e) {
            return $e->getMessage();
           }
    }

    public function insertEmployee(
        $employeeLastName, $employeeFirstName, 
        $employeeTitle, $employeeTitleCourtesy, 
        $employeeBirthDate, $employeeHireDate, 
        $employeeAddress, $employeeCity, 
        $employeeRegion, $employeePostalCode, 
        $employeeCountry, $employeeHomePhone, 
        $employeeReportTo
        ) {
            try{
                $database = new Connection();
                $pdo = $database->connect();
    
                $stmt = $pdo->prepare("CALL Sp_Ins_Empleado(:E_LastName, :E_FirstName, :E_Title, :E_TitleOfCourtesy, :E_BirthDate, :E_HireDate, :E_Address, :E_City, :E_Region, :E_PostalCode, :E_Country, :E_HomePhone, :E_ReportsToName)");
                
                $stmt->bindParam(':E_LastName', $employeeLastName, PDO::PARAM_STR);
                $stmt->bindParam(':E_FirstName', $employeeFirstName, PDO::PARAM_STR);
                $stmt->bindParam(':E_Title', $employeeTitle, PDO::PARAM_STR);
                $stmt->bindParam(':E_TitleOfCourtesy', $employeeTitleCourtesy, PDO::PARAM_STR);
                $stmt->bindParam(':E_BirthDate', $employeeBirthDate, PDO::PARAM_STR);
                $stmt->bindParam(':E_HireDate', $employeeHireDate, PDO::PARAM_STR);
                $stmt->bindParam(':E_Address', $employeeAddress, PDO::PARAM_STR);
                $stmt->bindParam(':E_City', $employeeCity, PDO::PARAM_STR);
                $stmt->bindParam(':E_Region', $employeeRegion, PDO::PARAM_STR);
                $stmt->bindParam(':E_PostalCode', $employeePostalCode, PDO::PARAM_STR);
                $stmt->bindParam(':E_Country', $employeeCountry, PDO::PARAM_STR);
                $stmt->bindParam(':E_HomePhone', $employeeHomePhone, PDO::PARAM_STR);
                $stmt->bindParam(':E_ReportsToName', $employeeReportTo, PDO::PARAM_STR);
    
                return $stmt->execute();
            
            }
            catch(PDOException $e){
                echo $e->getMessage();
            }
    }

    public function updateEmployee(
        $employeeid, $employeeLastName, 
        $employeeFirstName, $employeeTitle, 
        $employeeTitleCourtesy, $employeeBirthDate, 
        $employeeHireDate, $employeeAddress, 
        $employeeCity, $employeeRegion, 
        $employeePostalCode, $employeeCountry, 
        $employeeHomePhone, $employeeReportTo
        ) {
            try{
                $database = new Connection();
                $pdo = $database->connect();
    
                $stmt = $pdo->prepare("CALL Sp_Upd_Empleado(:E_ID, :E_LastName, :E_FirstName, :E_Title, :E_TitleOfCourtesy, :E_BirthDate, :E_HireDate, :E_Address, :E_City, :E_Region, :E_PostalCode, :E_Country, :E_HomePhone, :E_ReportsToName)");
                
                $stmt->bindParam(':E_ID', $employeeid, PDO::PARAM_STR);
                $stmt->bindParam(':E_LastName', $employeeLastName, PDO::PARAM_STR);
                $stmt->bindParam(':E_FirstName', $employeeFirstName, PDO::PARAM_STR);
                $stmt->bindParam(':E_Title', $employeeTitle, PDO::PARAM_STR);
                $stmt->bindParam(':E_TitleOfCourtesy', $employeeTitleCourtesy, PDO::PARAM_STR);
                $stmt->bindParam(':E_BirthDate', $employeeBirthDate, PDO::PARAM_STR);
                $stmt->bindParam(':E_HireDate', $employeeHireDate, PDO::PARAM_STR);
                $stmt->bindParam(':E_Address', $employeeAddress, PDO::PARAM_STR);
                $stmt->bindParam(':E_City', $employeeCity, PDO::PARAM_STR);
                $stmt->bindParam(':E_Region', $employeeRegion, PDO::PARAM_STR);
                $stmt->bindParam(':E_PostalCode', $employeePostalCode, PDO::PARAM_STR);
                $stmt->bindParam(':E_Country', $employeeCountry, PDO::PARAM_STR);
                $stmt->bindParam(':E_HomePhone', $employeeHomePhone, PDO::PARAM_STR);
                $stmt->bindParam(':E_ReportsToName', $employeeReportTo, PDO::PARAM_STR);
    
                return $stmt->execute();
            
            }
            catch(PDOException $e){
                echo $e->getMessage();
            }
    }

    public function deleteEmployee($id) {

       try {
        $database = new Connection();
        $pdo = $database->connect();
        $query = "CALL Sp_Del_Empleado(:empleadoID)";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":empleadoID", $id, PDO::PARAM_INT);

        return $stmt->execute();

       } catch (PDOException $e){
        echo $e->getMessage();
       }
    
    }
}