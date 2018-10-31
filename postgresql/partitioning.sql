CREATE OR REPLACE FUNCTION pns_call_records_partition_function()
  RETURNS trigger AS
$BODY$
DECLARE
	partition_date TEXT;
	partition TEXT;
BEGIN
	IF TG_OP='INSERT' THEN
		--NEW.PNS_CALL_RECORD_ID := SEQ_PNS_CALL_ALL_RECORD_ID.NEXTVAL;
		IF NEW.PNS_CALL_RECORD_DATE IS NULL THEN
		 	NEW.PNS_CALL_RECORD_DATE := NOW();
		END IF;
	END IF;

	IF TG_OP='INSERT' THEN

		partition_date := to_char(NEW.PNS_CALL_RECORD_DATE,'YYYY_MM_DD');
		partition := TG_RELNAME || '_' || partition_date;
		IF NOT EXISTS(SELECT relname FROM pg_class WHERE relname=partition) THEN       
			EXECUTE 'CREATE TABLE ' || partition || ' (check (PNS_CALL_RECORD_DATE = ''' || NEW.PNS_CALL_RECORD_DATE || ''')) INHERITS (' || TG_RELNAME || ');';
			EXECUTE 'ALTER TABLE ' || partition || ' OWNER TO indiamart';
			EXECUTE 'GRANT ALL PRIVILEGES ON TABLE ' || partition || ' TO indiamart';
		END IF;
		--EXECUTE 'INSERT INTO ' || partition || ' SELECT(' || TG_RELNAME || ' ' || quote_literal(NEW) || ').* RETURNING patent_id;';
		EXECUTE 'INSERT INTO ' || partition || ' VALUES ($1.*)' USING NEW;
		RETURN NULL;
	END IF;

END;
$BODY$
LANGUAGE plpgsql;
================================================================================================
DROP TRIGGER trg_pns_call_all_records ON PNS_CALL_RECORDS;
========================================================================================================
CREATE TRIGGER trg_pns_call_all_records
BEFORE INSERT ON PNS_CALL_RECORDS
FOR EACH ROW EXECUTE PROCEDURE pns_call_records_partition_function();



=========================================================================

create table map_query_glid(
map_query_id numeric(10,0),
map_query_rcv_glusr_usr_id numeric(10,0)
);
=================================================================================

CREATE OR REPLACE FUNCTION map_query_glid_partition_function()
  RETURNS TRIGGER AS
$BODY$
DECLARE
tablename text;
idx_name text;
consraint_name text;
recv_val numeric;
cnt numeric;
BEGIN

	IF TG_OP = 'INSERT' THEN
		tablename := 'map_query_glid_'||to_char(mod(NEW.map_query_id, 100),'fm00');

		idx_name := 'idx_map_query_glid_'||to_char(mod(NEW.map_query_id, 100),'fm00');

		consraint_name := 'constrnt_map_query_glid_'||to_char(mod(NEW.map_query_id, 100),'fm00');

		SELECT COUNT(1) INTO cnt 
		FROM   pg_catalog.pg_class c
		JOIN   pg_catalog.pg_namespace n ON n.oid = c.relnamespace
		WHERE  c.relkind = 'r'
		AND    c.relname = tablename
		AND    n.nspname = 'public';

		IF cnt = 0 THEN
			select mod(new.map_query_id, 100) into recv_val;

			EXECUTE 'CREATE TABLE ' || tablename || ' () INHERITS (map_query_glid)';
			EXECUTE 'ALTER TABLE ' || tablename || ' OWNER TO indiamart';
			EXECUTE 'ALTER TABLE ' || tablename || ' ADD CONSTRAINT '|| consraint_name ||' CHECK(map_query_id % 100= '|| recv_val ||' )';
			EXECUTE 'GRANT ALL PRIVILEGES ON TABLE ' || tablename || ' TO indiamart';
			EXECUTE 'CREATE INDEX '|| idx_name || ' ON '|| tablename ||' (map_query_id,map_query_rcv_glusr_usr_id)';
		END IF;

	EXECUTE 'INSERT INTO ' || tablename || ' VALUES ($1.*) ' USING NEW;
	RETURN NULL;
END IF;
END;
$BODY$
  LANGUAGE plpgsql;

====================================================================================================================================================================
CREATE TRIGGER trg_map_query_glid
  BEFORE INSERT
  ON map_query_glid
  FOR EACH ROW
  EXECUTE PROCEDURE map_query_glid_partition_function();



do
$$
declare
tab_name text;
begin
for i in 0..99 loop
	tab_name :='map_query_glid_'||to_char(mod(i, 100),'fm00');
	execute 'grant select,insert,update,delete on  '|| tab_name || ' to enquiry,astbuy,pns,leap,soa,weberp,gladmin';
end loop;
end;
$$
--------------------------------------

do
$$
declare
tab_name text;
trg_name text;
begin
for i in 0..0 loop
	tab_name :='dir_query_'||to_char(mod(i, 100),'fm00');
	trg_name :='trg_dir_query_update_'||to_char(mod(i, 100),'fm00');
	execute 'create trigger '||trg_name||' before update on '||tab_name||' for each row execute procedure fn_dir_quuery_update_on_child()';
end loop;
end;
$$
language plpgsql;


do
$$
declare
tab_name text;
trg_name text;
begin
for i in 31..35 loop
	tab_name :='dir_query_'||to_char(mod(i, 100),'fm00');
	trg_name :='trg_dir_query_update_'||to_char(mod(i, 100),'fm00');
	execute 'drop trigger '||trg_name||' on '||tab_name||' ';
end loop;
end;
$$
language plpgsql;


EXECUTE 'ALTER TABLE ' || tablename || ' ADD CONSTRAINT '|| constraint_name ||' CHECK(message_receiver_glusr_id % 100= '|| recv_val ||' )';



do
$$
declare
tab_name text;
constraint_name text;
begin
for i in 0..99 loop
	tab_name :='message_center_detail_'||to_char(mod(i, 100),'fm00');
	constraint_name :='chk_message_center_detail_'||to_char(mod(i, 100),'fm00');
	execute 'alter table'||tab_name||'  ADD CONSTRAINT '|| constraint_name ||' CHECK(message_receiver_glusr_id % 100= '||i||'';
end loop;
end;
$$
language plpgsql;


