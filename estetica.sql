/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50733
 Source Host           : localhost:3306
 Source Schema         : estetica

 Target Server Type    : MySQL
 Target Server Version : 50733
 File Encoding         : 65001

 Date: 10/05/2022 23:40:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cita
-- ----------------------------
DROP TABLE IF EXISTS `cita`;
CREATE TABLE `cita`  (
  `id_cita` bigint(20) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora` time(0) NOT NULL,
  `status` varchar(3) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `idUsuarios` bigint(20) NOT NULL,
  `idServicio` tinyint(4) NOT NULL,
  `idlocal` int(11) NOT NULL,
  PRIMARY KEY (`id_cita`) USING BTREE,
  INDEX `idUsuarios`(`idUsuarios`) USING BTREE,
  INDEX `idServicio`(`idServicio`) USING BTREE,
  INDEX `idlocal`(`idlocal`) USING BTREE,
  CONSTRAINT `idServicio` FOREIGN KEY (`idServicio`) REFERENCES `servicio` (`id_servicio`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idUsuarios` FOREIGN KEY (`idUsuarios`) REFERENCES `usuario` (`id_usuarios`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idlocal` FOREIGN KEY (`idlocal`) REFERENCES `local` (`id_local`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cita
-- ----------------------------

-- ----------------------------
-- Table structure for local
-- ----------------------------
DROP TABLE IF EXISTS `local`;
CREATE TABLE `local`  (
  `id_local` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `direccion_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id_local`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of local
-- ----------------------------

-- ----------------------------
-- Table structure for servicio
-- ----------------------------
DROP TABLE IF EXISTS `servicio`;
CREATE TABLE `servicio`  (
  `id_servicio` tinyint(4) NOT NULL AUTO_INCREMENT,
  `nombre_servicio` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `precio` float NOT NULL,
  `status` bit(1) NULL DEFAULT NULL,
  `tiempo` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_servicio`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicio
-- ----------------------------

-- ----------------------------
-- Table structure for usuario
-- ----------------------------
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario`  (
  `id_usuarios` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `apellido1` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `apellido2` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `telefono` varchar(14) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `contrasenia` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `token` int(11) NOT NULL,
  PRIMARY KEY (`id_usuarios`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuario
-- ----------------------------

-- ----------------------------
-- Procedure structure for proc_insertar_usuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_usuario`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_usuario`(p_nombre varchar(255), p_apellido1 VARCHAR(255),p_apellido2 varchar(255), p_telefono varchar(255), p_correo varchar(255),
p_contrasenia varchar(255))
begin
if p_nombre='' or p_apellido1='' or p_telefono='' or p_contrasenia=''
then
SELECT 'No dejes campos en blanco' as MENSAJE_BD;
else
insert usuario values(DEFAULT,trim(p_nombre), trim(p_apellido1), trim(p_apellido2), trim(p_telefono), trim(p_correo), trim(p_contrasenia), (SELECT ROUND(((999999999 - 100000000) * RAND() + 1), 0)));
SELECT 'SE REGISTRO DE FOMRA ADECUADA EL USUARIO' AS MENSAJE_BD;
end if;

end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
