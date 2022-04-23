CREATE TABLE bracelet (
    product_id     INTEGER NOT NULL,
    product_id2    INTEGER NOT NULL,
    product_name   VARCHAR2(40),
    product_weight FLOAT,
    commodity_type VARCHAR2(4000)
);

ALTER TABLE bracelet ADD CONSTRAINT bracelet_pk PRIMARY KEY ( product_id );

ALTER TABLE bracelet ADD CONSTRAINT bracelet_pkv1 UNIQUE ( product_id2 );

CREATE TABLE customer (
    customer_id      VARCHAR2(40) NOT NULL,
    customer_name    VARCHAR2(4000),
    customer_address VARCHAR2(40),
    purchase_type    VARCHAR2(4000),
    contact_details  VARCHAR2(40)
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( customer_id );

CREATE TABLE necklace (
    product_id     INTEGER NOT NULL,
    product_id2    INTEGER NOT NULL,
    product_name   VARCHAR2(40),
    product_weight FLOAT,
    commodity_type VARCHAR2(4000)
);

ALTER TABLE necklace ADD CONSTRAINT necklace_pk PRIMARY KEY ( product_id );

ALTER TABLE necklace ADD CONSTRAINT necklace_pkv1 UNIQUE ( product_id2 );

CREATE TABLE products (
    product_id     INTEGER NOT NULL,
    product_name   VARCHAR2(4000),
    product_type   VARCHAR2(8) NOT NULL,
    commodity_type VARCHAR2(4000),
    product_price  FLOAT
);

ALTER TABLE products
    ADD CONSTRAINT ch_inh_products CHECK ( product_type IN ( 'Bracelet', 'Necklace', 'Products', 'Ring' ) );

ALTER TABLE products ADD CONSTRAINT products_pk PRIMARY KEY ( product_id );

CREATE TABLE relation_1 (
    vendor_vendor_id    VARCHAR2(40) NOT NULL,
    products_product_id INTEGER NOT NULL
);

ALTER TABLE relation_1 ADD CONSTRAINT relation_1_pk PRIMARY KEY ( vendor_vendor_id,
                                                                  products_product_id );

CREATE TABLE relation_3 (
    products_product_id INTEGER NOT NULL,
    sales_invoice_no    INTEGER NOT NULL
);

ALTER TABLE relation_3 ADD CONSTRAINT relation_3_pk PRIMARY KEY ( products_product_id,
                                                                  sales_invoice_no );

CREATE TABLE relation_4 (
    customer_customer_id VARCHAR2(40) NOT NULL,
    service_service_id   INTEGER NOT NULL
);

ALTER TABLE relation_4 ADD CONSTRAINT relation_4_pk PRIMARY KEY ( customer_customer_id,
                                                                  service_service_id );

CREATE TABLE ring (
    product_id     INTEGER NOT NULL,
    product_id2    INTEGER NOT NULL,
    product_name   VARCHAR2(40),
    product_weight FLOAT,
    commodity_type VARCHAR2(4000)
);

ALTER TABLE ring ADD CONSTRAINT ring_pk PRIMARY KEY ( product_id );

ALTER TABLE ring ADD CONSTRAINT ring_pkv1 UNIQUE ( product_id2 );

CREATE TABLE sales (
    invoice_no           INTEGER NOT NULL,
    customer_id          VARCHAR2(40),
    customer_name        VARCHAR2(4000),
    purchase_items       VARCHAR2(4000),
    msrp                 FLOAT,
    discount             FLOAT,
    customer_customer_id VARCHAR2(40) NOT NULL,
    product_id           INTEGER
);

ALTER TABLE sales ADD CONSTRAINT sales_pk PRIMARY KEY ( invoice_no );

CREATE TABLE service (
    service_id          INTEGER NOT NULL,
    service_type        VARCHAR2(40),
    product_type        VARCHAR2(4000),
    problem_description VARCHAR2(4000),
    "Date_&_Time"       DATE,
    cost_of_service     FLOAT,
    sales_invoice_no    INTEGER NOT NULL,
    invoice_no          INTEGER NOT NULL
);

ALTER TABLE service ADD CONSTRAINT service_pk PRIMARY KEY ( service_id );

CREATE TABLE vendor (
    vendor_id    VARCHAR2(40) NOT NULL,
    vendor_name  VARCHAR2(4000),
    vendor_items VARCHAR2(40),
    product_id   INTEGER,
    product_name VARCHAR2(4000)
);

ALTER TABLE vendor ADD CONSTRAINT vendor_pk PRIMARY KEY ( vendor_id );

ALTER TABLE bracelet
    ADD CONSTRAINT bracelet_products_fk FOREIGN KEY ( product_id )
        REFERENCES products ( product_id );

ALTER TABLE necklace
    ADD CONSTRAINT necklace_products_fk FOREIGN KEY ( product_id )
        REFERENCES products ( product_id );

ALTER TABLE relation_1
    ADD CONSTRAINT relation_1_products_fk FOREIGN KEY ( products_product_id )
        REFERENCES products ( product_id );

ALTER TABLE relation_1
    ADD CONSTRAINT relation_1_vendor_fk FOREIGN KEY ( vendor_vendor_id )
        REFERENCES vendor ( vendor_id );

ALTER TABLE relation_3
    ADD CONSTRAINT relation_3_products_fk FOREIGN KEY ( products_product_id )
        REFERENCES products ( product_id );

ALTER TABLE relation_3
    ADD CONSTRAINT relation_3_sales_fk FOREIGN KEY ( sales_invoice_no )
        REFERENCES sales ( invoice_no );

ALTER TABLE relation_4
    ADD CONSTRAINT relation_4_customer_fk FOREIGN KEY ( customer_customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE relation_4
    ADD CONSTRAINT relation_4_service_fk FOREIGN KEY ( service_service_id )
        REFERENCES service ( service_id );

ALTER TABLE ring
    ADD CONSTRAINT ring_products_fk FOREIGN KEY ( product_id )
        REFERENCES products ( product_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_customer_fk FOREIGN KEY ( customer_customer_id )
        REFERENCES customer ( customer_id );

ALTER TABLE service
    ADD CONSTRAINT service_sales_fk FOREIGN KEY ( sales_invoice_no )
        REFERENCES sales ( invoice_no );

CREATE OR REPLACE TRIGGER arc_fkarc_1_ring BEFORE
    INSERT OR UPDATE OF product_id ON ring
    FOR EACH ROW
DECLARE
    d VARCHAR2(8);
BEGIN
    SELECT
        a.product_type
    INTO d
    FROM
        products a
    WHERE
        a.product_id = :new.product_id;

    IF ( d IS NULL OR d <> 'Ring' ) THEN
        raise_application_error(-20223, 'FK Ring_Products_FK in Table Ring violates Arc constraint on Table Products - discriminator column Product_Type doesn''t have value ''Ring''');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_1_necklace BEFORE
    INSERT OR UPDATE OF product_id ON necklace
    FOR EACH ROW
DECLARE
    d VARCHAR2(8);
BEGIN
    SELECT
        a.product_type
    INTO d
    FROM
        products a
    WHERE
        a.product_id = :new.product_id;

    IF ( d IS NULL OR d <> 'Necklace' ) THEN
        raise_application_error(-20223, 'FK Necklace_Products_FK in Table Necklace violates Arc constraint on Table Products - discriminator column Product_Type doesn''t have value ''Necklace''');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_1_bracelet BEFORE
    INSERT OR UPDATE OF product_id ON bracelet
    FOR EACH ROW
DECLARE
    d VARCHAR2(8);
BEGIN
    SELECT
        a.product_type
    INTO d
    FROM
        products a
    WHERE
        a.product_id = :new.product_id;

    IF ( d IS NULL OR d <> 'Bracelet' ) THEN
        raise_application_error(-20223, 'FK Bracelet_Products_FK in Table Bracelet violates Arc constraint on Table Products - discriminator column Product_Type doesn''t have value ''Bracelet''');
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/