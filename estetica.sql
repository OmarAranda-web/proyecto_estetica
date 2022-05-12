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

 Date: 11/05/2022 22:45:07
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
  CONSTRAINT `idlocal` FOREIGN KEY (`idlocal`) REFERENCES `locales` (`id_local`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cita
-- ----------------------------
INSERT INTO `cita` VALUES (1, 'Cita Emer', '2022-05-12', '13:00:00', '0', 1, 1, 1);
INSERT INTO `cita` VALUES (2, 'Cita Emer', '2022-05-12', '13:00:00', '1', 1, 1, 1);
INSERT INTO `cita` VALUES (3, 'Cita Emer', '2022-05-13', '13:00:00', '1', 1, 1, 1);

-- ----------------------------
-- Table structure for locales
-- ----------------------------
DROP TABLE IF EXISTS `locales`;
CREATE TABLE `locales`  (
  `id_local` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `direccion_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id_local`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of locales
-- ----------------------------
INSERT INTO `locales` VALUES (1, 'Loilta', 'Jilotepec');
INSERT INTO `locales` VALUES (2, 'Juan', 'Jilo');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicio
-- ----------------------------
INSERT INTO `servicio` VALUES (1, 'Corte Sencillo', 50, b'1', '2 semanas');
INSERT INTO `servicio` VALUES (2, 'Teñido de cabello', 100, b'1', 'Solo los sabados');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuario
-- ----------------------------
INSERT INTO `usuario` VALUES (1, 'oMAR', 'Aranda', '', '55301245', 'OMAR.COM.MX', '1234', 270435762);

-- ----------------------------
-- Procedure structure for proc_cancelar_cita
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_cancelar_cita`;
delimiter ;;
CREATE PROCEDURE `proc_cancelar_cita`(p_cita int)
BEGIN
UPDATE cita set cita.`status`='0' where cita.id_cita=p_cita;
select 'se cancelo la cita' as Mensaje_BD;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_insertar_cita
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_cita`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_cita`(p_alias varchar(255),
p_fecha varchar(255),
p_hora varchar(255),
p_usuario int,
p_servicio varchar(255),
p_local varchar(255))
begin
declare id_servicio int;
declare id_local int;

select servicio.id_servicio into id_servicio from servicio where servicio.nombre_servicio=p_servicio;
select locales.id_local into id_local from  locales where locales.nombre_local=p_local;

if EXISTS (SELECT cita.id_cita from cita where cita.fecha=p_fecha and cita.hora=p_hora)
then
		SELECT 'FECHA NO DISPONIBLE' AS MENSAJE_BD;
else
	insert cita VALUES(default, trim(p_alias), p_fecha, p_hora, '1', p_usuario, id_servicio, id_local);
	SELECT 'Se hizo la cita' AS MENSAJE_BD;
end if;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_insertar_local
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_local`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_local`(p_nom_local varchar(255),
p_direccion_local varchar(255))
begin
if EXISTS(Select locales.nombre_local from locales where locales.nombre_local=trim(p_nom_local))
then
	SELECT 'Ya existe ese local' as Mensaje_BD;
else
	insert locales values(default, trim(p_nom_local),trim(p_direccion_local));
	SELECT 'Se inserto Local' as Mensaje_BD;
end if;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_insertar_servicio
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_servicio`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_servicio`(p_nom_servicio varchar(255),
p_precio_serv float,
p_tiempo varchar(255))
begin
if EXISTS(Select servicio.nombre_servicio from servicio where servicio.nombre_servicio=trim(p_nom_servicio))
then
	SELECT 'Ya exite este servicio' as Mensaje_BD;
else
	insert servicio VALUES(DEFAULT, trim(p_nom_servicio), trim(p_precio_serv), 1, trim(p_tiempo));
	Select 'Se inserto nuevo servicio' as Mensaje_BD;
end if;
end
;;
delimiter ;

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

-- ----------------------------
-- Procedure structure for proc_validar_usuario
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_validar_usuario`;
delimiter ;;
CREATE PROCEDURE `proc_validar_usuario`(p_usuario varchar(255),
p_contra varchar(255))
begin
declare id_usuario int;
if EXISTS(select usuario.id_usuarios from usuario where usuario.nombre=p_usuario and usuario.contrasenia=p_contra)
then
	SELECT 'Puedes ingresar' as Mensaje_BD;
	select usuario.id_usuarios into id_usuario from usuario where usuario.nombre=p_usuario and usuario.contrasenia=p_contra;
else
	Select "El usuario o la contraseña son incorrectos" as Mensaje_BD;
end if;
end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
