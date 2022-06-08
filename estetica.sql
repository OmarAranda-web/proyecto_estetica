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

 Date: 08/06/2022 15:34:17
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
  `idlocal` int(11) NOT NULL,
  `total_cita` float NOT NULL,
  PRIMARY KEY (`id_cita`) USING BTREE,
  INDEX `idUsuarios`(`idUsuarios`) USING BTREE,
  INDEX `idlocal`(`idlocal`) USING BTREE,
  CONSTRAINT `idUsuarios` FOREIGN KEY (`idUsuarios`) REFERENCES `usuario` (`id_usuarios`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `idlocal` FOREIGN KEY (`idlocal`) REFERENCES `locales` (`id_local`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cita
-- ----------------------------
INSERT INTO `cita` VALUES (6, 'Cita Emer', '2022-05-13', '13:00:00', '1', 3, 3, 200);
INSERT INTO `cita` VALUES (7, 'Cita Emer', '2022-05-13', '14:00:00', '1', 3, 3, 0);

-- ----------------------------
-- Table structure for detalle_cita
-- ----------------------------
DROP TABLE IF EXISTS `detalle_cita`;
CREATE TABLE `detalle_cita`  (
  `id_dtalle_cita` bigint(255) NOT NULL AUTO_INCREMENT,
  `id_cita_dcita` bigint(255) NOT NULL,
  `id_servicio_dcita` tinyint(255) NOT NULL,
  `cantidad_cita` tinyint(4) NOT NULL,
  PRIMARY KEY (`id_dtalle_cita`) USING BTREE,
  INDEX `id_servicio_dcita`(`id_servicio_dcita`) USING BTREE,
  INDEX `id_cita_dcita`(`id_cita_dcita`) USING BTREE,
  CONSTRAINT `id_cita_dcita` FOREIGN KEY (`id_cita_dcita`) REFERENCES `cita` (`id_cita`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `id_servicio_dcita` FOREIGN KEY (`id_servicio_dcita`) REFERENCES `servicio` (`id_servicio`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of detalle_cita
-- ----------------------------
INSERT INTO `detalle_cita` VALUES (3, 6, 3, 2);

-- ----------------------------
-- Table structure for locales
-- ----------------------------
DROP TABLE IF EXISTS `locales`;
CREATE TABLE `locales`  (
  `id_local` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `direccion_local` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `estatus` bit(1) NOT NULL,
  PRIMARY KEY (`id_local`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of locales
-- ----------------------------
INSERT INTO `locales` VALUES (3, 'Juan', 'Jilo', b'1');
INSERT INTO `locales` VALUES (4, 'Juanas', 'Mnazanas', b'1');

-- ----------------------------
-- Table structure for servicio
-- ----------------------------
DROP TABLE IF EXISTS `servicio`;
CREATE TABLE `servicio`  (
  `id_servicio` tinyint(4) NOT NULL AUTO_INCREMENT,
  `nombre_servicio` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `precio` float NOT NULL,
  `estatus` bit(1) NULL DEFAULT NULL,
  `tiempo` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_servicio`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicio
-- ----------------------------
INSERT INTO `servicio` VALUES (3, 'Teñido de cabello', 100, b'1', 'Solo los sabados');
INSERT INTO `servicio` VALUES (4, 'Corte de Cabello', 90, b'1', 'Indefinido');

-- ----------------------------
-- Table structure for usuario
-- ----------------------------
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario`  (
  `id_usuarios` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `apellido1` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `telefono` varchar(14) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `contrasenia` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `token` int(11) NOT NULL,
  `permiso` bit(1) NOT NULL,
  PRIMARY KEY (`id_usuarios`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuario
-- ----------------------------
INSERT INTO `usuario` VALUES (2, 'oMAR', 'Aranda', '55301245', 'OMAR.COM.MX', '1234', 486165776, b'0');
INSERT INTO `usuario` VALUES (3, 'oMAR', 'Aranda', '55301245', 'OMAR.COM.MX', '1234', 10478926, b'0');

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
-- Procedure structure for proc_consul_citasTotales
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_consul_citasTotales`;
delimiter ;;
CREATE PROCEDURE `proc_consul_citasTotales`()
begin
	SELECT cita.alias, cita.fecha, cita.hora, cita.total_cita, usuario.nombre, locales.nombre_local from cita inner join usuario on
cita.idUsuarios = usuario.id_usuarios INNER JOIN locales on locales.id_local=cita.idlocal;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_consul_edita_local
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_consul_edita_local`;
delimiter ;;
CREATE PROCEDURE `proc_consul_edita_local`(p_idLocal TINYINT)
begin
	Select locales.id_local,locales.nombre_local, locales.direccion_local, locales.estatus from locales where locales.id_local=p_idLocal;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_consul_locales
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_consul_locales`;
delimiter ;;
CREATE PROCEDURE `proc_consul_locales`()
begin
Select * from locales;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_consul_servicios
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_consul_servicios`;
delimiter ;;
CREATE PROCEDURE `proc_consul_servicios`()
begin
Select * from servicio;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_consu_etidar_servicio
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_consu_etidar_servicio`;
delimiter ;;
CREATE PROCEDURE `proc_consu_etidar_servicio`(p_idServicio TINYINT)
begin
	select servicio.id_servicio,servicio.nombre_servicio, servicio.precio, servicio.tiempo, servicio.estatus from servicio WHERE servicio.id_servicio=p_idServicio;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_editar_local
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_editar_local`;
delimiter ;;
CREATE PROCEDURE `proc_editar_local`(p_idLocal TINYINT, p_nomLocal VARCHAR(255), p_direccionLocla VARCHAR(255), p_estatus bit)
begin
	UPDATE locales set locales.nombre_local=p_nomLocal, locales.direccion_local=p_direccionLocla, locales.estatus=p_estatus
	WHERE locales.id_local=p_idLocal ;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_editar_servicio
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_editar_servicio`;
delimiter ;;
CREATE PROCEDURE `proc_editar_servicio`(p_idServicio TINYINT, p_nomServicio VARCHAR(255), p_precioServ FLOAT, p_tiempoServ VARCHAR(255), p_estatusServ bit)
begin
UPDATE servicio set servicio.nombre_servicio=p_nomServicio, servicio.precio= p_precioServ, servicio.tiempo=p_tiempoServ, servicio.estatus=p_estatusServ WHERE servicio.id_servicio=p_idServicio;
end
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
p_local varchar(255))
begin
declare id_local int;

select locales.id_local into id_local from  locales where locales.nombre_local=p_local;

if EXISTS (SELECT cita.id_cita from cita where cita.fecha=p_fecha and cita.hora=p_hora)
then
		SELECT 'FECHA NO DISPONIBLE' AS MENSAJE_BD;
else
	insert cita VALUES(default,trim(p_alias), p_fecha, p_hora, '1', p_usuario, id_local,0);
	SELECT 'Se hizo la cita' AS MENSAJE_BD;
end if;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_insertar_detalle_cita
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_detalle_cita`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_detalle_cita`(p_id_cita BIGINT, p_servicio VARCHAR(255))
BEGIN
	declare id_servicio int;
	select servicio.id_servicio into id_servicio from servicio where servicio.nombre_servicio=p_servicio;
	insert into detalle_cita VALUES(default,p_id_cita, id_servicio);
	select 'Se inserto Detalle de Cita' as 'Mensaje_DB';
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for proc_insertar_detCita
-- ----------------------------
DROP PROCEDURE IF EXISTS `proc_insertar_detCita`;
delimiter ;;
CREATE PROCEDURE `proc_insertar_detCita`(p_idCita BIGINT, p_servicio BIGINT)
begin
declare pcatiCita tinyint;
DECLARE totaciata float;
Declare actuacita float;
Select cantidad_cita into pcatiCita from detalle_cita WHERE detalle_cita.id_cita_dcita=p_idCita;

Select total_cita into totaciata from cita where cita.id_cita=p_idCita;

SELECT servicio.precio into actuacita from servicio where servicio.id_servicio = p_servicio;

if EXISTS (Select detalle_cita.id_cita_dcita from detalle_cita where detalle_cita.id_cita_dcita=p_idCita and detalle_cita.id_servicio_dcita=p_servicio)
then
	UPDATE detalle_cita set cantidad_cita=(pcaticita+1) where detalle_cita.id_cita_dcita=p_idCita;
	UPDATE cita set total_cita=(totaciata+actuacita) where cita.id_cita=p_idCita;
else	insert detalle_cita values (DEFAULt,p_idCita, p_servicio, 1);
	UPDATE cita set total_cita=(totaciata+actuacita) where cita.id_cita=p_idCita;
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
	insert locales values(default, trim(p_nom_local),trim(p_direccion_local),1);
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
CREATE PROCEDURE `proc_insertar_usuario`(p_nombre varchar(255), p_apellido1 VARCHAR(255), p_telefono varchar(255), p_correo varchar(255),
p_contrasenia varchar(255))
begin
if p_nombre='' or p_apellido1='' or p_telefono='' or p_contrasenia=''
then
SELECT 'No dejes campos en blanco' as MENSAJE_BD;
else
insert usuario values(DEFAULT,trim(p_nombre), trim(p_apellido1), trim(p_telefono), trim(p_correo), trim(p_contrasenia), (SELECT ROUND(((999999999 - 100000000) * RAND() + 1), 0)),0);
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
