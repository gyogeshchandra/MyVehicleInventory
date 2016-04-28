CREATE TABLE inventory (                                                     
clientid INT UNSIGNED NOT NULL,
cname TEXT NOT NULL,
Vehicle TEXT NOT NULL,
Fcolor TEXT NOT NULL,
Scolor TEXT NOT NULL,
BookingAmount decimal(10,2) NOT NULL DEFAULT '0.00',                                      
Balance decimal(10,2) NOT NULL DEFAULT '0.00',                                    
FOREIGN KEY (clientid) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO `inventory` (clientid, cname, Vehicle, Fcolor,BookingAmount,Balance) VALUES (2, 'Yogesh', 'Wagon R','White',50000,150000);
INSERT INTO `inventory` (clientid, cname, Vehicle, Fcolor,BookingAmount,Balance) VALUES (3, 'Fariyad', 'Indica','Grey',40000,110000);