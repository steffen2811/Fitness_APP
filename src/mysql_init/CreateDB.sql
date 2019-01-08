CREATE DATABASE  IF NOT EXISTS `users` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `users`;
-- MySQL dump 10.13  Distrib 5.7.24, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: users
-- ------------------------------------------------------
-- Server version	5.7.24-log

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
  `idfitness_exercises` int(11) NOT NULL,
  `Execise_name` varchar(100) NOT NULL,
  `Repeats` int(11) NOT NULL,
  `Weight_or_level` varchar(10) NOT NULL,
  PRIMARY KEY (`idfitness_exercises`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_exercises`
--

LOCK TABLES `fitness_exercises` WRITE;
/*!40000 ALTER TABLE `fitness_exercises` DISABLE KEYS */;
/*!40000 ALTER TABLE `fitness_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_exercises_in_plan`
--

DROP TABLE IF EXISTS `fitness_exercises_in_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_exercises_in_plan` (
  `fitness_exercise_id` int(11) NOT NULL,
  `fitness_plan_id` int(11) NOT NULL,
  KEY `fk_fitness_exercise_id_idx` (`fitness_exercise_id`),
  KEY `fk_fitness_plan_id_idx` (`fitness_plan_id`),
  CONSTRAINT `fk_fitness_exercise_id` FOREIGN KEY (`fitness_exercise_id`) REFERENCES `fitness_exercises` (`idfitness_exercises`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_fitness_plan_id` FOREIGN KEY (`fitness_plan_id`) REFERENCES `fitness_plan` (`idFitness`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_exercises_in_plan`
--

LOCK TABLES `fitness_exercises_in_plan` WRITE;
/*!40000 ALTER TABLE `fitness_exercises_in_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `fitness_exercises_in_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_plan`
--

DROP TABLE IF EXISTS `fitness_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fitness_plan` (
  `idFitness` int(11) NOT NULL,
  `Fitness_plan_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idFitness`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_plan`
--

LOCK TABLES `fitness_plan` WRITE;
/*!40000 ALTER TABLE `fitness_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `fitness_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `running`
--

DROP TABLE IF EXISTS `running`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `running` (
  `id` int(11) NOT NULL,
  `Route` longtext NOT NULL,
  `Time_secound` int(11) NOT NULL,
  `Start_time` datetime NOT NULL,
  `Distance` int(11) NOT NULL,
  PRIMARY KEY (`id`)
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
  `user_id` int(11) NOT NULL,
  `running_id` int(11) DEFAULT NULL,
  `fitness_id` int(11) DEFAULT NULL,
  KEY `fk_running_id_idx` (`running_id`),
  KEY `fk_fitness_id_idx` (`fitness_id`),
  CONSTRAINT `fk_fitness_id` FOREIGN KEY (`fitness_id`) REFERENCES `fitness_plan` (`idFitness`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_running_id` FOREIGN KEY (`running_id`) REFERENCES `running` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `used_facebook_login` tinyint(4) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `Facebook_token` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `mobile` int(11) NOT NULL,
  `primary_sports` varchar(50) NOT NULL,
  `profile_img_path` varchar(200) NOT NULL,
  `time_spend_per_week` int(11) NOT NULL,
  `sport_level` int(11) NOT NULL,
  `location_long` float NOT NULL,
  `location_Lat` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (3,'steffen2811@live.dk',0,'$2a$10$Wt3qzrxTYH5x4RbjaAp/KOaDYVlJ4ABRLD6X5uR72yHU7fWBPnOAa',NULL,'Steffen Thomsen',22,26357820,'running','path',5,5,5.55,6.66);
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
INSERT INTO users.users_relations (idusers_1, idusers_2, differentInTime) 
SELECT 	NEW.id as idusers_1,
		userTable.id as idusers_2, 
		CONCAT(CalculateTimeDifferent(NEW.time_spend_per_week, userTable.time_spend_per_week), " hour") AS differentInTime 
        
FROM 	users.users AS userTable

where 	userTable.time_spend_per_week > NEW.time_spend_per_week * 0.6 and 
		userTable.time_spend_per_week < NEW.time_spend_per_week * 1.4 and 
        userTable.id <> NEW.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users_relations`
--

DROP TABLE IF EXISTS `users_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_relations` (
  `idusers_1` int(11) NOT NULL,
  `idusers_2` int(11) NOT NULL,
  `differentInTime` varchar(45) NOT NULL,
  `Relations_accepted_user1` tinyint(4) DEFAULT NULL,
  `Relations_accepted_user2` tinyint(4) DEFAULT NULL,
  UNIQUE KEY `idusers_unique_combinations` (`idusers_1`,`idusers_2`),
  KEY `idusers_1_fk_idx` (`idusers_1`),
  KEY `idusers_2_fk_idx` (`idusers_2`),
  CONSTRAINT `idusers_1_fk` FOREIGN KEY (`idusers_1`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `idusers_2_fk` FOREIGN KEY (`idusers_2`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_relations`
--

LOCK TABLES `users_relations` WRITE;
/*!40000 ALTER TABLE `users_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_relations` ENABLE KEYS */;
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
TRUNCATE users.users_relations;

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

-- Dump completed on 2019-01-08 12:48:49
