CREATE TABLE promocode (
		id INT IDENTITY(1,1), 
		promocode VARCHAR(10),
		discount VARCHAR(4)
		PRIMARY KEY (id), 
		UNIQUE (promocode)
);