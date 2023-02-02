-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 02, 2023 at 03:25 PM
-- Server version: 8.0.21
-- PHP Version: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `chatapp`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `backup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `backup` ()  BEGIN
select user_pic,name,user_id from users where user_id=(select distinct(receiver_id) from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id);
SELECT msg_content from users_messages where (sender_id = (select distinct(receiver_id) from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id) and receiver_id= id) or (sender_id=id and receiver_id=(select distinct(receiver_id) from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id)) Order by msg_createddate desc limit 1;
END$$

DROP PROCEDURE IF EXISTS `getSingleUserChat`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSingleUserChat` (IN `id` INT, IN `othermsgid` INT)  BEGIN
select * from users_messages where (receiver_id=othermsgid and sender_id=id) or (receiver_id=id and sender_id=othermsgid);
select * from users where user_id=id;
select distinct(receiver_id) from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id;
END$$

DROP PROCEDURE IF EXISTS `get_usersdata`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_usersdata` (IN `id` INT)  BEGIN
select user_pic,name,user_id from users where user_id=(select distinct(receiver_id) from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id);
select receiver_id,msg_content from users_messages where (receiver_id=id or sender_id=id) and receiver_id!=id GROUP by receiver_id Order by msg_createddate DESC;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `getUsers_go`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getUsers_go` (`emails` VARCHAR(255), `passed` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 BEGIN
   DECLARE val_pass varchar(255);
   DECLARE val varchar(255);
IF 
(select password from users where email = emails) !=''
THEN
SET val_pass= (select password from users where email = emails);
IF
val_pass!=passed
THEN
SET val='pass_err';
ELSE
SET val= (select user_id from users where email = emails);
end IF;
ELSE
SET val='email_err';
END IF;
RETURN val;
 END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` tinyint NOT NULL,
  `user_status` tinyint NOT NULL,
  `user_pic` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `friends` longtext,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `phone`, `password`, `user_type`, `user_status`, `user_pic`, `address`, `friends`) VALUES
(1, 'test', 'test@gmail.com', '9879879879', 'tests', 1, 1, 'default.png', 'test', '[\"3\",\"2\",\"4\"]'),
(2, 'test2', 'test2@gmail.com', '8787687666', 'test', 1, 1, 'man.jpg', 'test', '[\"4\",\"3\",\"1\",\"5\"]'),
(3, 'test3', 'test3@gmail.com', '7987987987', 'test', 1, 1, 'man.jpg', 'sdfs', NULL),
(4, 'test4', 'test4@gmail.com', '7657657655', 'test', 1, 1, 'man.jpg', 'test4', NULL),
(5, 'Ramam', 'Ramam@gmail.com', '9879879788', 'test', 1, 1, 'default.png', 'tetsing', '[\"1\",\"2\"]');

-- --------------------------------------------------------

--
-- Table structure for table `users_messages`
--

DROP TABLE IF EXISTS `users_messages`;
CREATE TABLE IF NOT EXISTS `users_messages` (
  `msg_id` int NOT NULL AUTO_INCREMENT,
  `msg_content` longtext NOT NULL,
  `msg_status` tinyint NOT NULL,
  `receiver_id` int NOT NULL,
  `receiver_status` int NOT NULL,
  `sender_id` int NOT NULL,
  `sender_status` int NOT NULL,
  `user_id` int NOT NULL,
  `msg_createddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `flag_pic` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`msg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users_messages`
--

INSERT INTO `users_messages` (`msg_id`, `msg_content`, `msg_status`, `receiver_id`, `receiver_status`, `sender_id`, `sender_status`, `user_id`, `msg_createddate`, `flag_pic`) VALUES
(1, 'okay', 1, 2, 0, 1, 1, 1, '2022-12-24 03:18:24', 0),
(2, 'okkkk', 1, 1, 0, 2, 1, 2, '2022-12-24 03:18:38', 0),
(3, 'ddd', 1, 1, 0, 2, 1, 2, '2022-12-24 03:18:46', 0),
(4, 'sdfgfsdg', 1, 1, 0, 2, 1, 2, '2022-12-24 03:18:54', 0),
(5, 'dddddddd', 1, 1, 0, 2, 1, 2, '2022-12-24 03:19:11', 0),
(6, 'sdfgsdg', 1, 1, 0, 2, 1, 2, '2022-12-24 03:20:05', 0),
(7, 'i know that man', 1, 1, 0, 2, 1, 2, '2022-12-24 03:21:07', 0),
(8, 'ok', 1, 1, 0, 2, 1, 2, '2022-12-24 03:23:19', 0),
(9, 'okokok', 1, 2, 0, 1, 1, 1, '2022-12-24 03:24:56', 0),
(10, 'okok', 1, 1, 0, 2, 1, 2, '2022-12-24 04:11:43', 0),
(11, 'i know that man thats damn thing', 1, 2, 0, 1, 1, 1, '2022-12-24 04:11:55', 0),
(12, 'okkkk', 1, 2, 0, 1, 1, 1, '2022-12-24 04:15:31', 0),
(13, 'i know', 1, 1, 0, 2, 1, 2, '2022-12-24 04:20:39', 0),
(14, 'kt', 1, 2, 0, 1, 1, 1, '2022-12-24 04:21:11', 0),
(15, 'i nkkk', 1, 1, 0, 2, 1, 2, '2022-12-24 04:24:55', 0),
(16, 'kk', 1, 2, 0, 1, 1, 1, '2022-12-24 04:25:05', 0),
(17, 'sfd', 1, 1, 0, 2, 1, 2, '2022-12-24 04:27:48', 0),
(18, 'yry', 1, 1, 0, 2, 1, 2, '2022-12-24 04:28:12', 0),
(19, 'ff', 1, 1, 0, 2, 1, 2, '2022-12-24 04:35:26', 0),
(20, 'ddf', 1, 2, 0, 1, 1, 1, '2022-12-24 04:37:04', 0),
(21, 'fff', 1, 2, 0, 1, 1, 1, '2022-12-24 04:37:33', 0),
(22, 'fff', 1, 2, 0, 1, 1, 1, '2022-12-24 04:37:58', 0),
(23, 'ffffdsd', 1, 2, 0, 1, 1, 1, '2022-12-24 04:38:30', 0),
(24, 'sdsd', 1, 2, 0, 1, 1, 1, '2022-12-24 04:38:52', 0),
(25, 'dydr', 1, 2, 0, 1, 1, 1, '2022-12-24 04:46:17', 0),
(26, 'sdfgsdf', 1, 2, 0, 1, 1, 1, '2022-12-24 04:47:07', 0),
(27, 'dffds', 1, 2, 0, 1, 1, 1, '2022-12-24 04:47:11', 0),
(28, 'dfdf', 1, 2, 0, 1, 1, 1, '2022-12-24 04:47:29', 0),
(29, 'fddfd', 1, 2, 0, 1, 1, 1, '2022-12-24 04:47:34', 0),
(30, 'fdf', 1, 2, 0, 1, 1, 1, '2022-12-24 04:49:03', 0),
(31, 'dfd', 1, 2, 0, 1, 1, 1, '2022-12-24 04:49:06', 0),
(32, 'k', 1, 2, 0, 1, 1, 1, '2022-12-24 04:55:16', 0),
(33, 'hhh', 1, 2, 0, 1, 1, 1, '2022-12-24 04:55:21', 0),
(34, 'dfdfdf', 1, 2, 0, 1, 1, 1, '2022-12-24 05:00:43', 0),
(35, 'dds', 1, 2, 0, 1, 1, 1, '2022-12-24 05:00:46', 0),
(36, 'ddf', 1, 2, 0, 1, 1, 1, '2022-12-24 05:02:10', 0),
(37, 'fdfdf', 1, 2, 0, 1, 1, 1, '2022-12-24 05:03:59', 0),
(38, 'ff', 1, 2, 0, 1, 1, 1, '2022-12-24 05:12:21', 0),
(39, 'dfdfd', 1, 2, 0, 1, 1, 1, '2022-12-24 05:12:26', 0),
(40, 'fdfdf', 1, 2, 0, 1, 1, 1, '2022-12-24 05:24:31', 0),
(41, 'dsddds', 1, 2, 0, 1, 1, 1, '2022-12-24 05:24:35', 0),
(42, 'sdds', 1, 2, 0, 1, 1, 1, '2022-12-24 05:34:06', 0),
(43, 'sddsd', 1, 2, 0, 1, 1, 1, '2022-12-24 05:34:08', 0),
(44, 'i nknasdf', 1, 1, 0, 2, 1, 2, '2022-12-24 05:34:35', 0),
(45, 'ok', 1, 2, 0, 1, 1, 1, '2022-12-24 05:37:14', 0),
(46, 'ds', 1, 2, 0, 1, 1, 1, '2022-12-24 05:37:50', 0),
(47, 'okok', 1, 1, 0, 2, 1, 2, '2022-12-24 05:53:58', 0),
(48, 'ok', 1, 3, 0, 2, 1, 2, '2022-12-25 01:54:57', 0),
(49, 'i know that', 1, 2, 0, 3, 1, 3, '2022-12-25 01:55:02', 0),
(50, 'kk', 1, 2, 0, 3, 1, 3, '2022-12-25 01:55:35', 0),
(51, 'ddd', 1, 1, 0, 2, 1, 2, '2022-12-27 13:46:32', 0),
(52, 'Yggv', 1, 1, 0, 2, 1, 2, '2022-12-27 13:53:56', 0),
(53, 'Ikkjj', 1, 2, 0, 1, 1, 1, '2022-12-27 13:54:02', 0),
(54, 'Hhgv', 1, 2, 0, 1, 1, 1, '2022-12-27 13:54:11', 0),
(55, 'sdsdds', 1, 3, 0, 2, 1, 2, '2022-12-27 14:03:12', 0),
(56, 'dsds', 1, 3, 0, 2, 1, 2, '2022-12-27 14:03:16', 0),
(57, 'Hello i know', 1, 2, 0, 1, 1, 1, '2022-12-27 14:28:56', 0),
(58, 'I know about that man always a gem ', 1, 2, 0, 1, 1, 1, '2022-12-27 14:29:05', 0),
(59, 'Shshs', 1, 2, 0, 1, 1, 1, '2022-12-27 14:29:11', 0),
(60, 'cccc', 1, 3, 0, 2, 1, 2, '2022-12-29 13:31:24', 0),
(61, 'gggggg', 1, 1, 0, 2, 1, 2, '2022-12-29 13:31:46', 0),
(62, 'hello man', 1, 1, 0, 2, 1, 2, '2022-12-30 16:41:20', 0),
(63, 'testste', 1, 1, 0, 2, 1, 2, '2022-12-30 16:41:52', 0),
(64, 'testse', 1, 1, 0, 2, 1, 2, '2022-12-30 16:43:43', 0),
(65, 'i know ', 1, 1, 0, 2, 1, 2, '2023-01-23 15:19:16', 0),
(66, 'dsds', 1, 1, 0, 2, 1, 2, '2023-01-23 15:19:29', 0),
(67, 'test', 1, 1, 0, 2, 1, 2, '2023-01-23 15:21:59', 0),
(68, 'ddd', 1, 1, 0, 2, 1, 2, '2023-01-23 15:22:28', 0),
(69, 'testse', 1, 1, 0, 2, 1, 2, '2023-01-23 15:26:57', 0),
(70, 'esttset', 1, 1, 0, 2, 1, 2, '2023-01-23 15:27:36', 0),
(71, 'good man', 1, 1, 0, 2, 1, 2, '2023-01-23 15:28:03', 0),
(72, 'Ok man', 1, 4, 0, 1, 1, 1, '2023-01-30 14:16:54', 0);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
