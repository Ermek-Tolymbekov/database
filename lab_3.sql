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
select student.id, name from student
inner join(
    select id from takes
    inner join course
    on takes.course_id = course.course_id
        where dept_name = 'Comp. Sci.'
        group by id
        having count(id) > 3)
        as course_stud
on student.id = course_stud.id;
        
--e:
select id, name from instructor
    where dept_name = 'Biology'
    or dept_name = 'Philosophy'
    or dept_name = 'Music';
    
--f:
select name from instructor
inner join teaches
on instructor.id = teaches.id
    where year = 2018
    group by name
except
select name from instructor
inner join teaches
on instructor.id = teaches.id
    where year = 2017
    group by name;

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
select i_id from advisor
inner join takes
on advisor.s_id = takes.id
    where grade <> 'A'
    and grade <> 'A-'
    and grade <> 'B+'
    and grade <> 'B'
    group by i_id;
