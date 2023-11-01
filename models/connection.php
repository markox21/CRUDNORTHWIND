<?php 

class Connection{
    static public function connect(){
        $connection = new PDO("mysql:host=localhost;dbname=northwind", "root", "");
        return $connection;
    }
}