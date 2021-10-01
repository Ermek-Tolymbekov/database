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
    from student, (
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
        ) as stud_id
    where student.id = stud_id.id;
        
--e:
select id, name from instructor
    where dept_name = 'Biology'
    or dept_name = 'Philosophy'
    or dept_name = 'Music';
    
--f:
select name from instructor,(
    select id from teaches
    where year = 2018
    group by id) as id_2018
    where instructor.id = id_2018.id
except
select name from instructor,(
    select id from teaches
    where year = 2017
    group by id) as id_2017
    where instructor.id = id_2017.id;

--3a:
select name from student
inner join
(select id from takes
    inner join course
    on takes.course_id = course.course_id
    where dept_name = 'Comp. Sci.'
        and (grade = 'A'
        or grade = 'A-')
group by id) as ids
on student.id = ids.id;
    
--b:
select i_id
    from advisor,(select id from takes
        where grade <> 'A'
        and grade <> 'A-'
        and grade <> 'B+'
        and grade <> 'B'
        group by id) as stud_ids
    where advisor.s_id = stud_ids.id
    group by i_id;
