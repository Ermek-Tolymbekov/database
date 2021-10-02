--1a:
select course_id
    from course
    where credits > 3;

--1b:
select building, room_number 
    from classroom 
    where building = 'Watson'
       or building = 'Packard';

--1c:
select course_id 
    from course
    where dept_name = 'Comp. Sci.';

--1d:
select course_id 
    from section 
    where semester = 'Fall';

--1e:
select name 
    from student 
    where tot_cred > 45
      and tot_cred < 90;

--1f:
select name
    from student
    where name like '%a'
       or name like '%e'
       or name like '%i'
       or name like '%o'
       or name like '%u'
       or name like '%y';

--1g:
select course_id
    from prereq
    where prereq_id = 'CS-101';

--2a:
select dept_name, avg(salary) as avg_salary
    from instructor
    group by dept_name
    order by avg_salary asc ;

--2b:
select building, count(course_id)
    from section
    group by building
    having count(course_id) = (
        select max(course_num)
        from(
            select building, count(course_id) as course_num
            from section
            group by building) as foo);

--2c:
select dept_name, count(dept_name)
    from course
    group by dept_name
    having count(dept_name) = (
        select min(course_num)
        from(
            select dept_name, count(dept_name) as course_num
            from course
            group by dept_name) as foo);

--2d:
select student.id, name
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
        
--2e:
select id, name from instructor
    where dept_name = 'Biology'
    or dept_name = 'Philosophy'
    or dept_name = 'Music';
    
--2f:
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
select name
    from student, (
        select id
        from takes, (
            select course_id
                from course
                where dept_name = 'Comp. Sci.'
            ) as compsci
        where (grade = 'A'
           or grade = 'A-')
            and takes.course_id = compsci.course_id
        group by id
        ) as ids
    where student.id = ids.id;
    
--3b:
select i_id
    from advisor,(select id from takes
        where grade <> 'A'
        and grade <> 'A-'
        and grade <> 'B+'
        and grade <> 'B'
        group by id) as stud_ids
    where advisor.s_id = stud_ids.id
    group by i_id;
    
--3c:
select dept_name
    from course, (
        select course_id from takes
            where grade <> 'F'
                and grade <> 'C'
            group by course_id)
        as sorted_courses
    where course.course_id = sorted_courses.course_id
    group by dept_name;

--3d:
select name from instructor
inner join (
    select teaches.id from teaches
    inner join takes
    on teaches.year = takes.year
        and teaches.semester = takes.semester
        and teaches.sec_id = takes.sec_id
        and teaches.course_id = takes.course_id
    except
    select teaches.id from teaches
    inner join takes
    on teaches.year = takes.year
        and teaches.semester = takes.semester
        and teaches.sec_id = takes.sec_id
        and teaches.course_id = takes.course_id
        where grade = 'A')
    as no_A_inst
on instructor.id = no_A_inst.id;

--3e:
select course_id from section
inner join time_slot
on section.time_slot_id = time_slot.time_slot_id
    where end_hr < 13
    group by course_id;
