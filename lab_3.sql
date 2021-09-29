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

--e
select id, name from instructor
    where dept_name = 'Biology'
    or dept_name = 'Philosophy'
    or dept_name = 'Music';

