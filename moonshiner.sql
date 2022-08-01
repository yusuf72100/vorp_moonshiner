SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `moonshiner` (
  `id` int(10) UNSIGNED NOT NULL,
  `object` text NOT NULL DEFAULT '',
  `xpos` float NOT NULL,
  `ypos` float NOT NULL,
  `zpos` float NOT NULL,
  `actif` int(10) UNSIGNED DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `moonshiner`
  ADD PRIMARY KEY (`id`) USING BTREE;

ALTER TABLE `moonshiner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;

USE `vorpv2`;

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES
                    ('soborno', 'Soborno Alcohol', 15, 1, 'item_standard', 0),
                    ('water', 'Wasser', 15, 1, 'item_standard', 1),
	                ('pear', 'Birne', 15, 1, 'item_standard', 1),
                    ('currant', 'Johannisbeere', 20, 1, 'item_standard', 0),
                    ('apple', 'Apfel', 20, 1, 'item_standard', 1),
                    ('blackberry', 'Heidelbeere', 20, 1, 'item_standard', 0),
                    ('tropicalPunchMash', 'Tropical Punch Meische', 10, 1, 'item_standard', 0),
                    ('wildCiderMash', 'Wild Cider Meische', 10, 1, 'item_standard', 0),
                    ('appleCrumbMash', 'Apfel Beeren Meische', 10, 1, 'item_standard', 0),
                    ('tropicalPunchMoonshine', 'Tropical Punch Moonshine', 10, 1, 'item_standard', 0),
                    ('wildCiderMoonshine', 'Wild Cider Moonshine', 10, 1, 'item_standard', 0),
                    ('appleCrumbMoonshine', 'Apfel Beeren Moonshine', 10, 1, 'item_standard', 0),
                    ('mp001_p_mp_still02x', 'Brennerei', 1, 1, 'item_standard', 1),
                    ('p_boxcar_barrel_09a', 'Meische Fass', 1, 1, 'item_standard', 1),
	                ('vanillaFlower', 'Vanille Blume', 20, 1, 'item_standard', 0);

UPDATE `items`
SET `limit` = 15, `usable` = 0
WHERE `item` = 'soborno';

UPDATE `items`
SET `limit` = 15, `usable` = 1
WHERE `item` = 'water';

UPDATE `items`
SET `limit` = 15, `usable` = 1
WHERE `item` = 'pear';

UPDATE `items`
SET `limit` = 20, `usable` = 0
WHERE `item` = 'currant';

UPDATE `items`
SET `limit` = 20, `usable` = 1
WHERE `item` = 'apple';

UPDATE `items`
SET `limit` = 20, `usable` = 0
WHERE `item` = 'blackberry';

UPDATE `items`
SET `limit` = 10, `usable` = 0
WHERE `item` = 'tropicalPunchMash';

UPDATE `items`
SET `limit` = 10, `usable` = 0
WHERE `item` = 'wildCiderMash';

UPDATE `items`
SET `limit` = 10, `usable` = 0
WHERE `item` = 'tropicalPunchMoonshine';

UPDATE `items`
SET `limit` = 10, `usable` = 0
WHERE `item` = 'wildCiderMoonshine';

UPDATE `items`
SET `limit` = 10, `usable` = 0
WHERE `item` = 'appleCrumbMoonshine';

UPDATE `items`
SET `limit` = 1, `usable` = 1
WHERE `item` = 'mp001_p_mp_still02x';

UPDATE `items`
SET `limit` = 1, `usable` = 1
WHERE `item` = 'p_boxcar_barrel_09a';

UPDATE `items`
SET `limit` = 20, `usable` = 0
WHERE `item` = 'blackberry';

UPDATE `items`
SET `limit` = 20, `usable` = 0
WHERE `item` = 'vanillaFlower';
