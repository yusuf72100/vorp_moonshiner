SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `moonshiner_plants` (
  `id` int(10) UNSIGNED NOT NULL,
  `object` text NOT NULL DEFAULT '',
  `xpos` float NOT NULL,
  `ypos` float NOT NULL,
  `zpos` float NOT NULL,
  `cooldown` int(10) UNSIGNED DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `moonshiner_plants`
  ADD PRIMARY KEY (`id`) USING BTREE;

ALTER TABLE `moonshiner_plants`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;

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


INSERT INTO `moonshiner_plants` (`id`, `object`, `xpos`, `ypos`, `zpos`, `cooldown`) VALUES
  (1, 'alaskanginseng_p', -139.81, 1931.9, 255.269, 0),
  (2, 'alaskanginseng_p', -148.19, 1928.39, 254.8, 0),
  (3, 'alaskanginseng_p', -147.9, 1917.46, 253.23, 0),
  (4, 'alaskanginseng_p', -156.46, 1924.57, 253.49, 0),
  (5, 'alaskanginseng_p', -134.9, 1918.82, 254.26, 0),
  (6, 'alaskanginseng_p', -126.98, 1929.65, 255.2, 0),
  (7, 'ginseng_p', -1441.57, -1551.41, 88.44, 0),
  (8, 'ginseng_p', -1440.07, -1567.56, 89.01, 0),
  (9, 'ginseng_p', -1490.11, -1522.28, 93.64, 0),
  (10, 'ginseng_p', -1490.11, -1522.28, 93.64, 0),
  (11, 'ginseng_p', -1412.69, -1544.3, 85.81, 0),
  (12, 'ginseng_p', -1393.44, -1550.06, 84.95, 0),
  (13, 's_inv_baybolete01bx', -2046.48, -1498.77, 128.76, 0),
  (14, 's_inv_baybolete01bx', -2043.81, -1487.83, 127.51, 0),
  (15, 's_inv_baybolete01bx', -2036.59, -1489.84, 125.56, 0),
  (16, 's_inv_baybolete01bx', -2031.76, -1506, 123.91, 0),
  (17, 'blackcurrant_p', -5169.28, -2565.08, -9.94, 0),
  (18, 'blackcurrant_p', -5182.47, -2565.79, -8.14, 0),
  (19, 'blackcurrant_p', -5189.39, -2564.81, -7.58, 0),
  (20, 'blackcurrant_p', -5192.56, -2570.35, -6.86, 0),
  (21, 'blackcurrant_p', -5173.05, -2559.49, -9.64, 0),
  (22, 's_inv_huckleberry01x', 2396.58, 1021.06, 89.35, 0),
  (23, 's_inv_huckleberry01x', 2395.36, 1004.37, 87.31, 0),
  (24, 's_inv_huckleberry01x', 2389.55, 1029.9, 89.35, 0),
  (25, 's_inv_huckleberry01x', 2378.31, 1025.52, 89.35, 0),
  (26, 's_inv_huckleberry01x', 2357.28, 860.63, 77.58, 0),
  (27, 's_inv_huckleberry01x', 2383.94, 867.17, 74.44, 0),
  (28, 's_inv_huckleberry01x', 2367.73, 848.99, 77.77, 0),
  (29, 's_inv_huckleberry01x', 2352.81, 853.82, 79.62, 0),
  (30, 'wildmint_p', -2781.61, -7.44, 154.7, 0),
  (31, 'wildmint_p', -2774.35, -29.88, 152.95, 0),
  (32, 'wildmint_p', -2785.41, 5.94, 155.35, 0),
  (33, 'wildmint_p', -2778.72, 11.01, 155.39, 0),
  (34, 'wildmint_p', -2766.75, -4.64, 154.39, 0),
  (35, 'wildmint_p', -2800.75, -41.03, 155.2, 0),
  (36, 'wildmint_p', -2799.97, -55.82, 155.25, 0),
  (37, 'wildmint_p', -2812.37, -41.92, 156.19, 0),
  (38, 'wildmint_p', -2809.4, -38.57, 156.09, 0),
  (39, 's_inv_blackberry01x', -669.59, 282.33, 89.22, 0),
  (40, 's_inv_blackberry01x', -1016.87, 197.81, 85.76, 0),
  (41, 's_inv_blackberry01x', -1023.06, 194.34, 87.56, 33),
  (42, 's_inv_blackberry01x', -1015.04, 190.29, 86.27, 0),
  (43, 's_inv_blackberry01x', -1027.94, 181.45, 89.29, 0),
  (44, 's_inv_blackberry01x', -1030.86, 198.4, 87.3, 43),
  (45, 's_inv_blackberry01x', -669.87, 261.07, 90, 0),
  (46, 's_inv_blackberry01x', -662.48, 271.38, 89.9, 0),
  (47, 's_inv_blackberry01x', -655.7, 264.41, 90.11, 0),
  (48, 's_inv_blackberry01x', -659.28, 285.87, 89.42, 0),
  (49, 's_inv_blackberry01x', -645.99, 281.11, 89.78, 0),
  (50, 's_inv_raspberry01x', 28.92, 483.13, 160.06, 0),
  (51, 's_inv_raspberry01x', 40.92, 484.13, 158.56, 0),
  (52, 's_inv_raspberry01x', 32.92, 470.13, 156.93, 0),
  (53, 's_inv_raspberry01x', 9, 486.13, 158.24, 0),
  (54, 's_inv_raspberry01x', -9, 519.13, 152.73, 0),
  (55, 's_inv_raspberry01x', -19, 554.13, 135.02, 0);

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
