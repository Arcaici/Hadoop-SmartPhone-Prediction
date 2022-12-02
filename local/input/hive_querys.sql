--Create Phone Table
CREATE TABLE IF NOT EXISTS phone(battery_power INT, blue INT, clock_speed FLOAT, dual_sim INT, fc INT, four_g INT, int_memory INT, m_dep FLOAT, mobile_wt INT, n_cores INT, pc INT, px_height INT, px_width INT, ram INT, sc_h INT, sc_w INT, talk_time INT, three_g INT,  touch_screen INT, wifi INT, price_range INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

--Loading data into Phone Table
LOAD DATA INPATH  '/train.csv' INTO TABLE phone;

--Camera Range

--MegaPixel < 10
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_fc_10'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(fc), price_range FROM phone WHERE fc <= 10 GROUP BY price_range;

--MegaPixel > 10 and <= 15
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_fc_10_15' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(fc), price_range FROM phone WHERE fc > 10 AND fc <= 15 GROUP BY price_range;

--MegaPixel > 15
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_fc_m_15' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(fc), price_range FROM phone WHERE fc > 15 GROUP BY price_range;

--Ram Range

--Ram MB <= 500
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_ram_500' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(ram), price_range FROM phone WHERE ram <= 500 GROUP BY price_range;

--Ram MB > 500 and <= 1000
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_ram_500_1000' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(ram), price_range FROM phone WHERE ram > 500 AND ram <= 1000 GROUP BY price_range;

--Ram MB > 1000 and <= 2000
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_ram_1000_2000' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(ram), price_range FROM phone WHERE ram > 1000 AND ram <= 2000 GROUP BY price_range;

--Ram MB > 2000 and <= 3000
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_ram_2000_3000' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(ram), price_range FROM phone WHERE ram > 2000 AND ram <= 3000 GROUP BY price_range;

--Ram MB < 3000
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_ram_m_3000' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(ram), price_range FROM phone WHERE ram > 3000 GROUP BY price_range;

--Battery power Range mAh

--mAh >=500 and < 800
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_battery_power_500_800' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(battery_power), price_range FROM phone WHERE battery_power >= 500 AND battery_power < 800 GROUP BY price_range;

--mAh >=800 and < 1000
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_battery_power_800_1000' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(battery_power), price_range FROM phone WHERE battery_power >= 800 AND battery_power < 1000 GROUP BY price_range;

--mAh >=1000 and < 1200
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_battery_power_1000_1200' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(battery_power), price_range FROM phone WHERE battery_power >= 1000 AND ram < 1200 GROUP BY price_range;

--mAh >=1200 and < 1400
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_battery_power_1200_1400' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(battery_power), price_range FROM phone WHERE battery_power >= 1200 AND battery_power < 1400 GROUP BY price_range;

--mAh < 1400
INSERT OVERWRITE LOCAL DIRECTORY '/home/bigdata/server/price_battery_power_m_1400' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
SELECT COUNT(battery_power), price_range FROM phone WHERE battery_power >= 1400 GROUP BY price_range;

