-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-11-2023 a las 06:59:04
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `northwind`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Del_Categories` (IN `cat_ID` INT)   BEGIN
    DELETE FROM Categories WHERE CategoryID = cat_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Del_Cliente` (IN `clienteID` CHAR(5))   BEGIN

    DELETE FROM orders WHERE CustomerID = clienteID;
    DELETE FROM customers WHERE CustomerID = clienteID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Del_Empleado` (IN `empleadoID` INT)   BEGIN
    DECLARE supervisorCount INT;
    SELECT COUNT(*) INTO supervisorCount FROM employees WHERE ReportsTo = empleadoID;
    IF supervisorCount > 0 THEN
        SELECT 'No se puede eliminar. Este empleado es un encargado.' AS Message;
    ELSE
        
        DELETE FROM employeeterritories WHERE EmployeeID = empleadoID;
        DELETE FROM employees WHERE EmployeeID = empleadoID;
        SELECT 'Empleado y órdenes relacionadas eliminadas en cascada.' AS Message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Del_Orders` (IN `ord_ID` INT)   BEGIN
    DELETE FROM Orders WHERE OrderID = ord_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Del_Producto` (IN `productoID` INT)   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE tablaID INT;
    START TRANSACTION;
    DELETE FROM products WHERE ProductID = productoID;
    SELECT CategoryID INTO tablaID FROM products WHERE ProductID = productoID;
    DELETE FROM categories WHERE CategoryID = tablaID;
    SELECT SupplierID INTO tablaID FROM products WHERE ProductID = productoID;
    DELETE FROM suppliers WHERE SupplierID = tablaID;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Ins_Categories` (IN `cat_Name` VARCHAR(15), IN `cat_Description` LONGTEXT)   BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES (cat_Name, cat_Description);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Ins_Cliente` (IN `C_CompanyName` VARCHAR(40), IN `C_ContactName` VARCHAR(30), IN `C_ContactTitle` VARCHAR(30), IN `C_Address` VARCHAR(60), IN `C_City` VARCHAR(15), IN `C_Region` VARCHAR(15), IN `C_PostalCode` VARCHAR(10), IN `C_Country` VARCHAR(15), IN `C_Phone` VARCHAR(24), IN `C_Fax` VARCHAR(24))   BEGIN
    DECLARE incial VARCHAR(5);
    DECLARE pripalabra VARCHAR(20);
    DECLARE segpalabra VARCHAR(20);
    SET pripalabra = UPPER(SUBSTRING_INDEX(C_CompanyName, ' ', 1));
    SET segpalabra = CASE 
                        WHEN LENGTH(C_CompanyName) - LENGTH(REPLACE(C_CompanyName, ' ', '')) > 0 
                        THEN UPPER(SUBSTRING_INDEX(SUBSTRING_INDEX(C_CompanyName, ' ', 2), ' ', -1))
                        ELSE ''
                    END;
    SET incial = CONCAT(pripalabra, segpalabra);
    INSERT INTO customers(CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, CustomerID)
    VALUES (C_CompanyName, C_ContactName, C_ContactTitle, C_Address, C_City, C_Region, C_PostalCode, C_Country, C_Phone, C_Fax, incial);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Ins_Empleado` (IN `E_LastName` VARCHAR(20), IN `E_FirstName` VARCHAR(10), IN `E_Title` VARCHAR(30), IN `E_TitleOfCourtesy` VARCHAR(25), IN `E_BirthDate` DATETIME, IN `E_HireDate` DATETIME, IN `E_Address` VARCHAR(60), IN `E_City` VARCHAR(15), IN `E_Region` VARCHAR(15), IN `E_PostalCode` VARCHAR(10), IN `E_Country` VARCHAR(15), IN `E_HomePhone` VARCHAR(24), IN `E_ReportsToName` VARCHAR(50))   BEGIN
    DECLARE supervisorID INT;
    SELECT EmployeeID INTO supervisorID FROM employees
    WHERE CONCAT(FirstName, ' ', LastName) = E_ReportsToName;
        INSERT INTO employees(LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, ReportsTo)
        VALUES (E_LastName, E_FirstName, E_Title, E_TitleOfCourtesy, E_BirthDate, E_HireDate, E_Address, E_City, E_Region, E_PostalCode, E_Country, E_HomePhone, supervisorID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Ins_Order` (IN `ord_CustomerID` CHAR(5), IN `ord_EmployeeID` INT, IN `ord_ShipVia` INT, IN `ord_OrderDate` DATETIME, IN `ord_RequiredDate` DATETIME, IN `ord_ShippedDate` DATETIME, IN `ord_Freight` DOUBLE, IN `ord_ShipName` VARCHAR(40), IN `ord_ShipAddress` VARCHAR(60), IN `ord_ShipCity` VARCHAR(15), IN `ord_ShipRegion` VARCHAR(15), IN `ord_ShipPostalCode` VARCHAR(10), IN `ord_ShipCountry` VARCHAR(15))   BEGIN
    INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry)
    VALUES (ord_CustomerID, ord_EmployeeID, ord_OrderDate, ord_RequiredDate, ord_ShippedDate, ord_ShipVia, ord_Freight, ord_ShipName, ord_ShipAddress, ord_ShipCity, ord_ShipRegion, ord_ShipPostalCode, ord_ShipCountry);

    SELECT 'Inserción exitosa en Orders' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Ins_Producto` (IN `P_ProductName` VARCHAR(40), IN `P_CompanyName` VARCHAR(40), IN `P_CategoryName` VARCHAR(15), IN `P_QuantityPerUnit` VARCHAR(20), IN `P_UnitPrice` DOUBLE, IN `P_UnitsInStock` SMALLINT, IN `P_UnitsOnOrder` SMALLINT, IN `P_ReorderLevel` SMALLINT, IN `P_Discontinued` TINYINT)   BEGIN
    DECLARE supplier_id INT;
    DECLARE category_id INT;

    SELECT SupplierID INTO supplier_id FROM suppliers WHERE CompanyName = P_CompanyName;
    SELECT CategoryID INTO category_id FROM categories WHERE CategoryName = P_CategoryName;

    INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
    VALUES (P_ProductName, supplier_id, category_id, P_QuantityPerUnit, P_UnitPrice, P_UnitsInStock, P_UnitsOnOrder, P_ReorderLevel, P_Discontinued);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Mostrar_Categories` ()   BEGIN
    SELECT * FROM Categories;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Mostrar_Cliente` ()   BEGIN
    SELECT * FROM customers;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Mostrar_Emple` ()   BEGIN
    DECLARE employeeCount INT;
    SELECT COUNT(*) INTO employeeCount FROM employees;
    IF employeeCount > 0 THEN
        
        SELECT 
            E.EmployeeID,
            E.LastName,
            E.FirstName,
            E.Title,
            E.TitleOfCourtesy,
            E.BirthDate,
            E.HireDate,
            E.Address,
            E.City,
            E.Region,
            E.PostalCode,
            E.Country,
            E.HomePhone,
            COALESCE(CONCAT(S.FirstName, ' ', S.LastName), 'Supervisor') AS ReportsToName 
        FROM employees E
        LEFT JOIN employees S ON E.ReportsTo = S.EmployeeID;
    ELSE
        SELECT 'Empleado no encontrado.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Mostrar_Orden` ()   BEGIN
    SELECT *
    FROM Orders;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Mostrar_Prod` ()   BEGIN
    SELECT
        P.ProductID AS ID_P,
        P.ProductName AS Nombre_del_Producto,
        -- S.SupplierID AS ID_S,
        S.CompanyName AS Empresa,
        -- Cat.CategoryID AS ID_Cat,
        Cat.CategoryName AS Categoria,
        P.QuantityPerUnit AS Cantidad_x_Precio,
        P.UnitPrice AS Precio_Unitario,
        P.UnitsInStock AS Stock,
        P.UnitsOnOrder AS Orden,
        P.ReorderLevel AS Niveles,
        P.Discontinued AS Discontinued
    FROM products AS P
    INNER JOIN suppliers S ON P.`SupplierID` = S.`SupplierID`
    INNER JOIN categories Cat ON P.`CategoryID` = Cat.`CategoryID`
    ORDER BY P.ProductID ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Read_Category` (IN `CAT_ID` INT)   BEGIN
    SELECT *
    FROM categories
    WHERE CategoryID = CAT_ID
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Read_Cliente` (IN `C_ID` CHAR(5))   BEGIN
    SELECT *
    FROM customers
    WHERE CustomerID = C_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Read_Empleado` (IN `EMP_ID` INT)   BEGIN
    SELECT *
    FROM employees
    WHERE EmployeeID = EMP_ID
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Read_Orden` (IN `ORD_ID` INT)   BEGIN
    SELECT * 
    FROM orders 
    WHERE OrderID = ORD_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Read_Productos` (IN `PRO_ID` INT)   BEGIN
    SELECT 
        P.ProductID,
        P.ProductName,
        IFNULL(S.CompanyName, 'No Supplier') AS SupplierName,
        IFNULL(C.CategoryName, 'No Category') AS CategoryName,
        P.QuantityPerUnit,
        P.UnitPrice,
        P.UnitsInStock,
        P.UnitsOnOrder,
        P.ReorderLevel,
        P.Discontinued
    FROM products P
    LEFT JOIN Suppliers S ON P.SupplierID = S.SupplierID
    LEFT JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE P.ProductID = PRO_ID
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Upd_Categories` (IN `cat_ID` INT, IN `cat_Name` VARCHAR(15), IN `cat_Description` LONGTEXT)   BEGIN
    UPDATE Categories 
    SET CategoryName = cat_Name, Description = cat_Description
    WHERE CategoryID = cat_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Upd_Cliente` (IN `C_ID` CHAR(5), IN `C_CompanyName` VARCHAR(40), IN `C_ContactName` VARCHAR(30), IN `C_ContactTitle` VARCHAR(30), IN `C_Address` VARCHAR(60), IN `C_City` VARCHAR(15), IN `C_Region` VARCHAR(15), IN `C_PostalCode` VARCHAR(10), IN `C_Country` VARCHAR(15), IN `C_Phone` VARCHAR(24), IN `C_Fax` VARCHAR(24))   BEGIN
    DECLARE record INT DEFAULT 0;
    DECLARE incial VARCHAR(5);
    DECLARE pripalabra VARCHAR(20);
    DECLARE segpalabra VARCHAR(20);
    SELECT COUNT(*) INTO record FROM customers WHERE CustomerID = C_ID;
    IF record > 0 THEN
        SET pripalabra = UPPER(SUBSTRING_INDEX(C_CompanyName, ' ', 1));
        SET segpalabra = CASE 
                            WHEN LENGTH(C_CompanyName) - LENGTH(REPLACE(C_CompanyName, ' ', '')) > 0 
                            THEN UPPER(SUBSTRING_INDEX(SUBSTRING_INDEX(C_CompanyName, ' ', 2), ' ', -1))
                            ELSE ''
                        END;
        SET incial = CONCAT(pripalabra, segpalabra);
        UPDATE customers
        SET 
            CompanyName = C_CompanyName,
            ContactName = C_ContactName,
            ContactTitle = C_ContactTitle,
            Address = C_Address,
            City = C_City,
            Region = C_Region,
            PostalCode = C_PostalCode,
            Country = C_Country,
            Phone = C_Phone,
            Fax = C_Fax,
            CustomerID = incial
        WHERE CustomerID = C_ID;
        SELECT 'Registro actualizado exitosamente.' AS Message;
    ELSE
        SELECT 'No se encontró ningún registro con el CustomerID proporcionado.' AS Message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Upd_Empleado` (IN `E_ID` INT, IN `E_LastName` VARCHAR(20), IN `E_FirstName` VARCHAR(10), IN `E_Title` VARCHAR(30), IN `E_TitleOfCourtesy` VARCHAR(25), IN `E_BirthDate` DATETIME, IN `E_HireDate` DATETIME, IN `E_Address` VARCHAR(60), IN `E_City` VARCHAR(15), IN `E_Region` VARCHAR(15), IN `E_PostalCode` VARCHAR(10), IN `E_Country` VARCHAR(15), IN `E_HomePhone` VARCHAR(24), IN `E_ReportsTo` INT)   BEGIN
    DECLARE supervisorName VARCHAR(50);
    SELECT CONCAT(FirstName, ' ', LastName) INTO supervisorName
    FROM employees 
    WHERE EmployeeID = E_ReportsTo;
    UPDATE employees 
    SET LastName = E_LastName, 
        FirstName = E_FirstName, 
        Title = E_Title, 
        TitleOfCourtesy = E_TitleOfCourtesy, 
        BirthDate = E_BirthDate, 
        HireDate = E_HireDate, 
        Address = E_Address, 
        City = E_City, 
        Region = E_Region, 
        PostalCode = E_PostalCode, 
        Country = E_Country, 
        HomePhone = E_HomePhone, 
        ReportsTo = E_ReportsTo
        
    WHERE EmployeeID = E_ID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Upd_Order` (IN `ord_ID` INT, IN `ord_CustomerID` CHAR(5), IN `ord_EmployeeID` INT, IN `ord_OrderDate` DATETIME, IN `ord_RequiredDate` DATETIME, IN `ord_ShippedDate` DATETIME, IN `ord_ShipVia` INT, IN `ord_Freight` DOUBLE, IN `ord_ShipName` VARCHAR(40), IN `ord_ShipAddress` VARCHAR(60), IN `ord_ShipCity` VARCHAR(15), IN `ord_ShipRegion` VARCHAR(15), IN `ord_ShipPostalCode` VARCHAR(10), IN `ord_ShipCountry` VARCHAR(15))   BEGIN
    UPDATE Orders
    SET 
        CustomerID = ord_CustomerID,
        EmployeeID = ord_EmployeeID,
        OrderDate = ord_OrderDate,
        RequiredDate = ord_RequiredDate,
        ShippedDate = ord_ShippedDate,
        ShipVia = ord_ShipVia,
        Freight = ord_Freight,
        ShipName = ord_ShipName,
        ShipAddress = ord_ShipAddress,
        ShipCity = ord_ShipCity,
        ShipRegion = ord_ShipRegion,
        ShipPostalCode = ord_ShipPostalCode,
        ShipCountry = ord_ShipCountry
    WHERE OrderID = ord_ID;

    SELECT 'Registro actualizado en Orders' AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Sp_Upd_Producto` (IN `P_ProductID` INT, IN `P_ProductName` VARCHAR(40), IN `P_CompanyName` VARCHAR(40), IN `P_CategoryName` VARCHAR(15), IN `P_QuantityPerUnit` VARCHAR(20), IN `P_UnitPrice` DOUBLE, IN `P_UnitsInStock` SMALLINT, IN `P_UnitsOnOrder` SMALLINT, IN `P_ReorderLevel` SMALLINT, IN `P_Discontinued` TINYINT)   BEGIN
    DECLARE supplier_id INT;
    DECLARE category_id INT;
    SELECT SupplierID INTO supplier_id FROM suppliers WHERE CompanyName = P_CompanyName;
    SELECT CategoryID INTO category_id FROM categories WHERE CategoryName = P_CategoryName;
    UPDATE Products
    SET ProductName = P_ProductName,
        SupplierID = supplier_id,
        CategoryID = category_id,
        QuantityPerUnit = P_QuantityPerUnit,
        UnitPrice = P_UnitPrice,
        UnitsInStock = P_UnitsInStock,
        UnitsOnOrder = P_UnitsOnOrder,
        ReorderLevel = P_ReorderLevel,
        Discontinued = P_Discontinued
    WHERE ProductID = P_ProductID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `CategoryID` int(11) NOT NULL,
  `CategoryName` varchar(15) NOT NULL,
  `Description` longtext DEFAULT NULL,
  `Picture` longblob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`CategoryID`, `CategoryName`, `Description`, `Picture`) VALUES
(2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings', NULL),
(3, 'Confections', 'Desserts, candies, and sweet breads', NULL),
(4, 'Dairy Products', 'Cheeses', NULL),
(5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal', NULL),
(6, 'AWAsss', 'UWUasdasd', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customercustomerdemo`
--

CREATE TABLE `customercustomerdemo` (
  `CustomerID` char(5) NOT NULL,
  `CustomerTypeID` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customerdemographics`
--

CREATE TABLE `customerdemographics` (
  `CustomerTypeID` char(10) NOT NULL,
  `CustomerDesc` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `customers`
--

CREATE TABLE `customers` (
  `CustomerID` char(5) NOT NULL,
  `CompanyName` varchar(40) NOT NULL,
  `ContactName` varchar(30) DEFAULT NULL,
  `ContactTitle` varchar(30) DEFAULT NULL,
  `Address` varchar(60) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Region` varchar(15) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  `Phone` varchar(24) DEFAULT NULL,
  `Fax` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `customers`
--

INSERT INTO `customers` (`CustomerID`, `CompanyName`, `ContactName`, `ContactTitle`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `Phone`, `Fax`) VALUES
('ACCIO', 'ACCION Popular', 'RoyChunque', 'Supervisor', 'Av. Chocolatada asdasd', 'Lima', 'Lima', '123124', 'Peru', '987654312', '1231'),
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany', '030-0074321', '030-0076545'),
('ALFRE', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin AVENIDA', '', '12209', 'Germany', '030-0074321', '030-0076545'),
('ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constituci?n 2222', 'M?xico D.F.', '', '05021', 'Mexico', '(5) 555-4729', '(5) 555-3745'),
('ANTON', 'Antonio Moreno Taquer?a', 'Antonio Moreno', 'Owner', 'Mataderos  2312', 'M?xico D.F.', '', '05023', 'Mexico', '(5) 555-3932', ''),
('AWESO', 'Awesome Business Company', 'John asdcdc', 'CEO', '123 Main St', 'Cityville', 'Region', '12345', 'Country', '123-456-7890', '123-456-7891'),
('BERGS', 'Berglunds snabbk?p', 'Christina Berglund', 'Order Administrator', 'Berguvsv?gen  8', 'Lule?', '', 'S-958 22', 'Sweden', '0921-12 34 65', '0921-12 34 67'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Representative', 'Forsterstr. 57', 'Mannheim', '', '68306', 'Germany', '0621-08460', '0621-08924'),
('BLONP', 'Blondesddsl p?re et fils', 'Fr?d?rique Citeaux', 'Marketing Manager', '24, place Kl?ber', 'Strasbourg', '', '67000', 'France', '88.60.15.31', '88.60.15.32'),
('BOLID', 'B?lido Comidas preparadas', 'Mart?n Sommer', 'Owner', 'C/ Araquil, 67', 'Madrid', '', '28023', 'Spain', '(91) 555 22 82', '(91) 555 91 99'),
('BONAP', 'Bon app\'', 'Laurence Lebihan', 'Owner', '12, rue des Bouchers', 'Marseille', '', '13008', 'France', '91.24.45.40', '91.24.45.41'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Accounting Manager', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', '(604) 555-4729', '(604) 555-3745'),
('BSBEV', 'B\'s Beverages', 'Victoria Ashworth', 'Sales Representative', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK', '(171) 555-1212', ''),
('CACTU', 'Cactus Comidas para llevar', 'Patricio Simpson', 'Sales Agent', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina', '(1) 135-5555', '(1) 135-4892'),
('CENTC', 'Centro comercial Moctezuma', 'Francisco Chang', 'Marketing Manager', 'Sierras de Granada 9993', 'M?xico D.F.', '', '05022', 'Mexico', '(5) 555-3392', '(5) 555-7293'),
('CHOPS', 'Chop-suey Chinese', 'Yang Wang', 'Owner', 'Hauptstr. 29', 'Bern', '', '3012', 'Switzerland', '0452-076545', ''),
('COMMI', 'Com?rcio Mineiro', 'Pedro Afonso', 'Sales Associate', 'Av. dos Lus?adas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil', '(11) 555-7647', ''),
('CONSH', 'Consolidated Holdings', 'Elizabeth Brown', 'Sales Representative', 'Berkeley Gardens 12  Brewery', 'London', '', 'WX1 6LT', 'UK', '(171) 555-2282', '(171) 555-9199'),
('DRACD', 'Drachenblut Delikatessen', 'Sven Ottlieb', 'Order Administrator', 'Walserweg 21', 'Aachen', '', '52066', 'Germany', '0241-039123', '0241-059428'),
('DUMON', 'Du monde entier', 'Janine Labrune', 'Owner', '67, rue des Cinquante Otages', 'Nantes', '', '44000', 'France', '40.67.88.88', '40.67.89.89'),
('EASTC', 'Eastern Connection', 'Ann Devon', 'Sales Agent', '35 King George', 'London', '', 'WX3 6FW', 'UK', '(171) 555-0297', '(171) 555-3373'),
('EDFVD', 'Edfvdvfgbvfbf', 'John Doe', 'CEO', '123 Main St', 'Cityville', 'Region', '12345', 'Country', '123-456-7890', '123-456-7891'),
('ERNSH', 'Ernst Handel', 'Roland Mendel', 'Sales Manager', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria', '7675-3425', '7675-3426'),
('Esthe', 'Esther de Valdivia', 'Nombre del Contacto', 'Título del Contacto', 'Dirección del Cliente', 'Ciudad del Clie', 'Región del Clie', 'Código Pos', 'País del Client', 'Número de Teléfono', 'Fax del Cliente'),
('EWEDE', 'EWE DE IWI', 'John asdcdc', 'CEO', '123 Main St', 'Cityville', 'Region', '12345', 'Country', '123-456-7890', '123-456-7891'),
('FAMIA', 'Familia Arquibaldo', 'Aria Cruz', 'Marketing Assistant', 'Rua Or?s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil', '(11) 555-9857', ''),
('FISSA', 'FISSA Fabrica Inter. Salchichas S.A.', 'Diego Roel', 'Accounting Manager', 'C/ Moralzarzal, 86', 'Madrid', '', '28034', 'Spain', '(91) 555 94 44', '(91) 555 55 93'),
('FOLIG', 'Folies gourmandes', 'Martine Ranc?', 'Assistant Sales Agent', '184, chauss?e de Tournai', 'Lille', '', '59000', 'France', '20.16.10.16', '20.16.10.17'),
('FOLKO', 'Folk och f? HB', 'Maria Larsson', 'Owner', '?kergatan 24', 'Br?cke', '', 'S-844 67', 'Sweden', '0695-34 67 21', ''),
('FRANK', 'Frankenversand', 'Peter Franken', 'Marketing Manager', 'Berliner Platz 43', 'M?nchen', '', '80805', 'Germany', '089-0877310', '089-0877451'),
('FRANR', 'France restauration', 'Carine Schmitt', 'Marketing Manager', '54, rue Royale', 'Nantes', '', '44000', 'France', '40.32.21.21', '40.32.21.20'),
('FRANS', 'Franchi S.p.A.', 'Paolo Accorti', 'Sales Representative', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy', '011-4988260', '011-4988261'),
('FURIB', 'Furia Bacalhau e Frutos do Mar', 'Lino Rodriguez', 'Sales Manager', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal', '(1) 354-2534', '(1) 354-2535'),
('GALED', 'Galer?a del gastr?nomo', 'Eduardo Saavedra', 'Marketing Manager', 'Rambla de Catalu?a, 23', 'Barcelona', '', '08022', 'Spain', '(93) 203 4560', '(93) 203 4561'),
('GODOS', 'Godos Cocina T?pica', 'Jos? Pedro Freyre', 'Sales Manager', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain', '(95) 555 82 82', ''),
('GOURL', 'Gourmet Lanchonetes', 'Andr? Fonseca', 'Sales Associate', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil', '(11) 555-9482', ''),
('GREAL', 'Great Lakes Food Market', 'Howard Snyder', 'Marketing Manager', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA', '(503) 555-7555', ''),
('GROSR', 'GROSELLA-Restaurante', 'Manuel Pereira', 'Owner', '5? Ave. Los Palos Grandes', 'Caracas', 'DF', '1081', 'Venezuela', '(2) 283-2951', '(2) 283-3397'),
('HANAR', 'Hanari Carnes', 'Mario Pontes', 'Accounting Manager', 'Rua do Pa?o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil', '(21) 555-0091', '(21) 555-8765'),
('HILAA', 'HILARION-Abastos', 'Carlos Hern?ndez', 'Sales Representative', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist?bal', 'T?chira', '5022', 'Venezuela', '(5) 555-1340', '(5) 555-1948'),
('HUNGC', 'Hungry Coyote Import Store', 'Yoshi Latimer', 'Sales Representative', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA', '(503) 555-6874', '(503) 555-2376'),
('HUNGO', 'Hungry Owl All-Night Grocers', 'Patricia McKenna', 'Sales Associate', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland', '2967 542', '2967 3333'),
('ISLAT', 'Island Trading', 'Helen Bennett', 'Marketing Manager', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK', '(198) 555-8888', ''),
('KOENE', 'K?niglich Essen', 'Philip Cramer', 'Sales Associate', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany', '0555-09876', ''),
('LACOR', 'La corne d\'abondance', 'Daniel Tonini', 'Sales Representative', '67, avenue de l\'Europe', 'Versailles', '', '78000', 'France', '30.59.84.10', '30.59.85.11'),
('LAMAI', 'La maison d\'Asie', 'Annette Roulet', 'Sales Manager', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France', '61.77.61.10', '61.77.61.11'),
('LAUGB', 'Laughing Bacchus Wine Cellars', 'Yoshi Tannamuri', 'Marketing Assistant', '1900 Oak St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada', '(604) 555-3392', '(604) 555-7293'),
('LAZYK', 'Lazy K Kountry Store', 'John Steel', 'Marketing Manager', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', 'USA', '(509) 555-7969', '(509) 555-6221'),
('LEHMS', 'Lehmanns Marktstand', 'Renate Messner', 'Sales Representative', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany', '069-0245984', '069-0245874'),
('LETSS', 'Let\'s Stop N Shop', 'Jaime Yorres', 'Owner', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA', '(415) 555-5938', ''),
('LILAS', 'LILA-Supermercado', 'Carlos Gonz?lez', 'Accounting Manager', 'Carrera 52 con Ave. Bol?var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela', '(9) 331-6954', '(9) 331-7256'),
('LINOD', 'LINO-Delicateses', 'Felipe Izquierdo', 'Owner', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela', '(8) 34-56-12', '(8) 34-93-93'),
('LONEP', 'Lonesome Pine Restaurant', 'Fran Wilson', 'Sales Manager', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA', '(503) 555-9573', '(503) 555-9646'),
('MAGAA', 'Magazzini Alimentari Riuniti', 'Giovanni Rovelli', 'Marketing Manager', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy', '035-640230', '035-640231'),
('MAISD', 'Maison Dewey', 'Catherine Dewey', 'Sales Agent', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium', '(02) 201 24 67', '(02) 201 24 68'),
('MEREP', 'M?re Paillarde', 'Jean Fresni?re', 'Marketing Assistant', '43 rue St. Laurent', 'Montr?al', 'Qu?bec', 'H1J 1C3', 'Canada', '(514) 555-8054', '(514) 555-8055'),
('MORGK', 'Morgenstern Gesundkost', 'Alexander Feuer', 'Marketing Assistant', 'Heerstr. 22', 'Leipzig', '', '04179', 'Germany', '0342-023176', ''),
('NORTS', 'North/South', 'Simon Crowther', 'Sales Associate', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK', '(171) 555-7733', '(171) 555-2530'),
('OCEAN', 'Oc?ano Atl?ntico Ltda.', 'Yvonne Moncada', 'Sales Agent', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina', '(1) 135-5333', '(1) 135-5535'),
('OLDWO', 'Old World Delicatessen', 'Rene Phillips', 'Sales Representative', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA', '(907) 555-7584', '(907) 555-2880'),
('OTTIK', 'Ottilies K?seladen', 'Henriette Pfalzheim', 'Owner', 'Mehrheimerstr. 369', 'K?ln', '', '50739', 'Germany', '0221-0644327', '0221-0765721'),
('PARIS', 'Paris sp?cialit?s', 'Marie Bertrand', 'Owner', '265, boulevard Charonne', 'Paris', '', '75012', 'France', '(1) 42.34.22.66', '(1) 42.34.22.77'),
('PERIC', 'Pericles Comidas cl?sicas', 'Guillermo Fern?ndez', 'Sales Representative', 'Calle Dr. Jorge Cash 321', 'M?xico D.F.', '', '05033', 'Mexico', '(5) 552-3745', '(5) 545-3745'),
('PICCO', 'Piccolo und mehr', 'Georg Pipps', 'Sales Manager', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria', '6562-9722', '6562-9723'),
('PRINI', 'Princesa Isabel Vinhos', 'Isabel de Castro', 'Sales Representative', 'Estrada da sa?de n. 58', 'Lisboa', '', '1756', 'Portugal', '(1) 356-5634', ''),
('QUEDE', 'Que Del?cia', 'Bernardo Batista', 'Accounting Manager', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil', '(21) 555-4252', '(21) 555-4545'),
('QUEEN', 'Queen Cozinha', 'L?cia Carvalho', 'Marketing Assistant', 'Alameda dos Can?rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil', '(11) 555-1189', ''),
('QUICK', 'QUICK-Stop', 'Horst Kloss', 'Accounting Manager', 'Taucherstra?e 10', 'Cunewalde', '', '01307', 'Germany', '0372-035188', ''),
('RANCH', 'Rancho grande', 'Sergio Guti?rrez', 'Sales Representative', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina', '(1) 123-5555', '(1) 123-5556'),
('RATTC', 'Rattlesnake Canyon Grocery', 'Paula Wilson', 'Assistant Sales Representative', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA', '(505) 555-5939', '(505) 555-3620'),
('REGGC', 'Reggiani Caseifici', 'Maurizio Moroni', 'Sales Associate', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy', '0522-556721', '0522-556722'),
('RICAR', 'Ricardo Adocicados', 'Janete Limeira', 'Assistant Sales Agent', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil', '(21) 555-3412', ''),
('RICSU', 'Richter Supermarkt', 'Michael Holz', 'Sales Manager', 'Grenzacherweg 237', 'Gen?ve', '', '1203', 'Switzerland', '0897-034214', ''),
('ROMEY', 'Romero y tomillo', 'Alejandra Camino', 'Accounting Manager', 'Gran V?a, 1', 'Madrid', '', '28001', 'Spain', '(91) 745 6200', '(91) 745 6210'),
('SANTG', 'Sant? Gourmet', 'Jonas Bergulfsen', 'Owner', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway', '07-98 92 35', '07-98 92 47'),
('SAVEA', 'Save-a-lot Markets', 'Jose Pavarotti', 'Sales Representative', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA', '(208) 555-8097', ''),
('SEVES', 'Seven Seas Imports', 'Hari Kumar', 'Sales Manager', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK', '(171) 555-1717', '(171) 555-5646'),
('SIMOB', 'Simons bistro', 'Jytte Petersen', 'Owner', 'Vinb?ltet 34', 'Kobenhavn', '', '1734', 'Denmark', '31 12 34 56', '31 13 35 57'),
('SPECD', 'Sp?cialit?s du monde', 'Dominique Perrier', 'Marketing Manager', '25, rue Lauriston', 'Paris', '', '75016', 'France', '(1) 47.55.60.10', '(1) 47.55.60.20'),
('SPLIR', 'Split Rail Beer & Ale', 'Art Braunschweiger', 'Sales Manager', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA', '(307) 555-4680', '(307) 555-6525'),
('SUPRD', 'Supr?mes d?lices', 'Pascale Cartrain', 'Accounting Manager', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium', '(071) 23 67 22 20', '(071) 23 67 22 21'),
('THEBI', 'The Big Cheese', 'Liz Nixon', 'Marketing Manager', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA', '(503) 555-3612', ''),
('THECR', 'The Cracker Box', 'Liu Wong', 'Marketing Assistant', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA', '(406) 555-5834', '(406) 555-8083'),
('TOMSP', 'Toms Spezialit?ten', 'Karin Josephs', 'Marketing Manager', 'Luisenstr. 48', 'M?nster', '', '44087', 'Germany', '0251-031259', '0251-035695'),
('TORTU', 'Tortuga Restaurante', 'Miguel Angel Paolino', 'Owner', 'Avda. Azteca 123', 'M?xico D.F.', '', '05033', 'Mexico', '(5) 555-2933', ''),
('TRADH', 'Tradi??o Hipermercados', 'Anabela Domingues', 'Sales Representative', 'Av. In?s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil', '(11) 555-2167', '(11) 555-2168'),
('TRAIH', 'Trail\'s Head Gourmet Provisioners', 'Helvetius Nagy', 'Sales Associate', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA', '(206) 555-8257', '(206) 555-2174'),
('VAFFE', 'Vaffeljernet', 'Palle Ibsen', 'Sales Manager', 'Smagsloget 45', '?rhus', '', '8200', 'Denmark', '86 21 32 43', '86 22 33 44'),
('VICTE', 'Victuailles en stock', 'Mary Saveley', 'Sales Agent', '2, rue du Commerce', 'Lyon', '', '69004', 'France', '78.32.54.86', '78.32.54.87'),
('VINET', 'Vins et alcools Chevalier', 'Paul Henriot', 'Accounting Manager', '59 rue de l\'Abbaye', 'Reims', '', '51100', 'France', '26.47.15.10', '26.47.15.11'),
('WANDK', 'Die Wandernde Kuh', 'Rita M?ller', 'Sales Representative', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany', '0711-020361', '0711-035428'),
('WARTH', 'Wartian Herkku', 'Pirkko Koskitalo', 'Accounting Manager', 'Torikatu 38', 'Oulu', '', '90110', 'Finland', '981-443655', '981-443655');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employees`
--

CREATE TABLE `employees` (
  `EmployeeID` int(11) NOT NULL,
  `LastName` varchar(20) NOT NULL,
  `FirstName` varchar(10) NOT NULL,
  `Title` varchar(30) DEFAULT NULL,
  `TitleOfCourtesy` varchar(25) DEFAULT NULL,
  `BirthDate` datetime DEFAULT NULL,
  `HireDate` datetime DEFAULT NULL,
  `Address` varchar(60) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Region` varchar(15) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  `HomePhone` varchar(24) DEFAULT NULL,
  `Extension` varchar(4) DEFAULT NULL,
  `Photo` longblob DEFAULT NULL,
  `Notes` longtext DEFAULT NULL,
  `ReportsTo` int(11) DEFAULT NULL,
  `PhotoPath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `employees`
--

INSERT INTO `employees` (`EmployeeID`, `LastName`, `FirstName`, `Title`, `TitleOfCourtesy`, `BirthDate`, `HireDate`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `HomePhone`, `Extension`, `Photo`, `Notes`, `ReportsTo`, `PhotoPath`) VALUES
(1, 'Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1948-12-08 00:00:00', '1992-05-01 00:00:00', '507 - 20th Ave. E.Apt. 2A', 'Lima', 'WA', '98122', 'Peru', '(206) 555-9857', '5467', NULL, 'Education includes a BA in psychology from Colorado State University in 1970.  She also completed \"The Art of the Cold Call.\"  Nancy is a member of Toastmasters International.', 2, 'http://accweb/emmployees/davolio.bmp'),
(2, 'Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1952-02-19 00:00:00', '1992-08-14 00:00:00', '908 W. Capital Way', 'Tacoma', 'WA', '98401', 'USA', '(206) 555-9482', '3457', NULL, 'Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.  He is fluent in French and Italian and reads German.  He joined the company as a sales representative, was promoted to sales manager in January 1992 and to vice president of sales in March 1993.  Andrew is a member of the Sales Management Roundtable, the Seattle Chamber of Commerce, and the Pacific Rim Importers Association.', NULL, 'http://accweb/emmployees/fuller.bmp'),
(3, 'Leverling', 'Janet', 'Sales Representative', 'Ms.', '1963-08-30 00:00:00', '1992-04-01 00:00:00', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '98033', 'USA', '(206) 555-3412', '3355', NULL, 'Janet has a BS degree in chemistry from Boston College (1984).  She has also completed a certificate program in food retailing management.  Janet was hired as a sales associate in 1991 and promoted to sales representative in February 1992.', 2, 'http://accweb/emmployees/leverling.bmp'),
(4, 'Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1937-09-19 00:00:00', '1993-05-03 00:00:00', '4110 Old Redmond Rd.', 'Redmond', 'WA', '98052', 'USA', '(206) 555-8122', '5176', NULL, 'Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).  She was assigned to the London office temporarily from July through November 1992.', 2, 'http://accweb/emmployees/peacock.bmp'),
(5, 'Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1955-03-04 00:00:00', '1993-10-17 00:00:00', '14 Garrett Hill', 'London', '', 'SW1 8JR', 'UK', '(71) 555-4848', '3453', NULL, 'Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.  Upon joining the company as a sales representative in 1992, he spent 6 months in an orientation program at the Seattle office and then returned to his permanent post in London.  He was promoted to sales manager in March 1993.  Mr. Buchanan has completed the courses \"Successful Telemarketing\" and \"International Sales Management.\"  He is fluent in French.', 2, 'http://accweb/emmployees/buchanan.bmp'),
(6, 'Suyama', 'Michael', 'Sales Representative', 'Mr.', '1963-07-02 00:00:00', '1993-10-17 00:00:00', 'Coventry House\r\nMiner Rd.', 'London', '', 'EC2 7JR', 'UK', '(71) 555-7773', '428', NULL, 'Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).  He has also taken the courses \"Multi-Cultural Selling\" and \"Time Management for the Sales Professional.\"  He is fluent in Japanese and can read and write French, Portuguese, and Spanish.', 5, 'http://accweb/emmployees/davolio.bmp'),
(10, 'Chunque', 'Roy', 'Sales Manager', 'Mr', '1955-03-04 00:00:00', '1993-10-17 00:00:00', 'SenatiIndependecia', 'Lima', 'Lima', 'aaaa', 'Peru', '(+51 98765431)', 'eeee', NULL, NULL, 2, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employeeterritories`
--

CREATE TABLE `employeeterritories` (
  `EmployeeID` int(11) NOT NULL,
  `TerritoryID` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `employeeterritories`
--

INSERT INTO `employeeterritories` (`EmployeeID`, `TerritoryID`) VALUES
(1, '19713'),
(1, '6897'),
(2, '1581'),
(2, '1730'),
(2, '1833'),
(2, '2116'),
(2, '2139'),
(2, '2184'),
(2, '40222'),
(3, '30346'),
(3, '31406'),
(3, '32859'),
(3, '33607'),
(4, '20852'),
(4, '27403'),
(4, '27511'),
(5, '10019'),
(5, '10038'),
(5, '11747'),
(5, '14450'),
(5, '2903'),
(5, '7960'),
(5, '8837'),
(6, '85014'),
(6, '85251'),
(6, '98004'),
(6, '98052'),
(6, '98104');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orderdetails`
--

CREATE TABLE `orderdetails` (
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `UnitPrice` double NOT NULL DEFAULT 0,
  `Quantity` smallint(6) NOT NULL DEFAULT 0,
  `Discount` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `orderdetails`
--

INSERT INTO `orderdetails` (`OrderID`, `ProductID`, `UnitPrice`, `Quantity`, `Discount`) VALUES
(10248, 11, 14, 12, 0),
(10248, 42, 9.8, 10, 0),
(10250, 65, 16.8, 15, 0.15000001),
(10251, 22, 16.8, 6, 0.05),
(10251, 57, 15.6, 15, 0.05),
(10251, 65, 16.8, 20, 0),
(10252, 20, 64.8, 40, 0.05),
(10252, 33, 2, 25, 0.05),
(10252, 60, 27.2, 40, 0),
(10253, 31, 10, 20, 0),
(10253, 49, 16, 40, 0),
(10254, 55, 19.2, 21, 0.15000001),
(10257, 27, 35.1, 25, 0),
(10258, 5, 17, 65, 0.2),
(10258, 32, 25.6, 6, 0.2),
(10259, 21, 8, 10, 0),
(10260, 57, 15.6, 50, 0),
(10260, 62, 39.4, 15, 0.25),
(10261, 21, 8, 20, 0),
(10265, 17, 31.2, 30, 0),
(10266, 12, 30.4, 12, 0.05),
(10267, 59, 44, 70, 0.15000001),
(10271, 33, 2, 24, 0),
(10272, 20, 64.8, 6, 0),
(10272, 31, 10, 40, 0),
(10273, 31, 10, 15, 0.05),
(10273, 33, 2, 20, 0),
(10275, 59, 44, 6, 0.05),
(10277, 62, 39.4, 12, 0),
(10280, 55, 19.2, 20, 0),
(10281, 19, 7.3, 1, 0),
(10282, 57, 15.6, 2, 0),
(10283, 15, 12.4, 20, 0),
(10283, 19, 7.3, 18, 0),
(10283, 60, 27.2, 35, 0),
(10284, 27, 35.1, 15, 0.25),
(10284, 44, 15.5, 21, 0),
(10284, 60, 27.2, 20, 0.25),
(10285, 53, 26.2, 36, 0.2),
(10288, 54, 5.9, 10, 0.1),
(10288, 68, 10, 3, 0.1),
(10291, 44, 15.5, 24, 0.1),
(10292, 20, 64.8, 20, 0),
(10293, 63, 35.1, 5, 0),
(10294, 17, 31.2, 15, 0),
(10294, 60, 27.2, 21, 0),
(10295, 56, 30.4, 4, 0),
(10296, 11, 16.8, 12, 0),
(10296, 16, 13.9, 30, 0),
(10298, 59, 44, 30, 0.25),
(10298, 62, 39.4, 15, 0),
(10299, 19, 7.3, 15, 0),
(10300, 66, 13.6, 30, 0),
(10300, 68, 10, 20, 0),
(10302, 17, 31.2, 40, 0),
(10304, 49, 16, 30, 0),
(10304, 59, 44, 10, 0),
(10306, 53, 26.2, 10, 0),
(10306, 54, 5.9, 5, 0),
(10307, 62, 39.4, 10, 0),
(10307, 68, 10, 3, 0),
(10309, 4, 17.6, 20, 0),
(10309, 6, 20, 30, 0),
(10309, 42, 11.2, 2, 0),
(10311, 42, 11.2, 6, 0),
(10312, 53, 26.2, 20, 0),
(10314, 32, 25.6, 40, 0.1),
(10314, 62, 39.4, 25, 0.1),
(10316, 62, 39.4, 70, 0),
(10323, 15, 12.4, 5, 0),
(10323, 25, 11.2, 4, 0),
(10325, 6, 20, 6, 0),
(10325, 31, 10, 4, 0),
(10326, 4, 17.6, 24, 0),
(10326, 57, 15.6, 16, 0),
(10327, 11, 16.8, 50, 0.2),
(10328, 59, 44, 9, 0),
(10328, 65, 16.8, 40, 0),
(10328, 68, 10, 10, 0),
(10329, 19, 7.3, 10, 0.05),
(10329, 56, 30.4, 12, 0.05),
(10330, 26, 24.9, 50, 0.15000001),
(10332, 42, 11.2, 10, 0.2),
(10332, 47, 7.6, 16, 0.2),
(10333, 21, 8, 10, 0.1),
(10337, 23, 7.2, 40, 0),
(10337, 26, 24.9, 24, 0),
(10338, 17, 31.2, 20, 0),
(10339, 4, 17.6, 10, 0),
(10339, 17, 31.2, 70, 0.05),
(10339, 62, 39.4, 28, 0),
(10342, 31, 10, 56, 0.2),
(10342, 55, 19.2, 40, 0.2),
(10343, 64, 26.6, 50, 0),
(10343, 68, 10, 4, 0.05),
(10345, 8, 32, 70, 0),
(10345, 19, 7.3, 80, 0),
(10345, 42, 11.2, 9, 0),
(10346, 17, 31.2, 36, 0.1),
(10346, 56, 30.4, 20, 0),
(10347, 25, 11.2, 10, 0),
(10348, 23, 7.2, 25, 0),
(10350, 50, 13, 15, 0.1),
(10351, 44, 15.5, 77, 0.05),
(10351, 65, 16.8, 10, 0.05),
(10352, 54, 5.9, 20, 0.15000001),
(10355, 57, 15.6, 25, 0),
(10356, 31, 10, 30, 0),
(10356, 55, 19.2, 12, 0),
(10357, 26, 24.9, 16, 0),
(10357, 60, 27.2, 8, 0.2),
(10359, 16, 13.9, 56, 0.05),
(10359, 31, 10, 70, 0.05),
(10359, 60, 27.2, 80, 0.05),
(10360, 29, 99, 35, 0),
(10360, 49, 16, 35, 0),
(10360, 54, 5.9, 28, 0),
(10361, 60, 27.2, 55, 0.1),
(10362, 25, 11.2, 50, 0),
(10362, 54, 5.9, 24, 0),
(10363, 31, 10, 20, 0),
(10365, 11, 16.8, 24, 0),
(10368, 21, 8, 5, 0.1),
(10368, 57, 15.6, 25, 0),
(10368, 64, 26.6, 35, 0.1),
(10370, 64, 26.6, 30, 0),
(10372, 20, 64.8, 12, 0.25),
(10372, 60, 27.2, 70, 0.25),
(10375, 54, 5.9, 10, 0),
(10376, 31, 10, 42, 0.05),
(10379, 63, 35.1, 16, 0.1),
(10379, 65, 16.8, 20, 0.1),
(10382, 5, 17, 32, 0),
(10382, 29, 99, 14, 0),
(10382, 33, 2, 60, 0),
(10384, 20, 64.8, 28, 0),
(10384, 60, 27.2, 15, 0),
(10385, 60, 27.2, 20, 0.2),
(10385, 68, 10, 8, 0.2),
(10387, 59, 44, 12, 0),
(10388, 52, 5.6, 20, 0.2),
(10388, 53, 26.2, 40, 0),
(10389, 55, 19.2, 15, 0),
(10389, 62, 39.4, 20, 0),
(10390, 31, 10, 60, 0.1),
(10393, 25, 11.2, 7, 0.25),
(10393, 26, 24.9, 70, 0.25),
(10393, 31, 10, 32, 0),
(10394, 62, 39.4, 10, 0),
(10395, 53, 26.2, 70, 0.1),
(10396, 23, 7.2, 40, 0),
(10397, 21, 8, 10, 0.15000001),
(10398, 55, 19.2, 120, 0.1),
(10400, 29, 99, 21, 0),
(10400, 49, 16, 30, 0),
(10401, 56, 30.4, 70, 0),
(10401, 65, 16.8, 20, 0),
(10403, 16, 13.9, 21, 0.15000001),
(10403, 48, 10.2, 70, 0.15000001),
(10404, 26, 24.9, 30, 0.05),
(10404, 42, 11.2, 40, 0.05),
(10404, 49, 16, 30, 0.05),
(10405, 3, 8, 50, 0),
(10407, 11, 16.8, 30, 0),
(10409, 21, 8, 12, 0),
(10410, 33, 2, 49, 0),
(10410, 59, 44, 16, 0),
(10413, 62, 39.4, 40, 0),
(10414, 19, 7.3, 18, 0.05),
(10414, 33, 2, 50, 0),
(10415, 17, 31.2, 2, 0),
(10415, 33, 2, 20, 0),
(10417, 68, 10, 36, 0.25),
(10418, 47, 7.6, 55, 0),
(10418, 61, 22.8, 16, 0),
(10419, 60, 27.2, 60, 0.05),
(10422, 26, 24.9, 2, 0),
(10423, 31, 10, 14, 0),
(10423, 59, 44, 20, 0),
(10425, 55, 19.2, 10, 0.25),
(10426, 56, 30.4, 5, 0),
(10426, 64, 26.6, 7, 0),
(10429, 50, 13, 40, 0),
(10429, 63, 35.1, 35, 0.25),
(10430, 17, 31.2, 45, 0.2),
(10430, 21, 8, 50, 0),
(10430, 56, 30.4, 30, 0),
(10430, 59, 44, 70, 0.2),
(10431, 17, 31.2, 50, 0.25),
(10431, 47, 7.6, 30, 0.25),
(10432, 26, 24.9, 10, 0),
(10432, 54, 5.9, 40, 0),
(10433, 56, 30.4, 28, 0),
(10434, 11, 16.8, 6, 0),
(10436, 56, 30.4, 40, 0.1),
(10436, 64, 26.6, 30, 0.1),
(10438, 19, 7.3, 15, 0.2),
(10438, 57, 15.6, 15, 0.2),
(10439, 12, 30.4, 15, 0),
(10439, 16, 13.9, 16, 0),
(10439, 64, 26.6, 6, 0),
(10440, 16, 13.9, 49, 0.15000001),
(10440, 29, 99, 24, 0.15000001),
(10440, 61, 22.8, 90, 0.15000001),
(10441, 27, 35.1, 50, 0),
(10442, 11, 16.8, 30, 0),
(10442, 54, 5.9, 80, 0),
(10442, 66, 13.6, 60, 0),
(10444, 17, 31.2, 10, 0),
(10444, 26, 24.9, 15, 0),
(10445, 54, 5.9, 15, 0),
(10446, 19, 7.3, 12, 0.1),
(10446, 31, 10, 3, 0.1),
(10446, 52, 5.6, 15, 0.1),
(10447, 19, 7.3, 40, 0),
(10447, 65, 16.8, 35, 0),
(10448, 26, 24.9, 6, 0),
(10449, 52, 5.6, 20, 0),
(10449, 62, 39.4, 35, 0),
(10451, 55, 19.2, 120, 0.1),
(10451, 64, 26.6, 35, 0.1),
(10451, 65, 16.8, 28, 0.1),
(10453, 48, 10.2, 15, 0.1),
(10454, 16, 13.9, 20, 0.2),
(10454, 33, 2, 20, 0.2),
(10457, 59, 44, 36, 0),
(10461, 21, 8, 40, 0.25),
(10461, 55, 19.2, 60, 0.25),
(10462, 23, 7.2, 21, 0),
(10463, 19, 7.3, 21, 0),
(10463, 42, 11.2, 50, 0),
(10464, 4, 17.6, 16, 0.2),
(10464, 56, 30.4, 30, 0.2),
(10464, 60, 27.2, 20, 0),
(10465, 29, 99, 18, 0.1),
(10465, 50, 13, 25, 0),
(10466, 11, 16.8, 10, 0),
(10470, 23, 7.2, 15, 0),
(10470, 64, 26.6, 8, 0),
(10471, 56, 30.4, 20, 0),
(10473, 33, 2, 12, 0),
(10477, 21, 8, 21, 0.25),
(10479, 53, 26.2, 28, 0),
(10479, 59, 44, 60, 0),
(10479, 64, 26.6, 30, 0),
(10480, 47, 7.6, 30, 0),
(10480, 59, 44, 12, 0),
(10484, 21, 8, 14, 0),
(10485, 3, 8, 20, 0.1),
(10485, 55, 19.2, 30, 0.1),
(10486, 11, 16.8, 5, 0),
(10487, 19, 7.3, 5, 0),
(10487, 26, 24.9, 30, 0),
(10487, 54, 5.9, 24, 0.25),
(10489, 11, 16.8, 15, 0.25),
(10489, 16, 13.9, 18, 0),
(10492, 25, 11.2, 60, 0.05),
(10492, 42, 11.2, 20, 0.05),
(10493, 65, 16.8, 15, 0.1),
(10493, 66, 13.6, 10, 0.1),
(10494, 56, 30.4, 30, 0),
(10495, 23, 7.2, 10, 0),
(10499, 49, 20, 25, 0),
(10500, 15, 15.5, 12, 0.05),
(10502, 53, 32.8, 6, 0),
(10503, 65, 21.05, 20, 0),
(10505, 62, 49.3, 3, 0),
(10510, 29, 123.79, 36, 0),
(10511, 4, 22, 50, 0.15000001),
(10511, 8, 40, 10, 0.15000001),
(10514, 20, 81, 39, 0),
(10514, 56, 38, 70, 0),
(10514, 65, 21.05, 39, 0),
(10515, 9, 97, 16, 0.15000001),
(10515, 16, 17.45, 50, 0),
(10515, 27, 43.9, 120, 0),
(10515, 33, 2.5, 16, 0.15000001),
(10515, 60, 34, 84, 0.15000001),
(10516, 42, 14, 20, 0),
(10517, 52, 7, 6, 0),
(10517, 59, 55, 4, 0),
(10518, 44, 19.45, 9, 0),
(10519, 56, 38, 40, 0),
(10519, 60, 34, 10, 0.05),
(10522, 8, 40, 24, 0),
(10524, 54, 7.45, 15, 0),
(10526, 56, 38, 30, 0.15000001),
(10528, 11, 21, 3, 0),
(10528, 33, 2.5, 8, 0.2),
(10529, 55, 24, 14, 0),
(10529, 68, 12.5, 20, 0),
(10530, 17, 39, 40, 0),
(10530, 61, 28.5, 20, 0),
(10535, 11, 21, 50, 0.1),
(10535, 57, 19.5, 5, 0.1),
(10535, 59, 55, 15, 0.1),
(10536, 12, 38, 15, 0.25),
(10536, 31, 12.5, 20, 0),
(10536, 33, 2.5, 30, 0),
(10536, 60, 34, 35, 0.25),
(10537, 31, 12.5, 30, 0),
(10539, 21, 10, 15, 0),
(10539, 33, 2.5, 15, 0),
(10539, 49, 20, 6, 0),
(10540, 3, 10, 60, 0),
(10540, 26, 31.23, 40, 0),
(10540, 68, 12.5, 35, 0),
(10541, 65, 21.05, 36, 0.1),
(10542, 11, 21, 15, 0.05),
(10542, 54, 7.45, 24, 0.05),
(10546, 62, 49.3, 40, 0),
(10547, 32, 32, 24, 0.15000001),
(10549, 31, 12.5, 55, 0.15000001),
(10551, 16, 17.45, 40, 0.15000001),
(10551, 44, 19.45, 40, 0),
(10553, 11, 21, 15, 0),
(10553, 16, 17.45, 14, 0),
(10553, 22, 21, 24, 0),
(10553, 31, 12.5, 30, 0),
(10554, 16, 17.45, 30, 0.05),
(10554, 23, 9, 20, 0.05),
(10554, 62, 49.3, 20, 0.05),
(10555, 19, 9.2, 35, 0.2),
(10555, 56, 38, 40, 0.2),
(10558, 47, 9.5, 25, 0),
(10558, 52, 7, 30, 0),
(10558, 53, 32.8, 18, 0),
(10559, 55, 24, 18, 0.05),
(10561, 44, 19.45, 10, 0),
(10562, 33, 2.5, 20, 0.1),
(10562, 62, 49.3, 10, 0.1),
(10563, 52, 7, 70, 0),
(10564, 17, 39, 16, 0.05),
(10564, 31, 12.5, 6, 0.05),
(10564, 55, 24, 25, 0.05),
(10567, 31, 12.5, 60, 0.2),
(10567, 59, 55, 40, 0.2),
(10569, 31, 12.5, 35, 0.2),
(10570, 11, 21, 15, 0.05),
(10570, 56, 38, 60, 0.05),
(10572, 16, 17.45, 12, 0.1),
(10572, 32, 32, 10, 0.1),
(10574, 33, 2.5, 14, 0),
(10574, 62, 49.3, 10, 0),
(10574, 64, 33.25, 6, 0),
(10575, 59, 55, 12, 0),
(10575, 63, 43.9, 6, 0),
(10576, 31, 12.5, 20, 0),
(10576, 44, 19.45, 21, 0),
(10578, 57, 19.5, 6, 0),
(10579, 15, 15.5, 10, 0),
(10580, 65, 21.05, 30, 0.05),
(10582, 57, 19.5, 4, 0),
(10583, 29, 123.79, 10, 0),
(10583, 60, 34, 24, 0.15000001),
(10584, 31, 12.5, 50, 0.05),
(10587, 26, 31.23, 6, 0),
(10588, 42, 14, 100, 0.2),
(10591, 3, 10, 14, 0),
(10591, 54, 7.45, 50, 0),
(10592, 15, 15.5, 25, 0.05),
(10592, 26, 31.23, 5, 0.05),
(10594, 52, 7, 24, 0),
(10595, 61, 28.5, 120, 0.25),
(10598, 27, 43.9, 50, 0),
(10599, 62, 49.3, 10, 0),
(10600, 54, 7.45, 4, 0),
(10604, 48, 12.75, 6, 0.1),
(10605, 16, 17.45, 30, 0.05),
(10605, 59, 55, 20, 0.05),
(10605, 60, 34, 70, 0.05),
(10606, 4, 22, 20, 0.2),
(10606, 55, 24, 20, 0.2),
(10606, 62, 49.3, 10, 0.2),
(10607, 17, 39, 100, 0),
(10607, 33, 2.5, 14, 0),
(10608, 56, 38, 28, 0),
(10612, 49, 20, 18, 0),
(10612, 60, 34, 40, 0),
(10616, 56, 38, 14, 0),
(10617, 59, 55, 30, 0.15000001),
(10618, 6, 25, 70, 0),
(10618, 56, 38, 20, 0),
(10618, 68, 12.5, 15, 0),
(10619, 21, 10, 42, 0),
(10619, 22, 21, 40, 0),
(10620, 52, 7, 5, 0),
(10621, 19, 9.2, 5, 0),
(10621, 23, 9, 10, 0),
(10622, 68, 12.5, 18, 0.2),
(10624, 29, 123.79, 6, 0),
(10624, 44, 19.45, 10, 0),
(10625, 42, 14, 5, 0),
(10625, 60, 34, 10, 0),
(10626, 53, 32.8, 12, 0),
(10626, 60, 34, 20, 0),
(10629, 29, 123.79, 20, 0),
(10629, 64, 33.25, 9, 0),
(10630, 55, 24, 12, 0.05),
(10636, 4, 22, 25, 0),
(10637, 11, 21, 10, 0),
(10637, 50, 16.25, 25, 0.05),
(10637, 56, 38, 60, 0.05),
(10638, 65, 21.05, 21, 0),
(10647, 19, 9.2, 30, 0),
(10648, 22, 21, 15, 0),
(10650, 53, 32.8, 25, 0.05),
(10650, 54, 7.45, 30, 0),
(10652, 42, 14, 20, 0),
(10653, 16, 17.45, 30, 0.1),
(10653, 60, 34, 20, 0.1),
(10654, 4, 22, 12, 0.1),
(10654, 54, 7.45, 6, 0.1),
(10656, 44, 19.45, 28, 0.1),
(10656, 47, 9.5, 6, 0.1),
(10657, 15, 15.5, 50, 0),
(10657, 47, 9.5, 10, 0),
(10657, 56, 38, 45, 0),
(10657, 60, 34, 30, 0),
(10658, 21, 10, 60, 0),
(10658, 60, 34, 55, 0.05),
(10662, 68, 12.5, 10, 0),
(10663, 42, 14, 30, 0.05),
(10664, 56, 38, 12, 0.15000001),
(10664, 65, 21.05, 15, 0.15000001),
(10665, 59, 55, 1, 0),
(10668, 31, 12.5, 8, 0.1),
(10668, 55, 24, 4, 0.1),
(10668, 64, 33.25, 15, 0.1),
(10670, 23, 9, 32, 0),
(10671, 16, 17.45, 10, 0),
(10671, 62, 49.3, 10, 0),
(10671, 65, 21.05, 12, 0),
(10674, 23, 9, 5, 0),
(10675, 53, 32.8, 10, 0),
(10676, 19, 9.2, 7, 0),
(10676, 44, 19.45, 21, 0),
(10677, 26, 31.23, 30, 0.15000001),
(10677, 33, 2.5, 8, 0.15000001),
(10680, 16, 17.45, 50, 0.25),
(10680, 31, 12.5, 20, 0.25),
(10680, 42, 14, 40, 0.25),
(10681, 19, 9.2, 30, 0.1),
(10681, 21, 10, 12, 0.1),
(10681, 64, 33.25, 28, 0),
(10682, 33, 2.5, 30, 0),
(10682, 66, 17, 4, 0),
(10683, 52, 7, 9, 0),
(10684, 47, 9.5, 40, 0),
(10684, 60, 34, 30, 0),
(10685, 47, 9.5, 15, 0),
(10686, 17, 39, 30, 0.2),
(10686, 26, 31.23, 15, 0),
(10690, 56, 38, 20, 0.25),
(10691, 29, 123.79, 40, 0),
(10691, 44, 19.45, 24, 0),
(10691, 62, 49.3, 48, 0),
(10692, 63, 43.9, 20, 0),
(10697, 19, 9.2, 7, 0.25),
(10698, 11, 21, 15, 0),
(10698, 17, 39, 8, 0.05),
(10698, 29, 123.79, 12, 0.05),
(10698, 65, 21.05, 65, 0.05),
(10699, 47, 9.5, 12, 0),
(10700, 68, 12.5, 40, 0.2),
(10701, 59, 55, 42, 0.15000001),
(10702, 3, 10, 6, 0),
(10703, 59, 55, 35, 0),
(10704, 4, 22, 6, 0),
(10704, 48, 12.75, 24, 0),
(10707, 55, 24, 21, 0),
(10707, 57, 19.5, 40, 0),
(10708, 5, 21.35, 4, 0),
(10709, 8, 40, 40, 0),
(10709, 60, 34, 10, 0),
(10710, 19, 9.2, 5, 0),
(10710, 47, 9.5, 5, 0),
(10711, 19, 9.2, 12, 0),
(10711, 53, 32.8, 120, 0),
(10712, 53, 32.8, 3, 0.05),
(10712, 56, 38, 30, 0),
(10713, 26, 31.23, 30, 0),
(10714, 17, 39, 27, 0.25),
(10714, 47, 9.5, 50, 0.25),
(10714, 56, 38, 18, 0.25),
(10716, 21, 10, 5, 0),
(10716, 61, 28.5, 10, 0),
(10717, 21, 10, 32, 0.05),
(10717, 54, 7.45, 15, 0),
(10718, 12, 38, 36, 0),
(10718, 16, 17.45, 20, 0),
(10718, 62, 49.3, 20, 0),
(10721, 44, 19.45, 50, 0.05),
(10725, 52, 7, 4, 0),
(10725, 55, 24, 6, 0),
(10726, 4, 22, 25, 0),
(10726, 11, 21, 5, 0),
(10727, 17, 39, 20, 0.05),
(10727, 56, 38, 10, 0.05),
(10727, 59, 55, 10, 0.05),
(10728, 55, 24, 12, 0),
(10728, 60, 34, 15, 0),
(10730, 16, 17.45, 15, 0.05),
(10730, 31, 12.5, 3, 0.05),
(10730, 65, 21.05, 10, 0.05),
(10733, 52, 7, 25, 0),
(10734, 6, 25, 30, 0),
(10735, 61, 28.5, 20, 0.1),
(10738, 16, 17.45, 3, 0),
(10739, 52, 7, 18, 0),
(10742, 3, 10, 20, 0),
(10742, 60, 34, 50, 0),
(10746, 42, 14, 28, 0),
(10746, 62, 49.3, 9, 0),
(10747, 31, 12.5, 8, 0),
(10747, 63, 43.9, 9, 0),
(10748, 23, 9, 44, 0),
(10748, 56, 38, 28, 0),
(10749, 56, 38, 15, 0),
(10749, 59, 55, 6, 0),
(10751, 26, 31.23, 12, 0.1),
(10751, 50, 16.25, 20, 0.1),
(10755, 47, 9.5, 30, 0.25),
(10755, 56, 38, 30, 0.25),
(10755, 57, 19.5, 14, 0.25),
(10757, 59, 55, 7, 0),
(10757, 62, 49.3, 30, 0),
(10757, 64, 33.25, 24, 0),
(10758, 26, 31.23, 20, 0),
(10758, 52, 7, 60, 0),
(10759, 32, 32, 10, 0),
(10760, 25, 14, 12, 0.25),
(10760, 27, 43.9, 40, 0),
(10761, 25, 14, 35, 0.25),
(10762, 47, 9.5, 30, 0),
(10762, 56, 38, 60, 0),
(10763, 21, 10, 40, 0),
(10763, 22, 21, 6, 0),
(10764, 3, 10, 20, 0.1),
(10765, 65, 21.05, 80, 0.1),
(10766, 68, 12.5, 40, 0),
(10767, 42, 14, 2, 0),
(10768, 22, 21, 4, 0),
(10768, 31, 12.5, 50, 0),
(10768, 60, 34, 15, 0),
(10769, 52, 7, 15, 0.05),
(10769, 61, 28.5, 20, 0),
(10769, 62, 49.3, 15, 0),
(10772, 29, 123.79, 18, 0),
(10772, 59, 55, 25, 0),
(10773, 17, 39, 33, 0),
(10773, 31, 12.5, 70, 0.2),
(10774, 31, 12.5, 2, 0.25),
(10774, 66, 17, 50, 0),
(10776, 31, 12.5, 16, 0.05),
(10776, 42, 14, 12, 0.05),
(10779, 16, 17.45, 20, 0),
(10779, 62, 49.3, 20, 0),
(10781, 54, 7.45, 3, 0.2),
(10781, 56, 38, 20, 0.2),
(10783, 31, 12.5, 10, 0),
(10787, 29, 123.79, 20, 0.05),
(10788, 19, 9.2, 50, 0.05),
(10789, 63, 43.9, 30, 0),
(10789, 68, 12.5, 18, 0),
(10790, 56, 38, 20, 0.15000001),
(10791, 29, 123.79, 14, 0.05),
(10793, 52, 7, 8, 0),
(10794, 54, 7.45, 6, 0.2),
(10796, 26, 31.23, 21, 0.2),
(10796, 44, 19.45, 10, 0),
(10796, 64, 33.25, 35, 0.2),
(10798, 62, 49.3, 2, 0),
(10800, 11, 21, 50, 0.1),
(10800, 54, 7.45, 7, 0.1),
(10801, 17, 39, 40, 0.25),
(10801, 29, 123.79, 20, 0.25),
(10802, 55, 24, 60, 0.25),
(10802, 62, 49.3, 5, 0.25),
(10804, 49, 20, 4, 0.15000001),
(10806, 65, 21.05, 2, 0),
(10808, 56, 38, 20, 0.15000001),
(10810, 25, 14, 5, 0),
(10812, 31, 12.5, 16, 0.1),
(10814, 48, 12.75, 8, 0.15000001),
(10814, 61, 28.5, 30, 0.15000001),
(10815, 33, 2.5, 16, 0),
(10816, 62, 49.3, 20, 0.05),
(10817, 26, 31.23, 40, 0.15000001),
(10817, 62, 49.3, 25, 0.15000001),
(10820, 56, 38, 30, 0),
(10822, 62, 49.3, 3, 0),
(10823, 11, 21, 20, 0.1),
(10823, 57, 19.5, 15, 0),
(10823, 59, 55, 40, 0.1),
(10825, 26, 31.23, 12, 0),
(10825, 53, 32.8, 20, 0),
(10826, 31, 12.5, 35, 0),
(10826, 57, 19.5, 15, 0),
(10830, 6, 25, 6, 0),
(10830, 60, 34, 30, 0),
(10830, 68, 12.5, 24, 0),
(10831, 19, 9.2, 2, 0),
(10832, 25, 14, 10, 0.2),
(10832, 44, 19.45, 16, 0.2),
(10832, 64, 33.25, 3, 0),
(10833, 31, 12.5, 9, 0.1),
(10833, 53, 32.8, 9, 0.1),
(10834, 29, 123.79, 8, 0.05),
(10835, 59, 55, 15, 0),
(10840, 25, 14, 6, 0.2),
(10841, 56, 38, 30, 0),
(10841, 59, 55, 50, 0),
(10842, 11, 21, 15, 0),
(10842, 68, 12.5, 20, 0),
(10846, 4, 22, 21, 0),
(10847, 19, 9.2, 12, 0.2),
(10847, 60, 34, 45, 0.2),
(10850, 25, 14, 20, 0.15000001),
(10850, 33, 2.5, 4, 0.15000001),
(10851, 25, 14, 10, 0.05),
(10851, 57, 19.5, 10, 0.05),
(10851, 59, 55, 42, 0.05),
(10855, 16, 17.45, 50, 0),
(10855, 31, 12.5, 14, 0),
(10855, 56, 38, 24, 0),
(10855, 65, 21.05, 15, 0.15000001),
(10856, 42, 14, 20, 0),
(10858, 27, 43.9, 10, 0),
(10859, 54, 7.45, 35, 0.25),
(10859, 64, 33.25, 30, 0.25),
(10867, 53, 32.8, 3, 0),
(10869, 11, 21, 10, 0),
(10869, 23, 9, 50, 0),
(10869, 68, 12.5, 20, 0),
(10872, 55, 24, 10, 0.05),
(10872, 62, 49.3, 20, 0.05),
(10872, 64, 33.25, 15, 0.05),
(10872, 65, 21.05, 21, 0.05),
(10875, 19, 9.2, 25, 0),
(10875, 47, 9.5, 21, 0.1),
(10875, 49, 20, 15, 0),
(10877, 16, 17.45, 30, 0.25),
(10878, 20, 81, 20, 0.05),
(10882, 42, 14, 25, 0),
(10882, 49, 20, 20, 0.15000001),
(10882, 54, 7.45, 32, 0.15000001),
(10884, 21, 10, 40, 0.05),
(10884, 56, 38, 21, 0.05),
(10884, 65, 21.05, 12, 0.05),
(10886, 31, 12.5, 35, 0),
(10888, 68, 12.5, 18, 0),
(10892, 59, 55, 40, 0.05),
(10895, 60, 34, 100, 0),
(10897, 29, 123.79, 80, 0),
(10902, 55, 24, 30, 0.15000001),
(10902, 62, 49.3, 6, 0.15000001),
(10903, 65, 21.05, 21, 0),
(10903, 68, 12.5, 20, 0),
(10908, 52, 7, 14, 0.05),
(10909, 16, 17.45, 15, 0),
(10911, 17, 39, 12, 0),
(10912, 11, 21, 40, 0.25),
(10912, 29, 123.79, 60, 0.25),
(10913, 4, 22, 30, 0.25),
(10913, 33, 2.5, 40, 0.25),
(10915, 17, 39, 10, 0),
(10915, 33, 2.5, 30, 0),
(10915, 54, 7.45, 10, 0),
(10916, 16, 17.45, 6, 0),
(10916, 32, 32, 6, 0),
(10916, 57, 19.5, 20, 0),
(10917, 60, 34, 10, 0),
(10918, 60, 34, 25, 0.25),
(10919, 16, 17.45, 24, 0),
(10919, 25, 14, 24, 0),
(10920, 50, 16.25, 24, 0),
(10921, 63, 43.9, 40, 0),
(10922, 17, 39, 15, 0),
(10925, 52, 7, 12, 0.15000001),
(10926, 11, 21, 2, 0),
(10926, 19, 9.2, 7, 0),
(10927, 20, 81, 5, 0),
(10927, 52, 7, 5, 0),
(10928, 47, 9.5, 5, 0),
(10929, 21, 10, 60, 0),
(10930, 21, 10, 36, 0),
(10930, 27, 43.9, 25, 0),
(10930, 55, 24, 25, 0.2),
(10931, 57, 19.5, 30, 0),
(10933, 53, 32.8, 2, 0),
(10933, 61, 28.5, 30, 0),
(10934, 6, 25, 20, 0),
(10938, 60, 34, 49, 0.25),
(10943, 22, 21, 21, 0),
(10944, 11, 21, 5, 0.25),
(10944, 44, 19.45, 18, 0.25),
(10944, 56, 38, 18, 0),
(10945, 31, 12.5, 10, 0),
(10947, 59, 55, 4, 0),
(10948, 50, 16.25, 9, 0),
(10948, 55, 24, 4, 0),
(10949, 6, 25, 12, 0),
(10949, 17, 39, 6, 0),
(10949, 62, 49.3, 60, 0),
(10950, 4, 22, 5, 0),
(10952, 6, 25, 16, 0.05),
(10954, 16, 17.45, 28, 0.15000001),
(10954, 31, 12.5, 25, 0.15000001),
(10954, 60, 34, 24, 0.15000001),
(10956, 21, 10, 12, 0),
(10956, 47, 9.5, 14, 0),
(10966, 56, 38, 12, 0.15000001),
(10966, 62, 49.3, 12, 0.15000001),
(10967, 19, 9.2, 12, 0),
(10967, 49, 20, 40, 0),
(10968, 12, 38, 30, 0),
(10968, 64, 33.25, 4, 0),
(10971, 29, 123.79, 14, 0),
(10972, 17, 39, 6, 0),
(10972, 33, 2.5, 7, 0),
(10973, 26, 31.23, 5, 0),
(10974, 63, 43.9, 10, 0),
(10975, 8, 40, 16, 0),
(10983, 57, 19.5, 15, 0),
(10984, 16, 17.45, 55, 0),
(10985, 16, 17.45, 36, 0.1),
(10985, 32, 32, 35, 0.1),
(10988, 62, 49.3, 40, 0.1),
(10989, 6, 25, 40, 0),
(10989, 11, 21, 15, 0),
(10990, 21, 10, 65, 0),
(10990, 55, 24, 65, 0.15000001),
(10990, 61, 28.5, 66, 0.15000001),
(10994, 59, 55, 18, 0.05),
(10995, 60, 34, 4, 0),
(10996, 42, 14, 40, 0),
(11000, 4, 22, 25, 0.25),
(11001, 22, 21, 25, 0),
(11001, 55, 24, 6, 0),
(11002, 42, 14, 24, 0.15000001),
(11002, 55, 24, 40, 0),
(11003, 52, 7, 10, 0),
(11004, 26, 31.23, 6, 0),
(11006, 29, 123.79, 2, 0.25),
(11009, 60, 34, 9, 0),
(11012, 19, 9.2, 50, 0.05),
(11012, 60, 34, 36, 0.05),
(11013, 23, 9, 10, 0),
(11013, 42, 14, 4, 0),
(11013, 68, 12.5, 2, 0),
(11018, 12, 38, 20, 0),
(11018, 56, 38, 5, 0),
(11019, 49, 20, 2, 0),
(11021, 20, 81, 15, 0),
(11021, 26, 31.23, 63, 0),
(11024, 26, 31.23, 12, 0),
(11024, 33, 2.5, 30, 0),
(11024, 65, 21.05, 21, 0),
(11027, 62, 49.3, 21, 0.25),
(11028, 55, 24, 35, 0),
(11028, 59, 55, 24, 0),
(11029, 56, 38, 20, 0),
(11029, 63, 43.9, 12, 0),
(11031, 64, 33.25, 20, 0),
(11035, 42, 14, 30, 0),
(11035, 54, 7.45, 10, 0),
(11038, 52, 7, 2, 0),
(11039, 49, 20, 60, 0),
(11039, 57, 19.5, 28, 0),
(11040, 21, 10, 20, 0),
(11041, 63, 43.9, 30, 0),
(11042, 44, 19.45, 15, 0),
(11042, 61, 28.5, 4, 0),
(11043, 11, 21, 10, 0),
(11045, 33, 2.5, 15, 0),
(11048, 68, 12.5, 42, 0),
(11049, 12, 38, 4, 0.2),
(11052, 61, 28.5, 10, 0.2),
(11053, 32, 32, 20, 0),
(11053, 64, 33.25, 25, 0.2),
(11059, 17, 39, 12, 0),
(11059, 60, 34, 35, 0),
(11060, 60, 34, 4, 0),
(11061, 60, 34, 15, 0),
(11062, 53, 32.8, 10, 0.2),
(11064, 17, 39, 77, 0.1),
(11064, 53, 32.8, 25, 0.1),
(11064, 55, 24, 4, 0.1),
(11064, 68, 12.5, 55, 0),
(11070, 16, 17.45, 30, 0.15000001),
(11070, 31, 12.5, 20, 0),
(11072, 50, 16.25, 22, 0),
(11072, 64, 33.25, 130, 0),
(11073, 11, 21, 10, 0),
(11076, 6, 25, 20, 0.25),
(11076, 19, 9.2, 10, 0.25);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `orders`
--

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `CustomerID` char(5) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `OrderDate` datetime DEFAULT NULL,
  `RequiredDate` datetime DEFAULT NULL,
  `ShippedDate` datetime DEFAULT NULL,
  `ShipVia` int(11) DEFAULT NULL,
  `Freight` double DEFAULT 0,
  `ShipName` varchar(40) DEFAULT NULL,
  `ShipAddress` varchar(60) DEFAULT NULL,
  `ShipCity` varchar(15) DEFAULT NULL,
  `ShipRegion` varchar(15) DEFAULT NULL,
  `ShipPostalCode` varchar(10) DEFAULT NULL,
  `ShipCountry` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `orders`
--

INSERT INTO `orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`) VALUES
(10248, 'VINET', 5, '1996-07-04 00:00:00', '1996-08-01 00:00:00', '1996-07-16 00:00:00', 1, 32.38, 'Vins et alcools Chevalier', '59 rue de l\'Abbaye', 'Reims', 'BC Region', '51100', 'Peru'),
(10249, 'TOMSP', 6, '1996-07-05 00:00:00', '1996-08-16 00:00:00', '1996-07-10 00:00:00', 1, 11.61, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10250, 'HANAR', 4, '1996-07-08 00:00:00', '1996-08-05 00:00:00', '1996-07-12 00:00:00', 2, 65.83, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10251, 'VICTE', 3, '1996-07-08 00:00:00', '1996-08-05 00:00:00', '1996-07-15 00:00:00', 1, 41.34, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10252, 'SUPRD', 4, '1996-07-09 00:00:00', '1996-08-06 00:00:00', '1996-07-11 00:00:00', 2, 51.3, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10253, 'HANAR', 3, '1996-07-10 00:00:00', '1996-07-24 00:00:00', '1996-07-16 00:00:00', 2, 58.17, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10254, 'CHOPS', 5, '1996-07-11 00:00:00', '1996-08-08 00:00:00', '1996-07-23 00:00:00', 2, 22.98, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(10257, 'HILAA', 4, '1996-07-16 00:00:00', '1996-08-13 00:00:00', '1996-07-22 00:00:00', 3, 81.91, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10258, 'ERNSH', 1, '1996-07-17 00:00:00', '1996-08-14 00:00:00', '1996-07-23 00:00:00', 1, 140.51, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10259, 'CENTC', 4, '1996-07-18 00:00:00', '1996-08-15 00:00:00', '1996-07-25 00:00:00', 3, 3.25, 'Centro comercial Moctezuma', 'Sierras de Granada 9993', 'M�xico D.F.', '', '5022', 'Mexico'),
(10260, 'OTTIK', 4, '1996-07-19 00:00:00', '1996-08-16 00:00:00', '1996-07-29 00:00:00', 1, 55.09, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10261, 'QUEDE', 4, '1996-07-19 00:00:00', '1996-08-16 00:00:00', '1996-07-30 00:00:00', 2, 3.05, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10264, 'FOLKO', 6, '1996-07-24 00:00:00', '1996-08-21 00:00:00', '1996-08-23 00:00:00', 3, 3.67, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10265, 'BLONP', 2, '1996-07-25 00:00:00', '1996-08-22 00:00:00', '1996-08-12 00:00:00', 1, 55.28, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10266, 'WARTH', 3, '1996-07-26 00:00:00', '1996-09-06 00:00:00', '1996-07-31 00:00:00', 3, 25.73, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10267, 'FRANK', 4, '1996-07-29 00:00:00', '1996-08-26 00:00:00', '1996-08-06 00:00:00', 1, 208.58, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10270, 'WARTH', 1, '1996-08-01 00:00:00', '1996-08-29 00:00:00', '1996-08-02 00:00:00', 1, 136.54, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10271, 'SPLIR', 6, '1996-08-01 00:00:00', '1996-08-29 00:00:00', '1996-08-30 00:00:00', 2, 4.54, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10272, 'RATTC', 6, '1996-08-02 00:00:00', '1996-08-30 00:00:00', '1996-08-06 00:00:00', 2, 98.03, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10273, 'QUICK', 3, '1996-08-05 00:00:00', '1996-09-02 00:00:00', '1996-08-12 00:00:00', 3, 76.07, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10274, 'VINET', 6, '1996-08-06 00:00:00', '1996-09-03 00:00:00', '1996-08-16 00:00:00', 1, 6.01, 'Vins et alcools Chevalier', '59 rue de l\'Abbaye', 'Reims', '', '51100', 'France'),
(10275, 'MAGAA', 1, '1996-08-07 00:00:00', '1996-09-04 00:00:00', '1996-08-09 00:00:00', 1, 26.93, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10277, 'MORGK', 2, '1996-08-09 00:00:00', '1996-09-06 00:00:00', '1996-08-13 00:00:00', 3, 125.77, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '4179', 'Germany'),
(10280, 'BERGS', 2, '1996-08-14 00:00:00', '1996-09-11 00:00:00', '1996-09-12 00:00:00', 1, 8.98, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10281, 'ROMEY', 4, '1996-08-14 00:00:00', '1996-08-28 00:00:00', '1996-08-21 00:00:00', 1, 2.94, 'Romero y tomillo', 'Gran V�a, 1', 'Madrid', '', '28001', 'Spain'),
(10282, 'ROMEY', 4, '1996-08-15 00:00:00', '1996-09-12 00:00:00', '1996-08-21 00:00:00', 1, 12.69, 'Romero y tomillo', 'Gran V�a, 1', 'Madrid', '', '28001', 'Spain'),
(10283, 'LILAS', 3, '1996-08-16 00:00:00', '1996-09-13 00:00:00', '1996-08-23 00:00:00', 3, 84.81, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10284, 'LEHMS', 4, '1996-08-19 00:00:00', '1996-09-16 00:00:00', '1996-08-27 00:00:00', 1, 76.56, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10285, 'QUICK', 1, '1996-08-20 00:00:00', '1996-09-17 00:00:00', '1996-08-26 00:00:00', 2, 76.83, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10288, 'REGGC', 4, '1996-08-23 00:00:00', '1996-09-20 00:00:00', '1996-09-03 00:00:00', 1, 7.45, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10291, 'QUEDE', 6, '1996-08-27 00:00:00', '1996-09-24 00:00:00', '1996-09-04 00:00:00', 2, 6.4, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10292, 'TRADH', 1, '1996-08-28 00:00:00', '1996-09-25 00:00:00', '1996-09-02 00:00:00', 2, 1.35, 'Tradi�ao Hipermercados', 'Av. In�s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil'),
(10293, 'TORTU', 1, '1996-08-29 00:00:00', '1996-09-26 00:00:00', '1996-09-11 00:00:00', 3, 21.18, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10294, 'RATTC', 4, '1996-08-30 00:00:00', '1996-09-27 00:00:00', '1996-09-05 00:00:00', 2, 147.26, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10295, 'VINET', 2, '1996-09-02 00:00:00', '1996-09-30 00:00:00', '1996-09-10 00:00:00', 2, 1.15, 'Vins et alcools Chevalier', '59 rue de l\'Abbaye', 'Reims', '', '51100', 'France'),
(10296, 'LILAS', 6, '1996-09-03 00:00:00', '1996-10-01 00:00:00', '1996-09-11 00:00:00', 1, 0.12, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10297, 'BLONP', 5, '1996-09-04 00:00:00', '1996-10-16 00:00:00', '1996-09-10 00:00:00', 2, 5.74, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10298, 'HUNGO', 6, '1996-09-05 00:00:00', '1996-10-03 00:00:00', '1996-09-11 00:00:00', 2, 168.22, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10299, 'RICAR', 4, '1996-09-06 00:00:00', '1996-10-04 00:00:00', '1996-09-13 00:00:00', 2, 29.76, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10300, 'MAGAA', 2, '1996-09-09 00:00:00', '1996-10-07 00:00:00', '1996-09-18 00:00:00', 2, 17.68, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10302, 'SUPRD', 4, '1996-09-10 00:00:00', '1996-10-08 00:00:00', '1996-10-09 00:00:00', 2, 6.27, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10304, 'TORTU', 1, '1996-09-12 00:00:00', '1996-10-10 00:00:00', '1996-09-17 00:00:00', 2, 63.79, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10306, 'ROMEY', 1, '1996-09-16 00:00:00', '1996-10-14 00:00:00', '1996-09-23 00:00:00', 3, 7.56, 'Romero y tomillo', 'Gran V�a, 1', 'Madrid', '', '28001', 'Spain'),
(10307, 'LONEP', 2, '1996-09-17 00:00:00', '1996-10-15 00:00:00', '1996-09-25 00:00:00', 2, 0.56, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10309, 'HUNGO', 3, '1996-09-19 00:00:00', '1996-10-17 00:00:00', '1996-10-23 00:00:00', 1, 47.3, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10311, 'DUMON', 1, '1996-09-20 00:00:00', '1996-10-04 00:00:00', '1996-09-26 00:00:00', 3, 24.69, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', '', '44000', 'France'),
(10312, 'WANDK', 2, '1996-09-23 00:00:00', '1996-10-21 00:00:00', '1996-10-03 00:00:00', 2, 40.26, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany'),
(10313, 'QUICK', 2, '1996-09-24 00:00:00', '1996-10-22 00:00:00', '1996-10-04 00:00:00', 2, 1.96, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10314, 'RATTC', 1, '1996-09-25 00:00:00', '1996-10-23 00:00:00', '1996-10-04 00:00:00', 2, 74.16, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10315, 'ISLAT', 4, '1996-09-26 00:00:00', '1996-10-24 00:00:00', '1996-10-03 00:00:00', 2, 41.76, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10316, 'RATTC', 1, '1996-09-27 00:00:00', '1996-10-25 00:00:00', '1996-10-08 00:00:00', 3, 150.15, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10317, 'LONEP', 6, '1996-09-30 00:00:00', '1996-10-28 00:00:00', '1996-10-10 00:00:00', 1, 12.69, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10320, 'WARTH', 5, '1996-10-03 00:00:00', '1996-10-17 00:00:00', '1996-10-18 00:00:00', 3, 34.57, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10321, 'ISLAT', 3, '1996-10-03 00:00:00', '1996-10-31 00:00:00', '1996-10-11 00:00:00', 2, 3.43, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10323, 'KOENE', 4, '1996-10-07 00:00:00', '1996-11-04 00:00:00', '1996-10-14 00:00:00', 1, 4.88, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10325, 'KOENE', 1, '1996-10-09 00:00:00', '1996-10-23 00:00:00', '1996-10-14 00:00:00', 3, 64.86, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10326, 'BOLID', 4, '1996-10-10 00:00:00', '1996-11-07 00:00:00', '1996-10-14 00:00:00', 2, 77.92, 'B�lido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', '', '28023', 'Spain'),
(10327, 'FOLKO', 2, '1996-10-11 00:00:00', '1996-11-08 00:00:00', '1996-10-14 00:00:00', 1, 63.36, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10328, 'FURIB', 4, '1996-10-14 00:00:00', '1996-11-11 00:00:00', '1996-10-17 00:00:00', 3, 87.03, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10329, 'SPLIR', 4, '1996-10-15 00:00:00', '1996-11-26 00:00:00', '1996-10-23 00:00:00', 2, 191.67, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10330, 'LILAS', 3, '1996-10-16 00:00:00', '1996-11-13 00:00:00', '1996-10-28 00:00:00', 1, 12.75, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10332, 'MEREP', 3, '1996-10-17 00:00:00', '1996-11-28 00:00:00', '1996-10-21 00:00:00', 2, 52.84, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10333, 'WARTH', 5, '1996-10-18 00:00:00', '1996-11-15 00:00:00', '1996-10-25 00:00:00', 3, 0.59, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10337, 'FRANK', 4, '1996-10-24 00:00:00', '1996-11-21 00:00:00', '1996-10-29 00:00:00', 3, 108.26, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10338, 'OLDWO', 4, '1996-10-25 00:00:00', '1996-11-22 00:00:00', '1996-10-29 00:00:00', 3, 84.21, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10339, 'MEREP', 2, '1996-10-28 00:00:00', '1996-11-25 00:00:00', '1996-11-04 00:00:00', 2, 15.66, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10340, 'BONAP', 1, '1996-10-29 00:00:00', '1996-11-26 00:00:00', '1996-11-08 00:00:00', 3, 166.31, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10342, 'FRANK', 4, '1996-10-30 00:00:00', '1996-11-13 00:00:00', '1996-11-04 00:00:00', 2, 54.83, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10343, 'LEHMS', 4, '1996-10-31 00:00:00', '1996-11-28 00:00:00', '1996-11-06 00:00:00', 1, 110.37, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10345, 'QUICK', 2, '1996-11-04 00:00:00', '1996-12-02 00:00:00', '1996-11-11 00:00:00', 2, 249.06, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10346, 'RATTC', 3, '1996-11-05 00:00:00', '1996-12-17 00:00:00', '1996-11-08 00:00:00', 3, 142.08, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10347, 'FAMIA', 4, '1996-11-06 00:00:00', '1996-12-04 00:00:00', '1996-11-08 00:00:00', 3, 3.1, 'Familia Arquibaldo', 'Rua Or�s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil'),
(10348, 'WANDK', 4, '1996-11-07 00:00:00', '1996-12-05 00:00:00', '1996-11-15 00:00:00', 2, 0.78, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany'),
(10350, 'LAMAI', 6, '1996-11-11 00:00:00', '1996-12-09 00:00:00', '1996-12-03 00:00:00', 2, 64.19, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10351, 'ERNSH', 1, '1996-11-11 00:00:00', '1996-12-09 00:00:00', '1996-11-20 00:00:00', 1, 162.33, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10352, 'FURIB', 3, '1996-11-12 00:00:00', '1996-11-26 00:00:00', '1996-11-18 00:00:00', 3, 1.3, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10355, 'ALFRE', 6, '1996-11-15 00:00:00', '1996-12-13 00:00:00', '1996-11-20 00:00:00', 1, 41.95, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10356, 'WANDK', 6, '1996-11-18 00:00:00', '1996-12-16 00:00:00', '1996-11-27 00:00:00', 2, 36.71, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany'),
(10357, 'LILAS', 1, '1996-11-19 00:00:00', '1996-12-17 00:00:00', '1996-12-02 00:00:00', 3, 34.88, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10358, 'LAMAI', 5, '1996-11-20 00:00:00', '1996-12-18 00:00:00', '1996-11-27 00:00:00', 1, 19.64, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10359, 'SEVES', 5, '1996-11-21 00:00:00', '1996-12-19 00:00:00', '1996-11-26 00:00:00', 3, 288.43, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10360, 'BLONP', 4, '1996-11-22 00:00:00', '1996-12-20 00:00:00', '1996-12-02 00:00:00', 3, 131.7, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10361, 'QUICK', 1, '1996-11-22 00:00:00', '1996-12-20 00:00:00', '1996-12-03 00:00:00', 2, 183.17, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10362, 'BONAP', 3, '1996-11-25 00:00:00', '1996-12-23 00:00:00', '1996-11-28 00:00:00', 1, 96.04, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10363, 'DRACD', 4, '1996-11-26 00:00:00', '1996-12-24 00:00:00', '1996-12-04 00:00:00', 3, 30.54, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', '', '52066', 'Germany'),
(10364, 'EASTC', 1, '1996-11-26 00:00:00', '1997-01-07 00:00:00', '1996-12-04 00:00:00', 1, 71.97, 'Eastern Connection', '35 King George', 'London', '', 'WX3 6FW', 'UK'),
(10365, 'ANTON', 3, '1996-11-27 00:00:00', '1996-12-25 00:00:00', '1996-12-02 00:00:00', 2, 22, 'Antonio Moreno Taquer�a', 'Mataderos  2312', 'M�xico D.F.', '', '5023', 'Mexico'),
(10368, 'ERNSH', 2, '1996-11-29 00:00:00', '1996-12-27 00:00:00', '1996-12-02 00:00:00', 2, 101.95, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10370, 'CHOPS', 6, '1996-12-03 00:00:00', '1996-12-31 00:00:00', '1996-12-27 00:00:00', 2, 1.17, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(10371, 'LAMAI', 1, '1996-12-03 00:00:00', '1996-12-31 00:00:00', '1996-12-24 00:00:00', 1, 0.45, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10372, 'QUEEN', 5, '1996-12-04 00:00:00', '1997-01-01 00:00:00', '1996-12-09 00:00:00', 2, 890.78, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10373, 'HUNGO', 4, '1996-12-05 00:00:00', '1997-01-02 00:00:00', '1996-12-11 00:00:00', 3, 124.12, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10375, 'HUNGC', 3, '1996-12-06 00:00:00', '1997-01-03 00:00:00', '1996-12-09 00:00:00', 2, 20.12, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA'),
(10376, 'MEREP', 1, '1996-12-09 00:00:00', '1997-01-06 00:00:00', '1996-12-13 00:00:00', 2, 20.39, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10377, 'SEVES', 1, '1996-12-09 00:00:00', '1997-01-06 00:00:00', '1996-12-13 00:00:00', 3, 22.21, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10378, 'FOLKO', 5, '1996-12-10 00:00:00', '1997-01-07 00:00:00', '1996-12-19 00:00:00', 3, 5.44, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10379, 'QUEDE', 2, '1996-12-11 00:00:00', '1997-01-08 00:00:00', '1996-12-13 00:00:00', 1, 45.03, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10381, 'LILAS', 3, '1996-12-12 00:00:00', '1997-01-09 00:00:00', '1996-12-13 00:00:00', 3, 7.99, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10382, 'ERNSH', 4, '1996-12-13 00:00:00', '1997-01-10 00:00:00', '1996-12-16 00:00:00', 1, 94.77, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10384, 'BERGS', 3, '1996-12-16 00:00:00', '1997-01-13 00:00:00', '1996-12-20 00:00:00', 3, 168.64, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10385, 'SPLIR', 1, '1996-12-17 00:00:00', '1997-01-14 00:00:00', '1996-12-23 00:00:00', 2, 30.96, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10387, 'SANTG', 1, '1996-12-18 00:00:00', '1997-01-15 00:00:00', '1996-12-20 00:00:00', 2, 93.63, 'Sant� Gourmet', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway'),
(10388, 'SEVES', 2, '1996-12-19 00:00:00', '1997-01-16 00:00:00', '1996-12-20 00:00:00', 1, 34.86, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10389, 'BOTTM', 4, '1996-12-20 00:00:00', '1997-01-17 00:00:00', '1996-12-24 00:00:00', 2, 47.42, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10390, 'ERNSH', 6, '1996-12-23 00:00:00', '1997-01-20 00:00:00', '1996-12-26 00:00:00', 1, 126.38, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10391, 'DRACD', 3, '1996-12-23 00:00:00', '1997-01-20 00:00:00', '1996-12-31 00:00:00', 3, 5.45, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', '', '52066', 'Germany'),
(10392, 'PICCO', 2, '1996-12-24 00:00:00', '1997-01-21 00:00:00', '1997-01-01 00:00:00', 3, 122.46, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10393, 'SAVEA', 1, '1996-12-25 00:00:00', '1997-01-22 00:00:00', '1997-01-03 00:00:00', 3, 126.56, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10394, 'HUNGC', 1, '1996-12-25 00:00:00', '1997-01-22 00:00:00', '1997-01-03 00:00:00', 3, 30.34, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA'),
(10395, 'HILAA', 6, '1996-12-26 00:00:00', '1997-01-23 00:00:00', '1997-01-03 00:00:00', 1, 184.41, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10396, 'FRANK', 1, '1996-12-27 00:00:00', '1997-01-10 00:00:00', '1997-01-06 00:00:00', 3, 135.35, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10397, 'PRINI', 5, '1996-12-27 00:00:00', '1997-01-24 00:00:00', '1997-01-02 00:00:00', 1, 60.26, 'Princesa Isabel Vinhos', 'Estrada da sa�de n. 58', 'Lisboa', '', '1756', 'Portugal'),
(10398, 'SAVEA', 2, '1996-12-30 00:00:00', '1997-01-27 00:00:00', '1997-01-09 00:00:00', 3, 89.16, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10400, 'EASTC', 1, '1997-01-01 00:00:00', '1997-01-29 00:00:00', '1997-01-16 00:00:00', 3, 83.93, 'Eastern Connection', '35 King George', 'London', '', 'WX3 6FW', 'UK'),
(10401, 'RATTC', 1, '1997-01-01 00:00:00', '1997-01-29 00:00:00', '1997-01-10 00:00:00', 1, 12.51, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10403, 'ERNSH', 4, '1997-01-03 00:00:00', '1997-01-31 00:00:00', '1997-01-09 00:00:00', 3, 73.79, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10404, 'MAGAA', 2, '1997-01-03 00:00:00', '1997-01-31 00:00:00', '1997-01-08 00:00:00', 1, 155.97, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10405, 'LINOD', 1, '1997-01-06 00:00:00', '1997-02-03 00:00:00', '1997-01-22 00:00:00', 1, 34.82, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10407, 'OTTIK', 2, '1997-01-07 00:00:00', '1997-02-04 00:00:00', '1997-01-30 00:00:00', 2, 91.48, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10409, 'OCEAN', 3, '1997-01-09 00:00:00', '1997-02-06 00:00:00', '1997-01-14 00:00:00', 1, 29.83, 'Oc�ano Atl�ntico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina'),
(10410, 'BOTTM', 3, '1997-01-10 00:00:00', '1997-02-07 00:00:00', '1997-01-15 00:00:00', 3, 2.4, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10413, 'LAMAI', 3, '1997-01-14 00:00:00', '1997-02-11 00:00:00', '1997-01-16 00:00:00', 2, 95.66, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10414, 'FAMIA', 2, '1997-01-14 00:00:00', '1997-02-11 00:00:00', '1997-01-17 00:00:00', 3, 21.48, 'Familia Arquibaldo', 'Rua Or�s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil'),
(10415, 'HUNGC', 3, '1997-01-15 00:00:00', '1997-02-12 00:00:00', '1997-01-24 00:00:00', 1, 0.2, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA'),
(10417, 'SIMOB', 4, '1997-01-16 00:00:00', '1997-02-13 00:00:00', '1997-01-28 00:00:00', 3, 70.29, 'Simons bistro', 'Vinb�ltet 34', 'Kobenhavn', '', '1734', 'Denmark'),
(10418, 'QUICK', 4, '1997-01-17 00:00:00', '1997-02-14 00:00:00', '1997-01-24 00:00:00', 1, 17.55, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10419, 'RICSU', 4, '1997-01-20 00:00:00', '1997-02-17 00:00:00', '1997-01-30 00:00:00', 2, 137.35, 'Richter Supermarkt', 'Starenweg 5', 'Gen�ve', '', '1204', 'Switzerland'),
(10422, 'FRANS', 2, '1997-01-22 00:00:00', '1997-02-19 00:00:00', '1997-01-31 00:00:00', 1, 3.02, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(10423, 'GOURL', 6, '1997-01-23 00:00:00', '1997-02-06 00:00:00', '1997-02-24 00:00:00', 3, 24.5, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10425, 'LAMAI', 6, '1997-01-24 00:00:00', '1997-02-21 00:00:00', '1997-02-14 00:00:00', 2, 7.93, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10426, 'GALED', 4, '1997-01-27 00:00:00', '1997-02-24 00:00:00', '1997-02-06 00:00:00', 1, 18.69, 'Galer�a del gastron�mo', 'Rambla de Catalu�a, 23', 'Barcelona', '', '8022', 'Spain'),
(10427, 'PICCO', 4, '1997-01-27 00:00:00', '1997-02-24 00:00:00', '1997-03-03 00:00:00', 2, 31.29, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10429, 'HUNGO', 3, '1997-01-29 00:00:00', '1997-03-12 00:00:00', '1997-02-07 00:00:00', 2, 56.63, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10430, 'ERNSH', 4, '1997-01-30 00:00:00', '1997-02-13 00:00:00', '1997-02-03 00:00:00', 1, 458.78, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10431, 'BOTTM', 4, '1997-01-30 00:00:00', '1997-02-13 00:00:00', '1997-02-07 00:00:00', 2, 44.17, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10432, 'SPLIR', 3, '1997-01-31 00:00:00', '1997-02-14 00:00:00', '1997-02-07 00:00:00', 2, 4.34, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10433, 'PRINI', 3, '1997-02-03 00:00:00', '1997-03-03 00:00:00', '1997-03-04 00:00:00', 3, 73.83, 'Princesa Isabel Vinhos', 'Estrada da sa�de n. 58', 'Lisboa', '', '1756', 'Portugal'),
(10434, 'FOLKO', 3, '1997-02-03 00:00:00', '1997-03-03 00:00:00', '1997-02-13 00:00:00', 2, 17.92, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10436, 'BLONP', 3, '1997-02-05 00:00:00', '1997-03-05 00:00:00', '1997-02-11 00:00:00', 2, 156.66, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10438, 'TOMSP', 3, '1997-02-06 00:00:00', '1997-03-06 00:00:00', '1997-02-14 00:00:00', 2, 8.24, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10439, 'MEREP', 6, '1997-02-07 00:00:00', '1997-03-07 00:00:00', '1997-02-10 00:00:00', 3, 4.07, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10440, 'SAVEA', 4, '1997-02-10 00:00:00', '1997-03-10 00:00:00', '1997-02-28 00:00:00', 2, 86.53, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10441, 'OLDWO', 3, '1997-02-10 00:00:00', '1997-03-24 00:00:00', '1997-03-14 00:00:00', 2, 73.02, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10442, 'ERNSH', 3, '1997-02-11 00:00:00', '1997-03-11 00:00:00', '1997-02-18 00:00:00', 2, 47.94, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10444, 'BERGS', 3, '1997-02-12 00:00:00', '1997-03-12 00:00:00', '1997-02-21 00:00:00', 3, 3.5, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10445, 'BERGS', 3, '1997-02-13 00:00:00', '1997-03-13 00:00:00', '1997-02-20 00:00:00', 1, 9.3, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10446, 'TOMSP', 6, '1997-02-14 00:00:00', '1997-03-14 00:00:00', '1997-02-19 00:00:00', 1, 14.68, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10447, 'RICAR', 4, '1997-02-14 00:00:00', '1997-03-14 00:00:00', '1997-03-07 00:00:00', 2, 68.66, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10448, 'RANCH', 4, '1997-02-17 00:00:00', '1997-03-17 00:00:00', '1997-02-24 00:00:00', 2, 38.82, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina'),
(10449, 'BLONP', 3, '1997-02-18 00:00:00', '1997-03-18 00:00:00', '1997-02-27 00:00:00', 2, 53.3, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10451, 'QUICK', 4, '1997-02-19 00:00:00', '1997-03-05 00:00:00', '1997-03-12 00:00:00', 3, 189.09, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10453, 'ALFRE', 1, '1997-02-21 00:00:00', '1997-03-21 00:00:00', '1997-02-26 00:00:00', 2, 25.36, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10454, 'LAMAI', 4, '1997-02-21 00:00:00', '1997-03-21 00:00:00', '1997-02-25 00:00:00', 3, 2.74, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10457, 'KOENE', 2, '1997-02-25 00:00:00', '1997-03-25 00:00:00', '1997-03-03 00:00:00', 1, 11.57, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10459, 'VICTE', 4, '1997-02-27 00:00:00', '1997-03-27 00:00:00', '1997-02-28 00:00:00', 2, 25.09, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10461, 'LILAS', 1, '1997-02-28 00:00:00', '1997-03-28 00:00:00', '1997-03-05 00:00:00', 3, 148.61, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10462, 'CONSH', 2, '1997-03-03 00:00:00', '1997-03-31 00:00:00', '1997-03-18 00:00:00', 1, 6.17, 'Consolidated Holdings', 'Berkeley Gardens 12  Brewery', 'London', '', 'WX1 6LT', 'UK'),
(10463, 'SUPRD', 5, '1997-03-04 00:00:00', '1997-04-01 00:00:00', '1997-03-06 00:00:00', 3, 14.78, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10464, 'FURIB', 4, '1997-03-04 00:00:00', '1997-04-01 00:00:00', '1997-03-14 00:00:00', 2, 89, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10465, 'VAFFE', 1, '1997-03-05 00:00:00', '1997-04-02 00:00:00', '1997-03-14 00:00:00', 3, 145.04, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10466, 'COMMI', 4, '1997-03-06 00:00:00', '1997-04-03 00:00:00', '1997-03-13 00:00:00', 1, 11.93, 'Com�rcio Mineiro', 'Av. dos Lus�adas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil'),
(10468, 'KOENE', 3, '1997-03-07 00:00:00', '1997-04-04 00:00:00', '1997-03-12 00:00:00', 3, 44.12, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10470, 'BONAP', 4, '1997-03-11 00:00:00', '1997-04-08 00:00:00', '1997-03-14 00:00:00', 2, 64.56, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10471, 'BSBEV', 2, '1997-03-11 00:00:00', '1997-04-08 00:00:00', '1997-03-18 00:00:00', 3, 45.59, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10473, 'ISLAT', 1, '1997-03-13 00:00:00', '1997-03-27 00:00:00', '1997-03-21 00:00:00', 3, 16.37, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10474, 'PERIC', 5, '1997-03-13 00:00:00', '1997-04-10 00:00:00', '1997-03-21 00:00:00', 2, 83.49, 'Pericles Comidas cl�sicas', 'Calle Dr. Jorge Cash 321', 'M�xico D.F.', '', '5033', 'Mexico'),
(10477, 'PRINI', 5, '1997-03-17 00:00:00', '1997-04-14 00:00:00', '1997-03-25 00:00:00', 2, 13.02, 'Princesa Isabel Vinhos', 'Estrada da sa�de n. 58', 'Lisboa', '', '1756', 'Portugal'),
(10478, 'VICTE', 2, '1997-03-18 00:00:00', '1997-04-01 00:00:00', '1997-03-26 00:00:00', 3, 4.81, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10479, 'RATTC', 3, '1997-03-19 00:00:00', '1997-04-16 00:00:00', '1997-03-21 00:00:00', 3, 708.95, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10480, 'FOLIG', 6, '1997-03-20 00:00:00', '1997-04-17 00:00:00', '1997-03-24 00:00:00', 2, 1.35, 'Folies gourmandes', '184, chauss�e de Tournai', 'Lille', '', '59000', 'France'),
(10482, 'LAZYK', 1, '1997-03-21 00:00:00', '1997-04-18 00:00:00', '1997-04-10 00:00:00', 3, 7.48, 'Lazy K Kountry Store', '12 Orchestra Terrace', 'Walla Walla', 'WA', '99362', 'USA'),
(10484, 'BSBEV', 3, '1997-03-24 00:00:00', '1997-04-21 00:00:00', '1997-04-01 00:00:00', 3, 6.88, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10485, 'LINOD', 4, '1997-03-25 00:00:00', '1997-04-08 00:00:00', '1997-03-31 00:00:00', 2, 64.45, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10486, 'HILAA', 1, '1997-03-26 00:00:00', '1997-04-23 00:00:00', '1997-04-02 00:00:00', 2, 30.53, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10487, 'QUEEN', 2, '1997-03-26 00:00:00', '1997-04-23 00:00:00', '1997-03-28 00:00:00', 2, 71.07, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10489, 'PICCO', 6, '1997-03-28 00:00:00', '1997-04-25 00:00:00', '1997-04-09 00:00:00', 2, 5.29, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10492, 'BOTTM', 3, '1997-04-01 00:00:00', '1997-04-29 00:00:00', '1997-04-11 00:00:00', 1, 62.89, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10493, 'LAMAI', 4, '1997-04-02 00:00:00', '1997-04-30 00:00:00', '1997-04-10 00:00:00', 3, 10.64, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10494, 'COMMI', 4, '1997-04-02 00:00:00', '1997-04-30 00:00:00', '1997-04-09 00:00:00', 2, 65.99, 'Com�rcio Mineiro', 'Av. dos Lus�adas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil'),
(10495, 'LAUGB', 3, '1997-04-03 00:00:00', '1997-05-01 00:00:00', '1997-04-11 00:00:00', 3, 4.65, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada'),
(10499, 'LILAS', 4, '1997-04-08 00:00:00', '1997-05-06 00:00:00', '1997-04-16 00:00:00', 2, 102.02, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10500, 'LAMAI', 6, '1997-04-09 00:00:00', '1997-05-07 00:00:00', '1997-04-17 00:00:00', 1, 42.68, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10502, 'PERIC', 2, '1997-04-10 00:00:00', '1997-05-08 00:00:00', '1997-04-29 00:00:00', 1, 69.32, 'Pericles Comidas cl�sicas', 'Calle Dr. Jorge Cash 321', 'M�xico D.F.', '', '5033', 'Mexico'),
(10503, 'HUNGO', 6, '1997-04-11 00:00:00', '1997-05-09 00:00:00', '1997-04-16 00:00:00', 2, 16.74, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10505, 'MEREP', 3, '1997-04-14 00:00:00', '1997-05-12 00:00:00', '1997-04-21 00:00:00', 3, 7.13, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10508, 'OTTIK', 1, '1997-04-16 00:00:00', '1997-05-14 00:00:00', '1997-05-13 00:00:00', 2, 4.99, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10509, 'BLAUS', 4, '1997-04-17 00:00:00', '1997-05-15 00:00:00', '1997-04-29 00:00:00', 1, 0.15, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', '', '68306', 'Germany'),
(10510, 'SAVEA', 6, '1997-04-18 00:00:00', '1997-05-16 00:00:00', '1997-04-28 00:00:00', 3, 367.63, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10511, 'BONAP', 4, '1997-04-18 00:00:00', '1997-05-16 00:00:00', '1997-04-21 00:00:00', 3, 350.64, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10514, 'ERNSH', 3, '1997-04-22 00:00:00', '1997-05-20 00:00:00', '1997-05-16 00:00:00', 2, 789.95, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10515, 'QUICK', 2, '1997-04-23 00:00:00', '1997-05-07 00:00:00', '1997-05-23 00:00:00', 1, 204.47, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10516, 'HUNGO', 2, '1997-04-24 00:00:00', '1997-05-22 00:00:00', '1997-05-01 00:00:00', 3, 62.78, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10517, 'NORTS', 3, '1997-04-24 00:00:00', '1997-05-22 00:00:00', '1997-04-29 00:00:00', 3, 32.07, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK'),
(10518, 'TORTU', 4, '1997-04-25 00:00:00', '1997-05-09 00:00:00', '1997-05-05 00:00:00', 2, 218.15, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10519, 'CHOPS', 6, '1997-04-28 00:00:00', '1997-05-26 00:00:00', '1997-05-01 00:00:00', 3, 91.76, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(10522, 'LEHMS', 4, '1997-04-30 00:00:00', '1997-05-28 00:00:00', '1997-05-06 00:00:00', 1, 45.33, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10524, 'BERGS', 1, '1997-05-01 00:00:00', '1997-05-29 00:00:00', '1997-05-07 00:00:00', 2, 244.79, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10525, 'BONAP', 1, '1997-05-02 00:00:00', '1997-05-30 00:00:00', '1997-05-23 00:00:00', 2, 11.06, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10526, 'WARTH', 4, '1997-05-05 00:00:00', '1997-06-02 00:00:00', '1997-05-15 00:00:00', 2, 58.59, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10528, 'GREAL', 6, '1997-05-06 00:00:00', '1997-05-20 00:00:00', '1997-05-09 00:00:00', 2, 3.35, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10529, 'MAISD', 5, '1997-05-07 00:00:00', '1997-06-04 00:00:00', '1997-05-09 00:00:00', 2, 66.69, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium'),
(10530, 'PICCO', 3, '1997-05-08 00:00:00', '1997-06-05 00:00:00', '1997-05-12 00:00:00', 2, 339.22, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10535, 'ANTON', 4, '1997-05-13 00:00:00', '1997-06-10 00:00:00', '1997-05-21 00:00:00', 1, 15.64, 'Antonio Moreno Taquer�a', 'Mataderos  2312', 'M�xico D.F.', '', '5023', 'Mexico'),
(10536, 'LEHMS', 3, '1997-05-14 00:00:00', '1997-06-11 00:00:00', '1997-06-06 00:00:00', 2, 58.88, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10537, 'RICSU', 1, '1997-05-14 00:00:00', '1997-05-28 00:00:00', '1997-05-19 00:00:00', 1, 78.85, 'Richter Supermarkt', 'Starenweg 5', 'Gen�ve', '', '1204', 'Switzerland'),
(10539, 'BSBEV', 6, '1997-05-16 00:00:00', '1997-06-13 00:00:00', '1997-05-23 00:00:00', 3, 12.36, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10540, 'QUICK', 3, '1997-05-19 00:00:00', '1997-06-16 00:00:00', '1997-06-13 00:00:00', 3, 1007.64, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10541, 'HANAR', 2, '1997-05-19 00:00:00', '1997-06-16 00:00:00', '1997-05-29 00:00:00', 1, 68.65, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10542, 'KOENE', 1, '1997-05-20 00:00:00', '1997-06-17 00:00:00', '1997-05-26 00:00:00', 3, 10.95, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10544, 'LONEP', 4, '1997-05-21 00:00:00', '1997-06-18 00:00:00', '1997-05-30 00:00:00', 1, 24.91, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10546, 'VICTE', 1, '1997-05-23 00:00:00', '1997-06-20 00:00:00', '1997-05-27 00:00:00', 3, 194.72, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10547, 'SEVES', 3, '1997-05-23 00:00:00', '1997-06-20 00:00:00', '1997-06-02 00:00:00', 2, 178.43, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10548, 'TOMSP', 3, '1997-05-26 00:00:00', '1997-06-23 00:00:00', '1997-06-02 00:00:00', 2, 1.43, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10549, 'QUICK', 5, '1997-05-27 00:00:00', '1997-06-10 00:00:00', '1997-05-30 00:00:00', 1, 171.24, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10551, 'FURIB', 4, '1997-05-28 00:00:00', '1997-07-09 00:00:00', '1997-06-06 00:00:00', 3, 72.95, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10552, 'HILAA', 2, '1997-05-29 00:00:00', '1997-06-26 00:00:00', '1997-06-05 00:00:00', 1, 83.22, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10553, 'WARTH', 2, '1997-05-30 00:00:00', '1997-06-27 00:00:00', '1997-06-03 00:00:00', 2, 149.49, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10554, 'OTTIK', 4, '1997-05-30 00:00:00', '1997-06-27 00:00:00', '1997-06-05 00:00:00', 3, 120.97, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10555, 'SAVEA', 6, '1997-06-02 00:00:00', '1997-06-30 00:00:00', '1997-06-04 00:00:00', 3, 252.49, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10556, 'SIMOB', 2, '1997-06-03 00:00:00', '1997-07-15 00:00:00', '1997-06-13 00:00:00', 1, 9.8, 'Simons bistro', 'Vinb�ltet 34', 'Kobenhavn', '', '1734', 'Denmark'),
(10558, 'ALFRE', 1, '1997-06-04 00:00:00', '1997-07-02 00:00:00', '1997-06-10 00:00:00', 2, 72.97, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10559, 'BLONP', 6, '1997-06-05 00:00:00', '1997-07-03 00:00:00', '1997-06-13 00:00:00', 1, 8.05, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10561, 'FOLKO', 2, '1997-06-06 00:00:00', '1997-07-04 00:00:00', '1997-06-09 00:00:00', 2, 242.21, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10562, 'REGGC', 1, '1997-06-09 00:00:00', '1997-07-07 00:00:00', '1997-06-12 00:00:00', 1, 22.95, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10563, 'RICAR', 2, '1997-06-10 00:00:00', '1997-07-22 00:00:00', '1997-06-24 00:00:00', 2, 60.43, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10564, 'RATTC', 4, '1997-06-10 00:00:00', '1997-07-08 00:00:00', '1997-06-16 00:00:00', 3, 13.75, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10567, 'HUNGO', 1, '1997-06-12 00:00:00', '1997-07-10 00:00:00', '1997-06-17 00:00:00', 1, 33.97, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10568, 'GALED', 3, '1997-06-13 00:00:00', '1997-07-11 00:00:00', '1997-07-09 00:00:00', 3, 6.54, 'Galer�a del gastron�mo', 'Rambla de Catalu�a, 23', 'Barcelona', '', '8022', 'Spain'),
(10569, 'RATTC', 5, '1997-06-16 00:00:00', '1997-07-14 00:00:00', '1997-07-11 00:00:00', 1, 58.98, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10570, 'MEREP', 3, '1997-06-17 00:00:00', '1997-07-15 00:00:00', '1997-06-19 00:00:00', 3, 188.99, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10572, 'BERGS', 3, '1997-06-18 00:00:00', '1997-07-16 00:00:00', '1997-06-25 00:00:00', 2, 116.43, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10574, 'TRAIH', 4, '1997-06-19 00:00:00', '1997-07-17 00:00:00', '1997-06-30 00:00:00', 2, 37.6, 'Trail\'s Head Gourmet Provisioners', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA'),
(10575, 'MORGK', 5, '1997-06-20 00:00:00', '1997-07-04 00:00:00', '1997-06-30 00:00:00', 1, 127.34, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '4179', 'Germany'),
(10576, 'TORTU', 3, '1997-06-23 00:00:00', '1997-07-07 00:00:00', '1997-06-30 00:00:00', 3, 18.56, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10578, 'BSBEV', 4, '1997-06-24 00:00:00', '1997-07-22 00:00:00', '1997-07-25 00:00:00', 3, 29.6, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10579, 'LETSS', 1, '1997-06-25 00:00:00', '1997-07-23 00:00:00', '1997-07-04 00:00:00', 2, 13.73, 'Let\'s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA'),
(10580, 'OTTIK', 4, '1997-06-26 00:00:00', '1997-07-24 00:00:00', '1997-07-01 00:00:00', 3, 75.89, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10581, 'FAMIA', 3, '1997-06-26 00:00:00', '1997-07-24 00:00:00', '1997-07-02 00:00:00', 1, 3.01, 'Familia Arquibaldo', 'Rua Or�s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil'),
(10582, 'BLAUS', 3, '1997-06-27 00:00:00', '1997-07-25 00:00:00', '1997-07-14 00:00:00', 2, 27.71, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', '', '68306', 'Germany'),
(10583, 'WARTH', 2, '1997-06-30 00:00:00', '1997-07-28 00:00:00', '1997-07-04 00:00:00', 2, 7.28, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10584, 'BLONP', 4, '1997-06-30 00:00:00', '1997-07-28 00:00:00', '1997-07-04 00:00:00', 1, 59.14, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10587, 'QUEDE', 1, '1997-07-02 00:00:00', '1997-07-30 00:00:00', '1997-07-09 00:00:00', 1, 62.52, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10588, 'QUICK', 2, '1997-07-03 00:00:00', '1997-07-31 00:00:00', '1997-07-10 00:00:00', 3, 194.67, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10590, 'MEREP', 4, '1997-07-07 00:00:00', '1997-08-04 00:00:00', '1997-07-14 00:00:00', 3, 44.77, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10591, 'VAFFE', 1, '1997-07-07 00:00:00', '1997-07-21 00:00:00', '1997-07-16 00:00:00', 1, 55.92, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10592, 'LEHMS', 3, '1997-07-08 00:00:00', '1997-08-05 00:00:00', '1997-07-16 00:00:00', 1, 32.1, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10594, 'OLDWO', 3, '1997-07-09 00:00:00', '1997-08-06 00:00:00', '1997-07-16 00:00:00', 2, 5.24, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10595, 'ERNSH', 2, '1997-07-10 00:00:00', '1997-08-07 00:00:00', '1997-07-14 00:00:00', 1, 96.78, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10598, 'RATTC', 1, '1997-07-14 00:00:00', '1997-08-11 00:00:00', '1997-07-18 00:00:00', 3, 44.42, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10599, 'BSBEV', 6, '1997-07-15 00:00:00', '1997-08-26 00:00:00', '1997-07-21 00:00:00', 3, 29.98, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10600, 'HUNGC', 4, '1997-07-16 00:00:00', '1997-08-13 00:00:00', '1997-07-21 00:00:00', 1, 45.13, 'Hungry Coyote Import Store', 'City Center Plaza 516 Main St.', 'Elgin', 'OR', '97827', 'USA'),
(10604, 'FURIB', 1, '1997-07-18 00:00:00', '1997-08-15 00:00:00', '1997-07-29 00:00:00', 1, 7.46, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10605, 'MEREP', 1, '1997-07-21 00:00:00', '1997-08-18 00:00:00', '1997-07-29 00:00:00', 2, 379.13, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10606, 'TRADH', 4, '1997-07-22 00:00:00', '1997-08-19 00:00:00', '1997-07-31 00:00:00', 3, 79.4, 'Tradi�ao Hipermercados', 'Av. In�s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil'),
(10607, 'SAVEA', 5, '1997-07-22 00:00:00', '1997-08-19 00:00:00', '1997-07-25 00:00:00', 1, 200.24, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10608, 'TOMSP', 4, '1997-07-23 00:00:00', '1997-08-20 00:00:00', '1997-08-01 00:00:00', 2, 27.79, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10612, 'SAVEA', 1, '1997-07-28 00:00:00', '1997-08-25 00:00:00', '1997-08-01 00:00:00', 2, 544.08, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10613, 'HILAA', 4, '1997-07-29 00:00:00', '1997-08-26 00:00:00', '1997-08-01 00:00:00', 2, 8.11, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10616, 'GREAL', 1, '1997-07-31 00:00:00', '1997-08-28 00:00:00', '1997-08-05 00:00:00', 2, 116.53, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10617, 'GREAL', 4, '1997-07-31 00:00:00', '1997-08-28 00:00:00', '1997-08-04 00:00:00', 2, 18.53, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10618, 'MEREP', 1, '1997-08-01 00:00:00', '1997-09-12 00:00:00', '1997-08-08 00:00:00', 1, 154.68, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10619, 'MEREP', 3, '1997-08-04 00:00:00', '1997-09-01 00:00:00', '1997-08-07 00:00:00', 3, 91.05, 'M�re Paillarde', '43 rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada'),
(10620, 'LAUGB', 2, '1997-08-05 00:00:00', '1997-09-02 00:00:00', '1997-08-14 00:00:00', 3, 0.94, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada'),
(10621, 'ISLAT', 4, '1997-08-05 00:00:00', '1997-09-02 00:00:00', '1997-08-11 00:00:00', 2, 23.73, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10622, 'RICAR', 4, '1997-08-06 00:00:00', '1997-09-03 00:00:00', '1997-08-11 00:00:00', 3, 50.97, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10624, 'THECR', 4, '1997-08-07 00:00:00', '1997-09-04 00:00:00', '1997-08-19 00:00:00', 2, 94.8, 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA'),
(10625, 'ANATR', 3, '1997-08-08 00:00:00', '1997-09-05 00:00:00', '1997-08-14 00:00:00', 1, 43.9, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constituci�n 2222', 'M�xico D.F.', '', '5021', 'Mexico'),
(10626, 'BERGS', 1, '1997-08-11 00:00:00', '1997-09-08 00:00:00', '1997-08-20 00:00:00', 2, 138.69, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10628, 'BLONP', 4, '1997-08-12 00:00:00', '1997-09-09 00:00:00', '1997-08-20 00:00:00', 3, 30.36, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10629, 'GODOS', 4, '1997-08-12 00:00:00', '1997-09-09 00:00:00', '1997-08-20 00:00:00', 3, 85.46, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10630, 'KOENE', 1, '1997-08-13 00:00:00', '1997-09-10 00:00:00', '1997-08-19 00:00:00', 2, 32.35, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10634, 'FOLIG', 4, '1997-08-15 00:00:00', '1997-09-12 00:00:00', '1997-08-21 00:00:00', 3, 487.38, 'Folies gourmandes', '184, chauss�e de Tournai', 'Lille', '', '59000', 'France'),
(10636, 'WARTH', 4, '1997-08-19 00:00:00', '1997-09-16 00:00:00', '1997-08-26 00:00:00', 1, 1.15, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10637, 'QUEEN', 6, '1997-08-19 00:00:00', '1997-09-16 00:00:00', '1997-08-26 00:00:00', 1, 201.29, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10638, 'LINOD', 3, '1997-08-20 00:00:00', '1997-09-17 00:00:00', '1997-09-01 00:00:00', 1, 158.44, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10640, 'WANDK', 4, '1997-08-21 00:00:00', '1997-09-18 00:00:00', '1997-08-28 00:00:00', 1, 23.55, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany'),
(10641, 'HILAA', 4, '1997-08-22 00:00:00', '1997-09-19 00:00:00', '1997-08-26 00:00:00', 2, 179.61, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela');
INSERT INTO `orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`) VALUES
(10643, 'ALFKI', 6, '1997-08-25 00:00:00', '1997-09-22 00:00:00', '1997-09-02 00:00:00', 1, 29.46, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(10645, 'HANAR', 4, '1997-08-26 00:00:00', '1997-09-23 00:00:00', '1997-09-02 00:00:00', 1, 12.41, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10647, 'QUEDE', 4, '1997-08-27 00:00:00', '1997-09-10 00:00:00', '1997-09-03 00:00:00', 2, 45.54, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10648, 'RICAR', 5, '1997-08-28 00:00:00', '1997-10-09 00:00:00', '1997-09-09 00:00:00', 2, 14.25, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10649, 'MAISD', 5, '1997-08-28 00:00:00', '1997-09-25 00:00:00', '1997-08-29 00:00:00', 3, 6.2, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium'),
(10650, 'FAMIA', 5, '1997-08-29 00:00:00', '1997-09-26 00:00:00', '1997-09-03 00:00:00', 3, 176.81, 'Familia Arquibaldo', 'Rua Or�s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil'),
(10652, 'GOURL', 4, '1997-09-01 00:00:00', '1997-09-29 00:00:00', '1997-09-08 00:00:00', 2, 7.14, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10653, 'FRANK', 1, '1997-09-02 00:00:00', '1997-09-30 00:00:00', '1997-09-19 00:00:00', 1, 93.25, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10654, 'BERGS', 5, '1997-09-02 00:00:00', '1997-09-30 00:00:00', '1997-09-11 00:00:00', 1, 55.26, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10655, 'REGGC', 1, '1997-09-03 00:00:00', '1997-10-01 00:00:00', '1997-09-11 00:00:00', 2, 4.41, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10656, 'GREAL', 6, '1997-09-04 00:00:00', '1997-10-02 00:00:00', '1997-09-10 00:00:00', 1, 57.15, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10657, 'SAVEA', 2, '1997-09-04 00:00:00', '1997-10-02 00:00:00', '1997-09-15 00:00:00', 2, 352.69, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10658, 'QUICK', 4, '1997-09-05 00:00:00', '1997-10-03 00:00:00', '1997-09-08 00:00:00', 1, 364.15, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10662, 'LONEP', 3, '1997-09-09 00:00:00', '1997-10-07 00:00:00', '1997-09-18 00:00:00', 2, 1.28, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10663, 'BONAP', 2, '1997-09-10 00:00:00', '1997-09-24 00:00:00', '1997-10-03 00:00:00', 2, 113.15, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10664, 'FURIB', 1, '1997-09-10 00:00:00', '1997-10-08 00:00:00', '1997-09-19 00:00:00', 3, 1.27, 'Furia Bacalhau e Frutos do Mar', 'Jardim das rosas n. 32', 'Lisboa', '', '1675', 'Portugal'),
(10665, 'LONEP', 1, '1997-09-11 00:00:00', '1997-10-09 00:00:00', '1997-09-17 00:00:00', 2, 26.31, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10668, 'WANDK', 1, '1997-09-15 00:00:00', '1997-10-13 00:00:00', '1997-09-23 00:00:00', 2, 47.22, 'Die Wandernde Kuh', 'Adenauerallee 900', 'Stuttgart', '', '70563', 'Germany'),
(10669, 'SIMOB', 2, '1997-09-15 00:00:00', '1997-10-13 00:00:00', '1997-09-22 00:00:00', 1, 24.39, 'Simons bistro', 'Vinb�ltet 34', 'Kobenhavn', '', '1734', 'Denmark'),
(10670, 'FRANK', 4, '1997-09-16 00:00:00', '1997-10-14 00:00:00', '1997-09-18 00:00:00', 1, 203.48, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10671, 'FRANR', 1, '1997-09-17 00:00:00', '1997-10-15 00:00:00', '1997-09-24 00:00:00', 1, 30.34, 'France restauration', '54, rue Royale', 'Nantes', '', '44000', 'France'),
(10674, 'ISLAT', 4, '1997-09-18 00:00:00', '1997-10-16 00:00:00', '1997-09-30 00:00:00', 2, 0.9, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10675, 'FRANK', 5, '1997-09-19 00:00:00', '1997-10-17 00:00:00', '1997-09-23 00:00:00', 2, 31.85, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10676, 'TORTU', 2, '1997-09-22 00:00:00', '1997-10-20 00:00:00', '1997-09-29 00:00:00', 2, 2.01, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10677, 'ANTON', 1, '1997-09-22 00:00:00', '1997-10-20 00:00:00', '1997-09-26 00:00:00', 3, 4.03, 'Antonio Moreno Taquer�a', 'Mataderos  2312', 'M�xico D.F.', '', '5023', 'Mexico'),
(10680, 'OLDWO', 1, '1997-09-24 00:00:00', '1997-10-22 00:00:00', '1997-09-26 00:00:00', 1, 26.61, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10681, 'GREAL', 3, '1997-09-25 00:00:00', '1997-10-23 00:00:00', '1997-09-30 00:00:00', 3, 76.13, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10682, 'ANTON', 3, '1997-09-25 00:00:00', '1997-10-23 00:00:00', '1997-10-01 00:00:00', 2, 36.13, 'Antonio Moreno Taquer�a', 'Mataderos  2312', 'M�xico D.F.', '', '5023', 'Mexico'),
(10683, 'DUMON', 2, '1997-09-26 00:00:00', '1997-10-24 00:00:00', '1997-10-01 00:00:00', 1, 4.4, 'Du monde entier', '67, rue des Cinquante Otages', 'Nantes', '', '44000', 'France'),
(10684, 'OTTIK', 3, '1997-09-26 00:00:00', '1997-10-24 00:00:00', '1997-09-30 00:00:00', 1, 145.63, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10685, 'GOURL', 4, '1997-09-29 00:00:00', '1997-10-13 00:00:00', '1997-10-03 00:00:00', 2, 33.75, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10686, 'PICCO', 2, '1997-09-30 00:00:00', '1997-10-28 00:00:00', '1997-10-08 00:00:00', 1, 96.5, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10688, 'VAFFE', 4, '1997-10-01 00:00:00', '1997-10-15 00:00:00', '1997-10-07 00:00:00', 2, 299.09, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10689, 'BERGS', 1, '1997-10-01 00:00:00', '1997-10-29 00:00:00', '1997-10-07 00:00:00', 2, 13.42, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10690, 'HANAR', 1, '1997-10-02 00:00:00', '1997-10-30 00:00:00', '1997-10-03 00:00:00', 1, 15.8, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10691, 'QUICK', 2, '1997-10-03 00:00:00', '1997-11-14 00:00:00', '1997-10-22 00:00:00', 2, 810.05, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10692, 'ALFKI', 4, '1997-10-03 00:00:00', '1997-10-31 00:00:00', '1997-10-13 00:00:00', 2, 61.02, 'Alfred\'s Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(10697, 'LINOD', 3, '1997-10-08 00:00:00', '1997-11-05 00:00:00', '1997-10-14 00:00:00', 1, 45.52, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10698, 'ERNSH', 4, '1997-10-09 00:00:00', '1997-11-06 00:00:00', '1997-10-17 00:00:00', 1, 272.47, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10699, 'MORGK', 3, '1997-10-09 00:00:00', '1997-11-06 00:00:00', '1997-10-13 00:00:00', 3, 0.58, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '4179', 'Germany'),
(10700, 'SAVEA', 3, '1997-10-10 00:00:00', '1997-11-07 00:00:00', '1997-10-16 00:00:00', 1, 65.1, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10701, 'HUNGO', 6, '1997-10-13 00:00:00', '1997-10-27 00:00:00', '1997-10-15 00:00:00', 3, 220.31, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10702, 'ALFKI', 4, '1997-10-13 00:00:00', '1997-11-24 00:00:00', '1997-10-21 00:00:00', 1, 23.94, 'Alfred\'s Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(10703, 'FOLKO', 6, '1997-10-14 00:00:00', '1997-11-11 00:00:00', '1997-10-20 00:00:00', 2, 152.3, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10704, 'QUEEN', 6, '1997-10-14 00:00:00', '1997-11-11 00:00:00', '1997-11-07 00:00:00', 1, 4.78, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10707, 'ALFRE', 4, '1997-10-16 00:00:00', '1997-10-30 00:00:00', '1997-10-23 00:00:00', 3, 21.74, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10708, 'THEBI', 6, '1997-10-17 00:00:00', '1997-11-28 00:00:00', '1997-11-05 00:00:00', 2, 2.96, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA'),
(10709, 'GOURL', 1, '1997-10-17 00:00:00', '1997-11-14 00:00:00', '1997-11-20 00:00:00', 3, 210.8, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10710, 'FRANS', 1, '1997-10-20 00:00:00', '1997-11-17 00:00:00', '1997-10-23 00:00:00', 1, 4.98, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(10711, 'SAVEA', 5, '1997-10-21 00:00:00', '1997-12-02 00:00:00', '1997-10-29 00:00:00', 2, 52.41, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10712, 'HUNGO', 3, '1997-10-21 00:00:00', '1997-11-18 00:00:00', '1997-10-31 00:00:00', 1, 89.93, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10713, 'SAVEA', 1, '1997-10-22 00:00:00', '1997-11-19 00:00:00', '1997-10-24 00:00:00', 1, 167.05, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10714, 'SAVEA', 5, '1997-10-22 00:00:00', '1997-11-19 00:00:00', '1997-10-27 00:00:00', 3, 24.49, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10715, 'BONAP', 3, '1997-10-23 00:00:00', '1997-11-06 00:00:00', '1997-10-29 00:00:00', 1, 63.2, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10716, 'RANCH', 4, '1997-10-24 00:00:00', '1997-11-21 00:00:00', '1997-10-27 00:00:00', 2, 22.57, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina'),
(10717, 'FRANK', 1, '1997-10-24 00:00:00', '1997-11-21 00:00:00', '1997-10-29 00:00:00', 2, 59.25, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10718, 'KOENE', 1, '1997-10-27 00:00:00', '1997-11-24 00:00:00', '1997-10-29 00:00:00', 3, 170.88, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10721, 'QUICK', 5, '1997-10-29 00:00:00', '1997-11-26 00:00:00', '1997-10-31 00:00:00', 3, 48.92, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10725, 'FAMIA', 4, '1997-10-31 00:00:00', '1997-11-28 00:00:00', '1997-11-05 00:00:00', 3, 10.83, 'Familia Arquibaldo', 'Rua Or�s, 92', 'Sao Paulo', 'SP', '05442-030', 'Brazil'),
(10726, 'EASTC', 4, '1997-11-03 00:00:00', '1997-11-17 00:00:00', '1997-12-05 00:00:00', 1, 16.56, 'Eastern Connection', '35 King George', 'London', '', 'WX3 6FW', 'UK'),
(10727, 'REGGC', 2, '1997-11-03 00:00:00', '1997-12-01 00:00:00', '1997-12-05 00:00:00', 1, 89.9, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10728, 'QUEEN', 4, '1997-11-04 00:00:00', '1997-12-02 00:00:00', '1997-11-11 00:00:00', 2, 58.33, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10730, 'BONAP', 5, '1997-11-05 00:00:00', '1997-12-03 00:00:00', '1997-11-14 00:00:00', 1, 20.12, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10732, 'BONAP', 3, '1997-11-06 00:00:00', '1997-12-04 00:00:00', '1997-11-07 00:00:00', 1, 16.97, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10733, 'BERGS', 1, '1997-11-07 00:00:00', '1997-12-05 00:00:00', '1997-11-10 00:00:00', 3, 110.11, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10734, 'GOURL', 2, '1997-11-07 00:00:00', '1997-12-05 00:00:00', '1997-11-12 00:00:00', 3, 1.63, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10735, 'LETSS', 6, '1997-11-10 00:00:00', '1997-12-08 00:00:00', '1997-11-21 00:00:00', 2, 45.97, 'Let\'s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA'),
(10737, 'VINET', 2, '1997-11-11 00:00:00', '1997-12-09 00:00:00', '1997-11-18 00:00:00', 2, 7.79, 'Vins et alcools Chevalier', '59 rue de l\'Abbaye', 'Reims', '', '51100', 'France'),
(10738, 'SPECD', 2, '1997-11-12 00:00:00', '1997-12-10 00:00:00', '1997-11-18 00:00:00', 1, 2.91, 'Sp�cialit�s du monde', '25, rue Lauriston', 'Paris', '', '75016', 'France'),
(10739, 'VINET', 3, '1997-11-12 00:00:00', '1997-12-10 00:00:00', '1997-11-17 00:00:00', 3, 11.08, 'Vins et alcools Chevalier', '59 rue de l\'Abbaye', 'Reims', '', '51100', 'France'),
(10741, 'ALFRE', 4, '1997-11-14 00:00:00', '1997-11-28 00:00:00', '1997-11-18 00:00:00', 3, 10.96, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10742, 'BOTTM', 3, '1997-11-14 00:00:00', '1997-12-12 00:00:00', '1997-11-18 00:00:00', 3, 243.73, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10743, 'ALFRE', 1, '1997-11-17 00:00:00', '1997-12-15 00:00:00', '1997-11-21 00:00:00', 2, 23.72, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10744, 'VAFFE', 6, '1997-11-17 00:00:00', '1997-12-15 00:00:00', '1997-11-24 00:00:00', 1, 69.19, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10746, 'CHOPS', 1, '1997-11-19 00:00:00', '1997-12-17 00:00:00', '1997-11-21 00:00:00', 3, 31.43, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(10747, 'PICCO', 6, '1997-11-19 00:00:00', '1997-12-17 00:00:00', '1997-11-26 00:00:00', 1, 117.33, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(10748, 'SAVEA', 3, '1997-11-20 00:00:00', '1997-12-18 00:00:00', '1997-11-28 00:00:00', 1, 232.55, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10749, 'ISLAT', 4, '1997-11-20 00:00:00', '1997-12-18 00:00:00', '1997-12-19 00:00:00', 2, 61.53, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10751, 'RICSU', 3, '1997-11-24 00:00:00', '1997-12-22 00:00:00', '1997-12-03 00:00:00', 3, 130.79, 'Richter Supermarkt', 'Starenweg 5', 'Gen�ve', '', '1204', 'Switzerland'),
(10752, 'NORTS', 2, '1997-11-24 00:00:00', '1997-12-22 00:00:00', '1997-11-28 00:00:00', 3, 1.39, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK'),
(10753, 'FRANS', 3, '1997-11-25 00:00:00', '1997-12-23 00:00:00', '1997-11-27 00:00:00', 1, 7.7, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(10754, 'MAGAA', 6, '1997-11-25 00:00:00', '1997-12-23 00:00:00', '1997-11-27 00:00:00', 3, 2.38, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10755, 'BONAP', 4, '1997-11-26 00:00:00', '1997-12-24 00:00:00', '1997-11-28 00:00:00', 2, 16.71, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10757, 'SAVEA', 6, '1997-11-27 00:00:00', '1997-12-25 00:00:00', '1997-12-15 00:00:00', 1, 8.19, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10758, 'RICSU', 3, '1997-11-28 00:00:00', '1997-12-26 00:00:00', '1997-12-04 00:00:00', 3, 138.17, 'Richter Supermarkt', 'Starenweg 5', 'Gen�ve', '', '1204', 'Switzerland'),
(10759, 'ANATR', 3, '1997-11-28 00:00:00', '1997-12-26 00:00:00', '1997-12-12 00:00:00', 3, 11.99, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constituci�n 2222', 'M�xico D.F.', '', '5021', 'Mexico'),
(10760, 'MAISD', 4, '1997-12-01 00:00:00', '1997-12-29 00:00:00', '1997-12-10 00:00:00', 1, 155.64, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium'),
(10761, 'RATTC', 5, '1997-12-02 00:00:00', '1997-12-30 00:00:00', '1997-12-08 00:00:00', 2, 18.66, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10762, 'FOLKO', 3, '1997-12-02 00:00:00', '1997-12-30 00:00:00', '1997-12-09 00:00:00', 1, 328.74, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10763, 'FOLIG', 3, '1997-12-03 00:00:00', '1997-12-31 00:00:00', '1997-12-08 00:00:00', 3, 37.35, 'Folies gourmandes', '184, chauss�e de Tournai', 'Lille', '', '59000', 'France'),
(10764, 'ERNSH', 6, '1997-12-03 00:00:00', '1997-12-31 00:00:00', '1997-12-08 00:00:00', 3, 145.45, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10765, 'QUICK', 3, '1997-12-04 00:00:00', '1998-01-01 00:00:00', '1997-12-09 00:00:00', 3, 42.74, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10766, 'OTTIK', 4, '1997-12-05 00:00:00', '1998-01-02 00:00:00', '1997-12-09 00:00:00', 1, 157.55, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10767, 'SUPRD', 4, '1997-12-05 00:00:00', '1998-01-02 00:00:00', '1997-12-15 00:00:00', 3, 1.59, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10768, 'ALFRE', 3, '1997-12-08 00:00:00', '1998-01-05 00:00:00', '1997-12-15 00:00:00', 2, 146.32, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10769, 'VAFFE', 3, '1997-12-08 00:00:00', '1998-01-05 00:00:00', '1997-12-12 00:00:00', 1, 65.06, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10772, 'LEHMS', 3, '1997-12-10 00:00:00', '1998-01-07 00:00:00', '1997-12-19 00:00:00', 2, 91.28, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10773, 'ERNSH', 1, '1997-12-11 00:00:00', '1998-01-08 00:00:00', '1997-12-16 00:00:00', 3, 96.43, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10774, 'FOLKO', 4, '1997-12-11 00:00:00', '1997-12-25 00:00:00', '1997-12-12 00:00:00', 1, 48.2, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10776, 'ERNSH', 1, '1997-12-15 00:00:00', '1998-01-12 00:00:00', '1997-12-18 00:00:00', 3, 351.53, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10778, 'BERGS', 3, '1997-12-16 00:00:00', '1998-01-13 00:00:00', '1997-12-24 00:00:00', 1, 6.79, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10779, 'MORGK', 3, '1997-12-16 00:00:00', '1998-01-13 00:00:00', '1998-01-14 00:00:00', 2, 58.13, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '4179', 'Germany'),
(10780, 'LILAS', 2, '1997-12-16 00:00:00', '1997-12-30 00:00:00', '1997-12-25 00:00:00', 1, 42.13, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10781, 'WARTH', 2, '1997-12-17 00:00:00', '1998-01-14 00:00:00', '1997-12-19 00:00:00', 3, 73.16, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(10783, 'HANAR', 4, '1997-12-18 00:00:00', '1998-01-15 00:00:00', '1997-12-19 00:00:00', 2, 124.98, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10784, 'MAGAA', 4, '1997-12-18 00:00:00', '1998-01-15 00:00:00', '1997-12-22 00:00:00', 3, 70.09, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10785, 'GROSR', 1, '1997-12-18 00:00:00', '1998-01-15 00:00:00', '1997-12-24 00:00:00', 3, 1.51, 'GROSELLA-Restaurante', '5� Ave. Los Palos Grandes', 'Caracas', 'DF', '1081', 'Venezuela'),
(10787, 'LAMAI', 2, '1997-12-19 00:00:00', '1998-01-02 00:00:00', '1997-12-26 00:00:00', 1, 249.93, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10788, 'QUICK', 1, '1997-12-22 00:00:00', '1998-01-19 00:00:00', '1998-01-19 00:00:00', 2, 42.7, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10789, 'FOLIG', 1, '1997-12-22 00:00:00', '1998-01-19 00:00:00', '1997-12-31 00:00:00', 2, 100.6, 'Folies gourmandes', '184, chauss�e de Tournai', 'Lille', '', '59000', 'France'),
(10790, 'GOURL', 6, '1997-12-22 00:00:00', '1998-01-19 00:00:00', '1997-12-26 00:00:00', 1, 28.23, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10791, 'FRANK', 6, '1997-12-23 00:00:00', '1998-01-20 00:00:00', '1998-01-01 00:00:00', 2, 16.85, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10793, 'ALFRE', 3, '1997-12-24 00:00:00', '1998-01-21 00:00:00', '1998-01-08 00:00:00', 3, 4.52, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10794, 'QUEDE', 6, '1997-12-24 00:00:00', '1998-01-21 00:00:00', '1998-01-02 00:00:00', 1, 21.49, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10796, 'HILAA', 3, '1997-12-25 00:00:00', '1998-01-22 00:00:00', '1998-01-14 00:00:00', 1, 26.52, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10798, 'ISLAT', 2, '1997-12-26 00:00:00', '1998-01-23 00:00:00', '1998-01-05 00:00:00', 1, 2.33, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10800, 'SEVES', 1, '1997-12-26 00:00:00', '1998-01-23 00:00:00', '1998-01-05 00:00:00', 3, 137.44, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10801, 'BOLID', 4, '1997-12-29 00:00:00', '1998-01-26 00:00:00', '1997-12-31 00:00:00', 2, 97.09, 'B�lido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', '', '28023', 'Spain'),
(10802, 'SIMOB', 4, '1997-12-29 00:00:00', '1998-01-26 00:00:00', '1998-01-02 00:00:00', 2, 257.26, 'Simons bistro', 'Vinb�ltet 34', 'Kobenhavn', '', '1734', 'Denmark'),
(10804, 'SEVES', 6, '1997-12-30 00:00:00', '1998-01-27 00:00:00', '1998-01-07 00:00:00', 2, 27.33, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10805, 'THEBI', 2, '1997-12-30 00:00:00', '1998-01-27 00:00:00', '1998-01-09 00:00:00', 3, 237.34, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA'),
(10806, 'VICTE', 3, '1997-12-31 00:00:00', '1998-01-28 00:00:00', '1998-01-05 00:00:00', 2, 22.11, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10807, 'FRANS', 4, '1997-12-31 00:00:00', '1998-01-28 00:00:00', '1998-01-30 00:00:00', 1, 1.36, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(10808, 'OLDWO', 2, '1998-01-01 00:00:00', '1998-01-29 00:00:00', '1998-01-09 00:00:00', 3, 45.53, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10810, 'LAUGB', 2, '1998-01-01 00:00:00', '1998-01-29 00:00:00', '1998-01-07 00:00:00', 3, 4.33, 'Laughing Bacchus Wine Cellars', '2319 Elm St.', 'Vancouver', 'BC', 'V3F 2K1', 'Canada'),
(10812, 'REGGC', 5, '1998-01-02 00:00:00', '1998-01-30 00:00:00', '1998-01-12 00:00:00', 1, 59.78, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10813, 'RICAR', 1, '1998-01-05 00:00:00', '1998-02-02 00:00:00', '1998-01-09 00:00:00', 1, 47.38, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10814, 'VICTE', 3, '1998-01-05 00:00:00', '1998-02-02 00:00:00', '1998-01-14 00:00:00', 3, 130.94, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10815, 'SAVEA', 2, '1998-01-05 00:00:00', '1998-02-02 00:00:00', '1998-01-14 00:00:00', 3, 14.62, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10816, 'GREAL', 4, '1998-01-06 00:00:00', '1998-02-03 00:00:00', '1998-02-04 00:00:00', 2, 719.78, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10817, 'KOENE', 3, '1998-01-06 00:00:00', '1998-01-20 00:00:00', '1998-01-13 00:00:00', 2, 306.07, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(10819, 'CACTU', 2, '1998-01-07 00:00:00', '1998-02-04 00:00:00', '1998-01-16 00:00:00', 3, 19.76, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina'),
(10820, 'RATTC', 3, '1998-01-07 00:00:00', '1998-02-04 00:00:00', '1998-01-13 00:00:00', 2, 37.52, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10821, 'SPLIR', 1, '1998-01-08 00:00:00', '1998-02-05 00:00:00', '1998-01-15 00:00:00', 1, 36.68, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10822, 'TRAIH', 6, '1998-01-08 00:00:00', '1998-02-05 00:00:00', '1998-01-16 00:00:00', 3, 7, 'Trail\'s Head Gourmet Provisioners', '722 DaVinci Blvd.', 'Kirkland', 'WA', '98034', 'USA'),
(10823, 'LILAS', 5, '1998-01-09 00:00:00', '1998-02-06 00:00:00', '1998-01-13 00:00:00', 2, 163.97, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10825, 'DRACD', 1, '1998-01-09 00:00:00', '1998-02-06 00:00:00', '1998-01-14 00:00:00', 1, 79.25, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', '', '52066', 'Germany'),
(10826, 'BLONP', 6, '1998-01-12 00:00:00', '1998-02-09 00:00:00', '1998-02-06 00:00:00', 1, 7.09, 'Blondel p�re et fils', '24, place Kl�ber', 'Strasbourg', '', '67000', 'France'),
(10827, 'BONAP', 1, '1998-01-12 00:00:00', '1998-01-26 00:00:00', '1998-02-06 00:00:00', 2, 63.54, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(10830, 'TRADH', 4, '1998-01-13 00:00:00', '1998-02-24 00:00:00', '1998-01-21 00:00:00', 2, 81.83, 'Tradi�ao Hipermercados', 'Av. In�s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil'),
(10831, 'SANTG', 3, '1998-01-14 00:00:00', '1998-02-11 00:00:00', '1998-01-23 00:00:00', 2, 72.19, 'Sant� Gourmet', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway'),
(10832, 'LAMAI', 2, '1998-01-14 00:00:00', '1998-02-11 00:00:00', '1998-01-19 00:00:00', 2, 43.26, 'La maison d\'Asie', '1 rue Alsace-Lorraine', 'Toulouse', '', '31000', 'France'),
(10833, 'OTTIK', 6, '1998-01-15 00:00:00', '1998-02-12 00:00:00', '1998-01-23 00:00:00', 2, 71.49, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(10834, 'TRADH', 1, '1998-01-15 00:00:00', '1998-02-12 00:00:00', '1998-01-19 00:00:00', 3, 29.78, 'Tradi�ao Hipermercados', 'Av. In�s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil'),
(10835, 'ALFKI', 1, '1998-01-15 00:00:00', '1998-02-12 00:00:00', '1998-01-21 00:00:00', 3, 69.53, 'Alfred\'s Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(10838, 'LINOD', 3, '1998-01-19 00:00:00', '1998-02-16 00:00:00', '1998-01-23 00:00:00', 3, 59.28, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10839, 'TRADH', 3, '1998-01-19 00:00:00', '1998-02-16 00:00:00', '1998-01-22 00:00:00', 3, 35.43, 'Tradi�ao Hipermercados', 'Av. In�s de Castro, 414', 'Sao Paulo', 'SP', '05634-030', 'Brazil'),
(10840, 'LINOD', 4, '1998-01-19 00:00:00', '1998-03-02 00:00:00', '1998-02-16 00:00:00', 2, 2.71, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10841, 'SUPRD', 5, '1998-01-20 00:00:00', '1998-02-17 00:00:00', '1998-01-29 00:00:00', 2, 424.3, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10842, 'TORTU', 1, '1998-01-20 00:00:00', '1998-02-17 00:00:00', '1998-01-29 00:00:00', 3, 54.42, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10843, 'VICTE', 4, '1998-01-21 00:00:00', '1998-02-18 00:00:00', '1998-01-26 00:00:00', 2, 9.26, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10846, 'SUPRD', 2, '1998-01-22 00:00:00', '1998-03-05 00:00:00', '1998-01-23 00:00:00', 3, 56.46, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10847, 'SAVEA', 4, '1998-01-22 00:00:00', '1998-02-05 00:00:00', '1998-02-10 00:00:00', 3, 487.57, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10850, 'VICTE', 1, '1998-01-23 00:00:00', '1998-03-06 00:00:00', '1998-01-30 00:00:00', 1, 49.19, 'Victuailles en stock', '2, rue du Commerce', 'Lyon', '', '69004', 'France'),
(10851, 'RICAR', 5, '1998-01-26 00:00:00', '1998-02-23 00:00:00', '1998-02-02 00:00:00', 1, 160.55, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10854, 'ERNSH', 3, '1998-01-27 00:00:00', '1998-02-24 00:00:00', '1998-02-05 00:00:00', 2, 100.22, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10855, 'OLDWO', 3, '1998-01-27 00:00:00', '1998-02-24 00:00:00', '1998-02-04 00:00:00', 1, 170.97, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10856, 'ANTON', 3, '1998-01-28 00:00:00', '1998-02-25 00:00:00', '1998-02-10 00:00:00', 2, 58.43, 'Antonio Moreno Taquer�a', 'Mataderos  2312', 'M�xico D.F.', '', '5023', 'Mexico'),
(10858, 'LACOR', 2, '1998-01-29 00:00:00', '1998-02-26 00:00:00', '1998-02-03 00:00:00', 1, 52.51, 'La corne d\'abondance', '67, avenue de l\'Europe', 'Versailles', '', '78000', 'France'),
(10859, 'FRANK', 1, '1998-01-29 00:00:00', '1998-02-26 00:00:00', '1998-02-02 00:00:00', 2, 76.1, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10860, 'FRANR', 3, '1998-01-29 00:00:00', '1998-02-26 00:00:00', '1998-02-04 00:00:00', 3, 19.26, 'France restauration', '54, rue Royale', 'Nantes', '', '44000', 'France'),
(10863, 'HILAA', 4, '1998-02-02 00:00:00', '1998-03-02 00:00:00', '1998-02-17 00:00:00', 2, 30.26, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10864, 'ALFRE', 4, '1998-02-02 00:00:00', '1998-03-02 00:00:00', '1998-02-09 00:00:00', 2, 3.04, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10865, 'QUICK', 2, '1998-02-02 00:00:00', '1998-02-16 00:00:00', '1998-02-12 00:00:00', 1, 348.14, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10866, 'BERGS', 5, '1998-02-03 00:00:00', '1998-03-03 00:00:00', '1998-02-12 00:00:00', 1, 109.11, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10867, 'LONEP', 6, '1998-02-03 00:00:00', '1998-03-17 00:00:00', '1998-02-11 00:00:00', 1, 1.93, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(10869, 'SEVES', 5, '1998-02-04 00:00:00', '1998-03-04 00:00:00', '1998-02-09 00:00:00', 1, 143.28, 'Seven Seas Imports', '90 Wadhurst Rd.', 'London', '', 'OX15 4NB', 'UK'),
(10872, 'GODOS', 5, '1998-02-05 00:00:00', '1998-03-05 00:00:00', '1998-02-09 00:00:00', 2, 175.32, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10874, 'GODOS', 5, '1998-02-06 00:00:00', '1998-03-06 00:00:00', '1998-02-11 00:00:00', 2, 19.58, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10875, 'BERGS', 4, '1998-02-06 00:00:00', '1998-03-06 00:00:00', '1998-03-03 00:00:00', 2, 32.37, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10877, 'RICAR', 1, '1998-02-09 00:00:00', '1998-03-09 00:00:00', '1998-02-19 00:00:00', 1, 38.06, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(10878, 'QUICK', 4, '1998-02-10 00:00:00', '1998-03-10 00:00:00', '1998-02-12 00:00:00', 1, 46.69, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10881, 'CACTU', 4, '1998-02-11 00:00:00', '1998-03-11 00:00:00', '1998-02-18 00:00:00', 1, 2.84, 'Cactus Comidas para llevar', 'Cerrito 333', 'Buenos Aires', '', '1010', 'Argentina'),
(10882, 'SAVEA', 4, '1998-02-11 00:00:00', '1998-03-11 00:00:00', '1998-02-20 00:00:00', 3, 23.1, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10884, 'LETSS', 4, '1998-02-12 00:00:00', '1998-03-12 00:00:00', '1998-02-13 00:00:00', 2, 90.97, 'Let\'s Stop N Shop', '87 Polk St. Suite 5', 'San Francisco', 'CA', '94117', 'USA'),
(10885, 'SUPRD', 6, '1998-02-12 00:00:00', '1998-03-12 00:00:00', '1998-02-18 00:00:00', 3, 5.64, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10886, 'HANAR', 1, '1998-02-13 00:00:00', '1998-03-13 00:00:00', '1998-03-02 00:00:00', 1, 4.99, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10888, 'GODOS', 1, '1998-02-16 00:00:00', '1998-03-16 00:00:00', '1998-02-23 00:00:00', 2, 51.87, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10892, 'MAISD', 4, '1998-02-17 00:00:00', '1998-03-17 00:00:00', '1998-02-19 00:00:00', 2, 120.27, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium'),
(10894, 'SAVEA', 1, '1998-02-18 00:00:00', '1998-03-18 00:00:00', '1998-02-20 00:00:00', 1, 116.13, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10895, 'ERNSH', 3, '1998-02-18 00:00:00', '1998-03-18 00:00:00', '1998-02-23 00:00:00', 1, 162.75, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10897, 'HUNGO', 3, '1998-02-19 00:00:00', '1998-03-19 00:00:00', '1998-02-25 00:00:00', 2, 603.54, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10898, 'OCEAN', 4, '1998-02-20 00:00:00', '1998-03-20 00:00:00', '1998-03-06 00:00:00', 2, 1.27, 'Oc�ano Atl�ntico Ltda.', 'Ing. Gustavo Moncada 8585 Piso 20-A', 'Buenos Aires', '', '1010', 'Argentina'),
(10899, 'LILAS', 5, '1998-02-20 00:00:00', '1998-03-20 00:00:00', '1998-02-26 00:00:00', 3, 1.21, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(10901, 'HILAA', 4, '1998-02-23 00:00:00', '1998-03-23 00:00:00', '1998-02-26 00:00:00', 1, 62.09, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10902, 'FOLKO', 1, '1998-02-23 00:00:00', '1998-03-23 00:00:00', '1998-03-03 00:00:00', 1, 44.15, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10903, 'HANAR', 3, '1998-02-24 00:00:00', '1998-03-24 00:00:00', '1998-03-04 00:00:00', 3, 36.71, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10907, 'SPECD', 6, '1998-02-25 00:00:00', '1998-03-25 00:00:00', '1998-02-27 00:00:00', 3, 9.19, 'Sp�cialit�s du monde', '25, rue Lauriston', 'Paris', '', '75016', 'France'),
(10908, 'REGGC', 4, '1998-02-26 00:00:00', '1998-03-26 00:00:00', '1998-03-06 00:00:00', 2, 32.96, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(10909, 'SANTG', 1, '1998-02-26 00:00:00', '1998-03-26 00:00:00', '1998-03-10 00:00:00', 2, 53.05, 'Sant� Gourmet', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway'),
(10911, 'GODOS', 3, '1998-02-26 00:00:00', '1998-03-26 00:00:00', '1998-03-05 00:00:00', 1, 38.19, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10912, 'HUNGO', 2, '1998-02-26 00:00:00', '1998-03-26 00:00:00', '1998-03-18 00:00:00', 2, 580.91, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10913, 'QUEEN', 4, '1998-02-26 00:00:00', '1998-03-26 00:00:00', '1998-03-04 00:00:00', 1, 33.05, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10914, 'QUEEN', 6, '1998-02-27 00:00:00', '1998-03-27 00:00:00', '1998-03-02 00:00:00', 1, 21.19, 'Queen Cozinha', 'Alameda dos Can�rios, 891', 'Sao Paulo', 'SP', '05487-020', 'Brazil'),
(10915, 'TORTU', 2, '1998-02-27 00:00:00', '1998-03-27 00:00:00', '1998-03-02 00:00:00', 2, 3.51, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(10916, 'RANCH', 1, '1998-02-27 00:00:00', '1998-03-27 00:00:00', '1998-03-09 00:00:00', 2, 63.77, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina'),
(10917, 'ROMEY', 4, '1998-03-02 00:00:00', '1998-03-30 00:00:00', '1998-03-11 00:00:00', 2, 8.29, 'Romero y tomillo', 'Gran V�a, 1', 'Madrid', '', '28001', 'Spain'),
(10918, 'BOTTM', 3, '1998-03-02 00:00:00', '1998-03-30 00:00:00', '1998-03-11 00:00:00', 3, 48.83, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10919, 'LINOD', 2, '1998-03-02 00:00:00', '1998-03-30 00:00:00', '1998-03-04 00:00:00', 2, 19.8, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10920, 'ALFRE', 4, '1998-03-03 00:00:00', '1998-03-31 00:00:00', '1998-03-09 00:00:00', 2, 29.61, 'Around the Horn', 'Brook Farm Stratford St. Mary', 'Colchester', 'Essex', 'CO7 6JX', 'UK'),
(10921, 'VAFFE', 1, '1998-03-03 00:00:00', '1998-04-14 00:00:00', '1998-03-09 00:00:00', 1, 176.48, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10922, 'HANAR', 5, '1998-03-03 00:00:00', '1998-03-31 00:00:00', '1998-03-05 00:00:00', 3, 62.74, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10924, 'BERGS', 3, '1998-03-04 00:00:00', '1998-04-01 00:00:00', '1998-04-08 00:00:00', 2, 151.52, 'Berglunds snabbk�p', 'Berguvsv�gen  8', 'Lule�', '', 'S-958 22', 'Sweden'),
(10925, 'HANAR', 3, '1998-03-04 00:00:00', '1998-04-01 00:00:00', '1998-03-13 00:00:00', 1, 2.27, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10926, 'ANATR', 4, '1998-03-04 00:00:00', '1998-04-01 00:00:00', '1998-03-11 00:00:00', 3, 39.92, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constituci�n 2222', 'M�xico D.F.', '', '5021', 'Mexico'),
(10927, 'LACOR', 4, '1998-03-05 00:00:00', '1998-04-02 00:00:00', '1998-04-08 00:00:00', 1, 19.79, 'La corne d\'abondance', '67, avenue de l\'Europe', 'Versailles', '', '78000', 'France'),
(10928, 'GALED', 1, '1998-03-05 00:00:00', '1998-04-02 00:00:00', '1998-03-18 00:00:00', 1, 1.36, 'Galer�a del gastron�mo', 'Rambla de Catalu�a, 23', 'Barcelona', '', '8022', 'Spain'),
(10929, 'FRANK', 6, '1998-03-05 00:00:00', '1998-04-02 00:00:00', '1998-03-12 00:00:00', 1, 33.93, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(10930, 'SUPRD', 4, '1998-03-06 00:00:00', '1998-04-17 00:00:00', '1998-03-18 00:00:00', 3, 15.55, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(10931, 'RICSU', 4, '1998-03-06 00:00:00', '1998-03-20 00:00:00', '1998-03-19 00:00:00', 2, 13.6, 'Richter Supermarkt', 'Starenweg 5', 'Gen�ve', '', '1204', 'Switzerland'),
(10933, 'ISLAT', 6, '1998-03-06 00:00:00', '1998-04-03 00:00:00', '1998-03-16 00:00:00', 3, 54.15, 'Island Trading', 'Garden House Crowther Way', 'Cowes', 'Isle of Wight', 'PO31 7PJ', 'UK'),
(10934, 'LEHMS', 3, '1998-03-09 00:00:00', '1998-04-06 00:00:00', '1998-03-12 00:00:00', 3, 32.01, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(10936, 'GREAL', 3, '1998-03-09 00:00:00', '1998-04-06 00:00:00', '1998-03-18 00:00:00', 2, 33.68, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(10938, 'QUICK', 3, '1998-03-10 00:00:00', '1998-04-07 00:00:00', '1998-03-16 00:00:00', 2, 31.89, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10939, 'MAGAA', 2, '1998-03-10 00:00:00', '1998-04-07 00:00:00', '1998-03-13 00:00:00', 2, 76.33, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10943, 'BSBEV', 4, '1998-03-11 00:00:00', '1998-04-08 00:00:00', '1998-03-19 00:00:00', 2, 2.17, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10944, 'BOTTM', 6, '1998-03-12 00:00:00', '1998-03-26 00:00:00', '1998-03-13 00:00:00', 3, 52.92, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10945, 'MORGK', 4, '1998-03-12 00:00:00', '1998-04-09 00:00:00', '1998-03-18 00:00:00', 1, 10.22, 'Morgenstern Gesundkost', 'Heerstr. 22', 'Leipzig', '', '4179', 'Germany'),
(10946, 'VAFFE', 1, '1998-03-12 00:00:00', '1998-04-09 00:00:00', '1998-03-19 00:00:00', 2, 27.2, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10947, 'BSBEV', 3, '1998-03-13 00:00:00', '1998-04-10 00:00:00', '1998-03-16 00:00:00', 2, 3.26, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(10948, 'GODOS', 3, '1998-03-13 00:00:00', '1998-04-10 00:00:00', '1998-03-19 00:00:00', 3, 23.39, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(10949, 'BOTTM', 2, '1998-03-13 00:00:00', '1998-04-10 00:00:00', '1998-03-17 00:00:00', 3, 74.44, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10950, 'MAGAA', 1, '1998-03-16 00:00:00', '1998-04-13 00:00:00', '1998-03-23 00:00:00', 2, 2.5, 'Magazzini Alimentari Riuniti', 'Via Ludovico il Moro 22', 'Bergamo', '', '24100', 'Italy'),
(10952, 'ALFKI', 1, '1998-03-16 00:00:00', '1998-04-27 00:00:00', '1998-03-24 00:00:00', 1, 40.42, 'Alfred\'s Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(10954, 'LINOD', 5, '1998-03-17 00:00:00', '1998-04-28 00:00:00', '1998-03-20 00:00:00', 1, 27.91, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(10956, 'BLAUS', 6, '1998-03-17 00:00:00', '1998-04-28 00:00:00', '1998-03-20 00:00:00', 2, 44.65, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', '', '68306', 'Germany'),
(10959, 'GOURL', 6, '1998-03-18 00:00:00', '1998-04-29 00:00:00', '1998-03-23 00:00:00', 2, 4.98, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(10960, 'HILAA', 3, '1998-03-19 00:00:00', '1998-04-02 00:00:00', '1998-04-08 00:00:00', 1, 2.08, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10964, 'SPECD', 3, '1998-03-20 00:00:00', '1998-04-17 00:00:00', '1998-03-24 00:00:00', 2, 87.38, 'Sp�cialit�s du monde', '25, rue Lauriston', 'Paris', '', '75016', 'France'),
(10965, 'OLDWO', 6, '1998-03-20 00:00:00', '1998-04-17 00:00:00', '1998-03-30 00:00:00', 3, 144.38, 'Old World Delicatessen', '2743 Bering St.', 'Anchorage', 'AK', '99508', 'USA'),
(10966, 'CHOPS', 4, '1998-03-20 00:00:00', '1998-04-17 00:00:00', '1998-04-08 00:00:00', 1, 27.19, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(10967, 'TOMSP', 2, '1998-03-23 00:00:00', '1998-04-20 00:00:00', '1998-04-02 00:00:00', 2, 62.22, 'Toms Spezialit�ten', 'Luisenstr. 48', 'M�nster', '', '44087', 'Germany'),
(10968, 'ERNSH', 1, '1998-03-23 00:00:00', '1998-04-20 00:00:00', '1998-04-01 00:00:00', 3, 74.6, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10969, 'COMMI', 1, '1998-03-23 00:00:00', '1998-04-20 00:00:00', '1998-03-30 00:00:00', 2, 0.21, 'Com�rcio Mineiro', 'Av. dos Lus�adas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil'),
(10971, 'FRANR', 2, '1998-03-24 00:00:00', '1998-04-21 00:00:00', '1998-04-02 00:00:00', 2, 121.82, 'France restauration', '54, rue Royale', 'Nantes', '', '44000', 'France'),
(10972, 'LACOR', 4, '1998-03-24 00:00:00', '1998-04-21 00:00:00', '1998-03-26 00:00:00', 2, 0.02, 'La corne d\'abondance', '67, avenue de l\'Europe', 'Versailles', '', '78000', 'France'),
(10973, 'LACOR', 6, '1998-03-24 00:00:00', '1998-04-21 00:00:00', '1998-03-27 00:00:00', 2, 15.17, 'La corne d\'abondance', '67, avenue de l\'Europe', 'Versailles', '', '78000', 'France'),
(10974, 'SPLIR', 3, '1998-03-25 00:00:00', '1998-04-08 00:00:00', '1998-04-03 00:00:00', 3, 12.96, 'Split Rail Beer & Ale', 'P.O. Box 555', 'Lander', 'WY', '82520', 'USA'),
(10975, 'BOTTM', 1, '1998-03-25 00:00:00', '1998-04-22 00:00:00', '1998-03-27 00:00:00', 3, 32.27, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10976, 'HILAA', 1, '1998-03-25 00:00:00', '1998-05-06 00:00:00', '1998-04-03 00:00:00', 1, 37.97, 'HILARION-Abastos', 'Carrera 22 con Ave. Carlos Soublette #8-35', 'San Crist�bal', 'T�chira', '5022', 'Venezuela'),
(10980, 'FOLKO', 4, '1998-03-27 00:00:00', '1998-05-08 00:00:00', '1998-04-17 00:00:00', 1, 1.26, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(10981, 'HANAR', 1, '1998-03-27 00:00:00', '1998-04-24 00:00:00', '1998-04-02 00:00:00', 2, 193.37, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(10982, 'BOTTM', 2, '1998-03-27 00:00:00', '1998-04-24 00:00:00', '1998-04-08 00:00:00', 1, 14.01, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10983, 'SAVEA', 2, '1998-03-27 00:00:00', '1998-04-24 00:00:00', '1998-04-06 00:00:00', 2, 657.54, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10984, 'SAVEA', 1, '1998-03-30 00:00:00', '1998-04-27 00:00:00', '1998-04-03 00:00:00', 3, 211.22, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(10985, 'HUNGO', 2, '1998-03-30 00:00:00', '1998-04-27 00:00:00', '1998-04-02 00:00:00', 1, 91.51, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(10988, 'RATTC', 3, '1998-03-31 00:00:00', '1998-04-28 00:00:00', '1998-04-10 00:00:00', 2, 61.14, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(10989, 'QUEDE', 2, '1998-03-31 00:00:00', '1998-04-28 00:00:00', '1998-04-02 00:00:00', 1, 34.76, 'Que Del�cia', 'Rua da Panificadora, 12', 'Rio de Janeiro', 'RJ', '02389-673', 'Brazil'),
(10990, 'ERNSH', 2, '1998-04-01 00:00:00', '1998-05-13 00:00:00', '1998-04-07 00:00:00', 3, 117.61, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(10991, 'QUICK', 1, '1998-04-01 00:00:00', '1998-04-29 00:00:00', '1998-04-07 00:00:00', 1, 38.51, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10992, 'THEBI', 1, '1998-04-01 00:00:00', '1998-04-29 00:00:00', '1998-04-03 00:00:00', 3, 4.27, 'The Big Cheese', '89 Jefferson Way Suite 2', 'Portland', 'OR', '97201', 'USA'),
(10994, 'VAFFE', 2, '1998-04-02 00:00:00', '1998-04-16 00:00:00', '1998-04-09 00:00:00', 3, 65.53, 'Vaffeljernet', 'Smagsloget 45', '�rhus', '', '8200', 'Denmark'),
(10995, 'PERIC', 1, '1998-04-02 00:00:00', '1998-04-30 00:00:00', '1998-04-06 00:00:00', 3, 46, 'Pericles Comidas cl�sicas', 'Calle Dr. Jorge Cash 321', 'M�xico D.F.', '', '5033', 'Mexico'),
(10996, 'QUICK', 4, '1998-04-02 00:00:00', '1998-04-30 00:00:00', '1998-04-10 00:00:00', 2, 1.12, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(10999, 'OTTIK', 6, '1998-04-03 00:00:00', '1998-05-01 00:00:00', '1998-04-10 00:00:00', 2, 96.35, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(11000, 'RATTC', 2, '1998-04-06 00:00:00', '1998-05-04 00:00:00', '1998-04-14 00:00:00', 3, 55.12, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'),
(11001, 'FOLKO', 2, '1998-04-06 00:00:00', '1998-05-04 00:00:00', '1998-04-14 00:00:00', 2, 197.3, 'Folk och f� HB', '�kergatan 24', 'Br�cke', '', 'S-844 67', 'Sweden'),
(11002, 'SAVEA', 4, '1998-04-06 00:00:00', '1998-05-04 00:00:00', '1998-04-16 00:00:00', 1, 141.16, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(11003, 'THECR', 3, '1998-04-06 00:00:00', '1998-05-04 00:00:00', '1998-04-08 00:00:00', 3, 14.91, 'The Cracker Box', '55 Grizzly Peak Rd.', 'Butte', 'MT', '59801', 'USA'),
(11004, 'MAISD', 3, '1998-04-07 00:00:00', '1998-05-05 00:00:00', '1998-04-20 00:00:00', 1, 44.84, 'Maison Dewey', 'Rue Joseph-Bens 532', 'Bruxelles', '', 'B-1180', 'Belgium'),
(11006, 'GREAL', 3, '1998-04-07 00:00:00', '1998-05-05 00:00:00', '1998-04-15 00:00:00', 2, 25.19, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(11009, 'GODOS', 2, '1998-04-08 00:00:00', '1998-05-06 00:00:00', '1998-04-10 00:00:00', 1, 59.11, 'Godos Cocina T�pica', 'C/ Romero, 33', 'Sevilla', '', '41101', 'Spain'),
(11010, 'REGGC', 2, '1998-04-09 00:00:00', '1998-05-07 00:00:00', '1998-04-21 00:00:00', 2, 28.71, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(11011, 'ALFKI', 3, '1998-04-09 00:00:00', '1998-05-07 00:00:00', '1998-04-13 00:00:00', 1, 1.21, 'Alfred\'s Futterkiste', 'Obere Str. 57', 'Berlin', '', '12209', 'Germany'),
(11012, 'FRANK', 1, '1998-04-09 00:00:00', '1998-04-23 00:00:00', '1998-04-17 00:00:00', 3, 242.95, 'Frankenversand', 'Berliner Platz 43', 'M�nchen', '', '80805', 'Germany'),
(11013, 'ROMEY', 2, '1998-04-09 00:00:00', '1998-05-07 00:00:00', '1998-04-10 00:00:00', 1, 32.99, 'Romero y tomillo', 'Gran V�a, 1', 'Madrid', '', '28001', 'Spain'),
(11014, 'LINOD', 2, '1998-04-10 00:00:00', '1998-05-08 00:00:00', '1998-04-15 00:00:00', 3, 23.6, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(11015, 'SANTG', 2, '1998-04-10 00:00:00', '1998-04-24 00:00:00', '1998-04-20 00:00:00', 2, 4.62, 'Sant� Gourmet', 'Erling Skakkes gate 78', 'Stavern', '', '4110', 'Norway'),
(11018, 'LONEP', 4, '1998-04-13 00:00:00', '1998-05-11 00:00:00', '1998-04-16 00:00:00', 2, 11.65, 'Lonesome Pine Restaurant', '89 Chiaroscuro Rd.', 'Portland', 'OR', '97219', 'USA'),
(11019, 'RANCH', 6, '1998-04-13 00:00:00', '1998-05-11 00:00:00', '0000-00-00 00:00:00', 3, 3.17, 'Rancho grande', 'Av. del Libertador 900', 'Buenos Aires', '', '1010', 'Argentina'),
(11020, 'OTTIK', 2, '1998-04-14 00:00:00', '1998-05-12 00:00:00', '1998-04-16 00:00:00', 2, 43.3, 'Ottilies K�seladen', 'Mehrheimerstr. 369', 'K�ln', '', '50739', 'Germany'),
(11021, 'QUICK', 3, '1998-04-14 00:00:00', '1998-05-12 00:00:00', '1998-04-21 00:00:00', 1, 297.18, 'QUICK-Stop', 'Taucherstra�e 10', 'Cunewalde', '', '1307', 'Germany'),
(11023, 'BSBEV', 1, '1998-04-14 00:00:00', '1998-04-28 00:00:00', '1998-04-24 00:00:00', 2, 123.83, 'B\'s Beverages', 'Fauntleroy Circus', 'London', '', 'EC2 5NT', 'UK'),
(11024, 'EASTC', 4, '1998-04-15 00:00:00', '1998-05-13 00:00:00', '1998-04-20 00:00:00', 1, 74.36, 'Eastern Connection', '35 King George', 'London', '', 'WX3 6FW', 'UK'),
(11025, 'WARTH', 6, '1998-04-15 00:00:00', '1998-05-13 00:00:00', '1998-04-24 00:00:00', 3, 29.17, 'Wartian Herkku', 'Torikatu 38', 'Oulu', '', '90110', 'Finland'),
(11026, 'FRANS', 4, '1998-04-15 00:00:00', '1998-05-13 00:00:00', '1998-04-28 00:00:00', 1, 47.09, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(11027, 'BOTTM', 1, '1998-04-16 00:00:00', '1998-05-14 00:00:00', '1998-04-20 00:00:00', 1, 52.52, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(11028, 'KOENE', 2, '1998-04-16 00:00:00', '1998-05-14 00:00:00', '1998-04-22 00:00:00', 1, 29.59, 'K�niglich Essen', 'Maubelstr. 90', 'Brandenburg', '', '14776', 'Germany'),
(11029, 'CHOPS', 4, '1998-04-16 00:00:00', '1998-05-14 00:00:00', '1998-04-27 00:00:00', 1, 47.84, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland');
INSERT INTO `orders` (`OrderID`, `CustomerID`, `EmployeeID`, `OrderDate`, `RequiredDate`, `ShippedDate`, `ShipVia`, `Freight`, `ShipName`, `ShipAddress`, `ShipCity`, `ShipRegion`, `ShipPostalCode`, `ShipCountry`) VALUES
(11031, 'SAVEA', 6, '1998-04-17 00:00:00', '1998-05-15 00:00:00', '1998-04-24 00:00:00', 2, 227.22, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(11035, 'SUPRD', 2, '1998-04-20 00:00:00', '1998-05-18 00:00:00', '1998-04-24 00:00:00', 2, 0.17, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(11038, 'SUPRD', 1, '1998-04-21 00:00:00', '1998-05-19 00:00:00', '1998-04-30 00:00:00', 2, 29.59, 'Supr�mes d�lices', 'Boulevard Tirou, 255', 'Charleroi', '', 'B-6000', 'Belgium'),
(11039, 'LINOD', 1, '1998-04-21 00:00:00', '1998-05-19 00:00:00', '0000-00-00 00:00:00', 2, 65, 'LINO-Delicateses', 'Ave. 5 de Mayo Porlamar', 'I. de Margarita', 'Nueva Esparta', '4980', 'Venezuela'),
(11040, 'GREAL', 4, '1998-04-22 00:00:00', '1998-05-20 00:00:00', '0000-00-00 00:00:00', 3, 18.84, 'Great Lakes Food Market', '2732 Baker Blvd.', 'Eugene', 'OR', '97403', 'USA'),
(11041, 'CHOPS', 3, '1998-04-22 00:00:00', '1998-05-20 00:00:00', '1998-04-28 00:00:00', 2, 48.22, 'Chop-suey Chinese', 'Hauptstr. 31', 'Bern', '', '3012', 'Switzerland'),
(11042, 'COMMI', 2, '1998-04-22 00:00:00', '1998-05-06 00:00:00', '1998-05-01 00:00:00', 1, 29.99, 'Com�rcio Mineiro', 'Av. dos Lus�adas, 23', 'Sao Paulo', 'SP', '05432-043', 'Brazil'),
(11043, 'SPECD', 5, '1998-04-22 00:00:00', '1998-05-20 00:00:00', '1998-04-29 00:00:00', 2, 8.8, 'Sp�cialit�s du monde', '25, rue Lauriston', 'Paris', '', '75016', 'France'),
(11045, 'BOTTM', 6, '1998-04-23 00:00:00', '1998-05-21 00:00:00', '0000-00-00 00:00:00', 2, 70.58, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(11048, NULL, NULL, '1998-05-22 00:00:00', '1998-04-30 00:00:00', '0000-00-00 00:00:00', NULL, 24.12, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC Region', 'T2F 8M4', 'Canada'),
(11049, 'GOURL', 3, '1998-04-24 00:00:00', '1998-05-22 00:00:00', '1998-05-04 00:00:00', 1, 8.34, 'Gourmet Lanchonetes', 'Av. Brasil, 442', 'Campinas', 'SP', '04876-786', 'Brazil'),
(11052, 'HANAR', 3, '1998-04-27 00:00:00', '1998-05-25 00:00:00', '1998-05-01 00:00:00', 1, 67.26, 'Hanari Carnes', 'Rua do Pa�o, 67', 'Rio de Janeiro', 'RJ', '05454-876', 'Brazil'),
(11053, 'PICCO', 2, '1998-04-27 00:00:00', '1998-05-25 00:00:00', '1998-04-29 00:00:00', 2, 53.05, 'Piccolo und mehr', 'Geislweg 14', 'Salzburg', '', '5020', 'Austria'),
(11057, 'NORTS', 3, '1998-04-29 00:00:00', '1998-05-27 00:00:00', '1998-05-01 00:00:00', 3, 4.13, 'North/South', 'South House 300 Queensbridge', 'London', '', 'SW7 1RZ', 'UK'),
(11059, 'RICAR', 2, '1998-04-29 00:00:00', '1998-06-10 00:00:00', '0000-00-00 00:00:00', 2, 85.8, 'Ricardo Adocicados', 'Av. Copacabana, 267', 'Rio de Janeiro', 'RJ', '02389-890', 'Brazil'),
(11060, 'FRANS', 2, '1998-04-30 00:00:00', '1998-05-28 00:00:00', '1998-05-04 00:00:00', 2, 10.98, 'Franchi S.p.A.', 'Via Monte Bianco 34', 'Torino', '', '10100', 'Italy'),
(11061, NULL, NULL, '1998-06-11 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, 14.01, 'Great Lakes Food Market', '2732 Baker Blvd. Avenida', 'Eugene', 'OR', '97403', 'USA'),
(11062, 'REGGC', 4, '1998-04-30 00:00:00', '1998-05-28 00:00:00', '0000-00-00 00:00:00', 2, 29.93, 'Reggiani Caseifici', 'Strada Provinciale 124', 'Reggio Emilia', '', '42100', 'Italy'),
(11063, 'HUNGO', 3, '1998-04-30 00:00:00', '1998-05-28 00:00:00', '1998-05-06 00:00:00', 2, 81.73, 'Hungry Owl All-Night Grocers', '8 Johnstown Road', 'Cork', 'Co. Cork', '', 'Ireland'),
(11064, 'SAVEA', 1, '1998-05-01 00:00:00', '1998-05-29 00:00:00', '1998-05-04 00:00:00', 1, 30.09, 'Save-a-lot Markets', '187 Suffolk Ln.', 'Boise', 'ID', '83720', 'USA'),
(11067, 'DRACD', 1, '1998-05-04 00:00:00', '1998-05-18 00:00:00', '1998-05-06 00:00:00', 2, 7.98, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', '', '52066', 'Germany'),
(11069, 'TORTU', 1, '1998-05-04 00:00:00', '1998-06-01 00:00:00', '1998-05-06 00:00:00', 2, 15.67, 'Tortuga Restaurante', 'Avda. Azteca 123', 'M�xico D.F.', '', '5033', 'Mexico'),
(11070, 'LEHMS', 2, '1998-05-05 00:00:00', '1998-06-02 00:00:00', '0000-00-00 00:00:00', 1, 136, 'Lehmanns Marktstand', 'Magazinweg 7', 'Frankfurt a.M.', '', '60528', 'Germany'),
(11071, 'LILAS', 1, '1998-05-05 00:00:00', '1998-06-02 00:00:00', '0000-00-00 00:00:00', 1, 0.93, 'LILA-Supermercado', 'Carrera 52 con Ave. Bol�var #65-98 Llano Largo', 'Barquisimeto', 'Lara', '3508', 'Venezuela'),
(11072, 'ERNSH', 4, '1998-05-05 00:00:00', '1998-06-02 00:00:00', '0000-00-00 00:00:00', 2, 258.64, 'Ernst Handel', 'Kirchgasse 6', 'Graz', '', '8010', 'Austria'),
(11073, 'PERIC', 2, '1998-05-05 00:00:00', '1998-06-02 00:00:00', '0000-00-00 00:00:00', 2, 24.95, 'Pericles Comidas cl�sicas', 'Calle Dr. Jorge Cash 321', 'M�xico D.F.', '', '5033', 'Mexico'),
(11076, 'BONAP', 4, '1998-05-06 00:00:00', '1998-06-03 00:00:00', '0000-00-00 00:00:00', 2, 38.28, 'Bon app\'', '12, rue des Bouchers', 'Marseille', '', '13008', 'France'),
(11083, NULL, NULL, '2023-10-29 08:00:00', '2023-11-05 00:00:00', '2023-11-03 12:00:00', NULL, 25.5, 'Shipping Name', 'Shipping Address', 'Shipping City', 'Shipping Region', '12345', 'Shipping Countr'),
(11084, NULL, NULL, '2023-10-29 08:00:00', '2023-11-05 00:00:00', '2023-11-03 12:00:00', NULL, 25.5, 'Shipping Name', 'Shipping Address', 'Shipping City', 'Shipping Region', '12345', 'Shipping Countr'),
(11085, NULL, NULL, '2023-11-05 00:00:00', '2023-11-03 12:00:00', '0000-00-00 00:00:00', NULL, 25.5, 'Shipping Name', 'Shipping Address', 'Shipping City', 'Shipping Region', '12345', 'Shipping Countr'),
(11086, NULL, 1, '2023-10-31 08:00:00', '2023-11-07 00:00:00', '2023-11-04 12:00:00', 1, 15, 'Entregado en casa', 'Av. Modelo 123', 'Ciudad Modelo', 'Región Modelo', '54321', 'Modelo de país'),
(11087, NULL, 1, '2023-10-31 08:00:00', '2023-11-07 00:00:00', '2023-11-04 12:00:00', 1, 15, 'Entregado en casa', 'Av. Modelo 123', 'Ciudad Modelo', 'Región Modelo', '54321', 'Modelo de país'),
(11088, 'ANATR', 1, '2023-10-31 08:00:00', '2023-11-07 00:00:00', '2023-11-04 12:00:00', 1, 15, 'Entregado en casa', 'Av. Modelo 123', 'Ciudad Modelo', 'Región Modelo', '54321', 'Modelo dfgvfvb ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `products`
--

CREATE TABLE `products` (
  `ProductID` int(11) NOT NULL,
  `ProductName` varchar(40) NOT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `QuantityPerUnit` varchar(20) DEFAULT NULL,
  `UnitPrice` double DEFAULT 0,
  `UnitsInStock` smallint(6) DEFAULT 0,
  `UnitsOnOrder` smallint(6) DEFAULT 0,
  `ReorderLevel` smallint(6) DEFAULT 0,
  `Discontinued` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `products`
--

INSERT INTO `products` (`ProductID`, `ProductName`, `SupplierID`, `CategoryID`, `QuantityPerUnit`, `UnitPrice`, `UnitsInStock`, `UnitsOnOrder`, `ReorderLevel`, `Discontinued`) VALUES
(3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10, 13, 70, 25, 1),
(4, 'Chef Anton\'s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22, 53, 0, 0, 1),
(5, 'Chef Anton\'s Gumbo Mix', 2, 2, '36 boxes', 21.35, 0, 0, 0, 0),
(6, 'Grandma\'s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25, 120, 0, 25, 0),
(8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40, 6, 0, 0, 0),
(9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97, 29, 0, 0, 0),
(11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21, 22, 30, 30, 0),
(12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38, 86, 0, 0, 0),
(15, 'Genen Shouyu', 6, 2, '24 - 250 ml bottles', 15.5, 39, 0, 5, 0),
(16, 'Pavlova', 7, 3, '32 - 500 g boxes', 17.45, 29, 0, 10, 0),
(17, 'Alice Mutton', 7, 6, '20 - 1 kg tins', 39, 0, 0, 0, 0),
(19, 'Teatime Chocolate Biscuits', 8, 3, '10 boxes x 12 pieces', 9.2, 25, 0, 5, 0),
(20, 'Sir Rodney\'s Marmalade', 8, 3, '30 gift boxes', 81, 40, 0, 0, 0),
(21, 'Sir Rodney\'s Scones', 8, 3, '24 pkgs. x 4 pieces', 10, 3, 40, 5, 0),
(22, 'Gustaf\'s Kn�ckebr�d', 9, 5, '24 - 500 g pkgs.', 21, 104, 0, 25, 0),
(23, 'Tunnbr�d', 9, 5, '12 - 250 g pkgs.', 9, 61, 0, 25, 0),
(25, 'NuNuCa Nu�-Nougat-Creme', 11, 3, '20 - 450 g glasses', 14, 76, 0, 30, 0),
(26, 'Gumb�r Gummib�rchen', 11, 3, '100 - 250 g bags', 31.23, 15, 0, 0, 0),
(27, 'Schoggi Schokolade', 11, 3, '100 - 100 g pieces', 43.9, 49, 0, 30, 0),
(29, 'Th�ringer Rostbratwurst', 12, 6, '50 bags x 30 sausgs.', 123.79, 0, 0, 0, 0),
(31, 'Gorgonzola Telino', 14, 4, '12 - 100 g pkgs', 12.5, 0, 70, 20, 0),
(32, 'Mascarpone Fabioli', 14, 4, '24 - 200 g pkgs.', 32, 9, 40, 25, 0),
(33, 'Geitost', 15, 4, '500 g', 2.5, 112, 0, 20, 0),
(42, 'Singaporean Hokkien Fried Mee', 20, 5, '32 - 1 kg pkgs.', 14, 26, 0, 0, 0),
(44, 'Gula Malacca', 20, 2, '20 - 2 kg bags', 19.45, 27, 0, 15, 0),
(47, 'Zaanse koeken', 22, 3, '10 - 4 oz boxes', 9.5, 36, 0, 0, 0),
(48, 'Chocolade', 22, 3, '10 pkgs.', 12.75, 15, 70, 25, 0),
(49, 'Maxilaku', 23, 3, '24 - 50 g pkgs.', 20, 10, 60, 15, 0),
(50, 'Valkoinen suklaa', 23, 3, '12 - 100 g bars', 16.25, 65, 0, 30, 0),
(52, 'Filo Mix', 24, 5, '16 - 2 kg boxes', 7, 38, 0, 25, 0),
(53, 'Perth Pasties', 24, 6, '48 pieces', 32.8, 0, 0, 0, 0),
(54, 'Tourti�re', 25, 6, '16 pies', 7.45, 21, 0, 10, 0),
(55, 'P�t� chinois', 25, 6, '24 boxes x 2 pies', 24, 115, 0, 20, 0),
(56, 'Gnocchi di nonna Alice', 26, 5, '24 - 250 g pkgs.', 38, 21, 10, 30, 0),
(57, 'Ravioli Angelo', 26, 5, '24 - 250 g pkgs.', 19.5, 36, 0, 20, 0),
(59, 'Raclette Courdavault', 28, 4, '5 kg pkg.', 55, 79, 0, 0, 0),
(60, 'Camembert Pierrot', 28, 4, '15 - 300 g rounds', 34, 19, 0, 0, 0),
(61, 'Sirop d\'�rable', 29, 2, '24 - 500 ml bottles', 28.5, 113, 0, 25, 0),
(62, 'Tarte au sucre', 29, 3, '48 pies', 49.3, 17, 0, 0, 0),
(63, 'Vegie-spread', 7, 2, '15 - 625 g jars', 43.9, 24, 0, 5, 0),
(64, 'Wimmers gute Semmelkn�del', 12, 5, '20 bags x 4 pieces', 33.25, 22, 80, 30, 0),
(65, 'Louisiana Fiery Hot Pepper Sauce', 2, 2, '32 - 8 oz bottles', 21.05, 76, 0, 0, 0),
(66, 'Louisiana Hot Spiced Okra', 2, 2, '24 - 8 oz jars', 17, 4, 100, 20, 0),
(68, 'Scottish Longbreads', NULL, NULL, '10 boxes x 8 pieces', 12.5, 6, 10, 15, 1),
(80, 'asdasd', NULL, NULL, 'aasd', 12, 12, 12, 12, 0),
(81, 'asadadsasd', NULL, NULL, 'asdasfxzv', 2, 2, 2, 2, 1),
(82, 'asdasd', NULL, NULL, '12', 12, 12, 12, 12, 1),
(83, 'asdasd', NULL, NULL, '12', 12, 12, 12, 1, 0),
(84, 'asdasd', NULL, NULL, '12', 12, 12, 12, 1, 1),
(86, 'FGBFGB', NULL, NULL, '1 kg', 10.99, 100, 20, 5, 1),
(87, 'asdasd', NULL, NULL, '1 kg', 12, 12, 12, 12, 0),
(89, 'Huevo', 1, NULL, '10 kg', 12, 12, 12, 12, 0),
(90, 'Cualquier Producto', 1, NULL, '1 kg', 12, 12, 12, 12, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `region`
--

CREATE TABLE `region` (
  `RegionID` int(11) NOT NULL,
  `RegionDescription` char(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `region`
--

INSERT INTO `region` (`RegionID`, `RegionDescription`) VALUES
(1, 'Eastern'),
(2, 'Western'),
(3, 'Northern'),
(4, 'Southern');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shippers`
--

CREATE TABLE `shippers` (
  `ShipperID` int(11) NOT NULL,
  `CompanyName` varchar(40) NOT NULL,
  `Phone` varchar(24) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `shippers`
--

INSERT INTO `shippers` (`ShipperID`, `CompanyName`, `Phone`) VALUES
(1, 'Speedy Express', '(503) 555-9831'),
(2, 'United Package', '(503) 555-3199'),
(3, 'Federal Shipping', '(503) 555-9931');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suppliers`
--

CREATE TABLE `suppliers` (
  `SupplierID` int(11) NOT NULL,
  `CompanyName` varchar(40) NOT NULL,
  `ContactName` varchar(30) DEFAULT NULL,
  `ContactTitle` varchar(30) DEFAULT NULL,
  `Address` varchar(60) DEFAULT NULL,
  `City` varchar(15) DEFAULT NULL,
  `Region` varchar(15) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Country` varchar(15) DEFAULT NULL,
  `Phone` varchar(24) DEFAULT NULL,
  `Fax` varchar(24) DEFAULT NULL,
  `HomePage` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `suppliers`
--

INSERT INTO `suppliers` (`SupplierID`, `CompanyName`, `ContactName`, `ContactTitle`, `Address`, `City`, `Region`, `PostalCode`, `Country`, `Phone`, `Fax`, `HomePage`) VALUES
(1, 'Exotic Liquids', 'Charlotte Cooper', 'Purchasing Manager', '49 Gilbert St.', 'London', '', 'EC1 4SD', 'UK', '(171) 555-2222', '', ''),
(2, 'New Orleans Cajun Delights', 'Shelley Burke', 'Order Administrator', 'P.O. Box 78934', 'New Orleans', 'LA', '70117', 'USA', '(100) 555-4822', '', '#CAJUN.HTM#'),
(3, 'Grandma Kelly\'s Homestead', 'Regina Murphy', 'Sales Representative', '707 Oxford Rd.', 'Ann Arbor', 'MI', '48104', 'USA', '(313) 555-5735', '(313) 555-3349', ''),
(4, 'Tokyo Traders', 'Yoshi Nagase', 'Marketing Manager', '9-8 Sekimai Musashino-shi', 'Tokyo', '', '100', 'Japan', '(03) 3555-5011', '', ''),
(5, 'Cooperativa de Quesos \'Las Cabras\'', 'Antonio del Valle Saavedra', 'Export Administrator', 'Calle del Rosal 4', 'Oviedo', 'Asturias', '33007', 'Spain', '(98) 598 76 54', '', ''),
(6, 'Mayumi\'s', 'Mayumi Ohno', 'Marketing Representative', '92 Setsuko Chuo-ku', 'Osaka', '', '545', 'Japan', '(06) 431-7877', '', 'Mayumi\'s (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#'),
(7, 'Pavlova, Ltd.', 'Ian Devling', 'Marketing Manager', '74 Rose St. Moonie Ponds', 'Melbourne', 'Victoria', '3058', 'Australia', '(03) 444-2343', '(03) 444-6588', ''),
(8, 'Specialty Biscuits, Ltd.', 'Peter Wilson', 'Sales Representative', '29 King\'s Way', 'Manchester', '', 'M14 GSD', 'UK', '(161) 555-4448', '', ''),
(9, 'PB Kn�ckebr�d AB', 'Lars Peterson', 'Sales Agent', 'Kaloadagatan 13', 'G�teborg', '', 'S-345 67', 'Sweden', '031-987 65 43', '031-987 65 91', ''),
(10, 'Refrescos Americanas LTDA', 'Carlos Diaz', 'Marketing Manager', 'Av. das Americanas 12.890', 'Sao Paulo', '', '5442', 'Brazil', '(11) 555 4640', '', ''),
(11, 'Heli S��waren GmbH & Co. KG', 'Petra Winkler', 'Sales Manager', 'Tiergartenstra�e 5', 'Berlin', '', '10785', 'Germany', '(010) 9984510', '', ''),
(12, 'Plutzer Lebensmittelgro�m�rkte AG', 'Martin Bein', 'International Marketing Mgr.', 'Bogenallee 51', 'Frankfurt', '', '60439', 'Germany', '(069) 992755', '', 'Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#'),
(13, 'Nord-Ost-Fisch Handelsgesellschaft mbH', 'Sven Petersen', 'Coordinator Foreign Markets', 'Frahmredder 112a', 'Cuxhaven', '', '27478', 'Germany', '(04721) 8713', '(04721) 8714', ''),
(14, 'Formaggi Fortini s.r.l.', 'Elio Rossi', 'Sales Representative', 'Viale Dante, 75', 'Ravenna', '', '48100', 'Italy', '(0544) 60323', '(0544) 60603', '#FORMAGGI.HTM#'),
(15, 'Norske Meierier', 'Beate Vileid', 'Marketing Manager', 'Hatlevegen 5', 'Sandvika', '', '1320', 'Norway', '(0)2-953010', '', ''),
(16, 'Bigfoot Breweries', 'Cheryl Saylor', 'Regional Account Rep.', '3400 - 8th Avenue Suite 210', 'Bend', 'OR', '97101', 'USA', '(503) 555-9931', '', ''),
(17, 'Svensk Sj�f�da AB', 'Michael Bj�rn', 'Sales Representative', 'Brovallav�gen 231', 'Stockholm', '', 'S-123 45', 'Sweden', '08-123 45 67', '', ''),
(18, 'Aux joyeux eccl�siastiques', 'Guyl�ne Nodier', 'Sales Manager', '203, Rue des Francs-Bourgeois', 'Paris', '', '75004', 'France', '(1) 03.83.00.68', '(1) 03.83.00.62', ''),
(19, 'New England Seafood Cannery', 'Robb Merchant', 'Wholesale Account Agent', 'Order Processing Dept. 2100 Paul Revere Blvd.', 'Boston', 'MA', '2134', 'USA', '(617) 555-3267', '(617) 555-3389', ''),
(20, 'Leka Trading', 'Chandra Leka', 'Owner', '471 Serangoon Loop, Suite #402', 'Singapore', '', '512', 'Singapore', '555-8787', '', ''),
(21, 'Lyngbysild', 'Niels Petersen', 'Sales Manager', 'Lyngbysild Fiskebakken 10', 'Lyngby', '', '2800', 'Denmark', '43844108', '43844115', ''),
(22, 'Zaanse Snoepfabriek', 'Dirk Luchte', 'Accounting Manager', 'Verkoop Rijnweg 22', 'Zaandam', '', '9999 ZZ', 'Netherlands', '(12345) 1212', '(12345) 1210', ''),
(23, 'Karkki Oy', 'Anne Heikkonen', 'Product Manager', 'Valtakatu 12', 'Lappeenranta', '', '53120', 'Finland', '(953) 10956', '', ''),
(24, 'G\'day, Mate', 'Wendy Mackenzie', 'Sales Representative', '170 Prince Edward Parade Hunter\'s Hill', 'Sydney', 'NSW', '2042', 'Australia', '(02) 555-5914', '(02) 555-4873', 'G\'day Mate (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/gdaymate.htm#'),
(25, 'Ma Maison', 'Jean-Guy Lauzon', 'Marketing Manager', '2960 Rue St. Laurent', 'Montr�al', 'Qu�bec', 'H1J 1C3', 'Canada', '(514) 555-9022', '', ''),
(26, 'Pasta Buttini s.r.l.', 'Giovanni Giudici', 'Order Administrator', 'Via dei Gelsomini, 153', 'Salerno', '', '84100', 'Italy', '(089) 6547665', '(089) 6547667', ''),
(27, 'Escargots Nouveaux', 'Marie Delamare', 'Sales Manager', '22, rue H. Voiron', 'Montceau', '', '71300', 'France', '85.57.00.07', '', ''),
(28, 'Gai p�turage', 'Eliane Noz', 'Sales Representative', 'Bat. B 3, rue des Alpes', 'Annecy', '', '74000', 'France', '38.76.98.06', '38.76.98.58', ''),
(29, 'For�ts d\'�rables', 'Chantal Goulet', 'Accounting Manager', '148 rue Chasseur', 'Ste-Hyacinthe', 'Qu�bec', 'J2S 7S8', 'Canada', '(514) 555-2955', '(514) 555-2921', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `territories`
--

CREATE TABLE `territories` (
  `TerritoryID` varchar(20) NOT NULL,
  `TerritoryDescription` char(50) NOT NULL,
  `RegionID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `territories`
--

INSERT INTO `territories` (`TerritoryID`, `TerritoryDescription`, `RegionID`) VALUES
('10019', 'New York', 1),
('10038', 'New York', 1),
('11747', 'Mellvile', 1),
('14450', 'Fairport', 1),
('1581', 'Westboro', 1),
('1730', 'Bedford', 1),
('1833', 'Georgetow', 1),
('19428', 'Philadelphia', 3),
('19713', 'Neward', 1),
('20852', 'Rockville', 1),
('2116', 'Boston', 1),
('2139', 'Cambridge', 1),
('2184', 'Braintree', 1),
('27403', 'Greensboro', 1),
('27511', 'Cary', 1),
('2903', 'Providence', 1),
('29202', 'Columbia', 4),
('30346', 'Atlanta', 4),
('3049', 'Hollis', 3),
('31406', 'Savannah', 4),
('32859', 'Orlando', 4),
('33607', 'Tampa', 4),
('3801', 'Portsmouth', 3),
('40222', 'Louisville', 1),
('44122', 'Beachwood', 3),
('45839', 'Findlay', 3),
('48075', 'Southfield', 3),
('48084', 'Troy', 3),
('48304', 'Bloomfield Hills', 3),
('53404', 'Racine', 3),
('55113', 'Roseville', 3),
('55439', 'Minneapolis', 3),
('60179', 'Hoffman Estates', 2),
('60601', 'Chicago', 2),
('6897', 'Wilton', 1),
('72716', 'Bentonville', 4),
('75234', 'Dallas', 4),
('78759', 'Austin', 4),
('7960', 'Morristown', 1),
('80202', 'Denver', 2),
('80909', 'Colorado Springs', 2),
('85014', 'Phoenix', 2),
('85251', 'Scottsdale', 2),
('8837', 'Edison', 1),
('90405', 'Santa Monica', 2),
('94025', 'Menlo Park', 2),
('94105', 'San Francisco', 2),
('95008', 'Campbell', 2),
('95054', 'Santa Clara', 2),
('95060', 'Santa Cruz', 2),
('98004', 'Bellevue', 2),
('98052', 'Redmond', 2),
('98104', 'Seattle', 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`CategoryID`),
  ADD KEY `Categories_CategoryName` (`CategoryName`);

--
-- Indices de la tabla `customercustomerdemo`
--
ALTER TABLE `customercustomerdemo`
  ADD PRIMARY KEY (`CustomerID`,`CustomerTypeID`),
  ADD KEY `FK_CustomerCustomerDemo` (`CustomerTypeID`),
  ADD KEY `FK_CustomerCustomerDemo_Customers` (`CustomerID`);

--
-- Indices de la tabla `customerdemographics`
--
ALTER TABLE `customerdemographics`
  ADD PRIMARY KEY (`CustomerTypeID`);

--
-- Indices de la tabla `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`),
  ADD KEY `Customers_City` (`City`),
  ADD KEY `Customers_CompanyName` (`CompanyName`),
  ADD KEY `Customers_PostalCode` (`PostalCode`),
  ADD KEY `Customers_Region` (`Region`);

--
-- Indices de la tabla `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD KEY `Employees_LastName` (`LastName`),
  ADD KEY `Employees_PostalCode` (`PostalCode`),
  ADD KEY `FK_Employees_Employees` (`ReportsTo`);

--
-- Indices de la tabla `employeeterritories`
--
ALTER TABLE `employeeterritories`
  ADD PRIMARY KEY (`EmployeeID`,`TerritoryID`),
  ADD KEY `FK_EmployeeTerritories_Territories` (`TerritoryID`);

--
-- Indices de la tabla `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`OrderID`,`ProductID`),
  ADD KEY `OrderDetails_OrderID` (`OrderID`),
  ADD KEY `OrderDetails_OrdersOrder_Details` (`OrderID`),
  ADD KEY `OrderDetails_ProductID` (`ProductID`),
  ADD KEY `OrderDetails_ProductsOrder_Details` (`ProductID`);

--
-- Indices de la tabla `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `Orders_CustomerID` (`CustomerID`),
  ADD KEY `Orders_CustomersOrders` (`CustomerID`),
  ADD KEY `Orders_EmployeeID` (`EmployeeID`),
  ADD KEY `Orders_EmployeesOrders` (`EmployeeID`),
  ADD KEY `Orders_OrderDate` (`OrderDate`),
  ADD KEY `Orders_ShippedDate` (`ShippedDate`),
  ADD KEY `Orders_ShippersOrders` (`ShipVia`),
  ADD KEY `Orders_ShipPostalCode` (`ShipPostalCode`),
  ADD KEY `FK_Orders_Customers` (`CustomerID`);

--
-- Indices de la tabla `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`ProductID`),
  ADD KEY `Products_CategoriesProducts` (`CategoryID`),
  ADD KEY `Products_CategoryID` (`CategoryID`),
  ADD KEY `Products_ProductName` (`ProductName`),
  ADD KEY `Products_SupplierID` (`SupplierID`),
  ADD KEY `Products_SuppliersProducts` (`SupplierID`);

--
-- Indices de la tabla `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`RegionID`);

--
-- Indices de la tabla `shippers`
--
ALTER TABLE `shippers`
  ADD PRIMARY KEY (`ShipperID`);

--
-- Indices de la tabla `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SupplierID`),
  ADD KEY `Suppliers_CompanyName` (`CompanyName`),
  ADD KEY `Suppliers_PostalCode` (`PostalCode`);

--
-- Indices de la tabla `territories`
--
ALTER TABLE `territories`
  ADD PRIMARY KEY (`TerritoryID`),
  ADD KEY `FK_Territories_Region` (`RegionID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `employees`
--
ALTER TABLE `employees`
  MODIFY `EmployeeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11089;

--
-- AUTO_INCREMENT de la tabla `products`
--
ALTER TABLE `products`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT de la tabla `shippers`
--
ALTER TABLE `shippers`
  MODIFY `ShipperID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `SupplierID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `customercustomerdemo`
--
ALTER TABLE `customercustomerdemo`
  ADD CONSTRAINT `FK_CustomerCustomerDemo` FOREIGN KEY (`CustomerTypeID`) REFERENCES `customerdemographics` (`CustomerTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_CustomerCustomerDemo_Customers` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `FK_Employees_Employees` FOREIGN KEY (`ReportsTo`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `employeeterritories`
--
ALTER TABLE `employeeterritories`
  ADD CONSTRAINT `FK_EmployeeTerritories_Employees` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FK_EmployeeTerritories_Territories` FOREIGN KEY (`TerritoryID`) REFERENCES `territories` (`TerritoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `FK_Order_Details_Products` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `FK_Orders_Customers` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Orders_Employees` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Orders_Shippers` FOREIGN KEY (`ShipVia`) REFERENCES `shippers` (`ShipperID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `FK_Products_Categories` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`CategoryID`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_Products_Suppliers` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `territories`
--
ALTER TABLE `territories`
  ADD CONSTRAINT `FK_Territories_Region` FOREIGN KEY (`RegionID`) REFERENCES `region` (`RegionID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
