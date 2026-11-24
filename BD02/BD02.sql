
CREATE DATABASE gym_database;

USE gym_database;

CREATE TABLE CLIENT (
    client_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    email VARCHAR(254) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (client_id),
    CONSTRAINT uq_client_email UNIQUE (email)
);

CREATE TABLE EQUIPMENT (
    equipment_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    category ENUM('Free Weight', 'Cardio', 'Strength') NOT NULL,
    availability BOOLEAN NOT NULL DEFAULT TRUE,
    quantity INT NOT NULL,
    PRIMARY KEY (equipment_id),
    CONSTRAINT chk_equipment_quantity_positive
        CHECK (quantity > 0)
);

CREATE TABLE RENT (
    rent_id INT AUTO_INCREMENT,
    client_id INT NOT NULL,
    equipment_id INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME DEFAULT NULL,
    PRIMARY KEY (rent_id),
    CONSTRAINT fk_rent_client
        FOREIGN KEY (client_id)
        REFERENCES CLIENT(client_id),
    CONSTRAINT fk_rent_equipment
        FOREIGN KEY (equipment_id)
        REFERENCES EQUIPMENT(equipment_id)
);

ALTER TABLE EQUIPMENT
ADD COLUMN tier ENUM('Free', 'Normal', 'Premium');

ALTER TABLE EQUIPMENT
ADD CONSTRAINT chk_equipment_quantity_min_3
CHECK (quantity >= 3);

ALTER TABLE CLIENT
ADD CONSTRAINT chk_registration_date
CHECK (registration_date > '2026-03-13');

ALTER TABLE RENT
ADD CONSTRAINT chk_rent_start_time
CHECK (
    TIME(start_date) BETWEEN '06:00:00' AND '21:00:00'
);

ALTER TABLE EQUIPMENT
DROP CHECK chk_equipment_quantity_positive;

ALTER TABLE CLIENT
DROP COLUMN phone_number;

ALTER TABLE EQUIPMENT
ADD CONSTRAINT uq_equipment_name
UNIQUE (name);

ALTER TABLE RENT
DROP PRIMARY KEY,
ADD PRIMARY KEY (client_id, equipment_id),
ADD CONSTRAINT uq_rent_id UNIQUE (rent_id);

ALTER TABLE RENT
ADD COLUMN active_client_id INT
GENERATED ALWAYS AS (
    CASE
        WHEN end_date IS NULL THEN client_id
        ELSE NULL
    END
) STORED;

CREATE UNIQUE INDEX idx_one_active_rent
ON RENT (active_client_id);

RENAME TABLE CLIENT TO MEMBER;

DROP TABLE RENT;

CREATE USER 'carms'@'localhost'
IDENTIFIED BY 'holacaracola123';

GRANT SELECT, INSERT
ON gym_database.EQUIPMENT
TO 'carms'@'localhost';

SELECT DATABASE();

SHOW TABLES;

DESCRIBE EQUIPMENT;

DESCRIBE MEMBER;

SHOW CREATE TABLE EQUIPMENT;

SHOW CREATE TABLE MEMBER;


