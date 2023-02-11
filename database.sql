CREATE TABLE `oilwell_database` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`oilwell_id` INT(11) NULL DEFAULT NULL,
	`oil` INT(11) NULL DEFAULT NULL,
	`level` INT(11) NULL DEFAULT NULL,
	`workers` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`upgrade` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`durability` INT(11) NULL DEFAULT NULL,
	`sellprice` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`ID`) USING BTREE,
	UNIQUE INDEX `oilwell_id` (`oilwell_id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=63
;
