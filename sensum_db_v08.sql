﻿-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-resolution, multi-temporal database model 
-- Version: 0.8
-- Date: 20.09.13
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Adds the basic data model to a PostGIS 2.0 supported database.  
--		To activate multi-resolution support run sensum_db_v08_AddMultiResolutionSupport.sql. 
--		To activate multi-temporal support run sensum_db_v08_AddMultiTemporalSupport.sql.
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE SCHEMA taxonomy;

CREATE SCHEMA object;

CREATE SCHEMA history;

CREATE SEQUENCE taxonomy.dic_attribute_type_gid_seq5 START WITH 1;

CREATE SEQUENCE taxonomy.dic_attribute_value_gid_seq5 START WITH 1;

CREATE SEQUENCE taxonomy.dic_qualifier_type_gid_seq5 START WITH 1;

CREATE SEQUENCE taxonomy.dic_qualifier_value_gid_seq5 START WITH 1;

CREATE SEQUENCE taxonomy.dic_taxonomy_gid_seq5 START WITH 1;

CREATE SEQUENCE taxonomy.hazard_gid_seq5 START WITH 1;

CREATE SEQUENCE object.main_detail_gid_seq5 START WITH 1;

CREATE SEQUENCE object.main_gid_seq6 START WITH 1;

CREATE SEQUENCE object.main_detail_qualifier_gid_seq6 START WITH 1;

CREATE SEQUENCE history.logged_actions_gid_seq START WITH 1;

CREATE TABLE taxonomy.dic_qualifier_type ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_qualifier_type PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_qualifier_type UNIQUE ( code )
 );

COMMENT ON TABLE taxonomy.dic_qualifier_type IS 'The qualifier type dictionary table. Contains information about the qualifier types.';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.gid IS 'Unique qualifier type identifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.code IS 'Code of the qualifier type';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.description IS 'Short textual description of the qualifier type';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.extended_description IS 'Extended textual description of the qualifier type';

CREATE TABLE taxonomy.dic_qualifier_value ( 
	gid                  serial NOT NULL,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_dic_qualifier_value PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_qualifier_value_0 UNIQUE ( qualifier_value )
 );

CREATE INDEX idx_dic_qualifier_value ON taxonomy.dic_qualifier_value ( qualifier_type_code );

COMMENT ON TABLE taxonomy.dic_qualifier_value IS 'The qualifier value dictionary table. Contains information about the qualifier values.';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.gid IS 'Unique qualifier value identifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.qualifier_type_code IS 'Code of the qualifier type to which the value refers to';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.qualifier_value IS 'Value of the qualifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.description IS 'Short textual description of the qualifier value';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.extended_description IS 'Extended textual description of the qualifier value';

CREATE TABLE taxonomy.dic_taxonomy ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	version_date         date,
	CONSTRAINT pk_dic_taxonomy PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_taxonomy_0 UNIQUE ( code )
 );

COMMENT ON TABLE taxonomy.dic_taxonomy IS 'The taxonomy dictionary table. Contains information about the taxonomy to which the attribute type is linked to.';

COMMENT ON COLUMN taxonomy.dic_taxonomy.gid IS 'Unique taxonomy identifier';

COMMENT ON COLUMN taxonomy.dic_taxonomy.code IS 'Code of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.description IS 'Short textual description of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.extended_description IS 'Extended textual description of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.version_date IS 'Version of the taxonomy (date of the version)';

CREATE TABLE taxonomy.dic_attribute_type ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	taxonomy_code        varchar( 254 ),
	attribute_level      smallint,
	attribute_order      smallint,
	CONSTRAINT pk_dic_attribute_type PRIMARY KEY ( gid ),
	CONSTRAINT idx_dic_attribute_type UNIQUE ( code )
 );

CREATE INDEX idx_dic_attribute_type_0 ON taxonomy.dic_attribute_type ( taxonomy_code );

COMMENT ON TABLE taxonomy.dic_attribute_type IS 'The attribute type dictionary table. Contains information about the attribute types.';

COMMENT ON COLUMN taxonomy.dic_attribute_type.gid IS 'Unique attribute type identifier';

COMMENT ON COLUMN taxonomy.dic_attribute_type.code IS 'Code of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.description IS 'Short textual description of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.extended_description IS 'Extended textual description of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.taxonomy_code IS 'Code of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_attribute_type.attribute_level IS 'Identifier of the attribute level (e.g. GEM taxonomy: 1 = main attribute, 2 = secondary attribute, 3 = tertiary attribute)';

COMMENT ON COLUMN taxonomy.dic_attribute_type.attribute_order IS 'Order of the attribute type. To be used for compiling a textual representation of the taxonomy attributes and their values which follows a predefined order (e.g. GEM Taxonomy TaxT strings)';

CREATE TABLE taxonomy.dic_attribute_value ( 
	gid                  serial NOT NULL,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_dic_attribute_value PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_attribute_value_0 UNIQUE ( attribute_value )
 );

CREATE INDEX idx_dic_attribute_value ON taxonomy.dic_attribute_value ( attribute_type_code );

COMMENT ON TABLE taxonomy.dic_attribute_value IS 'The attribute value dictionary table. Contains information about the attribute values.';

COMMENT ON COLUMN taxonomy.dic_attribute_value.gid IS 'Unique attribute value identifier';

COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_type_code IS 'Code of the attribute type to which the value refers to';

COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_value IS 'Value of the attribute';

COMMENT ON COLUMN taxonomy.dic_attribute_value.description IS 'Short textual description of the attribute value';

COMMENT ON COLUMN taxonomy.dic_attribute_value.extended_description IS 'Extended textual description of the attribute value';

CREATE TABLE taxonomy.dic_hazard ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	attribute_type_code  varchar( 254 ),
	CONSTRAINT pk_hazard PRIMARY KEY ( gid )
 );

CREATE INDEX idx_hazard ON taxonomy.dic_hazard ( attribute_type_code );

COMMENT ON TABLE taxonomy.dic_hazard IS 'The hazard dictionary table. Contains information about the hazard type to which the taxonomy attribute type is linked to.';

COMMENT ON COLUMN taxonomy.dic_hazard.gid IS 'Unique hazard identifier';

COMMENT ON COLUMN taxonomy.dic_hazard.code IS 'Identifier for the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.description IS 'Short textual description of the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.extended_description IS 'Extended textual description of the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.attribute_type_code IS 'Code of the taxonomy attribute type to which the hazard type is linked to';

CREATE TABLE object.main ( 
	gid                  serial NOT NULL,
	survey_gid           integer,
	description          varchar( 254 ),
	source               text,
	resolution           integer,
	CONSTRAINT pk_main_0 PRIMARY KEY ( gid )
 );

COMMENT ON TABLE object.main IS 'The main object table. Contains basic information about the object.';

COMMENT ON COLUMN object.main.gid IS 'Unique object identifier';

COMMENT ON COLUMN object.main.survey_gid IS 'Identifier for the survey';

COMMENT ON COLUMN object.main.description IS 'Textual description of the object';

COMMENT ON COLUMN object.main.source IS 'Source of the object content (e.g. remote sensing, in-situ)';

COMMENT ON COLUMN object.main.resolution IS 'Identifier for the spatial resolution (e.g. 1 = local, 2 = regional, 3 = national)';

CREATE TABLE object.main_detail ( 
	gid                  serial NOT NULL,
	object_id            integer,
	resolution2_id       integer,
	resolution3_id       integer,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	attribute_numeric_1  numeric,
	attribute_numeric_2  numeric,
	attribute_text_1     varchar( 254 ),
	the_geom             geometry,
	CONSTRAINT pk_object PRIMARY KEY ( gid )
 );

CREATE INDEX pk_main ON object.main_detail ( attribute_type_code );

CREATE INDEX idx_main ON object.main_detail ( attribute_value );

CREATE INDEX idx_main_detail ON object.main_detail ( object_id );

COMMENT ON TABLE object.main_detail IS 'The main object detail table. Contains information about the object details.';

COMMENT ON COLUMN object.main_detail.gid IS 'Unique object detail identifier';

COMMENT ON COLUMN object.main_detail.object_id IS 'Object identifier';

COMMENT ON COLUMN object.main_detail.resolution2_id IS 'gid of the object detail at resolution level 2 (e.g. regional scale)';

COMMENT ON COLUMN object.main_detail.resolution3_id IS 'gid of the object detail at resolution level 3 (e.g. national scale)';

COMMENT ON COLUMN object.main_detail.attribute_type_code IS 'Code of the taxonomy attribute type';

COMMENT ON COLUMN object.main_detail.attribute_value IS 'Value of the taxonomy attribute type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object.main_detail.attribute_numeric_1 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object.main_detail.attribute_numeric_2 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object.main_detail.attribute_text_1 IS 'Value of the taxonomy attribute type (textual)';

COMMENT ON COLUMN object.main_detail.the_geom IS 'Spatial reference and geometry information';

CREATE TABLE object.main_detail_qualifier ( 
	gid                  serial NOT NULL,
	detail_id            integer,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	qualifier_numeric_1  numeric,
	qualifier_text_1     varchar( 254 ),
	qualifier_timestamp_1 timestamptz,
	qualifier_timestamp_2 timestamptz,
	CONSTRAINT pk_main_detail_qualifier PRIMARY KEY ( gid )
 );

CREATE INDEX idx_main_detail_qualifier ON object.main_detail_qualifier ( detail_id );

CREATE INDEX idx_main_detail_qualifier_0 ON object.main_detail_qualifier ( qualifier_type_code );

CREATE INDEX idx_main_detail_qualifier_1 ON object.main_detail_qualifier ( qualifier_value );

COMMENT ON TABLE object.main_detail_qualifier IS 'The main object detail qualifier table. Contains information about the object qualifiers.';

COMMENT ON COLUMN object.main_detail_qualifier.gid IS 'Unique object detail qualifier identifier';

COMMENT ON COLUMN object.main_detail_qualifier.detail_id IS 'Object detail identifier';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_type_code IS 'Code of the taxonomy qualifier type';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_value IS 'Value of the taxonomy qualifier type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_numeric_1 IS 'Value of the taxonomy qualifier type (numeric)';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_text_1 IS 'Value of the taxonomy qualifier type (textual)';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_timestamp_1 IS 'Value of the taxonomy qualifier type (timestamp)';

COMMENT ON COLUMN object.main_detail_qualifier.qualifier_timestamp_2 IS 'Value of the taxonomy qualifier type (timestamp)';

CREATE TABLE history.logged_actions ( 
	gid                  bigserial NOT NULL,
	schema_name          text NOT NULL,
	table_name           text NOT NULL,
	table_id             oid NOT NULL,
	transaction_id       bigint,
	transaction_time     timestamptz NOT NULL,
	transaction_user     text,
	transaction_query    text,
	transaction_type     text NOT NULL,
	old_record           hstore,
	new_record           hstore,
	changed_fields       hstore,
	CONSTRAINT logged_actions_pkey PRIMARY KEY ( gid )
 );

ALTER TABLE history.logged_actions ADD CONSTRAINT logged_actions_transaction_type_check CHECK ( transaction_type = ANY (ARRAY['I'::text, 'D'::text, 'U'::text, 'T'::text]) );

CREATE INDEX logged_changes_action_idx ON history.logged_actions ( transaction_type );

CREATE INDEX logged_changes_table_id_idx ON history.logged_actions ( table_id );

COMMENT ON TABLE history.logged_actions IS 'History of transactions on activated tables, from history.if_modified_func().';

COMMENT ON COLUMN history.logged_actions.gid IS 'Unique log identifier';

COMMENT ON COLUMN history.logged_actions.schema_name IS 'Textual reference to the database schema which contains the modified table';

COMMENT ON COLUMN history.logged_actions.table_name IS 'Name of the modified table';

COMMENT ON COLUMN history.logged_actions.table_id IS 'OID of the modified table';

COMMENT ON COLUMN history.logged_actions.transaction_id IS 'Identifier of the transaction (may differ from gid when more than one row is affected by a transaction query)';

COMMENT ON COLUMN history.logged_actions.transaction_time IS 'Timestamp when transaction was started (current_timestamp)';

COMMENT ON COLUMN history.logged_actions.transaction_user IS 'Session user name who caused the transaction';

COMMENT ON COLUMN history.logged_actions.transaction_query IS 'Transaction query';

COMMENT ON COLUMN history.logged_actions.transaction_type IS 'Transaction type (I = insert, D = delete, U = update, T = truncate)';

COMMENT ON COLUMN history.logged_actions.old_record IS 'The old record before the modification containing all the values as hstore (for DELETE and UPDATE statements)';

COMMENT ON COLUMN history.logged_actions.new_record IS 'The new record after the modification containing all the values as hstore (for INSERT and UPDATE statements)';

COMMENT ON COLUMN history.logged_actions.changed_fields IS 'The modified fields only, including the new values, stored as hstore';

ALTER TABLE taxonomy.dic_attribute_type ADD CONSTRAINT fk_dic_attribute_type FOREIGN KEY ( taxonomy_code ) REFERENCES taxonomy.dic_taxonomy( code );

ALTER TABLE taxonomy.dic_attribute_value ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE taxonomy.dic_hazard ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE taxonomy.dic_qualifier_value ADD CONSTRAINT fk_dic_qualifier_value FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

ALTER TABLE object.main_detail ADD CONSTRAINT fk_attribute_type FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE object.main_detail ADD CONSTRAINT fk_attribute_value FOREIGN KEY ( attribute_value ) REFERENCES taxonomy.dic_attribute_value( attribute_value );

ALTER TABLE object.main_detail ADD CONSTRAINT fk_object_gid FOREIGN KEY ( object_id ) REFERENCES object.main( gid );

ALTER TABLE object.main_detail_qualifier ADD CONSTRAINT fk_detail_gid FOREIGN KEY ( detail_id ) REFERENCES object.main_detail( gid );

ALTER TABLE object.main_detail_qualifier ADD CONSTRAINT fk_qualifier_value FOREIGN KEY ( qualifier_value ) REFERENCES taxonomy.dic_qualifier_value( qualifier_value );

ALTER TABLE object.main_detail_qualifier ADD CONSTRAINT fk_qualifier_type_code FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

