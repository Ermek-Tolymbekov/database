--1
--a:
select course_id from course where credits > 3;
--b:
select building, room_number from classroom where building = 'Watson' or building = 'Packard';
--c:
select course_id from course where dept_name = 'Comp. Sci.';
--d:
select course_id from section where semester = 'Fall';
--e:
select name from student where tot_cred > 45 and tot_cred < 90;
--f:
select name from student
where name like '%a'
    or name like '%e'
    or name like '%i'
    or name like '%o'
    or name like '%y';
--g:
select course_id from prereq where prereq_id = 'CS-101';

--2
--a:
select dept_name, avg(salary) as avg_salary
    from instructor
    group by dept_name
    order by avg_salary asc ;

--b:
select building, count(course_id)
    from section
    group by building
    having count(course_id) = (
        select max(course_num)
        from(
            select building, count(course_id) as course_num
            from section
            group by building) as foo);

--c:
select dept_name, count(dept_name)
    from course
    group by dept_name
    having count(dept_name) = (
        select min(course_num)
        from(
            select dept_name, count(dept_name) as course_num
            from course
            group by dept_name) as foo);

--d:
select name
    from student
    where id = (
        select id
            from (
                 select id, count(id) as course_num
                    from takes,(select course.course_id
                        from course
                        where dept_name = 'Comp. Sci.')
                        as compsci
                    where takes.course_id = compsci.course_id
                    group by id
                    having count(id) > 3
                     ) as id_with_num
        );
        
--e:
select id, name from instructor
    where dept_name = 'Biology'
    or dept_name = 'Philosophy'
    or dept_name = 'Music';

