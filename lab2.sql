/* Lab 2 */

/* Task 1. 3 DDL:*/
create table students(
    id integer,
    name varchar(20),
    surname varchar(40),
    faculty_id integer(5)
)

alter table students
    ADD COLUMN address varchar(20);

drop table students;

/* 3 DML */
insert into students(id, name, surname) value (10001, "Aaa", "Bbbb");

select * from students;

update students set name = "A", surname = "B" where id = 10001;

/* Task 2 */

create table customers(
    id  integer PRIMARY KEY ,
    full_name varchar(50) NOT NULL,
    timestamp timestamp NOT NULL,
    delivery_address text NOT NULL
);

create table products(
    id varchar(30) PRIMARY KEY ,
    name varchar(40) UNIQUE ,
    description text,
    price double precision CHECK ( price > 0 )
);

create table orders(
    code integer PRIMARY KEY ,
    customer_id integer REFERENCES customers(id),
    total_sum double precision NOT NULL CHECK ( total_sum > 0 ),
    is_paid boolean NOT NULL
);

create table order_items(
    order_code integer REFERENCES orders(code),
    product_id varchar REFERENCES products(id),
    quantity integer CHECK ( quantity > 0 )
);

/* Task 4 */

insert into customers(id, full_name, timestamp, delivery_address) values ( 1, 'Abcde', '2000-12-31', 'New_City st.Street');
insert into products values (1, 'Chair', 'comfortable', 399);
insert into orders values (1, 1, 399, true);
insert into order_items values (1, 1, 1);