-- ---------------------------------------------------
CREATE SCHEMA `platziblog` default character SET utf8;
USE platziblog; 
-- ----------------------------------------------------
-- TABLAS
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`people`(
	`person_id` INT NOT NULL AUTO_INCREMENT,
	`last_name` VARCHAR(255) NULL,
	`first_name` VARCHAR(255) NULL,
	`adress` VARCHAR(255) NULL,
	`city` VARCHAR(255) NULL,
	PRIMARY KEY (`person_id`)
);
INSERT INTO `platziblog`.`people` (`person_id`, `last_name`, `first_name`, `adress`, `city`) 
VALUES 
    ('1', 'Vásquez', 'Israel', 'Calle Famosa Num 1', 'México'),
	('2', 'Hernández', 'Mónica', 'Reforma 222', 'México'),
	('3', 'Alanis', 'Edgar', 'Central 1', 'Monterrey');
-- Crear una vista
CREATE VIEW new_view AS
SELECT * FROM platziblog.people;
-- Drop
DROP VIEW `platziblog`.`new_view`;
DROP TABLE people; -- Hay que borrar las vistas +relacionadas a esta tabla después o antes.
-- ----------------------------------------------------
-- BLOGPOST: TABLAS INDEPENDIENTES
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`categorias`( -- (sin llave foránea)
	`id` INT NOT NULL auto_increment,
    `nombre_categoria` varchar(30) NOT NULL,
primary key (`id`));
-- ----------------------------------------------------
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`usuarios`( -- (sin llave foránea)
	`id` INT NOT NULL auto_increment,
    `login` varchar(30) NOT NULL,
    `password` varchar(32) NOT NULL,
    `nickname` varchar(40) NOT NULL,
    `email` varchar(40) NOT NULL,
primary key (`id`),
UNIQUE INDEX (`email` ASC));
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`etiquetas`( -- (sin llave foránea)
	`id`INT NOT NULL auto_increment,
    `nombre_etiqueta`varchar(30) NOT NULL,
primary key (`id`));
-- ----------------------------------------------------

-- BLOGPOST: TABLAS DEPENDIENTES
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`posts`( -- (CON llave foránea)
	`id` INT NOT NULL auto_increment,
    `titulo` varchar(130) NOT NULL,
    `fecha_publicacion` timestamp null,
    `contenido` TEXT NOT NULL,
    `estatus` char(8) NULL default 'activo',
    `usuario_id` INT NOT NULL,
	`categoria_id` INT NULL,
primary key (`id`));
-- ----------------------------------------------------
-- ----------------------------------------------------
CREATE TABLE `platziblog`.`comentarios`( -- (CON llave foránea)
	`id` INT NOT NULL auto_increment,
    `cuerpo_comentario` TEXT NOT NULL,
    `usuario_id` INT NOT NULL,
    `post_id` INT NOT NULL,
primary key (`id`));
-- ----------------------------------------------------

-- TABLA POSTS
-- ----------------------------------------------------
-- Agregamos llaves Foráneas a la tabla posts (a usuarios y categorías)
ALTER TABLE `platziblog`.`posts` 
ADD INDEX `posts_usuarios_idx` (`usuario_id` ASC) VISIBLE;
;
ALTER TABLE `platziblog`.`posts` 
ADD CONSTRAINT `posts_usuarios`
  FOREIGN KEY (`usuario_id`)
  REFERENCES `platziblog`.`usuarios` (`id`)
  ON DELETE NO ACTION
  ON UPDATE CASCADE;
-- ----------------------------------------------------
ALTER TABLE `platziblog`.`posts` 
ADD INDEX `posts_categorias_idx` (`categoria_id` ASC) VISIBLE;
;
ALTER TABLE `platziblog`.`posts` 
ADD CONSTRAINT `posts_categorias`
  FOREIGN KEY (`categoria_id`)
  REFERENCES `platziblog`.`categorias` (`id`)
  ON DELETE NO ACTION
  ON UPDATE CASCADE;
-- ---------------------------------------------------- 

-- TABLA COMENTARIOS
-- ----------------------------------------------------   
-- Agregamos llaves Foránea a la tabla Comentarios (a usuarios y posts)    
ALTER TABLE `platziblog`.`comentarios`
ADD INDEX `comentarios_usuario_idx` (`usuario_id` ASC);
;
ALTER TABLE `platziblog`.`comentarios` 
ADD constraint `comentarios_usuario`
	foreign key (`usuario_id`)
	references `platziblog`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO action;
-- ---------------------------------------------------- 
ALTER TABLE `platziblog`.`comentarios`
ADD INDEX `comentarios_post_idx` (`post_id` ASC);
;
ALTER TABLE `platziblog`.`comentarios` 
ADD constraint `comentarios_post`
	foreign key (`post_id`)
	references `platziblog`.`posts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO action;
-- ----------------------------------------------------  

-- TABLAS TRANSITIVAS
-- ----------------------------------------------------  
CREATE TABLE `platziblog`.`posts_etiquetas`(
	`id` INT NOT NULL auto_increment,
    `post_id` INT NOT NULL,
	`etiqueta_id` INT NOT NULL,
primary key (`id`));
-- ----------------------------------------------------
ALTER TABLE `platziblog`.`posts_etiquetas`
ADD INDEX `postsetiquetas_post_idx` (`post_id` ASC);
;
ALTER TABLE `platziblog`.`posts_etiquetas` 
ADD constraint `postsetiquetas_post`
	foreign key (`post_id`)
	references `platziblog`.`posts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO action;
-- ----------------------------------------------------    
ALTER TABLE `platziblog`.`posts_etiquetas`
ADD INDEX `postsetiquetas_etiquetas_idx` (`etiqueta_id` ASC);
;
ALTER TABLE `platziblog`.`posts_etiquetas` 
ADD constraint `postsetiquetas_etiquetas`
	foreign key (`etiqueta_id`)
	references `platziblog`.`etiquetas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO action;
-- ----------------------------------------------------
-- ----------------------------------------------------

-- Datos de prueba

-- Usuarios
INSERT INTO `usuarios` (`id`,`login`,`password`,`nickname`,`email`) VALUES (1,'israel','jc8209*(^GCHN_(hcLA','Israel','israel@platziblog.com');
INSERT INTO `usuarios` (`id`,`login`,`password`,`nickname`,`email`) VALUES (2,'monica','(*&^LKJDHC_(*#YDLKJHODG','Moni','monica@platziblog.com');
INSERT INTO `usuarios` (`id`,`login`,`password`,`nickname`,`email`) VALUES (3,'laura','LKDJ)_*(-c.M:\"[pOwHDˆåßƒ∂','Lau','laura@platziblog.com');
INSERT INTO `usuarios` (`id`,`login`,`password`,`nickname`,`email`) VALUES (4,'edgar','LLiy)CX*Y:M<A<SC_(*N>O','Ed','edgar@platziblog.com');
INSERT INTO `usuarios` (`id`,`login`,`password`,`nickname`,`email`) VALUES (5,'perezoso','&N_*JS)_Y)*(&TGOKS','Oso Pérez','perezoso@platziblog.com');

-- Categorías
INSERT INTO `categorias` (`id`,`nombre_categoria`) VALUES (1,'Ciencia');
INSERT INTO `categorias` (`id`,`nombre_categoria`) VALUES (2,'Tecnología');
INSERT INTO `categorias` (`id`,`nombre_categoria`) VALUES (3,'Deportes');
INSERT INTO `categorias` (`id`,`nombre_categoria`) VALUES (4,'Espectáculos');
INSERT INTO `categorias` (`id`,`nombre_categoria`) VALUES (5,'Economía');

-- Etiquetas
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (1,'Robótica');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (2,'Computación');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (3,'Teléfonos Móviles');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (4,'Automovilismo');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (5,'Campeonatos');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (6,'Equipos');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (7,'Bolsa de valores');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (8,'Inversiones');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (9,'Brokers');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (10,'Celebridades');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (11,'Eventos');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (12,'Moda');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (13,'Avances');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (14,'Nobel');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (15,'Matemáticas');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (16,'Química');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (17,'Física');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (18,'Largo plazo');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (19,'Bienes Raíces');
INSERT INTO `etiquetas` (`id`,`nombre_etiqueta`) VALUES (20,'Estilo');

-- Posts
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (43,'Se presenta el nuevo teléfono móvil en evento','2030-04-05 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (44,'Tenemos un nuevo auto inteligente','2025-05-04 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,2);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (45,'Ganador del premio Nobel por trabajo en genética','2023-12-22 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',3,1);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (46,'Los mejores vestidos en la alfombra roja','2021-12-22 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',4,4);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (47,'Los paparatzi captan escándalo en cámara','2025-01-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',4,4);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (48,'Se mejora la conducción autónoma de vehículos','2022-05-23 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (49,'Se descubre nueva partícula del modelo estandar','2023-01-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,1);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (50,'Químicos descubren nanomaterial','2026-06-04 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,1);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (51,'La bolsa cae estrepitosamente','2024-04-03 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,5);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (52,'Bienes raices más baratos que nunca','2025-04-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',2,5);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (53,'Se fortalece el peso frente al dolar','2021-10-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,5);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (54,'Tenemos ganador de la formula e','2022-11-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,3);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (55,'Ganan partido frente a visitantes','2023-12-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',2,3);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (56,'Equipo veterano da un gran espectaculo','2023-12-01 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','inactivo',2,3);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (57,'Escándalo con el boxeador del momento','2025-03-05 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',4,4);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (58,'Fuccia OS sacude al mundo','2028-10-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.','activo',1,2);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (59,'U.S. Robotics presenta hallazgo','2029-01-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',1,2);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (60,'Cierra campeonato mundial de football de manera impresionante','2023-04-10 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',2,3);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (61,'Escándalo en el mundo de la moda','2022-04-11 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','activo',4,4);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (62,'Tenemos campeona del mundial de volleiball','2024-09-09 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','inactivo',2,3);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (63,'Se descubre la unión entre astrofísica y fisica cuántica','2022-05-03 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n','inactivo',3,1);
INSERT INTO `posts` (`id`,`titulo`,`fecha_publicacion`,`contenido`,`estatus`,`usuario_id`,`categoria_id`) VALUES (64,'El post que se quedó huérfano','2029-08-08 00:00:00','Phasellus laoreet eros nec vestibulum varius. Nunc id efficitur lacus, non imperdiet quam. Aliquam porta, tellus at porta semper, felis velit congue mauris, eu pharetra felis sem vitae tortor. Curabitur bibendum vehicula dolor, nec accumsan tortor ultrices ac. Vivamus nec tristique orci. Nullam fringilla eros magna, vitae imperdiet nisl mattis et. Ut quis malesuada felis. Proin at dictum eros, eget sodales libero. Sed egestas tristique nisi et tempor. Ut cursus sapien eu pellentesque posuere. Etiam eleifend varius cursus.\n\nNullam viverra quam porta orci efficitur imperdiet. Quisque magna erat, dignissim nec velit sit amet, hendrerit mollis mauris. Mauris sapien magna, consectetur et vulputate a, iaculis eget nisi. Nunc est diam, aliquam quis turpis ac, porta mattis neque. Quisque consequat dolor sit amet velit commodo sagittis. Donec commodo pulvinar odio, ut gravida velit pellentesque vitae. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\nMorbi vulputate ante quis elit pretium, ut blandit felis aliquet. Aenean a massa a leo tristique malesuada. Curabitur posuere, elit sed consectetur blandit, massa mauris tristique ante, in faucibus elit justo quis nisi. Ut viverra est et arcu egestas fringilla. Mauris condimentum, lorem id viverra placerat, libero lacus ultricies est, id volutpat metus sapien non justo. Nulla facilisis, sapien ut vehicula tristique, mauris lectus porta massa, sit amet malesuada dolor justo id lectus. Suspendisse sit amet tempor ligula. Nam sit amet nisl non magna lacinia finibus eget nec augue. Aliquam ornare cursus dapibus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.\n\nDonec ornare sem eget massa pharetra rhoncus. Donec tempor sapien at posuere porttitor. Morbi sodales efficitur felis eu scelerisque. Quisque ultrices nunc ut dignissim vehicula. Donec id imperdiet orci, sed porttitor turpis. Etiam volutpat elit sed justo lobortis, tincidunt imperdiet velit pretium. Ut convallis elit sapien, ac egestas ipsum finibus a. Morbi sed odio et dui tincidunt rhoncus tempor id turpis.\n\nProin fringilla consequat imperdiet. Ut accumsan velit ac augue sollicitudin porta. Phasellus finibus porttitor felis, a feugiat purus tempus vel. Etiam vitae vehicula ex. Praesent ut tellus tellus. Fusce felis nunc, congue ac leo in, elementum vulputate nisi. Duis diam nulla, consequat ac mauris quis, viverra gravida urna.\n\','activo',5,1);

-- Posts-etiquetas
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (1,43,3);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (2,43,11);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (3,44,2);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (4,44,4);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (5,45,14);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (6,45,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (7,46,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (8,46,11);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (9,46,12);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (10,46,20);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (11,47,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (12,48,1);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (13,48,2);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (14,48,4);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (15,48,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (16,49,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (17,49,14);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (18,49,17);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (19,50,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (20,50,14);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (21,50,16);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (22,51,7);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (23,51,8);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (24,51,9);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (25,51,18);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (26,52,8);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (27,52,18);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (28,53,7);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (29,53,8);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (30,54,4);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (31,54,5);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (32,55,5);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (33,55,6);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (34,56,5);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (35,56,6);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (36,56,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (37,58,2);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (38,58,3);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (39,58,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (40,59,1);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (41,59,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (42,57,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (43,60,5);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (44,60,6);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (45,61,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (46,61,12);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (47,61,20);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (48,62,5);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (49,62,10);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (50,63,13);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (51,63,14);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (52,63,17);
INSERT INTO `posts_etiquetas` (`id`,`post_id`,`etiqueta_id`) VALUES (53,52,19);

-- -----------------------------------------------------------------------------
-- CONSULTAS: QUERYS--
SELECT * -- ESTRELLITA ES todos
FROM posts
WHERE YEAR(fecha_publicacion) > '2024';

SELECT titulo AS encabezado, fecha_publicacion AS publicado_en, estatus AS estado -- manera de poner ALIAS, se los puede usar en el futuro.
FROM posts;

SELECT COUNT(*) AS numero_de_posts
FROM posts;

-- CLASE: Teoria de conjuntos.
/*ver gráficas en LA PÁGINA DEL CURSO*/

-- LEFT JOIN CON INTERSECCIÓN
SELECT *
FROM usuarios
	LEFT JOIN posts ON usuarios.id = posts.usuario_id; 
-- invocamos la clave que nos ayuda, las unimos a través de sus llaves, es una condicion
-- Primero traemos los usuarios con o sin posts y luego los posts con 
-- Se muestra a perezozo que no tiene posts

-- LEFT JOIN SIN INTERSECCIÓN   
SELECT *
FROM usuarios
	LEFT JOIN posts ON usuarios.id = posts.usuario_id
WHERE posts.usuario_id IS NULL;
-- Acá dejamos afuera los que sí tienen posts
-- Invocamos a los usuarios SIN posts

-- RIGHT JOIN CON INTERSECCIÓN
SELECT *
FROM usuarios
	RIGHT JOIN posts ON usuarios.id = posts.usuario_id;
--  Todos los POsts y solo usuarios con POSTS
-- 

-- RIGHT JOIN SIN INTERSECCIÓN
SELECT *
FROM usuarios
	RIGHT JOIN posts ON usuarios.id = posts.usuario_id
    WHERE posts.usuario_id IS NULL;
-- Solo los POSTS SIN USUARIOS


-- AHORA VEREMOS INTERSECCIONES --
SELECT *
FROM usuarios
	INNER JOIN posts ON usuarios.id = posts.usuario_id; 
    -- SOLO ME INTERESAN LOS DATOS QUE ESTÁN RELACIONADOS POR AMBOS LADOS
    -- Solo usuarios con posts y posts con usuarios
    
    
-- UNIÓN Y DIFERENCIA SIMETRICA
-- UNIÓN
SELECT * -- todoS LOS DATOS UNIDOS AHORA:
FROM usuarios
	LEFT JOIN posts ON usuarios.id = posts.usuario_id
    UNION
    SELECT *
		FROM usuarios
		RIGHT JOIN posts ON usuarios.id = posts.usuario_id;

-- TODO SIN LA INTERSECCION, DIFERENCIA SIMÉTRICA
-- LO QUE EXISTE EN A PERO NO EN B Y LO QUE EXISTE EN B PERO NO EN A
SELECT * -- LO CONTRARIO AL INNER JOIN, LOS DATOS NO RELACIONADOS
FROM usuarios
	LEFT JOIN posts ON usuarios.id = posts.usuario_id
	WHERE posts.usuario_id IS NULL
    UNION
    SELECT *
		FROM usuarios
		RIGHT JOIN posts ON usuarios.id = posts.usuario_id
        WHERE posts.usuario_id IS NULL;
        
/*-----------------------------32: WHERE---------------------------------*/
-- Cabe mencionar que los operadores LIKE y BETWEEN AND, pueden ser negados con NOT
SELECT *
FROM posts
WHERE id <= 50
;

SELECT *
FROM posts
WHERE estatus = 'activo'
;

SELECT *
FROM posts
WHERE estatus != 'activo'
;

SELECT *
FROM posts
WHERE id != 50
;

SELECT *
FROM posts
WHERE titulo LIKE '%veterano%' -- lo que sea antes, lo que sea después, pero que contenga "veterano"
;
-- like nos ayuda cuando no conocemos la cadena de caracteres exacta
SELECT *
FROM posts
WHERE titulo LIKE '%roja'
;

SELECT *
FROM posts
WHERE fecha_publicacion > '2025-01-01'
;

SELECT *
FROM posts
WHERE fecha_publicacion BETWEEN '2025-01-01' AND '2023-01-01'
;
-- hay que usar el BETWEEN ENTRE MENOR Y MAYOR
SELECT *
FROM posts
WHERE fecha_publicacion BETWEEN '2023-01-01' AND '2025-01-01' 
;

SELECT *
FROM posts
WHERE YEAR(fecha_publicacion) BETWEEN '2023' AND '2024' 
;

SELECT *
FROM posts
WHERE MONTH(fecha_publicacion) = '04' 
;

SELECT *
FROM posts
WHERE id BETWEEN 50 AND 60 
; -- incluye los extremos 


/*-----------------------------WHERE NULO Y NO NULO: NULO Y NO NULO ----------------------*/
SELECT *
FROM posts
WHERE usuario_id IS NULL-- vamos a ver los posts sin usuario
;

SELECT *
FROM posts
WHERE categoria_id IS NULL
;

SELECT *
FROM posts
WHERE usuario_id IS NOT NULL
	AND estatus = 'activo' 
    AND id < 50
    AND categoria_id = 2 -- WHERE NOS PERMITE FILTRAR TANTO COMO QUERAMOS
    AND YEAR (fecha_publicacion) > '2022'
;

/*---------------------------- 34: GROUP BY ----------------------------*/

SELECT estatus, -- Columna 1
	COUNT(*) AS Cantidad_de_Posts -- Columna 2
FROM posts
;-- cuenta TAMBIEN LOS INACTIVOS, Da error por no usar la agrupación

SELECT 	estatus, -- Columna 1
		COUNT(*) AS Cantidad_de_Posts -- Columna 2
FROM posts  -- Buscar columnas desde la TABLA POSTS
GROUP BY estatus -- acá le digo a través de que campos quiero que se agrupen los datos, primero agrupa y despues cuenta
; 
-- COUNT nos dice cuantos registros tengo agrupados por grupo


SELECT categoria_id, COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY categoria_id
;


SELECT 	estatus, -- Columna 1
		COUNT(*) AS Cantidad_de_Posts -- Columna 2
FROM posts  -- Buscar columnas desde la TABLA POSTS
-- GROUP BY estatus -- acá le digo a través de que campos quiero que se agrupen los datos
GROUP BY categoria_id
;  -- activo o inactivo toma el primero, esta sería una sentencia mal ejecutada

 

SELECT 
		YEAR(fecha_publicacion) AS Año_del_Post, 
        COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY Año_del_Post 
;

SELECT 
		YEAR(fecha_publicacion) AS Año_del_Post, -- COLUMNA 1
        COUNT(*) AS Cantidad_de_Posts            -- COLUMNA 2
FROM posts
; -- al usar count sin AGRUPAR te tira un solo número total

SELECT 
		MONTHNAME(fecha_publicacion) AS Mes_del_Post, 
        COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY Mes_del_Post;

SELECT 
		estatus, 
        MONTHNAME(fecha_publicacion) AS Mes_del_Post, 
        COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY 
		estatus,      -- Criterio 1
        Mes_del_Post  -- Criterio 2
;


SELECT 
		estatus, 
        YEAR(fecha_publicacion) AS Año_del_Post,
        MONTHNAME(fecha_publicacion) AS Mes_del_Post, 
        COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY 
		estatus,      -- Criterio 1
        Año_del_Post,
        Mes_del_Post  -- Criterio 2
;


SELECT 
		estatus, 
        YEAR(fecha_publicacion) AS Año_del_Post,
        MONTHNAME(fecha_publicacion) AS Mes_del_Post, 
        COUNT(*) AS Cantidad_de_Posts
FROM posts
GROUP BY 
		estatus,      -- Criterio 1
        Año_del_Post, -- Criterio 2
        Mes_del_Post  -- Criterio 3
ORDER BY 
		Año_del_Post DESC -- etudiar bien como queda esto
;

/*---------------------------- 35: ORDER BY y HAVING ----------------------------*/
-- El orden en el que se fue llenando la tabla es el primer ordenamiento que se presenta
SELECT *
FROM	posts
;
-- El orden en el que se fue llenando la tabla es el primer ordenamiento que se presenta

SELECT *
FROM	posts
ORDER BY fecha_publicacion -- ASCENDENTE POR DEFECTO
;

SELECT *
FROM	posts
ORDER BY fecha_publicacion DESC-- ASCENDENTE POR DEFECTO
;

-- Cuando tenemos una cadena como "titulo" nos ordena por orden alfabético en primera instancia (ASC)
SELECT *
FROM	posts
ORDER BY titulo 
;

SELECT *
FROM	posts
ORDER BY titulo DESC
;

SELECT *
FROM	posts
ORDER BY usuario_id
;

SELECT *
FROM	posts
ORDER BY fecha_publicacion -- ASCENDENTE POR DEFECTO
LIMIT 5
;

-- HAVING: se parece a WHERE -- 
/*La cláusula HAVING es similar a WHERE pero se utiliza para filtrar registros 
después de aplicar una agregación con GROUP BY.
Mientras que WHERE filtra filas antes de la agregación, 
HAVING filtra grupos después de la agregación.*/

SELECT 
	MONTHNAME(fecha_publicacion) AS Mes_del_Post,
	estatus,
    COUNT(*) as Cantidad_de_Posts
FROM posts
GROUP BY 
	estatus,
    Mes_del_Post
ORDER BY Mes_del_Post
;

SELECT 
	MONTHNAME(fecha_publicacion) AS Mes_del_Post,
	estatus,
    COUNT(*) as Cantidad_de_Posts
FROM posts
GROUP BY 
	estatus,
    Mes_del_Post
ORDER BY Mes_del_Post
;
-- WHERE FILTRA ANTES DE HACER LA AGRUPACION; POR ESO NO FUNCIONA EN ESTE CASO
-- Seleccion de tuplas agrupadas no se puede hacer con WHERE
-- HAVING nos ayuda una vez agrupados y creados campos dinámicos con los datos.
SELECT 
	MONTHNAME(fecha_publicacion) AS Mes_del_Post,
	estatus,
    COUNT(*) as Cantidad_de_Posts
FROM posts
GROUP BY 
	estatus,
    Mes_del_Post
HAVING Cantidad_de_Posts >= 1
ORDER BY Mes_del_Post
;


/*-----------------------36:(Nested queries)(Queris Anidados)---------------------------*/
SELECT
	new_table_projection.date,
    COUNT(*) AS post_count
FROM (  -- Acá vamos a crear una tabla dinámica
	SELECT 
		DATE(MIN(fecha_publicacion)) AS date, -- trae una sola fecha, es el que querermos proyectar en el SELECT del padre
        YEAR(fecha_publicacion) AS post_year
	FROM posts
	GROUP BY post_year
	) AS new_table_projection-- Ahora podemos hacer un FROM de esta SuBTABLA (si o si hay que darle un nombre con 'AS')
GROUP BY new_table_projection.date
ORDER BY new_table_projection.date
;

SELECT *
FROM posts
WHERE fecha_publicacion = (
	SELECT MAX(fecha_publicacion) -- esto solo trae la última fecha de publicacion
    FROM posts -- utilizamos una subquery para obtener un dato
)
;

/*----------------------------------37: PREGUNTA A QUERY ----------------------------------
•	SELECT: Lo que quieres mostrar
•	FROM: De dónde voy a tomar los datos
•	WHERE: Los filtros de los datos que quieres mostrar
•	GROUP BY: Los rubros por los que me interesa agrupar la información
•	ORDER BY: El orden en que quiero presentar mi información
•	HAVING: Los filtros que quiero que mis datos agrupados tengan
•	LIMIT: la cantidad de registros que quiero
*/


/*---------38_Preguntándole a la base de datos----------------------*/
-- núnmero de etiquetas por post:
SELECT 
	posts.titulo,
    COUNT(*) AS num_etiquetas  -- vamos a contar todo
FROM posts
    INNER JOIN posts_etiquetas ON posts.id = posts_etiquetas.post_id  -- Esto nos da la unions entre posts y posts eqituetas
    INNER JOIN etiquetas ON etiquetas.id = posts_etiquetas.etiqueta_id-- y ahora unimos todo finalmente con la tabla etiquetas
    -- Estamos uniendo tres tablas.
GROUP BY posts.id
ORDER BY num_etiquetas DESC
;

-- Ahora queremos ver cuales son esas etiquetas!
-- para eso vamos a usar GROUP_CONCAT, en vez de agrupar pone los resultados en un campo separados por comas
SELECT 
	posts.titulo,
    GROUP_CONCAT(nombre_etiqueta)
FROM posts
    INNER JOIN posts_etiquetas ON posts.id = posts_etiquetas.post_id  -- Esto nos da la unions entre posts y posts eqituetas
    INNER JOIN etiquetas ON etiquetas.id = posts_etiquetas.etiqueta_id-- y ahora unimos todo finalmente con la tabla etiquetas
    -- Estamos uniendo tres tablas.
GROUP BY posts.id
-- ORDER BY num_etiquetas DESC  (Ya no nos interesa el orden)
;

-- HAY alguna etiqueta que no esté relacionada con ningún post?
SELECT *
FROM etiquetas
	LEFT JOIN posts_etiquetas ON etiquetas.id = posts_etiquetas.etiqueta_id
    WHERE posts_etiquetas.etiqueta_id IS NULL
;


/*
Función CASE permite agregar un campo virtual con información generada a partir de condiciones múltiples.
Mostrar el idioma, precio de todos los libros, así como agregar una columna de informe que indique si el libro es caro, 
módico o barato basado en el precio

SELECT  idioma, precio, 
CASE
	WHEN precio > 1000 THEN "Muy caro"
	WHEN precio > 500 THEN "Precio módico"
	ELSE "Muy barato"
END AS "informe"
FROM libros;
*/

/*------------------------39: Consultando PLatziblog-------------------------*/
/*
Puedes usar una abreviación para evitar escribir lo mismo cada vez.
Ejemplo:

FROM categorias AS c
*/
-- vamos a preguntar las categorias de las que tienen más a menos posts
SELECT
	cat.nombre_categoria,
    COUNT(*) AS cantidad_posts
FROM categorias as cat
	INNER JOIN posts AS p ON cat.id = p.categoria_id
GROUP BY cat.id
ORDER BY cantidad_posts DESC
LIMIT 3
;

SELECT
	u.nickname,
    COUNT(*) AS cantidad_posts
FROM usuarios as u
	INNER JOIN posts AS p ON u.id = p.categoria_id
GROUP BY u.id
ORDER BY cantidad_posts DESC
LIMIT 3
;
-- SOBRE qué temas están escribiendo?
SELECT
	u.nickname,
    COUNT(*) AS cantidad_posts,
    GROUP_CONCAT(nombre_categoria)
FROM usuarios as u
	INNER JOIN posts AS p ON u.id = p.usuario_id
    INNER JOIN categorias AS c ON c.id = p.categoria_id
GROUP BY u.id
ORDER BY cantidad_posts DESC
;

-- QUe usuarios no escribieron ningún post
SELECT *
FROM usuarios As u
	LEFT JOIN posts ON u.id = posts.usuario_id
WHERE posts.usuario_id IS NULL
;