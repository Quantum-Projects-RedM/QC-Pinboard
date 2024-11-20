
CREATE TABLE IF NOT EXISTS `posters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `poster_link` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT '',
  `charidentifier` varchar(255) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
