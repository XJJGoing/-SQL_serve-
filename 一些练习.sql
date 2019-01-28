
----------------------实验二到实验六--------------------------
----------------------实验七到实验十五往后拉-------------------
-------------------------创建数据库------------------------

USE EDUC
create database EDUC
on primary
(
name='STU_data',
filename='C:\Users\14997\Desktop\语言极其数据库\SQL\STU_DATA.mdf',
size=5mb,
maxsize=100mb,
filegrowth=15%
)

log on
(
name='STU_log',
filename='C:\Users\14997\Desktop\语言极其数据库\SQL\STU_LOG.ldf',
size=10mb,
maxsize=200mb,
filegrowth=20mb
)
--------------------数据库的删除------------------------
DROP DATABASE EDUC

----------------------利用已经创建好的数据库的操作----------------
USE EDUC

----------------------创建所需要的表的操作------------------------
--创建学生表
create table Student
(
   sno int  not null primary key,
   sName nvarchar(15),
   sGender bit not null  default(1) ,--默认1为男生 0为女生
   sBirthy date, 
   sPhone char(11),
   sdept char(20),
)

---查看表中的约束--
sp_helpconstraint Student

--建立学生课程表
create table Course
(
cno int not null primary key,
cName nvarchar(15) not null,
);

--建立学生的选课表
create table SC
(
 sno int,
 cno int,
 Grade smallint,
 primary key(sno,cno),
 foreign key(sno) references Student(sno),
 foreign key(cno) references Course(cno)
);

---------------查看已经建立的表的操作-------------
select *from Student
select *from Course
select *from SC

drop table Student
drop table Course 
drop table SC


---------------对表进行数据的插入操作--------------

insert into Student(sno,sName,sGender,sBirthy,sPhone,sdept)
values
(201,'李白',1,'1999-05-26','18012821234','青龙系'),
(202,'韩信',1,'1999-06-26','18012821243','青龙系'),
(203,'蔡文姬',0,'1999-07-28','18012821894','朱雀系'),
(204,'明世隐',1,'1998-05-25','18012821789','白虎系'),
(205,'赵云',1,'1997-05-26','18012821523','青龙系'),
(206,'张飞',1,'1994-05-26','18012821896','白虎系'),
(207,'关羽',1,'1994-05-29','18012821134','玄武系'),
(208,'花木兰',0,'1993-05-26','18012821245','朱雀系'),
(209,'兰陵王',1,'1993-05-26','18012821263','玄武系'),
(210,'王昭君',0,'1999-07-26','18012821984','朱雀系'),
(211,'虞姬',0,'1999-03-26','18012821222','朱雀系')


insert into Course(cno,cName)
values
(123,'数据库'),
(124,'C++'),
(128,'C#'),
(129,'Node.JS'),
(130,'Python')

insert into SC(sno,cno,Grade)
values
(201,123,98),
(201,124,88),
(201,128,97),
(202,124,99),
(202,129,77),
(202,130,67),
(203,128,88),
(203,123,77),
(204,129,78),
(204,130,87),
(204,123,99),
(205,130,98),
(205,129,55),
(206,129,89),
(206,128,44),
(207,130,78),
(207,124,77),
(208,128,90),
(208,124,89),
(208,123,45),
(208,129,78),
(209,123,75),
(210,128,55),
(210,123,88),
(211,128,77)



------------------------索引的基本创建与删除----------------------

--对SC中的成绩列进行索引的创建
create index SCCC ON SC(Grade DESC)
create index STTT on Student(sname desc)
create unique index SGGG on Course(cname)
create index SCT on SC(sno ASC)
create index SCC on SC(Grade desc) 


--修改索引名称
exec sp_rename 'SC.SCCC','SDDD','index' 

--删除索引
drop index SCC on SC
drop index SCT on SC
drop index SGGG on Course
drop index STTT on Student



------------------------------7到15的实验--------------------------

----------------------简单的select语句
select *from Student
select *from SC
select *from Course
---题目：
--① 求青龙系系的学生学号和姓名；
select sno,Sname
from Student
where sdept='青龙系'
--② 求选修了课程的学生学号；
select distinct sno
from SC
where cno is not null
--③求选修数据库课程的学生学号和成绩，并要求对查询结果按成绩的降序排列，如果成绩相同则按学号的升序排列；
select sno,Grade
from SC,Course
where SC.cno=Course.cno and
Course.cname='数据库'
order by Grade desc,sno asc

--④求选修课程数据库课程且成绩在80－90 之间的学生学号和成绩，并将成绩乘以系数0.75 输出；
select sno,Grade,(Grade)*0.75 as 输出 
from SC,Course
where SC.cno=Course.cno and Course.cname='数据库'
and Grade between 80 and 90

select *from Student
--⑤ 求青龙系系和白虎系的姓张的学生的信息；
select *
from Student
where sdept in('青龙系','白虎系') and sName like '张%'

--⑥ 求缺少了成绩的学生的学号和课程号：
--先弄一个空值出来
select *from SC
UPDATE SC set Grade=null where sno=202 and cno=130

select sno,cno
from SC
where Grade is null

--⑦将以后1997年后的成绩大于90分的学生成绩存入永久成绩表；将1997年以前的成绩存入临时成绩表中
--直接select 加创表的形式-1997年后
select SC.sno,SC.Grade into #Grade_next from SC,Student
where Student.sno=SC.sno and year(Student.sBirthy)>1997
and SC.Grade>90
select *from #Grade_next
drop table #Grade_next
--1997年前
select SC.sno,SC.Grade into #Grade_pre from SC,Student
where Student.sno=SC.sno and year(Student.sBirthy)<1997
and SC.Grade>=90
select *from #Grade_pre
drop table #Grade_pre

--对EDUC数据库实现以下查询：
--①	查询每个学生的情况以及他（她）所选修的课程；
select s.sno,s.sName,s.sGender,s.sBirthy,s.sPhone,s.sdept,SC.cno
from Student as s,SC
where s.sno=SC.sno
 
--② 求学生的学号、姓名、选修的课程名及成绩；
select s.sno,s.sName,Course.cname,SC.Grade
from Student as s,SC,Course
where s.sno=SC.sno and SC.cno=Course.cno

--3	求选修C#课程且成绩在90 分以上的学生学号、姓名及成绩；
select Student.sno,sName,Grade
from Student,SC,Course
where Student.sno=SC.sno and Grade>90 and Course.cno=SC.cno and Course.cname='C#'

--③	查询每一门课的间接先行课。






-----------------------------利用子查询-------------------
select *from SC
SELECT *FROM Course
select *from Student
--1）求数据库课程的成绩高于王昭君的学生学号和成绩；
select SC.sno,Grade 
from SC,Student,Course
where Grade>(
select Grade
from SC,Course,Student
where SC.cno=Course.cno
and Course.cname='数据库'
and Student.sName='王昭君'
and Student.sno=SC.sno)
and SC.sno=Student.sno and SC.cno=Course.cno and Course.cname='数据库'

--3）求其他系中比青龙系某一学生年龄小的学生信息（即求其它系中年龄小于青龙系年龄最大者的学生）；
select *
from Student
where DATEDIFF(day,sBirthy,GETDATE())/365<
 (
 select MAX(DATEDIFF(day,sBirthy,GETDATE())/365)
 from Student
 where sdept='青龙系'
 ) and sdept!='青龙系'
 
 --4）求其他系中比青龙系学生年龄都小的学生信息；
select *
from Student
where DATEDIFF(day,sBirthy,GETDATE())/365<any
 (
	 select DATEDIFF(day,sBirthy,GETDATE())/365
	 from Student
	 where sdept='青龙系'
 ) and sdept!='青龙系'
 
 --5)求没有选修数据库课程的学生姓名； 
 select sName 
 from Student
 where sno not in(
 select sno
 from SC
 where cno in (
 select cno
 from Course
 where cname='数据库'
 )
 )

 --6）查询选修了全部课程减1的学生的姓名；
 select sName
 from Student
 where sno in (
 select sno 
 from SC
 group  by sno
 having COUNT(*)=(select (COUNT(cno)-1) from Course)
 )
 select *from SC
 SELECT *FROM Student
 select *from Course
 
 --7）求至少选修了学号为"210"的学生所选修的全部课程的学生学号和姓名。
 select distinct scx.sno,sName
 from SC  scx,Student
 where not exists
 (
    select *
    from SC scy
    where scy.sno='210' and
    not exists
    (
     select *
     from SC scz
     where scz.sno=scx.sno and scz.cno=scy.cno
    )
 )and scx.sno=Student.sno
 
 ------2提高操作实验
 --创建工程项目
 create database Building
 on primary
 (
   name='Build_data',
   filename='G:\语言极其数据库\SQL\Build_DATA.mdf',
   size=5mb,
   maxsize=100mb,
   filegrowth=15%  
 )
 log on
 (
 name='Build_log',
 filename='G:\语言极其数据库\SQL\Build_DATA.ldf',
 size=5mb,
 maxsize=100mb,
 filegrowth=10
 ) 
 use Building
 --建立供应商表
 create table S
 (
  Sno char(5) primary key,
  sname char(50),
  city char (20),
  siphone char(20)
 )
 --建立工程表
 create table J
 (
   Jno char(5) primary key,
   jname char(50),
   jperson char(10),
   jpre  char(8)
 )
 --建立零件表
 create table P
 (
   Pno char(5) primary key,
   Pname char(50),
   pqua char(10),
   psourse char(20),
   pcolor char(10) 
 )
 --建立供应零件表（SPJ）
 create table SPJ
 (
 Sno char(5),
 Jno char(5),
 Pno char(5),
 num int
 primary key(Sno,Pno,Jno),
 foreign key(Sno) references S(Sno),
 foreign key(Pno) references P(Pno),
 foreign key(Jno) references J(Jno)
 )
 insert into S(Sno,sname,city,siphone)
 values
 ('S1','北京供应商','北京','0108888888'),
 ('S2','天津供应商','天津','0228888888'),
 ('S3','重庆供应商','重庆','0238888888'),
 ('S4','上海供应商1','上海','0218888888'),
 ('S5','广州供应商','广州','0208888888'),
 ('S6','上海供应商2','上海','0216666666')
 
 insert into J(Jno,jname,jperson,jpre)
 values
 ('J1','工程1','丁一','200000'),
 ('J2','工程2','赵二','60000'),
 ('J3','工程3','张三','70000'),
 ('J4','工程4','李四','80000'),
 ('J5','工程5','王五','150000')
 
 insert into P(Pno,Pname,pqua,psourse,pcolor)
 values
 ('P1','螺丝','中','济南','红色'),
 ('P2','主板','集成','深圳','绿色'),
 ('P3','显卡','独立','香港','蓝色'),
 ('P4','声卡','集成','天津','红色'),
 ('P5','网卡','100M','上海','黑色'),
 ('P6','鼠标','无线','上海','黑色')
 UPDATE P SET pcolor='红色' where Pno='P6'
 
 insert into SPJ(Sno,Jno,Pno,num)
 values
 ('S1','J2','P4',50),
 ('S1','J3','P5',100),
 ('S2','J2','P6',500),
 ('S4','J1','P3',150),
 ('S4','J5','P1',200),
 ('S5','J4','P6',100),
 ('S6','J4','P2',90)
 
 select *from S
 select *from J 
 select *from P
 select *from SPJ
 --1) 求供应项目J4红色零件的供应商号及名称
 select Sno,sname
 from S 
 WHERE Sno in(
 select Sno
 from SPJ
 where Jno='J4' and Pno in(
 select Pno
 from P
 where pcolor='红色'
 )
 )
 --2)求没有上海供应商生成的零件的项目号
 select Pno
 from SPJ
 WHERE Sno in(
 select Sno 
 from S
 where sname not in ('上海供应商1','上海供应商2')
 ) and Sno in( 
 select Sno
 from SPJ
 where Pno not in(
 select Pno
 from P
 where psourse='上海'
 )
 )
 
----不相关子查询（子条件不依赖于父条件）
select t1.sno ,t1.sName 
from Student t1
where sno in
( select sno
  from Student
  where sdept='青龙系'
)
use Building
-----相关子查询（子查询的条件依赖于父查询的条件）
--案例：找出学生超过他自己选修课程平均成绩的学生的学号和课程号
select sno,cno
from SC  t2
where Grade>(
select AVG(Grade)
from SC t3
where t2.sno=t3.sno
)

-------------带有exists的子查询
--案例:查询所有选修了课程号为128的学生写姓名
select sname
from Student
where exists(
select *from SC
where Student.sno=SC.sno
and SC.cno='128'
)


----------------带有any 或者all 谓词的子查询
-----查询非青龙系中，比青龙系中任何一个学生年龄小的学生的学号以及姓名
select t4.sno ,t4.sName
from Student t4
where  floor(datediff(DAY,t4.sBirthy,GETDATE())/365)<any(
select floor(datediff(DAY,t5.sBirthy,GETDATE())/365)
from Student t5
where t5.sdept='青龙系'
) and t4.sdept!='青龙系'

------查询非青龙系中，比青龙系中所有学生年龄大的学生的学号以及姓名
select t4.sno ,t4.sName
from Student t4
where  floor(datediff(DAY,t4.sBirthy,GETDATE())/365)>all(
select floor(datediff(DAY,t5.sBirthy,GETDATE())/365)
from Student t5
where t5.sdept='青龙系'
) and t4.sdept!='青龙系'

----------------------------使用select语句--------------------
--1）求学生的总人数
select COUNT(*) 总人数 from Student
--2）求选修课程的学生的人数
select COUNT(distinct sno) 选修课课程的学生的人数 from SC

--3）求课程的课程号和选修该课程的人数
select cno,COUNT(distinct sno)
from SC
group by cno

--4)求选修课超过3 门课的学生学号
select sno,COUNT(cno) 选课的数量
from SC
group by sno
having COUNT(cno)>3


----------------------------创建视图--------------
--（1）
---建立朱雀系的学生的视图
create view Student_v2
as
select *
from Student
where sdept='朱雀系'
with check option
select *from Student_v2
drop view Student_v2

--（2）
--①在查询分析器中建立一个每个学生的学号、姓名、选修的课名及成绩的视图S_C_GRADE；
create view S_C_GRADE
AS
SELECT Student.sno,sName,cname,Grade
from SC,Student,Course
where SC.sno=Student.sno and SC.cno=Course.cno
select *from S_C_GRADE

----②建立一个所有青龙系学生的学号、选修课程号以及平均成绩的视图COMPUTE_AVG_GRADE;
create view COMPUTE_AVG_GRADE
as
select SC1.sno,cno,AVG_Grade
from SC SC1,
(
select SC2.sno,AVG(Grade)
from SC SC2,Student
where sdept='青龙系' and SC2.sno=Student.sno
group by SC2.sno) AS sno_AVG(sno,AVG_Grade)
WHERE SC1.sno=sno_AVG.sno
--修改前
SELECT *FROM COMPUTE_AVG_GRADE
--(1) 使用企业管理器修改视图
--在企业管理器中将视图COMPUTE_AVG_GRADE中改成建立在朱雀系的学生学号、选修课程号以及平均成绩的视图。
--修改后
SELECT *FROM COMPUTE_AVG_GRADE


--（2）使用SQL语句修改视图
--①  在查询分析器中使用更改视图的命令将上面建立的视图“S_C_GRADE”更名为“SC_GRADE“
exec sp_rename 'S_C_GRADE','SC_GRADE'
select *from SC_GRADE

--(3)删除视图
--1）	使用企业管理器删除视图
     -- 用企业管理器删除视图“V_计算机系学生”
     
--）  使用SQL语句删除视图
--用SQL语句删除视图COMPUTE_AVG_GRADE;
drop view COMPUTE_AVG_GRADE
select *from COMPUTE_AVG_GRADE

---建立一张学生的SC_v3视图(平均成绩在90分以上)
create view SC_v3
as
select sno, AVG(Grade) as 平均成绩
from SC
group by sno
having AVG(Grade)>80
select *from 
SC_v3
drop view SC_v3

----------------------------------使用视图---------------
---１定义青龙系学生基本情况视图V_Computer
create view V_Computer
as
select *
from Student
where sdept='青龙系'

select *from V_Computer
--２将Student Course 和SC表中学生的学号，姓名，课程号，课程名，成绩定义为视图V_S_C_G
 create view V_S_C_G
 as
 select Student.sno,sName,SC.cno,cname,Grade
 from SC,Student,Course
 where SC.sno=Student.sno and Course.cno=SC.cno
 SELECT *FROM V_S_C_G
 
 --３将各系学生人数，平均年龄定义为视图V_NUM_AVG
 create view V_NUM_AVG
 as 
 select sdept,COUNT(sno) 人数, AVG(DATEDIFF(day,sBirthy,getdate())/365) 平均年龄
 from Student
 group by sdept
 select *from V_NUM_AVG
 
 --4定义一个反映学生出生年份的视图V_YEAR
 create view V_YEAR
 as
 select sno,YEAR(sBirthy) 出生年份
 from Student
 SELECT *FROM V_YEAR
 
 --5将各位学生选修课程的门数及平均成绩定义为视图V_AVG_S_G
 create view V_AVG_S_G
 as 
 select sno,COUNT(cno) 门数,AVG(Grade) 平均成绩
 from SC
 GROUP BY sno
 select *from V_AVG_S_G
 
 --６将各门课程的选修人数及平均成绩定义为视图V_AVG_C_G
 create view V_AVG_C_G
 as
 select cno,COUNT(sno) 人数,AVG(Grade) 平均成绩
 from SC
 GROUP BY cno
 
 select *from V_AVG_C_G
 
 --二使用视图
 --1查询以上所建的视图的结果
 select *from V_Computer
 SELECT *FROM V_S_C_G
 select *from V_NUM_AVG
 SELECT *FROM V_YEAR
 select *from V_AVG_S_G
 select *from V_AVG_C_G
 
 --2查询平均成绩为90分以上的学生学号、姓名和成绩
 select Student.sno,sName,Grade
 from V_AVG_S_G,Student,SC
 WHERE V_AVG_S_G.平均成绩>90 AND V_AVG_S_G.sno=SC.sno
 and Student.sno=SC.sno
 
 --3查询各课成绩均大于平均成绩的学生学号、姓名、课程和成绩
  select sno,sName,cno,Grade
  from V_S_C_G
  where Grade>(
  select AVG(Grade) 
  from V_S_C_G
  )
  
  --4按系统计各系平均成绩在80分以上的人数，结果按降序排列
    select sdept,COUNT(Student.sno) 人数
    from V_AVG_S_G,Student
    where V_AVG_S_G.平均成绩>80 and Student.sno=V_AVG_S_G.sno
    Group by sdept
    order by COUNT(Student.sno) Asc
    
 --三 修改视图
 select *from V_Computer
 SELECT *FROM V_S_C_G
 select *from V_NUM_AVG
 SELECT *FROM V_YEAR
 select *from V_AVG_S_G
 select *from V_AVG_C_G
--1 通过视图V_Computer，分别将学号为“201”和“202”的学生姓名更改为“杜甫”,”赵飞” 并查询结果;
 update V_Computer set sName='李白' where sno='201'   
 update V_Computer set sName='韩信' where sno='202'
 
--2通过视图V_Computer，新增加一个学生记录 ('214','孙膑','1','1999-06-11','18178595955','玄武系')，并查询结果
insert into V_Computer(sno,sName,sGender,sBirthy,sphone,sdept)
 values('214','孙膑','1','1999-06-11','18178595955','玄武系')
select *from Student

--4通过视图V_Computer，删除学号为“214”的学生信息，并查询结果
delete from V_Computer
where sno='214'

--5要通过视图V_S_C_G，将学号为“201”的姓名改为“李黑”，是否可以实现？并说明原因
update V_S_C_G set sName='李白' where sno='201'
select *from V_S_C_G
select *from Student
/*能进行修改，建立该视图的时候没有进行设置对视图修改的约束，而且是对基本表的数据的修改*/

--6要通过视图V_AVG_S_G，将学号为“201”的平均成绩改为90分，是否可以实现？并说明原因
select *from V_AVG_S_G
update V_AVG_S_G set 平均成绩='90' where sno='201'
/*不能进行修改,因为平均成绩这个属性列是派生出来的，并不是基本表的属性列*/


---案例：查询朱雀系中选修选修了128课程号的学生的信息
select *
from Student_v2,SC
WHERE SC.cno='128' and Student_v2.sno=SC.sno
select *from SC

---案例：查询平均成绩在80分以上的学生的学号以及姓名
select t2.sno,t2.sName
from SC_v3 t1 ,Student t2
where t1.sno=t2.sno

----------------------------------更新语句-------------------
use EDUC
--1对于Student表，将所有专业号为‘’的，并且入学年份为2006的学生

select *from Student
--2对于student表，删掉性别为'1'，并且专业为‘玄武系’，年龄为20岁的学生的记录。
delete from Student 
where sGender='1' and sdept='玄武系' and (DATEDIFF(DAY,sBirthy,GETDATE())/365)=20

--3对于student表，插入一条新记录，它的具体信息为，学号：215、姓名：鲁班、性别：1、出生日期：1988-08-08,手机：18178595796专业：‘玄武系’
insert into Student(sno,sName,sGender,sBirthy,sphone,sdept)
values
('215','鲁班','1','1988-08-08','18178595796','玄武系')

--4对于student表，将年龄最小的学生的联系方式去掉。
update Student set sphone=NULL WHERE sno in(
select sno 
from Student,(select min(DATEDIFF(DAY,sBirthy,GETDATE())/365) as age from Student ) as Min_S(age)
where (DATEDIFF(DAY,sBirthy,GETDATE())/365)=Min_S.age
)

--5对于student表，将平均年龄最小的一个专业改为'蛟龙系'
update Student set sdept='蛟龙系' where sdept in(
select Student.sdept
from Student,(select sdept,AVG(DATEDIFF(DAY,sBirthy,GETDATE())/365) 平均成绩 from Student group by sdept ) AS AVG_sdept(sdept,平均成绩) 
where Student.sdept=AVG_sdept.sdept
group by Student.sdept
having min(AVG_sdept.平均成绩)='19'                            
)
select *from Student


update Student set sdept='青龙系' where sdept='蛟龙系'



/*select *from Student
update Student set sPhone='18178595973' where sPhone is null*/

--视图的更新
--案例：讲视图Student_v2中学号为213的学生的姓名改为小禹
update Student_v2 set sName='小禹' where sno=213
select *from Student_v2

---------------------------------流程控制语句-------------
--while循环：
declare @num int
set @num=0;
while @num<5
begin 
   set @num+=1;
   print '小贱贱';
end 

---if else流程控制语句
--案例：判断小禹是不是朱雀系的，是的话输出yes，否则输出no
if(select sdept from Student where sName='小禹')='朱雀系'
print 'yes';
else
print 'no';


---while break continue 流程控制语句的使用
--案例：定义一个@num int 类型的变量，如何@num为8则 break 为3 就continue
declare @num int
set @num=0;
while @num<9
begin 
  set @num+=1;
 if @num=3 continue;
 if @num=8 break;
end
print @num;


---定义=一个标记 标记echo（相当于JS中的function）
declare @num int;
set @num=0;
echo:
    print '林永健最帅';
    set @num=@num+1;
while  @num<10
begin
goto echo
end


---return条件的使用 直接返回
declare @num int
set @num=0;
while @num<8
begin
  set @num+=1;
  print '刘鹏老师也很帅';
     if @num=5
   return 
end;

--waitfor delay 以及 waitfor time的使用
--waitfor dalay 表示等多长时间
--waitfor time 表示到某时刻

waitfor delay '00:00:10'
print '小贱贱1'
waitfor time '10:25:00'
print '小贱贱2'

--------------------------------游标的使用-------------
select *from Student
---------普通游标：
declare cursor_name cursor for --游标的定义
    select top 5 sno,sName from Student
    order by sno desc

--打开游标 
open cursor_name
declare @Sname varchar(20),@Sno varchar(100) --需要在抓取游标数据的时候定义变量
fetch next from cursor_name into @Sno,@Sname  ----抓取一行游标数据
while @@FETCH_STATUS=0
  begin 
    declare @Sname varchar(100),@Sno varchar(100)
    --print '学生sno：'+@Sno +'   '+'学生的姓名'+@Sname
    fetch next from cursor_name into @Sno,@Sname  ----继续抓取下行游标数据
    print '学生sno：'+@Sno +'   '+'学生的姓名'+@Sname
  end;
  close cursor_name ---关闭游标
  deallocate cursor_name  --释放游标
  
 ---------滚动游标：
 set nocount on  --不反回计数，不受行数的影响，可以减少不必要的流量
 set nocount off --返回计数
 
 declare tt scroll cursor for
   select top 5 sno,sName from Student
   order by sno desc
 open tt
 FETCH LAST FROM tt   --最后一行的数据，并将当前行为指定行
 FETCH RELATIVE 1 FROM tt  --相对于当前行的后1行数据，并将当前行为指定行
 FETCH RELATIVE -2 FROM tt --相对于当前行的前2行数据，并将当前行为指定行
 FETCH PRIOR FROM tt   ----相对于当前行的前1行数据
 FETCH FIRST FROM tt   --刚开始第一行的数据，并将当前行为指定行
 FETCH NEXT FROM tt    --相对于当前行的后1行数据
CLOSE C
DEALLOCATE C


------------------------------------约束----------------------
use EDUC
create table 部门
(
 部门号     char(4),
 名称       varchar(20) not null,
 经理名     varchar(8),
 地址       varchar(50),
 电话号     varchar(20),
 constraint PK_部门号 primary key(部门号),
 constraint U_名称    unique(名称)
) 

--给Student表添加约束
alter table Student
add constraint C1 check(sdept in('青龙系','白虎系','朱雀系','玄武系'))
--测试无法插入
insert into Student
values
(214,'虞姬',0,'1999-03-26','18012821222','雀系')

--删除约束
alter table Student
drop constraint C1 



------------------------------T-SQL语句----------------
declare @@transcount int
print @@ERROR
print @@identity
print @@language
print @@max_connections
print @@rowcount
print @@servername
print @@transcount
print @@version

print 'SQL服务器的名称'+@@servername
print '服务器的版本号'+@@version


-----查询SC表中平均成绩并且按照要求写出等级制度
use EDUC
GO
declare @st_avg float,@sno varchar(20),@等级 varchar(20);
select @sno=sno,@st_avg=AVG(Grade),@等级=case
 when @st_avg>=90 then '优'
 when @st_avg between 80 and 90 then '良'
 when @st_avg<70 then '差'
end
from SC
where Grade is not null
group by sno
GO 

---定义一张表用于对不满足则加分要求的测试
create table test
(
  sno char(10),
  cno char(10),
  Grade  int,
  primary key(sno,cno)
)
insert into test(sno,cno,Grade)
values
('1','1',67),
('2','1',87),
('3','1',98),
('4','1',77),
('1','2',76),
('2','2',88),
('3','2',66),
('4','2',88)

select *from test
drop table test 
--自动加分的题目
declare @st_Avg float;
while(1=1)
begin 
  select @st_Avg=avg(Grade) from test WHERE Grade is not null
  if(@st_Avg>90) break;
  else 
    update test set Grade=
    case 
      when Grade between 70 and 80 then Grade+10
      when Grade between 80 and 90 then Grade+5
      when Grade>90 then Grade+1
      else Grade+11
    end
 end     
 select *from test 
 
 ---统计成绩中前3名最高分的
 
 declare @st_avg float
 select @st_avg=AVG(Grade) from test
 if(@st_avg>98)
   begin 
    print '本班成绩优良，并且成绩为'+convert(varchar(20),@st_avg)
    print '最高分的三课为：'
    select top 3* from test order by  Grade desc
 end
 else
 begin
    print '本班成绩比较差，后三名的成绩为';
    select top 3*from test  order by Grade asc
 end
   
   
-------------------存储过程的创建----------------
--案例表：
create table Account
(
 num varchar(10) primary key  not null,
 total float,
)
insert into Account(num,total)
values
('12345',2000.00),
('12346',1000.00)

select *from Account
drop table Account
--创建存储过程
create procedure trade(@in_account varchar(10),@out_account varchar(10),@num_money float)
as declare
i_account varchar(10),
all_money float,
o_account varchar(10),
begin 
  select all_money=total from Account where num=@out_account;
  if (all_money is null)
   begin
    rollback;
    return;
   end
  if all_money<@num_money
   begin 
    rollback;
    return;
  end 
  else 
    begin
   select i_account=num from Account where num=@in_account;
   if(i_account is null )
	  begin
	   rollback;
	   return;
	  end
	  else
		  begin 
			  update Account set total=total-@num_money where num=@out_account;
			  update Account set total=total+@num_money where num=@in_account;
		  commit;
		  end;
	 end;
  end;
   
 --执行存储过程
 call procedure trade('12345','12346',500.00)    