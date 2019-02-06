CREATE DATABASE  IF NOT EXISTS `users` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `users`;
-- MySQL dump 10.13  Distrib 5.7.22, for Win64 (x86_64)
--
-- Host: localhost    Database: users
-- ------------------------------------------------------
-- Server version	5.7.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `fitness_exercises`
--

DROP TABLE IF EXISTS `fitness_exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_exercises` (
  `id_fitness_exercises` int(11) NOT NULL AUTO_INCREMENT,
  `execiseName` varchar(100) NOT NULL,
  `repeats` int(11) NOT NULL,
  `sets` int(11) NOT NULL,
  `howToVideo` varchar(500) NOT NULL,
  PRIMARY KEY (`id_fitness_exercises`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_exercises`
--

LOCK TABLES `fitness_exercises` WRITE;
/*!40000 ALTER TABLE `fitness_exercises` DISABLE KEYS */;
INSERT INTO `fitness_exercises` VALUES (1,'Leg Press',10,3,'qxRlIA0JU2A'),(3,'Lying Leg Curls',12,3,'dBo-Pw2a2h8'),(4,'Wide-Grip Lat Pulldown',8,3,'lueEJGjTuPQ'),(5,'Butterfly',10,2,'oGxc2ph8Fnw'),(6,'Triceps pulldown',10,3,'q25J5FYxcYU'),(7,'Machine Biceps Curl',8,3,'uO_CNYidOw0'),(8,'Machine shoulder Press',12,2,'qEwKCR5JCog'),(9,'Ab Crunch Machine',10,3,'KNgfBz_u9LU');
/*!40000 ALTER TABLE `fitness_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_exercises_in_plan`
--

DROP TABLE IF EXISTS `fitness_exercises_in_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_exercises_in_plan` (
  `id_fitness_exercises` int(11) NOT NULL,
  `id_fitness_plan` int(11) NOT NULL,
  KEY `fk_fitness_plan_id_idx` (`id_fitness_plan`),
  KEY `id_fitness_exercises_fk_idx` (`id_fitness_exercises`),
  CONSTRAINT `id_fitness_exercises_fk` FOREIGN KEY (`id_fitness_exercises`) REFERENCES `fitness_exercises` (`id_fitness_exercises`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_fitness_plan_fk2` FOREIGN KEY (`id_fitness_plan`) REFERENCES `fitness_plan` (`id_fitness_plan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_exercises_in_plan`
--

LOCK TABLES `fitness_exercises_in_plan` WRITE;
/*!40000 ALTER TABLE `fitness_exercises_in_plan` DISABLE KEYS */;
INSERT INTO `fitness_exercises_in_plan` VALUES (1,1),(6,1),(9,1),(3,2),(4,2),(5,2),(7,3),(8,3),(9,3);
/*!40000 ALTER TABLE `fitness_exercises_in_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_plan`
--

DROP TABLE IF EXISTS `fitness_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_plan` (
  `id_fitness_plan` int(11) NOT NULL AUTO_INCREMENT,
  `FitnessPlanName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_fitness_plan`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_plan`
--

LOCK TABLES `fitness_plan` WRITE;
/*!40000 ALTER TABLE `fitness_plan` DISABLE KEYS */;
INSERT INTO `fitness_plan` VALUES (1,'Legs'),(2,'Back'),(3,'Biceps');
/*!40000 ALTER TABLE `fitness_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_relationship`
--

DROP TABLE IF EXISTS `friend_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friend_relationship` (
  `id_friend_relationship` int(11) NOT NULL AUTO_INCREMENT,
  `requestByUser` int(11) NOT NULL,
  `relatedUser` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_friend_relationship`),
  KEY `requestByUser_idx` (`requestByUser`),
  KEY `relatedUser_fk_idx` (`relatedUser`),
  CONSTRAINT `relatedUser_fk` FOREIGN KEY (`relatedUser`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `requestByUser_fk` FOREIGN KEY (`requestByUser`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_relationship`
--

LOCK TABLES `friend_relationship` WRITE;
/*!40000 ALTER TABLE `friend_relationship` DISABLE KEYS */;
INSERT INTO `friend_relationship` VALUES (1,12,3,1),(2,12,4,1),(3,11,7,1),(4,4,7,1),(5,10,6,1);
/*!40000 ALTER TABLE `friend_relationship` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `users`.`friend_relationship_BEFORE_INSERT` BEFORE INSERT ON `friend_relationship` FOR EACH ROW
BEGIN
	IF (EXISTS(SELECT 1 FROM friend_relationship WHERE new.requestByUser = relatedUser and new.relatedUser = requestByUser and status = 0)) THEN
		SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Requested user has already sent an invite';
	ELSEIF (EXISTS(SELECT 1 FROM friend_relationship WHERE new.requestByUser = requestByUser and new.relatedUser = relatedUser and status = 0)) THEN
		SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Request already exist';
	ELSEIF (EXISTS(SELECT 1 FROM friend_relationship WHERE new.requestByUser = requestByUser and new.relatedUser = relatedUser and status = 1)) THEN
		SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Users already friends';
	ELSEIF (EXISTS(SELECT 1 FROM friend_relationship WHERE new.requestByUser = relatedUser and new.relatedUser = requestByUser and status = 1)) THEN
		SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'Users already friends';
	ELSEIF (new.requestByUser = new.relatedUser) THEN
		SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'same user as requester and related';
    END IF; 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `users`.`friend_relationship_AFTER_INSERT` AFTER INSERT ON `friend_relationship` FOR EACH ROW
BEGIN
	DELETE FROM users.users_suggested_matches
	WHERE (new.requestByUser = users_suggested_matches.id_users_1 and new.relatedUser = users_suggested_matches.id_users_2)
    or
    (new.requestByUser = users_suggested_matches.id_users_2 and new.relatedUser = users_suggested_matches.id_users_1);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `running`
--

DROP TABLE IF EXISTS `running`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `running` (
  `id_running` int(11) NOT NULL AUTO_INCREMENT,
  `distance` double NOT NULL,
  `startTime` int(11) NOT NULL,
  `duration` double NOT NULL,
  `routeLat` longtext NOT NULL,
  `routeLong` longtext NOT NULL,
  `routeTime` longtext NOT NULL,
  PRIMARY KEY (`id_running`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `running`
--

LOCK TABLES `running` WRITE;
/*!40000 ALTER TABLE `running` DISABLE KEYS */;
/*!40000 ALTER TABLE `running` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_activity` (
  `id_users` int(11) NOT NULL,
  `id_running` int(11) DEFAULT NULL,
  `id_fitness_plan` int(11) DEFAULT NULL,
  KEY `fk_fitness_id_idx` (`id_fitness_plan`),
  KEY `id_users_fk_idx` (`id_users`),
  KEY `id_running_fk_idx` (`id_running`),
  CONSTRAINT `id_fitness_plan_fk` FOREIGN KEY (`id_fitness_plan`) REFERENCES `fitness_plan` (`id_fitness_plan`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_running_fk` FOREIGN KEY (`id_running`) REFERENCES `running` (`id_running`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_users_fk` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

LOCK TABLES `user_activity` WRITE;
/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id_users` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `gender` varchar(45) NOT NULL,
  `age` int(11) NOT NULL,
  `mobile` int(11) NOT NULL,
  `primarySports` varchar(50) NOT NULL,
  `profileImgPath` varchar(200) NOT NULL,
  `timeSpendPerWeek` int(11) NOT NULL,
  `sportLevel` int(11) NOT NULL,
  `locationLong` float NOT NULL,
  `locationLat` float NOT NULL,
  PRIMARY KEY (`id_users`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (3,'testuser1@test.dk','$2a$10$KZC6l9ytzuXnZJJsw.y23OqAue4F1U/8Xb93Vbi1FAQLTV7CnWq5G','Steffen Thomsen','Male',22,26357820,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',10,5,9.0395,56.5472),(4,'testuser2@test.dk','$2a$10$omhnPWtG7Urb47PLXw8CyOy6R0z/H.eOekJHKsBbcr8zvwDzfi65i','Poul Madsen','Male',55,42675841,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',9,6,9.1225,56.546),(5,'testuser3@test.dk','$2a$10$IHjzeCLylG/F2QV7FIiwK./AnPEvDoZ7aAUgJFtG06lxhdde9ZpoW','Ib Toft','Male',45,25454965,'Fitness','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',10,8,9.33402,56.5103),(6,'testuser4@test.dk','$2a$10$Z8MAjAWYZd970nvZNfsiZOhHLUjxpDl2KRDntiowfziS7dHM0jciC','Sara Justesen','Female',50,65654154,'Fitness','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',7,7,9.3426,56.5049),(7,'testuser5@test.dk','$2a$10$lIA2OOeteiBDE2hes01h2.wpPBS88OZjZilw2a2ehWwvCqy.x.fQm','Simon Flintholm','Male',25,54548542,'Fitness','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',3,2,9.39935,56.4579),(8,'testuser6@test.dk','$2a$10$w0V.gEEz/SyscEUDVkP7BeVqzNLX46Gp8860LkUOG0Qyb8blfYCSa','Maya Kjær','Female',39,55454654,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',5,3,9.39798,56.4427),(9,'testuser7@test.dk','$2a$10$OQymC2aUFZNMAm8MK89Hy.LOHjRWpiylgPgyY0srgb80yivvQvpty','Julie Pedersen','Female',21,54469455,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',6,4,9.37601,56.4412),(10,'testuser8@test.dk','$2a$10$qehl1jF4znihs23sIQI0Iey0.8Ow7HGLFeuK1q0nr5HpuCLsGKRwu','Kristina Strøm','Female',25,54545451,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',5,4,9.41515,56.4499),(11,'testuser9@test.dk','$2a$10$jU48RY/mRq7kA9hJgJVIyuHmmmMIYZ0Dohc8U03kRq4BCviXx6PR2','Mathias Laursen','Male',33,45451657,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',6,5,9.44398,56.4526),(12,'testuser10@test.dk','$2a$10$MRqYy1Gzg.xUjRl6R.wuWu17sqKG8gCpUK84ju9k53rHOC9YCr/4q','Vivi Jensen','Female',63,24647913,'Running','http://192.168.153.140/profilePictures/standartProfilePicture.jpg',5,4,9.39873,56.4365);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `users`.`users_AFTER_INSERT` AFTER INSERT ON `users` FOR EACH ROW
BEGIN
INSERT INTO users.users_suggested_matches (id_users_1, id_users_2, differentInTime, differentInLevel, distance) 
SELECT 	NEW.id_users as id_users_1,
		userTable.id_users as id_users_2, 
		CONCAT(ABS(NEW.timeSpendPerWeek - userTable.timeSpendPerWeek), " hour") AS differentInTime,
        CONCAT(ABS(NEW.sportLevel - userTable.sportLevel), " levels") AS differentInLevel,
        ST_Distance_Sphere(point(userTable.locationLong, userTable.locationLat), point(NEW.locationLong, NEW.locationLat)) AS distance
        
FROM 	users.users AS userTable

where 	userTable.timeSpendPerWeek > NEW.timeSpendPerWeek * 0.6 and 
		userTable.timeSpendPerWeek < NEW.timeSpendPerWeek * 1.4 and 
        LOWER(userTable.primarySports) = LOWER(NEW.primarySports) and
        userTable.sportLevel > NEW.sportLevel * 0.6 and 
		userTable.sportLevel < NEW.sportLevel * 1.4 and 
        ST_Distance_Sphere(point(userTable.locationLong, userTable.locationLat), point(NEW.locationLong, NEW.locationLat)) < 20000 and
        userTable.id_users <> NEW.id_users;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users_suggested_matches`
--

DROP TABLE IF EXISTS `users_suggested_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_suggested_matches` (
  `id_users_1` int(11) NOT NULL,
  `id_users_2` int(11) NOT NULL,
  `differentInTime` varchar(45) NOT NULL,
  `distance` double NOT NULL,
  `differentInLevel` varchar(45) NOT NULL,
  KEY `idusers_1_fk_idx` (`id_users_1`),
  KEY `id_users_2_fk_idx` (`id_users_2`),
  CONSTRAINT `id_users_1_fk` FOREIGN KEY (`id_users_1`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `id_users_2_fk` FOREIGN KEY (`id_users_2`) REFERENCES `users` (`id_users`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_suggested_matches`
--

LOCK TABLES `users_suggested_matches` WRITE;
/*!40000 ALTER TABLE `users_suggested_matches` DISABLE KEYS */;
INSERT INTO `users_suggested_matches` VALUES (4,3,'1 hour',5089.219438035263,'1 levels'),(9,8,'1 hour',1361.089184151921,'1 levels'),(10,8,'0 hour',1325.0544539056996,'1 levels'),(10,9,'1 hour',2593.8916073166884,'0 levels'),(11,9,'0 hour',4365.339464703175,'1 levels'),(11,10,'1 hour',1796.6231014776968,'1 levels'),(12,8,'0 hour',696.7387885881482,'1 levels'),(12,9,'1 hour',1492.558417741175,'0 levels'),(12,10,'0 hour',1805.3041786033825,'0 levels'),(12,11,'1 hour',3308.959181973319,'1 levels');
/*!40000 ALTER TABLE `users_suggested_matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'users'
--

--
-- Dumping routines for database 'users'
--
/*!50003 DROP FUNCTION IF EXISTS `CalculateTimeDifferent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateTimeDifferent`(user1Time int, user2Time int) RETURNS int(11)
BEGIN
RETURN ABS(user1Time - user2Time);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Match_Script` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Match_Script`(IN `user_ID` int)
BEGIN
SET @USERTIMESPENDWEEK  = (SELECT timeSpendPerWeek FROM users WHERE users.id = user_ID);

SELECT 	user_ID as currentUserid,
		userTable.id, 
		userTable.email, 
		CONCAT(CalculateTimeDifferent(@USERTIMESPENDWEEK, userTable.timeSpendPerWeek), " hour") AS DifferentInTime 
        
FROM 	users.users AS userTable

where 	userTable.timeSpendPerWeek > @USERTIMESPENDWEEK * 0.6 and 
		userTable.timeSpendPerWeek < @USERTIMESPENDWEEK * 1.4 and 
        userTable.id <> user_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Truncate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Truncate`()
BEGIN
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE users.users;
TRUNCATE users.users_suggested_matches;
TRUNCATE users.running;
TRUNCATE users.user_activity;
TRUNCATE users.fitness_exercises;
TRUNCATE users.fitness_exercises_in_plan;
TRUNCATE users.fitness_plan;
TRUNCATE users.friend_relationship;

SET FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-02-06 20:43:47
