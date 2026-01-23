-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema muebleria
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `muebleria` ;

-- -----------------------------------------------------
-- Schema muebleria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `muebleria` DEFAULT CHARACTER SET utf8 COLLATE utf8_czech_ci ;
USE `muebleria` ;

-- -----------------------------------------------------
-- Table `muebleria`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`cliente` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`cliente` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  `apellido` VARCHAR(100) NULL,
  `telefono` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  `direccion` VARCHAR(100) NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`producto` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`producto` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  `descripcion` VARCHAR(255) NULL,
  `precio` DECIMAL(10,2) NULL,
  `stock` INT NULL,
  PRIMARY KEY (`id_producto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`venta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`venta` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`venta` (
  `id_venta` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL,
  `fecha` DATETIME NULL,
  `estado` ENUM('PENDIENTE', 'CONFIRMADA', 'CANCELADA') NULL,
  PRIMARY KEY (`id_venta`),
  INDEX `fk_venta_cliente1_idx` (`id_cliente` ASC) ,
  CONSTRAINT `fk_venta_cliente1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `muebleria`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`detalle_venta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`detalle_venta` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`detalle_venta` (
  `id_detalle_venta` INT NOT NULL AUTO_INCREMENT,
  `id_venta` INT NULL,
  `id_producto` INT NULL,
  `cantidad` INT NULL,
  `precio_unitario` DECIMAL(10,2) NULL,
  `subtotal` DECIMAL(10,2) NULL,
  INDEX `fk_detalle_venta_producto1_idx` (`id_producto` ASC) ,
  INDEX `fk_detalle_venta_venta1_idx` (`id_venta` ASC) ,
  PRIMARY KEY (`id_detalle_venta`),
  CONSTRAINT `fk_detalle_venta_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `muebleria`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_venta_venta1`
    FOREIGN KEY (`id_venta`)
    REFERENCES `muebleria`.`venta` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`proveedor` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`proveedor` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `razon_social` VARCHAR(100) NULL,
  `telefono` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  `direccion` VARCHAR(150) NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`compra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`compra` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`compra` (
  `id_compra` INT NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT NULL,
  `fecha` DATETIME NULL,
  `total` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id_compra`),
  INDEX `fk_compra_proveedor1_idx` (`id_proveedor` ASC) ,
  CONSTRAINT `fk_compra_proveedor1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `muebleria`.`proveedor` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`detalle_compra`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`detalle_compra` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`detalle_compra` (
  `id_detalle_compra` INT NOT NULL AUTO_INCREMENT,
  `id_compra` INT NULL,
  `id_producto` INT NULL,
  `cantidad` INT NULL,
  `precio_unitario` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id_detalle_compra`),
  INDEX `fk_detalle_compra_compra1_idx` (`id_compra` ASC) ,
  INDEX `fk_detalle_compra_producto1_idx` (`id_producto` ASC) ,
  CONSTRAINT `fk_detalle_compra_compra1`
    FOREIGN KEY (`id_compra`)
    REFERENCES `muebleria`.`compra` (`id_compra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_compra_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `muebleria`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `muebleria`.`movimiento_stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `muebleria`.`movimiento_stock` ;

CREATE TABLE IF NOT EXISTS `muebleria`.`movimiento_stock` (
  `id_movimiento_stock` INT NOT NULL AUTO_INCREMENT,
  `id_producto` INT NULL,
  `tipo` ENUM('ENTRADA', 'SALIDA') NULL,
  `cantidad` INT NULL,
  `fecha` DATETIME NULL,
  `motivo` ENUM('COMPRA', 'VENTA', 'CAMBIO', 'DEVOLUCION') NULL,
  PRIMARY KEY (`id_movimiento_stock`),
  INDEX `fk_movimiento_stock_producto1_idx` (`id_producto` ASC) ,
  CONSTRAINT `fk_movimiento_stock_producto1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `muebleria`.`producto` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
