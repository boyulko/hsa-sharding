create table customer_category
(
    id          bigint,
    name        varchar(200),
    category_id bigint
);

CREATE EXTENSION postgres_fdw;

-- first server
CREATE SERVER myserver FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'postgresql-b1', dbname 'postgres', port '5432');
CREATE USER MAPPING FOR postgres SERVER myserver OPTIONS (user 'postgres', password 'postgres');

-- first shard
create table customer_category
(
    id          bigint,
    name        varchar(200),
    category_id bigint,
    CONSTRAINT category_id_check CHECK ( category_id = 1 )
);

CREATE INDEX customer_category_id_idx ON customer_category USING btree (category_id);

-- second server
CREATE SERVER myserver2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'postgresql-b2', dbname 'postgres', port '5432');
CREATE USER MAPPING FOR postgres SERVER myserver2 OPTIONS (user 'postgres', password 'postgres');

-- second shard
create table customer_category
(
    id          bigint,
    name        varchar(200),
    category_id bigint,
    CONSTRAINT category_id_check CHECK ( category_id = 2 )
);

CREATE INDEX customer_category_id_idx ON customer_category USING btree (category_id);


CREATE VIEW customer_category_view AS
SELECT *
FROM customer_category_01
UNION ALL
SELECT *
FROM customer_category_02;

-- rules
CREATE RULE customer_category_insert AS ON INSERT TO customer_category
    DO INSTEAD NOTHING;
CREATE RULE customer_category_update AS ON UPDATE TO customer_category
    DO INSTEAD NOTHING;
CREATE RULE customer_category_delete AS ON DELETE TO customer_category
    DO INSTEAD NOTHING;

CREATE RULE customer_category_insert_to_1 AS ON INSERT TO customer_category
    WHERE (category_id = 1)
    DO INSTEAD INSERT INTO customer_category_01
               VALUES (NEW.*);

CREATE RULE customer_category_insert_to_2 AS ON INSERT TO customer_category
    WHERE (category_id = 2)
    DO INSTEAD INSERT INTO customer_category_02
               VALUES (NEW.*);
