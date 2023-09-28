-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 23, 2023 at 10:28 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hooksloops`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCart` (IN `CusID` INT)   BEGIN
    	START TRANSACTION;
        	INSERT INTO cart (TotalPrice,CustomerID) VALUES (0,CusID);
            COMMIT;
        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCategory` (IN `N` VARCHAR(255), IN `D` VARCHAR(255))   BEGIN
    	START TRANSACTION;
            INSERT category (Name,Description) VALUES (N,D);
        COMMIT;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddProduct` (IN `N` VARCHAR(225), IN `D` VARCHAR(255), IN `P` INT, IN `S` INT, IN `CAT` INT)   BEGIN
	START TRANSACTION;
        INSERT product (ProductName,Description,Price,Stock,CategoryID) VALUES (N,D,P,S,CAT);
    	COMMIT;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddToCart` (IN `Pid` INT(255), IN `Cid` INT(255), IN `Q` INT)   BEGIN
        SET @b:=(SELECT Stock FROM product WHERE Cid = ProductID);
        IF @b < Q THEN
        	SELECT @c='asdsadsad';
        	ROLLBACK;
        ELSE
        	INSERT dborder (OrderDate, Quantity,ProductID,CartID) VALUES (CURRENT_DATE(),Q,Pid,Cid);
            SET @c:=(SELECT Price FROM product WHERE ProductID = PID);
            UPDATE cart SET TotalPrice = TotalPrice + @c*Q WHERE CartID = Cid;
            COMMIT;
   		END IF;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `UN` VARCHAR(255), IN `FN` VARCHAR(255), IN `LN` VARCHAR(255), IN `E` VARCHAR(255), IN `PSW` VARCHAR(255), IN `Ad` VARCHAR(255), IN `Ph` INT, IN `T` INT)   BEGIN
	START TRANSACTION;
        SET @a = (SELECT COUNT(UserID) FROM users);
        INSERT users VALUES (@a+1,UN,FN,LN,E,PSW,Ad,Ph,T);
        IF T = 1 THEN
            SET @b = (SELECT COUNT(AdminID) FROM admin);
            INSERT admin VALUES (@b+1,@a+1);
        ELSEIF T = 2 THEN
            SET @b = (SELECT COUNT(CustomerID) FROM customer);
            INSERT customer VALUES (@b+1,@a+1);
        END IF;
    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCart` (`Cid` INT)   BEGIN
    	START TRANSACTION;
        	DELETE FROM cart WHERE `cart`.`CartID` = Cid;
         	COMMIT;
        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOrder` (`Ono` INT)   BEGIN
    	START TRANSACTION;
			DELETE FROM dborder WHERE `dborder`.`OrderNo` = 7;
            COMMIT;
        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCart` (`CusId` INT)   BEGIN
    	SELECT * FROM `getcarts` WHERE CustomerID = CusID;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCartC` (IN `Cartid` INT)   BEGIN
	SELECT c.CustomerID, o.OrderNo, p.ProductName, p.Price, o.Quantity, c.TotalPrice 
    FROM cart c INNER JOIN dborder o ON o.CartID = c.CartID 
    INNER JOIN product p ON o.ProductID = p.ProductID WHERE c.CartID = Cartid;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Login` (IN `UN` VARCHAR(255), IN `PSW` VARCHAR(255))   BEGIN
    	SET @a:=(SELECT UserType FROM users WHERE UN = UserName AND PSW = PSWD);
        SET @b:=(SELECT UserID FROM users WHERE UN = UserName AND PSW = PSWD);
        
        IF @a = 1 THEN
        	SELECT u.UserName,u.UserType,a.AdminID FROM admin a INNER JOIN users u ON a.UserID = u.UserID AND a.UserID = @b;
            ELSEIF @a = 2 THEN
        	SELECT u.UserName,u.UserType,c.CustomerID FROM customer c INNER JOIN users u ON c.UserID = u.UserID AND c.UserID = @b;
        END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modOrder` (IN `Ono` VARCHAR(255), IN `Q` INT)   BEGIN
		START TRANSACTION;
    	SET @a:=(SELECT ProductID FROM dborder WHERE Ono = OrderNo);
        SET @b:=(SELECT Stock FROM product WHERE @a = ProductID);
        IF @b < Q THEN
        	SELECT @c='asdsadsad';
        	ROLLBACK;
        ELSE
       		SET @d:=(SELECT Quantity FROM dborder WHERE Ono = OrderNo);
            SET @e:=(SELECT CartID FROM dborder WHERE Ono = OrderNo);
        	UPDATE dborder SET Quantity = Q WHERE OrderNo = Ono;
            SET @c:=(SELECT Price FROM product WHERE ProductID = @a);
            UPDATE cart SET TotalPrice = TotalPrice + @c*Q-@c*@d WHERE CartID = @e;
            COMMIT;
   		END IF;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sendMessage` (IN `mess` VARCHAR(255), IN `Cind` INT, IN `Aid` INT)   BEGIN
    	START TRANSACTION;
        INSERT message (Message,AdminID,CustomerID) VALUES (mess,Aid,Cusid);
        COMMIT;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `AdminID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`AdminID`, `UserID`) VALUES
(1, 1),
(2, 5);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `CartID` int(11) NOT NULL,
  `TotalPrice` int(11) DEFAULT NULL,
  `CustomerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`CartID`, `TotalPrice`, `CustomerID`) VALUES
(7, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryID` int(11) NOT NULL,
  `Name` varchar(225) NOT NULL,
  `Description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryID`, `Name`, `Description`) VALUES
(1, 'Test', 'TEster'),
(2, 'Cat2', 'adawewe'),
(3, 'asdasd', 'sdfdsfdsfdsf');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerID`, `UserID`) VALUES
(1, 2),
(2, 3),
(3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `dborder`
--

CREATE TABLE `dborder` (
  `OrderNo` int(11) NOT NULL,
  `OrderDate` date DEFAULT NULL,
  `Quantity` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `CartID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dborder`
--

INSERT INTO `dborder` (`OrderNo`, `OrderDate`, `Quantity`, `ProductID`, `CartID`) VALUES
(7, '2023-09-23', 1, 2, 7);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getcarts`
-- (See below for the actual view)
--
CREATE TABLE `getcarts` (
`CustomerID` int(11)
,`CartID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getcategory`
-- (See below for the actual view)
--
CREATE TABLE `getcategory` (
`Name` varchar(225)
,`Description` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getcustomers`
-- (See below for the actual view)
--
CREATE TABLE `getcustomers` (
`CustomerID` int(11)
,`FirstName` varchar(255)
,`LastName` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `getproduct`
-- (See below for the actual view)
--
CREATE TABLE `getproduct` (
`CATNAME` varchar(225)
,`ProductID` int(11)
,`ProductName` varchar(255)
,`Price` int(11)
,`Stock` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `MessageID` int(11) NOT NULL,
  `Message` varchar(255) NOT NULL,
  `AdminID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `messages`
-- (See below for the actual view)
--
CREATE TABLE `messages` (
`MessageID` int(11)
,`Message` varchar(255)
,`AdminID` int(11)
,`CustomerID` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `PaymentID` int(11) NOT NULL,
  `date` date NOT NULL,
  `method` varchar(255) NOT NULL,
  `CartID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `ProductID` int(11) NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Price` int(11) NOT NULL,
  `Stock` int(11) NOT NULL,
  `CategoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductID`, `ProductName`, `Description`, `Price`, `Stock`, `CategoryID`) VALUES
(1, 'Test', 'Datest', 100, 10, 1),
(2, 'Test2', 'asd', 12, 34, 1),
(3, 'Cat2Test', 'qwe', 23, 33, 2),
(4, 'Testingw', '123wqe', 12, 322, 2),
(5, 'dsfdsf', 'dsfdf', 32, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `productreview`
--

CREATE TABLE `productreview` (
  `ProductReviewID` int(11) NOT NULL,
  `Message` varchar(255) NOT NULL,
  `Star` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(255) NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PSWD` varchar(255) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `PhoneNumber` int(11) NOT NULL,
  `UserType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `UserName`, `FirstName`, `LastName`, `Email`, `PSWD`, `Address`, `PhoneNumber`, `UserType`) VALUES
(1, 'admin', 'sdf', 'sdf', 'dsf', '123', 'dsf', 12213, 1),
(2, 'franco', 'asd', 'qwe', 'dsf', '1234', '123', 123456, 2),
(3, 'Mariel', 'sad', 'sad', 'sad', '1234', '123', 12, 2),
(4, 'danica', '23', 'wer', 'wer', '1234', 'ewq', 123423, 2),
(5, 'admin2', 'sad', 'sdf', 'asdf', '123', '45456', 456, 1);

-- --------------------------------------------------------

--
-- Structure for view `getcarts`
--
DROP TABLE IF EXISTS `getcarts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getcarts`  AS SELECT `c`.`CustomerID` AS `CustomerID`, `k`.`CartID` AS `CartID` FROM (`cart` `k` join `customer` `c` on(`c`.`CustomerID` = `k`.`CustomerID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `getcategory`
--
DROP TABLE IF EXISTS `getcategory`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getcategory`  AS SELECT `category`.`Name` AS `Name`, `category`.`Description` AS `Description` FROM `category` ;

-- --------------------------------------------------------

--
-- Structure for view `getcustomers`
--
DROP TABLE IF EXISTS `getcustomers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getcustomers`  AS SELECT `c`.`CustomerID` AS `CustomerID`, `u`.`FirstName` AS `FirstName`, `u`.`LastName` AS `LastName` FROM (`customer` `c` join `users` `u` on(`c`.`UserID` = `u`.`UserID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `getproduct`
--
DROP TABLE IF EXISTS `getproduct`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `getproduct`  AS SELECT `c`.`Name` AS `CATNAME`, `p`.`ProductID` AS `ProductID`, `p`.`ProductName` AS `ProductName`, `p`.`Price` AS `Price`, `p`.`Stock` AS `Stock` FROM (`category` `c` join `product` `p` on(`c`.`CategoryID` = `p`.`CategoryID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `messages`
--
DROP TABLE IF EXISTS `messages`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `messages`  AS SELECT `message`.`MessageID` AS `MessageID`, `message`.`Message` AS `Message`, `message`.`AdminID` AS `AdminID`, `message`.`CustomerID` AS `CustomerID` FROM `message` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`AdminID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`CartID`),
  ADD KEY `CustomerID` (`CustomerID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `dborder`
--
ALTER TABLE `dborder`
  ADD PRIMARY KEY (`OrderNo`),
  ADD KEY `ProductID` (`ProductID`),
  ADD KEY `CartID` (`CartID`);

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`MessageID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `AdminID` (`AdminID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`PaymentID`),
  ADD KEY `CartID` (`CartID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ProductID`),
  ADD KEY `CategoryID` (`CategoryID`);

--
-- Indexes for table `productreview`
--
ALTER TABLE `productreview`
  ADD PRIMARY KEY (`ProductReviewID`),
  ADD KEY `CustomerID` (`CustomerID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `UserName` (`UserName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `AdminID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `CartID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `dborder`
--
ALTER TABLE `dborder`
  MODIFY `OrderNo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `ProductID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `productreview`
--
ALTER TABLE `productreview`
  MODIFY `ProductReviewID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `dborder`
--
ALTER TABLE `dborder`
  ADD CONSTRAINT `dborder_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE CASCADE,
  ADD CONSTRAINT `dborder_ibfk_2` FOREIGN KEY (`CartID`) REFERENCES `cart` (`CartID`) ON DELETE CASCADE;

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`AdminID`) REFERENCES `admin` (`AdminID`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`CartID`) REFERENCES `cart` (`CartID`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`);

--
-- Constraints for table `productreview`
--
ALTER TABLE `productreview`
  ADD CONSTRAINT `productreview_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`),
  ADD CONSTRAINT `productreview_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
