CREATE TABLE A( A1 INTEGER PRIMARY KEY, A2 VARCHAR(100));
CREATE TABLE B( B1 INTEGER PRIMARY KEY, B2 INTEGER, B3 VARCHAR(100), FOREIGN KEY (B2) REFERENCES A(A1) );
