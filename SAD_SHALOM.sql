-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 25, 2022 at 10:05 AM
-- Server version: 8.0.29-0ubuntu0.20.04.3
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `SAD_SHALOM`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`student`@`%` PROCEDURE `pInsertDetailTrans` (IN `IDTrans` VARCHAR(9), IN `SKU` VARCHAR(7), IN `QTY` VARCHAR(4))  BEGIN
INSERT INTO DETAIL_TRANSACTION(ID_TRANSACTION, SKU, QTY_PRODUCT)
VALUES (IDTrans, SKU, QTY);
END$$

CREATE DEFINER=`student`@`%` PROCEDURE `pInsertProductBelom` (IN `SKU` VARCHAR(7), IN `IDCategory` VARCHAR(1), IN `P_Name` VARCHAR(50), IN `Size` INT, IN `Price` INT, IN `Stock` INT, IN `descript` TEXT)  BEGIN
declare urutan varchar(3);
declare temp varchar(7);

set temp = concat(ID_CATEGORY, SIZE);

if(ID_CATEGORY = "A" and size = "250") then set temp = concat(ID_CATEGORY, SIZE, temp);
elseif(Platform = "A" and size = "500") then set temp = concat("T",date_format(now(), "%Y%m%d"));
end if;

INSERT INTO TRANSACTION(SKU, ID_CATEGORY, P_NAME, SIZE, PRICE, STOCK, `DESCRIPTION`,
IMAGE)
VALUES (temp, IDCategory, P_Name, Size, Price, Stock, Descript, temp);
END$$

CREATE DEFINER=`student`@`%` PROCEDURE `pInsertTransaction` (IN `IDAdmin` VARCHAR(4), IN `DateTrans` DATE, IN `Platform` VARCHAR(9), IN `TotalQty` INT, IN `TotalPrice` INT, IN `TotalFee` INT, `StatDelete` VARCHAR(1))  BEGIN
declare temp varchar(9);
set temp = "";
if(Platform = "shopee") then set temp = concat("S",date_format(now(), "%Y%m%d"));
elseif(Platform = "tokopedia") then set temp = concat("T",date_format(now(), "%Y%m%d"));
end if;

INSERT INTO TRANSACTION(ID_TRANSACTION, ID_ADMIN, DATE_TRANSACTION, PLATFORM, TOTAL_QTY, TOTAL_PRICE, TOTAL_FEE, STATUS_DELETE)
VALUES (temp, IDAdmin, DateTrans, Platform, TotalQty, TotalPrice, TotalFee, StatDelete);

END$$

--
-- Functions
--
CREATE DEFINER=`student`@`%` FUNCTION `fAdminFee` (`platform` VARCHAR(10), `period` VARCHAR(20)) RETURNS VARCHAR(15) CHARSET utf8mb4 READS SQL DATA
BEGIN
	declare inc varchar(15);
    declare prd varchar(20);
    declare plt1 varchar(10);
    declare plt2 varchar(10);
    IF period = 'Last 7 Days' THEN
		set prd = '7';
	ELSEIF period = 'Last 30 Days' THEN
		set prd = '30';
	ELSEIF period = 'all' THEN
		set prd = '100000';
	END IF;
	IF platform = 'all' THEN
		set plt1 = 'Shopee';
        set plt2 = 'Tokopedia';
	ELSEIF platform = 'shopee' THEN
		set plt1 = 'Shopee';
        set plt2 = 'Shopee';
	ELSEIF platform = 'tokopedia' THEN
		set plt1 = 'Tokopedia';
        set plt2 = 'Tokopedia';
    END IF;
    select FORMAT(sum(TOTAL_FEE),2) into inc 
    from `TRANSACTION` 
    where (`TRANSACTION`.`PLATFORM` = plt1 or `TRANSACTION`.`PLATFORM` = plt2) AND `TRANSACTION`.`DATE_TRANSACTION` >= CAST((NOW() - INTERVAL prd DAY) AS DATE);
RETURN inc;
END$$

CREATE DEFINER=`student`@`%` FUNCTION `fID_Cat` () RETURNS CHAR(1) CHARSET utf8mb4 READS SQL DATA
BEGIN
declare tempID char(1);

select convert(char(ASCII(max(`ID_CATEGORY`))+1), char) into tempID
from CATEGORY; 

return tempID;

END$$

CREATE DEFINER=`student`@`%` FUNCTION `fNetProfit` (`platform` VARCHAR(10), `period` VARCHAR(20)) RETURNS VARCHAR(15) CHARSET utf8mb4 READS SQL DATA
BEGIN
	declare inc varchar(15);
    declare prd varchar(20);
    declare plt1 varchar(10);
    declare plt2 varchar(10);
    IF period = 'Last 7 Days' THEN
		set prd = '7';
	ELSEIF period = 'Last 30 Days' THEN
		set prd = '30';
	ELSEIF period = 'all' THEN
		set prd = '100000';
	END IF;
	IF platform = 'all' THEN
		set plt1 = 'Shopee';
        set plt2 = 'Tokopedia';
	ELSEIF platform = 'shopee' THEN
		set plt1 = 'Shopee';
        set plt2 = 'Shopee';
	ELSEIF platform = 'tokopedia' THEN
		set plt1 = 'Tokopedia';
        set plt2 = 'Tokopedia';
    END IF;
    select FORMAT(sum(NET_PRICE),2) into inc 
    from `TRANSACTION` 
    where (`TRANSACTION`.`PLATFORM` = plt1 or `TRANSACTION`.`PLATFORM` = plt2) AND `TRANSACTION`.`DATE_TRANSACTION` >= CAST((NOW() - INTERVAL prd DAY) AS DATE);
RETURN inc;
END$$

CREATE DEFINER=`student`@`%` FUNCTION `fSKU` () RETURNS VARCHAR(12) CHARSET utf8mb4 READS SQL DATA
BEGIN
declare temp varchar(3);
declare sku varchar(7);

IF ID_CATEGORY = "A" THEN
select lpad(ifnull(max(substring(SKU,5,3))+1,1),3,"0") into temp
from PRODUCT
where ID_CATEGORY = "A";

set sku = concat("A", if(SIZE = 250, 250, if(SIZE = 500, 500, 000)), temp);
RETURN sku;

ELSE IF ID_CATEGORY = "B" THEN
select lpad(ifnull(max(substring(SKU,5,3))+1,1),3,"0") into temp
from PRODUCT
where ID_CATEGORY = "B";

set sku = concat("B", if(SIZE = 250, 250, if(SIZE = 500, 500, 000)), temp);
RETURN sku;

ELSE IF ID_CATEGORY = "C" THEN
select lpad(ifnull(max(substring(SKU,5,3))+1,1),3,"0") into temp
from PRODUCT
where ID_CATEGORY = "C";

set sku = concat("C", if(SIZE = 250, 250, if(SIZE = 500, 500, 000)), temp);
RETURN sku;

ELSE 
set sku = concat("D", if(SIZE = 250, 250, if(SIZE = 500, 500, 000)), temp);
RETURN sku;

END IF;
END IF;
END IF;
END$$

CREATE DEFINER=`student`@`%` FUNCTION `fTransID` () RETURNS VARCHAR(12) CHARSET utf8mb4 READS SQL DATA
BEGIN
declare tempID varchar(9);

IF PLATFORM = "tokopedia" THEN
set tempID = concat("T",date_format(now(), "%Y%m%d"));
RETURN tempID;

ELSE 
set tempID = concat("S",date_format(now(), "%Y%m%d"));
RETURN tempID;

END IF;          
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ADMIN`
--

CREATE TABLE `ADMIN` (
  `ID_ADMIN` varchar(4) NOT NULL,
  `PASSWORD_ADMIN` varchar(8) DEFAULT NULL,
  `STATUS_DELETE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ADMIN`
--

INSERT INTO `ADMIN` (`ID_ADMIN`, `PASSWORD_ADMIN`, `STATUS_DELETE`) VALUES
('A001', 'A001', '0'),
('A002', 'A002', '0'),
('A003', 'A003', '0');

-- --------------------------------------------------------

--
-- Table structure for table `CART`
--

CREATE TABLE `CART` (
  `ID_TRANSACTION` varchar(10) NOT NULL,
  `ID_ADMIN` varchar(4) NOT NULL,
  `DATE` date NOT NULL,
  `PLATFORM` varchar(10) NOT NULL,
  `SKU` varchar(10) NOT NULL,
  `QTY_PRODUCT` int NOT NULL,
  `STATUS_DELETE` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `CART`
--

INSERT INTO `CART` (`ID_TRANSACTION`, `ID_ADMIN`, `DATE`, `PLATFORM`, `SKU`, `QTY_PRODUCT`, `STATUS_DELETE`) VALUES
('T00000000', 'A004', '2019-02-02', 'Tokopedia', 'A0000000', 1, '0');

-- --------------------------------------------------------

--
-- Table structure for table `CATEGORY`
--

CREATE TABLE `CATEGORY` (
  `ID_CATEGORY` varchar(1) NOT NULL,
  `C_NAME` varchar(15) NOT NULL,
  `TOTAL_PRODUCT` int DEFAULT '0',
  `STATUS_DELETE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `CATEGORY`
--

INSERT INTO `CATEGORY` (`ID_CATEGORY`, `C_NAME`, `TOTAL_PRODUCT`, `STATUS_DELETE`) VALUES
('A', 'Cleaner', 10, '0'),
('B', 'Protector', 14, '0'),
('C', 'Coating Factory', 7, '0'),
('D', 'Tools', 2, '0'),
('E', 'Cleaner Spray', 0, '0');

-- --------------------------------------------------------

--
-- Table structure for table `DETAIL_TRANSACTION`
--

CREATE TABLE `DETAIL_TRANSACTION` (
  `SKU` varchar(7) NOT NULL,
  `ID_TRANSACTION` varchar(9) NOT NULL,
  `QTY_PRODUCT` int NOT NULL,
  `STATUS_DELETE` varchar(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `DETAIL_TRANSACTION`
--

INSERT INTO `DETAIL_TRANSACTION` (`SKU`, `ID_TRANSACTION`, `QTY_PRODUCT`, `STATUS_DELETE`) VALUES
('A100001', 'S20220531', 1, '0'),
('A100001', 'T20220607', 1, '0'),
('A250001', 'S20220402', 1, '0'),
('A250001', 'T20220403', 1, '0'),
('A250001', 'T20220408', 1, '0'),
('A250001', 'T20220410', 1, '0'),
('A250001', 'T20220413', 1, '0'),
('A250001', 'T20220513', 1, '0'),
('A250002', 'S20220403', 1, '0'),
('A250002', 'S20220405', 1, '0'),
('A250002', 'S20220607', 4, '0'),
('A250002', 'S20220612', 6, '0'),
('A250002', 'T20220404', 1, '0'),
('A250002', 'T20220531', 8, '0'),
('A250002', 'T20220602', 6, '0'),
('A250002', 'T20220612', 9, '0'),
('A250003', 'S20220403', 2, '0'),
('A250003', 'S20220602', 3, '0'),
('A250003', 'S20220613', 1, '0'),
('A250003', 'T20220401', 1, '0'),
('A250003', 'T20220609', 2, '0'),
('A250003', 'T20220610', 10, '0'),
('A250004', 'S20220609', 1, '0'),
('A250004', 'T20220607', 5, '0'),
('A250005', 'S20220404', 2, '0'),
('A250005', 'T20220402', 2, '0'),
('A250005', 'T20220412', 2, '0'),
('A250006', 'S20220407', 2, '0'),
('A250006', 'S20220408', 2, '0'),
('A250006', 'S20220409', 3, '0'),
('A250006', 'S20220410', 2, '0'),
('A250006', 'T20220401', 3, '0'),
('A250006', 'T20220410', 2, '0'),
('A320001', 'S20220402', 3, '0'),
('A320001', 'S20220409', 3, '0'),
('A320001', 'S20220610', 5, '0'),
('A320001', 'T20220401', 3, '0'),
('A320001', 'T20220408', 3, '0'),
('A320001', 'T20220409', 3, '0'),
('A320001', 'T20220607', 2, '0'),
('A500001', 'S20220404', 3, '0'),
('A500001', 'S20220411', 3, '0'),
('A500001', 'S20220607', 2, '0'),
('A500001', 'T20220405', 3, '0'),
('A500001', 'T20220413', 3, '0'),
('A500001', 'T20220613', 10, '0'),
('A500002', 'S20220410', 4, '0'),
('A500002', 'S20220606', 1, '0'),
('A500002', 'T20220407', 4, '0'),
('A500002', 'T20220531', 4, '0'),
('A500003', 'S20220531', 2, '0'),
('A500003', 'T20220607', 1, '0'),
('A500004', 'S20220531', 1, '0'),
('A500004', 'T20220609', 2, '0'),
('B250001', 'S20220407', 4, '0'),
('B250001', 'S20220611', 1, '0'),
('B250001', 'S20220614', 2, '0'),
('B250001', 'T20220406', 4, '0'),
('B250001', 'T20220602', 1, '0'),
('B250001', 'T20220616', 1, '0'),
('B250002', 'S20220401', 4, '0'),
('B250002', 'T20220413', 4, '0'),
('B250002', 'T20220611', 2, '0'),
('B250002', 'T20220614', 1, '0'),
('B250003', 'S20220403', 5, '0'),
('B250003', 'S20220413', 5, '0'),
('B250003', 'T20220405', 5, '0'),
('B250004', 'S20220401', 5, '0'),
('B250004', 'S20220402', 5, '0'),
('B250004', 'T20220408', 5, '0'),
('B250004', 'T20220412', 5, '0'),
('B250005', 'S20220411', 5, '0'),
('B250005', 'S20220413', 5, '0'),
('B250005', 'T20220401', 5, '0'),
('B250005', 'T20220409', 5, '0'),
('B250006', 'S20220411', 6, '0'),
('B250006', 'S20220412', 6, '0'),
('B250007', 'S20220403', 6, '0'),
('B250007', 'S20220413', 6, '0'),
('B250007', 'T20220407', 6, '0'),
('B250007', 'T20220410', 6, '0'),
('B250007', 'T20220412', 6, '0'),
('B250007', 'T20220413', 6, '0'),
('B250008', 'S20220412', 6, '0'),
('B250008', 'T20220408', 7, '0'),
('B500001', 'S20220404', 7, '0'),
('B500001', 'S20220407', 7, '0'),
('B500001', 'T20220412', 7, '0'),
('B500003', 'S20220616', 2, '0'),
('C100001', 'S20220404', 7, '0'),
('C100001', 'S20220413', 7, '0'),
('C100001', 'T20220401', 7, '0'),
('C100001', 'T20220410', 7, '0'),
('C100001', 'T20220412', 7, '0'),
('C100002', 'S20220406', 8, '0'),
('C100002', 'T20220407', 8, '0'),
('C250001', 'S20220401', 8, '0'),
('C250001', 'S20220607', 5, '0'),
('C250001', 'T20220406', 8, '0'),
('C250001', 'T20220407', 8, '0'),
('C250002', 'S20220615', 2, '0'),
('C250003', 'S20220403', 9, '0'),
('C250003', 'T20220406', 9, '0'),
('C250003', 'T20220411', 8, '0'),
('C250004', 'T20220408', 9, '0'),
('C250004', 'T20220606', 1, '0'),
('C500001', 'S20220406', 9, '0'),
('C500001', 'T20220411', 9, '0'),
('C500001', 'T20220513', 3, '0'),
('C500001', 'T20220608', 2, '0'),
('C500001', 'T20220615', 1, '0'),
('D000001', 'S20220608', 1, '0'),
('D000002', 'S20220602', 5, '0');

--
-- Triggers `DETAIL_TRANSACTION`
--
DELIMITER $$
CREATE TRIGGER `tUpdateStock` AFTER INSERT ON `DETAIL_TRANSACTION` FOR EACH ROW BEGIN

	DECLARE stocknow int;
    DECLARE tempJumlahProduk int;
    
    select QTY_PRODUCT into tempJumlahProduk
    from DETAIL_TRANSACTION
    where SKU = NEW.SKU and ID_TRANSACTION = NEW.ID_TRANSACTION;
    
    select STOCK into stocknow
    from PRODUCT
    where SKU = NEW.SKU;
    
    update PRODUCT
    set STOCK = stocknow - tempJumlahProduk
    where SKU = NEW.SKU;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_all_all`
-- (See below for the actual view)
--
CREATE TABLE `finance_all_all` (
`PLATFORM` varchar(3)
,`DATE_TRANSACTION` varchar(9)
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_all_seven`
-- (See below for the actual view)
--
CREATE TABLE `finance_all_seven` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_all_thirty`
-- (See below for the actual view)
--
CREATE TABLE `finance_all_thirty` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_shopee_all`
-- (See below for the actual view)
--
CREATE TABLE `finance_shopee_all` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` varchar(9)
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` decimal(32,0)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_shopee_seven`
-- (See below for the actual view)
--
CREATE TABLE `finance_shopee_seven` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_shopee_thirty`
-- (See below for the actual view)
--
CREATE TABLE `finance_shopee_thirty` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_tokopedia_all`
-- (See below for the actual view)
--
CREATE TABLE `finance_tokopedia_all` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` varchar(9)
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_tokopedia_seven`
-- (See below for the actual view)
--
CREATE TABLE `finance_tokopedia_seven` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `finance_tokopedia_thirty`
-- (See below for the actual view)
--
CREATE TABLE `finance_tokopedia_thirty` (
`PLATFORM` varchar(9)
,`DATE_TRANSACTION` date
,`INT_NET_PROFIT` decimal(32,0)
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Table structure for table `PRODUCT`
--

CREATE TABLE `PRODUCT` (
  `SKU` varchar(7) NOT NULL,
  `ID_CATEGORY` varchar(1) NOT NULL,
  `P_NAME` varchar(50) DEFAULT NULL,
  `STOCK` int DEFAULT NULL,
  `SIZE` int DEFAULT NULL,
  `PRICE` int DEFAULT NULL,
  `DESCRIPTION` text,
  `IMAGE` varchar(100) DEFAULT NULL,
  `STATUS_DELETE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `PRODUCT`
--

INSERT INTO `PRODUCT` (`SKU`, `ID_CATEGORY`, `P_NAME`, `STOCK`, `SIZE`, `PRICE`, `DESCRIPTION`, `IMAGE`, `STATUS_DELETE`) VALUES
('A100001', 'A', 'Best Glass Scrub', 5, 100, 60000, 'BEST GLASS SCRUB / GLASS POLISH merupakan pembersih Jamur Kaca / Water Spot / Water Deposit khusus kaca yang aman untuk segala jenis kaca.', 'A100001.jpg', '0'),
('A250001', 'A', 'Tar Remover', 6, 250, 45000, 'Berfungsi untuk menghilangkan noda aspal, serangga, bekas oli, bekas lem, sticker dan getah yang menempel di body kendaraan.\'', 'A250001.jpg', '0'),
('A250003', 'A', 'All Purpose Cleaner', 33, 250, 30000, 'Membersihkan semua bagian interior mobil (dashboard, jok kulit, vinly, plafon mobil, jok beludru / kain, semua bagian plastik dan diimanapun kotoran berada di bagian interior atau dengan kata lain ALL INTERIOR SURFACE).', 'A250003.jpg', '0'),
('A250004', 'A', 'Leather and Vinyl Cleaner', 44, 250, 35000, 'Didesain khusus untuk membersihkan semua barang berbahan dasar kulit, vinyl, karet maupun plastik dengan efektif dan aman 100%. Dapat menghilangkan kotoran (minyak, debu, noda makanan) atau bekas semir lama yang melekat di kulit sepatu.', 'A250004.jpg', '0'),
('A250005', 'A', 'Canvas and Suede Cleaner', 48, 250, 35000, 'Didesain khusus untuk membersihkan semua barang berbahan dasar canvas, suede, nubuck dan fabric dengan efektif karena mengandung active cleaner dan aman 100%. Dapat menghilangkan kotoran (minyak, debu, noda makanan) pada bagian sepatu atau produk lainnya yang berbahan canvas, suede, nubuck and fabric.', 'A250005.jpg', '0'),
('A250006', 'A', 'Water Spot Remover', 47, 250, 40000, 'Menghilangkan water spot (bercak noda sisa air), water deposit (kerak) dan jamur pada bodi mobil, kaca, emblem dan dimanapun pada kendaraan anda (all surface water spot remover).', 'A250006.jpg', '0'),
('A320001', 'A', 'Rust Remover', 40, 320, 35000, 'Berfungsi untuk menghilangkan karat, kerak, jamur, debu, bekas oli yang telah mengendap lama dan menjadi kotoran yang susah untuk dibersihkan yang menempel pada blok mesin motor, baut-baut besi, kamar mandi, perabot rumah tangga, aksesoris dll yang terkontaminasi dengan karat/kerak.', 'A320001.jpg', '0'),
('A500001', 'A', 'Tar Remover', 35, 500, 80000, 'Berfungsi untuk menghilangkan noda aspal, serangga, bekas oli, bekas lem, sticker dan getah yang menempel di body kendaraan.', 'A500001.jpg', '0'),
('A500003', 'A', 'All Purpose Cleaner', 7, 500, 60000, 'Membersihkan semua bagian interior mobil (dashboard, jok kulit, vinly, plafon mobil, jok beludru / kain, semua bagian plastik dan diimanapun kotoran berada di bagian interior atau dengan kata lain ALL INTERIOR SURFACE).', 'A500003.jpg', '0'),
('A500004', 'A', 'Water Spot Remover', 30, 500, 70000, 'Menghilangkan water spot (bercak noda sisa air), water deposit (kerak) dan jamur pada bodi mobil, kaca, emblem dan dimanapun pada kendaraan anda (all surface water spot remover).', 'A500004.jpg', '0'),
('B250001', 'B', 'Best Interior Detailing', 41, 250, 35000, 'BEST INTERIOR DETAILING merupakan cara termudah untuk membersihkan, melindungi, dan memperindah vinyl, karet, dan plastik. Mengembalikan kilap permukaan interior mobil sehingga nampak baru kembali dan segar dengan aroma LEMON. Produk ini dapat juga dipakai untuk daily detailing pada ruang mesin mobil anda.', 'B250001.jpg', '0'),
('B250002', 'B', 'Black Trim Restorer', 43, 250, 70000, 'BEST BLACK TRIM RESTORER merupakan obat yang berfungsi untuk mengembalikan warna plastik trim hitam kendaraan anda yang telah rusak karena oksidasi, kotoran, sisa wax, dsb yang berwarna kusam sehingga menjadi hitam kembali.', 'B250002.jpg', '0'),
('B250003', 'B', 'Silane Guard', 45, 250, 70000, 'Produk ini wajib diaplikasikan menggunakan Microfiber Cloth. BEST SILANE GUARD ini juga dapat diaplikasikan pada windshield untuk memberikan hydropobic / water beading / water sheeting membuat pandangan lebih jelas waktu kondisi hujan dan wiper tidak perlu bekerja keras.', 'B250003.jpg', '0'),
('B250004', 'B', 'Silane Guard Pro', 50, 250, 95000, 'Merupakan produk paint sealant berbahan polymer yang berfungsi sama dengan BEST SILANE GUARD NEW FORMULA water based tetapi, BEST SILANE GUARD PRO merupakan produk yang solvent based. Hasil yang akan didapatkan adalah proteksi yang lebih tebal, hydropobic dan slick yang lebih kuat dan awet, wet look, glossy, swirlmark yang akan tertutup dengan jauh lebih baik, baik pada waktu siang maupun malam hari.', 'B250004.jpg', '0'),
('B250005', 'B', 'Water Repellent', 45, 250, 45000, 'Berfungsi untuk meningkatkan visibilitas pengemudi saat berkendara dalam kondisi hujan dengan cara melapisi kaca dengan lapisan anti air dan mengusir air hujan (hydropobic), sehingga air hujan tidak menempel pada kaca.', 'B250005.jpg', '0'),
('B250006', 'B', 'Water Repellent Pro', 44, 250, 65000, 'Berfungsi untuk meningkatkan visibilitas pengemudi saat berkendara dalam kondisi hujan dengan cara melapisi kaca dengan lapisan anti air dan mengusir air hujan (hydropobic), sehingga air hujan tidak menempel pada kaca. Produk ini berfungsi sama dengan yang Water Based, hanya saja tipe PRO menggunakan Solvent Based sehingga durability / lebih awet dan lebih hydropobic.', 'B250006.jpg', '0'),
('B250007', 'B', 'Pure Silane', 44, 250, 115000, 'Merupakan produk paint sealant berbahan dasar solvent ceramic coating yang berfungsi sama dengan BEST SILANE GUARD PRO ataupun NEW FORMULA. Bahan dasar yang digunakan menggunakan bahan dasar nano ceramic coating (SiO).', 'B250007.jpg', '0'),
('B250008', 'B', 'Nano Ceramic Coating', 50, 250, 350000, 'Dibuat khusus untuk memberi anda produk terbaik pelapis keramik terbaik dengan teknologi 3D MATRIX COATING. Produk ini dapat digunakan pada body mobil, kaca mobil, body motor, vinyl, plastik.', 'B250008.jpg', '0'),
('B250009', 'B', 'Best Exterior Dressing', 30, 250, 55000, 'Produk yg bertujuan utk melindungi plastik trim, ban dan karet pada bagian luar kendaraan anda dari kerusakan yg diakibatkan oleh kotoran, jamur, sinar UV, gesekan dan kontaminan lainnya.', 'B250009.jpg', '0'),
('B500001', 'B', 'Best Interior Detailing', 43, 500, 60000, 'BEST INTERIOR DETAILING merupakan cara termudah untuk membersihkan, melindungi, dan memperindah vinyl, karet, dan plastik. Mengembalikan kilap permukaan interior mobil sehingga nampak baru kembali dan segar dengan aroma LEMON. Produk ini dapat juga dipakai untuk daily detailing pada ruang mesin mobil anda.', 'B500001.jpg', '0'),
('B500002', 'B', 'Silane Guard', 28, 500, 125000, 'Produk ini wajib diaplikasikan menggunakan Microfiber Cloth. BEST SILANE GUARD ini juga dapat diaplikasikan pada windshield untuk memberikan hydropobic / water beading / water sheeting membuat pandangan lebih jelas waktu kondisi hujan dan wiper tidak perlu bekerja keras.', 'B500002.jpg', '0'),
('B500003', 'B', 'Silane Guard Pro', 24, 500, 165000, 'Merupakan produk paint sealant berbahan polymer yang berfungsi sama dengan BEST SILANE GUARD NEW FORMULA water based tetapi, BEST SILANE GUARD PRO merupakan produk yang solvent based. Hasil yang akan didapatkan adalah proteksi yang lebih tebal, hydropobic dan slick yang lebih kuat dan awet, wet look, glossy, swirlmark yang akan tertutup dengan jauh lebih baik, baik pada waktu siang maupun malam hari.', 'B500003.jpg', '0'),
('B500004', 'B', 'Water Repellent', 31, 500, 75000, 'Berfungsi untuk meningkatkan visibilitas pengemudi saat berkendara dalam kondisi hujan dengan cara melapisi kaca dengan lapisan anti air dan mengusir air hujan (hydropobic), sehingga air hujan tidak menempel pada kaca.', 'B500004.jpg', '0'),
('B500005', 'B', 'Best Exterior Dressing', 30, 500, 95000, 'Produk yg bertujuan utk melindungi plastik trim, ban dan karet pada bagian luar kendaraan anda dari kerusakan yg diakibatkan oleh kotoran, jamur, sinar UV, gesekan dan kontaminan lainnya.', 'B500005.jpg', '0'),
('C100001', 'C', 'Back to Black', 43, 100, 50000, 'Back to Black merupakan obat yang berfungsi untuk mengembalikan warna plastik trim hitam kendaraan anda yang telah rusak karena oksidasi, kotoran, sisa wax, dsb yang berwarna kusam sehingga menjadi hitam kembali.', 'C100001.jpg', '0'),
('C100002', 'C', 'Best Black Trim', 43, 100, 65000, 'BEST BLACK TRIM RESTORER merupakan obat yang berfungsi untuk mengembalikan warna plastik trim hitam kendaraan anda yang telah rusak karena oksidasi, kotoran, sisa wax, dsb yang berwarna kusam sehingga menjadi hitam kembali.', 'C100002.jpg', '0'),
('C250001', 'C', 'Glass Guard Pro', 37, 250, 55000, 'Produk ini berfungsi untuk meningkatkan visibilitas pengemudi saat berkendara dalam kondisi hujan dengan cara melapisi kaca dengan lapisan anti air dan mengusir air hujan (hydropobic), sehingga air hujan tidak menempel pada kaca.', 'C250001.jpg', '0'),
('C250002', 'C', 'Exxo Coat', 32, 250, 95000, 'Produk ini berfungsi untuk melindungi bagian exterior dari kendaraan anda (All Surface). EXXO memiliki daya tahan yang sangat baik hingga 3-6 bulan dalam sekali aplikasi pemakaian.', 'C250002.jpg', '0'),
('C250003', 'C', 'Eraser IPA Wipe Down', 32, 250, 30000, 'Produk ini berfungsi untuk membersihkan sisa minyak, compound atau wax sebelum proses pelapisan coating sehingga cairan coating bisa merekat dan terbentuk dengan sempurna.', 'C250003.jpg', '0'),
('C250004', 'C', 'All Purpose Cleaner', 40, 250, 30000, 'ALL PURPOSE CLEANER merupakan produk pembersih serbaguna yang aman untuk membersihkan semua bagian interior mobil anda (dashboard, jok kulit, vinly, plafon mobil, jok bludru / kain, semua bagian plastik dan diimanapun kotoran berada dibagian interior anda atau dengan kata lain ALL INTERIOR SURFACE).', 'C250004.jpg', '0'),
('C500001', 'C', 'High Foam Shampoo', 35, 500, 30000, 'Produk ini merupakan shampoo yang memiliki handungan PH Balance / Netral, sehingga sangat di rekomendasikan untuk mencuci kendaraan yang sudah diberikan lapisan protection (Wax, Sealant maupun Coating).', 'C500001.jpg', '0'),
('D000001', 'D', 'Microfiber Cloth', 64, 0, 14500, 'Sistem kerja microfiber sangat unik dan berbeda dibandingkan dengan kain pembersih biasa, misalnya katun atau handuk. Kain pembersih biasa hanya mendorong dan memindahkan kotoran dan debu dari satu tempat ke tempat lainnya. Sedangkan kain microfiber mengangkat, membersihkan kotoran, debu dan bakteri kedalam serat-serat benang fibernya.', 'D000001.jpg', '0'),
('D000002', 'D', 'Applicator Pad', 65, 0, 7000, 'APPLICATOR PAD merupakan sponge pad yang berstruktur padat dan rapat sehingga sangat baik digunakan dalam hal detailing / perawatan mobil anda.', 'D000002.jpg', '0');

--
-- Triggers `PRODUCT`
--
DELIMITER $$
CREATE TRIGGER `tJumlahKategori` BEFORE INSERT ON `PRODUCT` FOR EACH ROW BEGIN
	declare tempJumlahProduk int;

	select if(TOTAL_PRODUCT = 0, 1, TOTAL_PRODUCT+1) into tempJumlahProduk
	from CATEGORY
	where ID_CATEGORY = NEW.ID_CATEGORY
	group by ID_CATEGORY;

	update CATEGORY
	set TOTAL_PRODUCT = tempJumlahProduk
	where ID_CATEGORY = NEW.ID_CATEGORY;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tTotalProduct_deleteProduct` AFTER DELETE ON `PRODUCT` FOR EACH ROW BEGIN
	declare tempJumlahProduk int;

	select if(TOTAL_PRODUCT = 0, 1, TOTAL_PRODUCT-1) into tempJumlahProduk
	from CATEGORY
	where ID_CATEGORY = OLD.ID_CATEGORY
	group by ID_CATEGORY;

	update CATEGORY
	set TOTAL_PRODUCT = tempJumlahProduk
	where ID_CATEGORY = OLD.ID_CATEGORY;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_all_all`
-- (See below for the actual view)
--
CREATE TABLE `product_all_all` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_all_seven`
-- (See below for the actual view)
--
CREATE TABLE `product_all_seven` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_all_thirty`
-- (See below for the actual view)
--
CREATE TABLE `product_all_thirty` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_shopee_all`
-- (See below for the actual view)
--
CREATE TABLE `product_shopee_all` (
`PLATFORM` varchar(9)
,`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_shopee_seven`
-- (See below for the actual view)
--
CREATE TABLE `product_shopee_seven` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_shopee_thirty`
-- (See below for the actual view)
--
CREATE TABLE `product_shopee_thirty` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_tokopedia_all`
-- (See below for the actual view)
--
CREATE TABLE `product_tokopedia_all` (
`PLATFORM` varchar(9)
,`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_tokopedia_seven`
-- (See below for the actual view)
--
CREATE TABLE `product_tokopedia_seven` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_tokopedia_thirty`
-- (See below for the actual view)
--
CREATE TABLE `product_tokopedia_thirty` (
`SKU` varchar(7)
,`IMAGE` varchar(100)
,`CATEGORY` varchar(1)
,`PRODUCT_NAME` varchar(50)
,`SIZE` int
,`TOTAL_SOLD` decimal(32,0)
,`PRICE` varchar(48)
,`INCOME` varchar(91)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `report_all`
-- (See below for the actual view)
--
CREATE TABLE `report_all` (
`MONTH` int
,`NET_PROFIT` varchar(78)
,`OPERATIONAL_FEE` varchar(78)
);

-- --------------------------------------------------------

--
-- Table structure for table `TRANSACTION`
--

CREATE TABLE `TRANSACTION` (
  `ID_TRANSACTION` varchar(9) NOT NULL,
  `ID_ADMIN` varchar(4) NOT NULL,
  `DATE_TRANSACTION` date DEFAULT NULL,
  `PLATFORM` varchar(9) DEFAULT NULL,
  `TOTAL_QTY` int DEFAULT NULL,
  `TOTAL_PRICE` int DEFAULT NULL,
  `TOTAL_FEE` int DEFAULT NULL,
  `NET_PRICE` int DEFAULT '0',
  `STATUS_DELETE` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `TRANSACTION`
--

INSERT INTO `TRANSACTION` (`ID_TRANSACTION`, `ID_ADMIN`, `DATE_TRANSACTION`, `PLATFORM`, `TOTAL_QTY`, `TOTAL_PRICE`, `TOTAL_FEE`, `NET_PRICE`, `STATUS_DELETE`) VALUES
('S20220401', 'A001', '2022-04-01', 'shopee', 17, 1195000, 59750, 1135250, '0'),
('S20220402', 'A001', '2022-04-02', 'shopee', 9, 625000, 31250, 593750, '0'),
('S20220403', 'A001', '2022-04-03', 'shopee', 23, 1405000, 70250, 1334750, '0'),
('S20220404', 'A001', '2022-04-04', 'shopee', 19, 1080000, 54000, 1026000, '0'),
('S20220405', 'A001', '2022-04-05', 'shopee', 1, 35000, 1750, 33250, '0'),
('S20220406', 'A001', '2022-04-06', 'shopee', 17, 790000, 39500, 750500, '0'),
('S20220407', 'A001', '2022-04-07', 'shopee', 13, 640000, 32000, 608000, '0'),
('S20220408', 'A001', '2022-04-08', 'shopee', 2, 80000, 4000, 76000, '0'),
('S20220409', 'A001', '2022-04-09', 'shopee', 6, 225000, 11250, 213750, '0'),
('S20220410', 'A001', '2022-04-10', 'shopee', 6, 320000, 16000, 304000, '0'),
('S20220411', 'A001', '2022-04-11', 'shopee', 14, 855000, 42750, 812250, '0'),
('S20220412', 'A001', '2022-04-12', 'shopee', 12, 2490000, 124500, 2365500, '0'),
('S20220413', 'A001', '2022-04-13', 'shopee', 23, 1615000, 80750, 1534250, '0'),
('S20220531', 'A002', '2022-05-31', 'shopee', 1, 60000, 3000, 57000, '0'),
('S20220602', 'A001', '2022-06-02', 'Shopee', 9, 235000, 5000, 230000, '0'),
('S20220606', 'A001', '2022-06-06', 'Shopee', 1, 50000, 1500, 48500, '0'),
('S20220607', 'A002', '2022-06-07', 'Shopee', 14, 100000, 2500, 97500, '0'),
('S20220608', 'A001', '2022-06-08', 'Shopee', 1, 30000, 1000, 29000, '0'),
('S20220609', 'A001', '2022-06-09', 'Shopee', 1, 75000, 3750, 71250, '0'),
('S20220610', 'A002', '2022-06-10', 'Shopee', 5, 235000, 3000, 232000, '0'),
('S20220611', 'A001', '2022-06-11', 'Shopee', 1, 50000, 1500, 48500, '0'),
('S20220612', 'A001', '2022-06-12', 'Shopee', 6, 300000, 5000, 295000, '0'),
('S20220613', 'A001', '2022-06-13', 'Shopee', 1, 50000, 2500, 47500, '0'),
('S20220614', 'A001', '2022-06-14', 'Shopee', 2, 60000, 3000, 57000, '0'),
('S20220615', 'A001', '2022-06-15', 'Shopee', 2, 70000, 2500, 67500, '0'),
('S20220616', 'A001', '2022-06-16', 'Shopee', 2, 80000, 2500, 77500, '0'),
('T20220401', 'A001', '2022-04-01', 'tokopedia', 19, 830000, 41500, 788500, '0'),
('T20220402', 'A001', '2022-04-02', 'tokopedia', 2, 70000, 3500, 66500, '0'),
('T20220403', 'A001', '2022-04-03', 'tokopedia', 1, 45000, 2250, 42750, '0'),
('T20220404', 'A001', '2022-04-04', 'tokopedia', 1, 35000, 1750, 33250, '0'),
('T20220405', 'A001', '2022-04-05', 'tokopedia', 8, 590000, 29500, 560500, '0'),
('T20220406', 'A001', '2022-04-06', 'tokopedia', 21, 850000, 42500, 807500, '0'),
('T20220407', 'A001', '2022-04-07', 'tokopedia', 26, 1890000, 94500, 1795500, '0'),
('T20220408', 'A001', '2022-04-08', 'tokopedia', 25, 3345000, 167250, 3177750, '0'),
('T20220409', 'A001', '2022-04-09', 'tokopedia', 8, 330000, 16500, 313500, '0'),
('T20220410', 'A001', '2022-04-10', 'tokopedia', 16, 1165000, 58250, 1106750, '0'),
('T20220411', 'A001', '2022-04-11', 'tokopedia', 17, 510000, 25500, 484500, '0'),
('T20220412', 'A001', '2022-04-12', 'tokopedia', 27, 2005000, 100250, 1904750, '0'),
('T20220413', 'A001', '2022-04-13', 'tokopedia', 14, 1255000, 62750, 1192250, '0'),
('T20220513', 'A001', '2022-05-13', 'Tokopedia', 7, 150000, 2500, 147500, '0'),
('T20220531', 'A001', '2022-05-31', 'Tokopedia', 12, 185000, 2500, 182500, '0'),
('T20220602', 'A001', '2022-06-02', 'Tokopedia', 6, 600000, 30000, 570000, '0'),
('T20220606', 'A001', '2022-06-06', 'Tokopedia', 1, 30000, 1500, 28500, '0'),
('T20220607', 'A001', '2022-06-07', 'Tokopedia', 4, 250000, 12500, 237500, '0'),
('T20220608', 'A001', '2022-06-08', 'Tokopedia', 2, 40000, 1000, 39000, '0'),
('T20220609', 'A001', '2022-06-09', 'Tokopedia', 4, 350000, 17500, 332500, '0'),
('T20220610', 'A002', '2022-06-10', 'Tokopedia', 10, 450000, 5000, 445000, '0'),
('T20220611', 'A001', '2022-06-11', 'Tokopedia', 2, 50000, 2500, 47500, '0'),
('T20220612', 'A001', '2022-06-12', 'Tokopedia', 9, 900000, 45000, 855000, '0'),
('T20220613', 'A001', '2022-06-13', 'Tokopedia', 10, 500000, 2500, 497500, '0'),
('T20220614', 'A001', '2022-06-14', 'Tokopedia', 1, 50000, 1500, 48500, '0'),
('T20220615', 'A001', '2022-06-15', 'Tokopedia', 1, 50000, 2500, 47500, '0'),
('T20220616', 'A001', '2022-06-16', 'Tokopedia', 1, 40000, 1000, 39000, '0');

-- --------------------------------------------------------

--
-- Structure for view `finance_all_all`
--
DROP TABLE IF EXISTS `finance_all_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_all_all`  AS  select 'All' AS `PLATFORM`,monthname(`TRANSACTION`.`DATE_TRANSACTION`) AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` group by monthname(`TRANSACTION`.`DATE_TRANSACTION`) ;

-- --------------------------------------------------------

--
-- Structure for view `finance_all_seven`
--
DROP TABLE IF EXISTS `finance_all_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_all_seven`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 8 day) as date)) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_all_thirty`
--
DROP TABLE IF EXISTS `finance_all_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_all_thirty`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date)) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_shopee_all`
--
DROP TABLE IF EXISTS `finance_shopee_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_shopee_all`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,monthname(`TRANSACTION`.`DATE_TRANSACTION`) AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where (`TRANSACTION`.`PLATFORM` = 'Shopee') group by monthname(`TRANSACTION`.`DATE_TRANSACTION`),`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_shopee_seven`
--
DROP TABLE IF EXISTS `finance_shopee_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_shopee_seven`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where ((`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 8 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Shopee')) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_shopee_thirty`
--
DROP TABLE IF EXISTS `finance_shopee_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_shopee_thirty`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where ((`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Shopee')) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_tokopedia_all`
--
DROP TABLE IF EXISTS `finance_tokopedia_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_tokopedia_all`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,monthname(`TRANSACTION`.`DATE_TRANSACTION`) AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where (`TRANSACTION`.`PLATFORM` = 'Tokopedia') group by monthname(`TRANSACTION`.`DATE_TRANSACTION`),`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_tokopedia_seven`
--
DROP TABLE IF EXISTS `finance_tokopedia_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_tokopedia_seven`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where ((`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 8 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Tokopedia')) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `finance_tokopedia_thirty`
--
DROP TABLE IF EXISTS `finance_tokopedia_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `finance_tokopedia_thirty`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`TRANSACTION`.`DATE_TRANSACTION` AS `DATE_TRANSACTION`,sum(`TRANSACTION`.`TOTAL_PRICE`) AS `INT_NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` where ((`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Tokopedia')) group by `TRANSACTION`.`DATE_TRANSACTION`,`TRANSACTION`.`PLATFORM` ;

-- --------------------------------------------------------

--
-- Structure for view `product_all_all`
--
DROP TABLE IF EXISTS `product_all_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_all_all`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from (`PRODUCT` join `DETAIL_TRANSACTION`) where (`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_all_seven`
--
DROP TABLE IF EXISTS `product_all_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_all_seven`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 7 day) as date))) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_all_thirty`
--
DROP TABLE IF EXISTS `product_all_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_all_thirty`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date))) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_shopee_all`
--
DROP TABLE IF EXISTS `product_shopee_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_shopee_all`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`DETAIL_TRANSACTION`.`ID_TRANSACTION` = `TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`PLATFORM` = 'shopee')) group by `PRODUCT`.`SKU`,`TRANSACTION`.`PLATFORM` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_shopee_seven`
--
DROP TABLE IF EXISTS `product_shopee_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_shopee_seven`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 7 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Shopee')) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_shopee_thirty`
--
DROP TABLE IF EXISTS `product_shopee_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_shopee_thirty`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Shopee')) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_tokopedia_all`
--
DROP TABLE IF EXISTS `product_tokopedia_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_tokopedia_all`  AS  select `TRANSACTION`.`PLATFORM` AS `PLATFORM`,`PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`DETAIL_TRANSACTION`.`ID_TRANSACTION` = `TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`PLATFORM` = 'tokopedia')) group by `PRODUCT`.`SKU`,`TRANSACTION`.`PLATFORM` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_tokopedia_seven`
--
DROP TABLE IF EXISTS `product_tokopedia_seven`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_tokopedia_seven`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 7 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Tokopedia')) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `product_tokopedia_thirty`
--
DROP TABLE IF EXISTS `product_tokopedia_thirty`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `product_tokopedia_thirty`  AS  select `PRODUCT`.`SKU` AS `SKU`,`PRODUCT`.`IMAGE` AS `IMAGE`,`PRODUCT`.`ID_CATEGORY` AS `CATEGORY`,`PRODUCT`.`P_NAME` AS `PRODUCT_NAME`,`PRODUCT`.`SIZE` AS `SIZE`,sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`) AS `TOTAL_SOLD`,concat('Rp',format(`PRODUCT`.`PRICE`,2)) AS `PRICE`,concat('Rp',format((`PRODUCT`.`PRICE` * sum(`DETAIL_TRANSACTION`.`QTY_PRODUCT`)),2)) AS `INCOME` from ((`PRODUCT` join `DETAIL_TRANSACTION`) join `TRANSACTION`) where ((`DETAIL_TRANSACTION`.`SKU` = `PRODUCT`.`SKU`) and (`TRANSACTION`.`ID_TRANSACTION` = `DETAIL_TRANSACTION`.`ID_TRANSACTION`) and (`TRANSACTION`.`DATE_TRANSACTION` >= cast((now() - interval 30 day) as date)) and (`TRANSACTION`.`PLATFORM` = 'Tokopedia')) group by `PRODUCT`.`SKU` order by `TOTAL_SOLD` desc ;

-- --------------------------------------------------------

--
-- Structure for view `report_all`
--
DROP TABLE IF EXISTS `report_all`;

CREATE ALGORITHM=UNDEFINED DEFINER=`student`@`%` SQL SECURITY DEFINER VIEW `report_all`  AS  select month(`TRANSACTION`.`DATE_TRANSACTION`) AS `MONTH`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_PRICE`),2)) AS `NET_PROFIT`,concat('Rp',format(sum(`TRANSACTION`.`TOTAL_FEE`),2)) AS `OPERATIONAL_FEE` from `TRANSACTION` group by month(`TRANSACTION`.`DATE_TRANSACTION`) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ADMIN`
--
ALTER TABLE `ADMIN`
  ADD PRIMARY KEY (`ID_ADMIN`);

--
-- Indexes for table `CATEGORY`
--
ALTER TABLE `CATEGORY`
  ADD PRIMARY KEY (`ID_CATEGORY`);

--
-- Indexes for table `DETAIL_TRANSACTION`
--
ALTER TABLE `DETAIL_TRANSACTION`
  ADD PRIMARY KEY (`SKU`,`ID_TRANSACTION`),
  ADD KEY `FK_PRODUCE2` (`ID_TRANSACTION`);

--
-- Indexes for table `PRODUCT`
--
ALTER TABLE `PRODUCT`
  ADD PRIMARY KEY (`SKU`),
  ADD KEY `FK_HAS` (`ID_CATEGORY`);

--
-- Indexes for table `TRANSACTION`
--
ALTER TABLE `TRANSACTION`
  ADD PRIMARY KEY (`ID_TRANSACTION`),
  ADD KEY `FK_INPUTS` (`ID_ADMIN`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `DETAIL_TRANSACTION`
--
ALTER TABLE `DETAIL_TRANSACTION`
  ADD CONSTRAINT `FK_PRODUCE` FOREIGN KEY (`SKU`) REFERENCES `PRODUCT` (`SKU`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_PRODUCE2` FOREIGN KEY (`ID_TRANSACTION`) REFERENCES `TRANSACTION` (`ID_TRANSACTION`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `PRODUCT`
--
ALTER TABLE `PRODUCT`
  ADD CONSTRAINT `FK_HAS` FOREIGN KEY (`ID_CATEGORY`) REFERENCES `CATEGORY` (`ID_CATEGORY`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `TRANSACTION`
--
ALTER TABLE `TRANSACTION`
  ADD CONSTRAINT `FK_INPUTS` FOREIGN KEY (`ID_ADMIN`) REFERENCES `ADMIN` (`ID_ADMIN`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
