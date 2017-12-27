-- MySQL Script generated by MySQL Workbench
-- Wed 27 Dec 2017 17:31:34 GMT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema fyp
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `fyp` ;

-- -----------------------------------------------------
-- Schema fyp
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fyp` DEFAULT CHARACTER SET utf8 ;
USE `fyp` ;

-- -----------------------------------------------------
-- Table `fyp`.`paper`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fyp`.`paper` ;

CREATE TABLE IF NOT EXISTS `fyp`.`paper` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `author` VARCHAR(200) NOT NULL,
  `location` VARCHAR(200) NOT NULL,
  `text` TEXT(60000) NOT NULL,
  `parse` BLOB NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'A table listing all papers.';


-- -----------------------------------------------------
-- Table `fyp`.`key_phrase`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fyp`.`key_phrase` ;

CREATE TABLE IF NOT EXISTS `fyp`.`key_phrase` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `paper` INT NOT NULL,
  `start` INT NOT NULL,
  `end` INT NOT NULL,
  `text` VARCHAR(200) NULL,
  `classification` ENUM('Process', 'Task', 'Material') NULL,
  PRIMARY KEY (`id`),
  INDEX `paper_idx` (`paper` ASC),
  CONSTRAINT `fk_paper`
    FOREIGN KEY (`paper`)
    REFERENCES `fyp`.`paper` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Extracted key phrases from papers.';


-- -----------------------------------------------------
-- Table `fyp`.`hyponym`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fyp`.`hyponym` ;

CREATE TABLE IF NOT EXISTS `fyp`.`hyponym` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `kp1` INT NOT NULL,
  `kp2` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_kp1_idx` (`kp1` ASC),
  INDEX `fk_kp2_idx` (`kp2` ASC),
  CONSTRAINT `fk_kp1`
    FOREIGN KEY (`kp1`)
    REFERENCES `fyp`.`key_phrase` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_kp2`
    FOREIGN KEY (`kp2`)
    REFERENCES `fyp`.`key_phrase` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Stores \'Hyponym-of\' relation information.';


-- -----------------------------------------------------
-- Table `fyp`.`syn_link`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fyp`.`syn_link` ;

CREATE TABLE IF NOT EXISTS `fyp`.`syn_link` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Stores \'Synonym-of\' informatiom.\n\nThis table is the IDs of synonyms.';


-- -----------------------------------------------------
-- Table `fyp`.`synonym`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `fyp`.`synonym` ;

CREATE TABLE IF NOT EXISTS `fyp`.`synonym` (
  `id` INT NOT NULL,
  `kp` INT NOT NULL,
  INDEX `fk_syn_idx` (`id` ASC),
  INDEX `fk_kp_idx` (`kp` ASC),
  CONSTRAINT `fk_syn`
    FOREIGN KEY (`id`)
    REFERENCES `fyp`.`syn_link` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_kp`
    FOREIGN KEY (`kp`)
    REFERENCES `fyp`.`key_phrase` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Stores \'Synonym-of\' informatiom.\n\nThese are the actual synonyms.';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;