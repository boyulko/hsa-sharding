create table customer
(
    id       bigint,
    name     varchar(200),
    birthday date
);

CREATE TABLE customer_01
(
    CHECK (birthday >= to_date('1919-01-01', 'yyyy-MM-dd') AND birthday <= to_date('1961-01-31', 'yyyy-MM-dd'))
) INHERITS (customer);



CREATE TABLE customer_02
(
    CHECK (birthday >= to_date('1961-02-01', 'yyyy-MM-dd') AND birthday <= to_date('2019-02-28', 'yyyy-MM-dd'))
) INHERITS (customer);


CREATE OR REPLACE FUNCTION customer_insert_trigger()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (NEW.birthday >= to_date('1919-01-01', 'yyyy-MM-dd') AND
        NEW.birthday <= to_date('1961-01-31', 'yyyy-MM-dd')) THEN
        INSERT INTO customer_01 VALUES (NEW.*);
    ELSIF (NEW.birthday >= to_date('1961-02-01', 'yyyy-MM-dd') AND
           NEW.birthday <= to_date('2019-02-28', 'yyyy-MM-dd')) THEN
        INSERT INTO customer_02 VALUES (NEW.*);
    ELSE
        RAISE EXCEPTION 'Date out of range!';
    END IF;
    RETURN NULL;
END;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER insert_customer_trigger
    BEFORE INSERT
    ON customer
    FOR EACH ROW
EXECUTE PROCEDURE customer_insert_trigger();
