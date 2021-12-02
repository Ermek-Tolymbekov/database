--1
--a
create function inc(x int)
returns int as
    $$
    begin
    return x + 1;
    end;
    $$
language plpgsql;

--b
create function sum_of(a int, b int)
returns int as
    $$
    begin
    return a + b;
    end;$$
language plpgsql;

--c
create function div_2(x int)
returns bool as
    $$
    begin
    if x % 2 = 0
        then return true;
    else return false;
    end if;
    end;$$
language plpgsql;

--d
create or replace function password(x varchar)
returns bool as
    $$
    begin
    if length(x) < 8
        then return false;
    else return true;
    end if;
    end;$$
language plpgsql;

--e
create function func(x int,
    out prev int,
    out next int)
as
    $$
    begin
    prev := x - 1;
    next := x + 1;
    end;$$
language plpgsql;

--2
--a
create table data(
    id int,
    name varchar(20),
    primary key (id)
);
create table data_audit(
    changed_id int not null,
    operation varchar(8),
    change_data timestamp not null
);

create or replace function data_insert()
    returns trigger as
    $$
    begin
        insert into data_audit values(new.id, 'inserted', now());
        return new;
    end;
    $$
language plpgsql;

create or replace function data_update()
    returns trigger as
    $$
    begin
        if new.name <> old.name
            then insert into data_audit
            values (old.id, 'updated', now());
        end if;
        return new;
    end;
    $$
language plpgsql;

create or replace function data_delete()
    returns trigger as
    $$
    begin
        insert into data_audit
            values (old.id, 'deleted', now());
        return old;
    end;
    $$
language plpgsql;

create trigger data_inserted after insert on data
    for each row execute function data_insert();

create trigger data_updated before update on data
    for each row execute function data_update();

create trigger data_deleted before delete on data
    for each row execute function data_delete();

insert into data values (1, 'abc');
update data set name = 'bcd'
	where id = 1;
delete from data 
	where id = 1;
select * from data_audit;

--c
create table item(
    id int,
    name varchar(20),
    price int,
    primary key(id)
);

create function tax()
    returns trigger as
    $$
    begin
        new.price = new.price * 1.12;
    return new;
    end;$$
language plpgsql;

create trigger tax before insert on item
    for each row execute function tax();

insert into item values (111, 'phone', 1000);

--d
create table table_1(
    id int,
    inf varchar(10),
    primary key (id)
);
create table table_2(
    id int,
    inf varchar(10),
    primary key (id)
);
create function prevent()
    returns trigger as $$
    begin
        return null;
    end;$$
language plpgsql;

create trigger prevent before delete on table_1
    for each row execute function prevent();

insert into table_1 values (1, 'asd');
insert into table_2 values (2, 'cde');
delete from table_1 where id = 1;
delete from table_2 where id = 2;
select * from table_1;
select * from table_2;