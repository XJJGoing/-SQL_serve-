
----------------------ʵ�����ʵ����--------------------------
----------------------ʵ���ߵ�ʵ��ʮ��������-------------------
-------------------------�������ݿ�------------------------

USE EDUC
create database EDUC
on primary
(
name='STU_data',
filename='C:\Users\14997\Desktop\���Լ������ݿ�\SQL\STU_DATA.mdf',
size=5mb,
maxsize=100mb,
filegrowth=15%
)

log on
(
name='STU_log',
filename='C:\Users\14997\Desktop\���Լ������ݿ�\SQL\STU_LOG.ldf',
size=10mb,
maxsize=200mb,
filegrowth=20mb
)
--------------------���ݿ��ɾ��------------------------
DROP DATABASE EDUC

----------------------�����Ѿ������õ����ݿ�Ĳ���----------------
USE EDUC

----------------------��������Ҫ�ı�Ĳ���------------------------
--����ѧ����
create table Student
(
   sno int  not null primary key,
   sName nvarchar(15),
   sGender bit not null  default(1) ,--Ĭ��1Ϊ���� 0ΪŮ��
   sBirthy date, 
   sPhone char(11),
   sdept char(20),
)

---�鿴���е�Լ��--
sp_helpconstraint Student

--����ѧ���γ̱�
create table Course
(
cno int not null primary key,
cName nvarchar(15) not null,
);

--����ѧ����ѡ�α�
create table SC
(
 sno int,
 cno int,
 Grade smallint,
 primary key(sno,cno),
 foreign key(sno) references Student(sno),
 foreign key(cno) references Course(cno)
);

---------------�鿴�Ѿ������ı�Ĳ���-------------
select *from Student
select *from Course
select *from SC

drop table Student
drop table Course 
drop table SC


---------------�Ա�������ݵĲ������--------------

insert into Student(sno,sName,sGender,sBirthy,sPhone,sdept)
values
(201,'���',1,'1999-05-26','18012821234','����ϵ'),
(202,'����',1,'1999-06-26','18012821243','����ϵ'),
(203,'���ļ�',0,'1999-07-28','18012821894','��ȸϵ'),
(204,'������',1,'1998-05-25','18012821789','�׻�ϵ'),
(205,'����',1,'1997-05-26','18012821523','����ϵ'),
(206,'�ŷ�',1,'1994-05-26','18012821896','�׻�ϵ'),
(207,'����',1,'1994-05-29','18012821134','����ϵ'),
(208,'��ľ��',0,'1993-05-26','18012821245','��ȸϵ'),
(209,'������',1,'1993-05-26','18012821263','����ϵ'),
(210,'���Ѿ�',0,'1999-07-26','18012821984','��ȸϵ'),
(211,'�ݼ�',0,'1999-03-26','18012821222','��ȸϵ')


insert into Course(cno,cName)
values
(123,'���ݿ�'),
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



------------------------�����Ļ���������ɾ��----------------------

--��SC�еĳɼ��н��������Ĵ���
create index SCCC ON SC(Grade DESC)
create index STTT on Student(sname desc)
create unique index SGGG on Course(cname)
create index SCT on SC(sno ASC)
create index SCC on SC(Grade desc) 


--�޸���������
exec sp_rename 'SC.SCCC','SDDD','index' 

--ɾ������
drop index SCC on SC
drop index SCT on SC
drop index SGGG on Course
drop index STTT on Student



------------------------------7��15��ʵ��--------------------------

----------------------�򵥵�select���
select *from Student
select *from SC
select *from Course
---��Ŀ��
--�� ������ϵϵ��ѧ��ѧ�ź�������
select sno,Sname
from Student
where sdept='����ϵ'
--�� ��ѡ���˿γ̵�ѧ��ѧ�ţ�
select distinct sno
from SC
where cno is not null
--����ѡ�����ݿ�γ̵�ѧ��ѧ�źͳɼ�����Ҫ��Բ�ѯ������ɼ��Ľ������У�����ɼ���ͬ��ѧ�ŵ��������У�
select sno,Grade
from SC,Course
where SC.cno=Course.cno and
Course.cname='���ݿ�'
order by Grade desc,sno asc

--����ѡ�޿γ����ݿ�γ��ҳɼ���80��90 ֮���ѧ��ѧ�źͳɼ��������ɼ�����ϵ��0.75 �����
select sno,Grade,(Grade)*0.75 as ��� 
from SC,Course
where SC.cno=Course.cno and Course.cname='���ݿ�'
and Grade between 80 and 90

select *from Student
--�� ������ϵϵ�Ͱ׻�ϵ�����ŵ�ѧ������Ϣ��
select *
from Student
where sdept in('����ϵ','�׻�ϵ') and sName like '��%'

--�� ��ȱ���˳ɼ���ѧ����ѧ�źͿγ̺ţ�
--��Ūһ����ֵ����
select *from SC
UPDATE SC set Grade=null where sno=202 and cno=130

select sno,cno
from SC
where Grade is null

--�߽��Ժ�1997���ĳɼ�����90�ֵ�ѧ���ɼ��������óɼ�����1997����ǰ�ĳɼ�������ʱ�ɼ�����
--ֱ��select �Ӵ������ʽ-1997���
select SC.sno,SC.Grade into #Grade_next from SC,Student
where Student.sno=SC.sno and year(Student.sBirthy)>1997
and SC.Grade>90
select *from #Grade_next
drop table #Grade_next
--1997��ǰ
select SC.sno,SC.Grade into #Grade_pre from SC,Student
where Student.sno=SC.sno and year(Student.sBirthy)<1997
and SC.Grade>=90
select *from #Grade_pre
drop table #Grade_pre

--��EDUC���ݿ�ʵ�����²�ѯ��
--��	��ѯÿ��ѧ��������Լ�����������ѡ�޵Ŀγ̣�
select s.sno,s.sName,s.sGender,s.sBirthy,s.sPhone,s.sdept,SC.cno
from Student as s,SC
where s.sno=SC.sno
 
--�� ��ѧ����ѧ�š�������ѡ�޵Ŀγ������ɼ���
select s.sno,s.sName,Course.cname,SC.Grade
from Student as s,SC,Course
where s.sno=SC.sno and SC.cno=Course.cno

--3	��ѡ��C#�γ��ҳɼ���90 �����ϵ�ѧ��ѧ�š��������ɼ���
select Student.sno,sName,Grade
from Student,SC,Course
where Student.sno=SC.sno and Grade>90 and Course.cno=SC.cno and Course.cname='C#'

--��	��ѯÿһ�ſεļ�����пΡ�






-----------------------------�����Ӳ�ѯ-------------------
select *from SC
SELECT *FROM Course
select *from Student
--1�������ݿ�γ̵ĳɼ��������Ѿ���ѧ��ѧ�źͳɼ���
select SC.sno,Grade 
from SC,Student,Course
where Grade>(
select Grade
from SC,Course,Student
where SC.cno=Course.cno
and Course.cname='���ݿ�'
and Student.sName='���Ѿ�'
and Student.sno=SC.sno)
and SC.sno=Student.sno and SC.cno=Course.cno and Course.cname='���ݿ�'

--3��������ϵ�б�����ϵĳһѧ������С��ѧ����Ϣ����������ϵ������С������ϵ��������ߵ�ѧ������
select *
from Student
where DATEDIFF(day,sBirthy,GETDATE())/365<
 (
 select MAX(DATEDIFF(day,sBirthy,GETDATE())/365)
 from Student
 where sdept='����ϵ'
 ) and sdept!='����ϵ'
 
 --4��������ϵ�б�����ϵѧ�����䶼С��ѧ����Ϣ��
select *
from Student
where DATEDIFF(day,sBirthy,GETDATE())/365<any
 (
	 select DATEDIFF(day,sBirthy,GETDATE())/365
	 from Student
	 where sdept='����ϵ'
 ) and sdept!='����ϵ'
 
 --5)��û��ѡ�����ݿ�γ̵�ѧ�������� 
 select sName 
 from Student
 where sno not in(
 select sno
 from SC
 where cno in (
 select cno
 from Course
 where cname='���ݿ�'
 )
 )

 --6����ѯѡ����ȫ���γ̼�1��ѧ����������
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
 
 --7��������ѡ����ѧ��Ϊ"210"��ѧ����ѡ�޵�ȫ���γ̵�ѧ��ѧ�ź�������
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
 
 ------2��߲���ʵ��
 --����������Ŀ
 create database Building
 on primary
 (
   name='Build_data',
   filename='G:\���Լ������ݿ�\SQL\Build_DATA.mdf',
   size=5mb,
   maxsize=100mb,
   filegrowth=15%  
 )
 log on
 (
 name='Build_log',
 filename='G:\���Լ������ݿ�\SQL\Build_DATA.ldf',
 size=5mb,
 maxsize=100mb,
 filegrowth=10
 ) 
 use Building
 --������Ӧ�̱�
 create table S
 (
  Sno char(5) primary key,
  sname char(50),
  city char (20),
  siphone char(20)
 )
 --�������̱�
 create table J
 (
   Jno char(5) primary key,
   jname char(50),
   jperson char(10),
   jpre  char(8)
 )
 --���������
 create table P
 (
   Pno char(5) primary key,
   Pname char(50),
   pqua char(10),
   psourse char(20),
   pcolor char(10) 
 )
 --������Ӧ�����SPJ��
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
 ('S1','������Ӧ��','����','0108888888'),
 ('S2','���Ӧ��','���','0228888888'),
 ('S3','���칩Ӧ��','����','0238888888'),
 ('S4','�Ϻ���Ӧ��1','�Ϻ�','0218888888'),
 ('S5','���ݹ�Ӧ��','����','0208888888'),
 ('S6','�Ϻ���Ӧ��2','�Ϻ�','0216666666')
 
 insert into J(Jno,jname,jperson,jpre)
 values
 ('J1','����1','��һ','200000'),
 ('J2','����2','�Զ�','60000'),
 ('J3','����3','����','70000'),
 ('J4','����4','����','80000'),
 ('J5','����5','����','150000')
 
 insert into P(Pno,Pname,pqua,psourse,pcolor)
 values
 ('P1','��˿','��','����','��ɫ'),
 ('P2','����','����','����','��ɫ'),
 ('P3','�Կ�','����','���','��ɫ'),
 ('P4','����','����','���','��ɫ'),
 ('P5','����','100M','�Ϻ�','��ɫ'),
 ('P6','���','����','�Ϻ�','��ɫ')
 UPDATE P SET pcolor='��ɫ' where Pno='P6'
 
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
 --1) ��Ӧ��ĿJ4��ɫ����Ĺ�Ӧ�̺ż�����
 select Sno,sname
 from S 
 WHERE Sno in(
 select Sno
 from SPJ
 where Jno='J4' and Pno in(
 select Pno
 from P
 where pcolor='��ɫ'
 )
 )
 --2)��û���Ϻ���Ӧ�����ɵ��������Ŀ��
 select Pno
 from SPJ
 WHERE Sno in(
 select Sno 
 from S
 where sname not in ('�Ϻ���Ӧ��1','�Ϻ���Ӧ��2')
 ) and Sno in( 
 select Sno
 from SPJ
 where Pno not in(
 select Pno
 from P
 where psourse='�Ϻ�'
 )
 )
 
----������Ӳ�ѯ���������������ڸ�������
select t1.sno ,t1.sName 
from Student t1
where sno in
( select sno
  from Student
  where sdept='����ϵ'
)
use Building
-----����Ӳ�ѯ���Ӳ�ѯ�����������ڸ���ѯ��������
--�������ҳ�ѧ���������Լ�ѡ�޿γ�ƽ���ɼ���ѧ����ѧ�źͿγ̺�
select sno,cno
from SC  t2
where Grade>(
select AVG(Grade)
from SC t3
where t2.sno=t3.sno
)

-------------����exists���Ӳ�ѯ
--����:��ѯ����ѡ���˿γ̺�Ϊ128��ѧ��д����
select sname
from Student
where exists(
select *from SC
where Student.sno=SC.sno
and SC.cno='128'
)


----------------����any ����all ν�ʵ��Ӳ�ѯ
-----��ѯ������ϵ�У�������ϵ���κ�һ��ѧ������С��ѧ����ѧ���Լ�����
select t4.sno ,t4.sName
from Student t4
where  floor(datediff(DAY,t4.sBirthy,GETDATE())/365)<any(
select floor(datediff(DAY,t5.sBirthy,GETDATE())/365)
from Student t5
where t5.sdept='����ϵ'
) and t4.sdept!='����ϵ'

------��ѯ������ϵ�У�������ϵ������ѧ��������ѧ����ѧ���Լ�����
select t4.sno ,t4.sName
from Student t4
where  floor(datediff(DAY,t4.sBirthy,GETDATE())/365)>all(
select floor(datediff(DAY,t5.sBirthy,GETDATE())/365)
from Student t5
where t5.sdept='����ϵ'
) and t4.sdept!='����ϵ'

----------------------------ʹ��select���--------------------
--1����ѧ����������
select COUNT(*) ������ from Student
--2����ѡ�޿γ̵�ѧ��������
select COUNT(distinct sno) ѡ�޿ογ̵�ѧ�������� from SC

--3����γ̵Ŀγ̺ź�ѡ�޸ÿγ̵�����
select cno,COUNT(distinct sno)
from SC
group by cno

--4)��ѡ�޿γ���3 �ſε�ѧ��ѧ��
select sno,COUNT(cno) ѡ�ε�����
from SC
group by sno
having COUNT(cno)>3


----------------------------������ͼ--------------
--��1��
---������ȸϵ��ѧ������ͼ
create view Student_v2
as
select *
from Student
where sdept='��ȸϵ'
with check option
select *from Student_v2
drop view Student_v2

--��2��
--���ڲ�ѯ�������н���һ��ÿ��ѧ����ѧ�š�������ѡ�޵Ŀ������ɼ�����ͼS_C_GRADE��
create view S_C_GRADE
AS
SELECT Student.sno,sName,cname,Grade
from SC,Student,Course
where SC.sno=Student.sno and SC.cno=Course.cno
select *from S_C_GRADE

----�ڽ���һ����������ϵѧ����ѧ�š�ѡ�޿γ̺��Լ�ƽ���ɼ�����ͼCOMPUTE_AVG_GRADE;
create view COMPUTE_AVG_GRADE
as
select SC1.sno,cno,AVG_Grade
from SC SC1,
(
select SC2.sno,AVG(Grade)
from SC SC2,Student
where sdept='����ϵ' and SC2.sno=Student.sno
group by SC2.sno) AS sno_AVG(sno,AVG_Grade)
WHERE SC1.sno=sno_AVG.sno
--�޸�ǰ
SELECT *FROM COMPUTE_AVG_GRADE
--(1) ʹ����ҵ�������޸���ͼ
--����ҵ�������н���ͼCOMPUTE_AVG_GRADE�иĳɽ�������ȸϵ��ѧ��ѧ�š�ѡ�޿γ̺��Լ�ƽ���ɼ�����ͼ��
--�޸ĺ�
SELECT *FROM COMPUTE_AVG_GRADE


--��2��ʹ��SQL����޸���ͼ
--��  �ڲ�ѯ��������ʹ�ø�����ͼ��������潨������ͼ��S_C_GRADE������Ϊ��SC_GRADE��
exec sp_rename 'S_C_GRADE','SC_GRADE'
select *from SC_GRADE

--(3)ɾ����ͼ
--1��	ʹ����ҵ������ɾ����ͼ
     -- ����ҵ������ɾ����ͼ��V_�����ϵѧ����
     
--��  ʹ��SQL���ɾ����ͼ
--��SQL���ɾ����ͼCOMPUTE_AVG_GRADE;
drop view COMPUTE_AVG_GRADE
select *from COMPUTE_AVG_GRADE

---����һ��ѧ����SC_v3��ͼ(ƽ���ɼ���90������)
create view SC_v3
as
select sno, AVG(Grade) as ƽ���ɼ�
from SC
group by sno
having AVG(Grade)>80
select *from 
SC_v3
drop view SC_v3

----------------------------------ʹ����ͼ---------------
---����������ϵѧ�����������ͼV_Computer
create view V_Computer
as
select *
from Student
where sdept='����ϵ'

select *from V_Computer
--����Student Course ��SC����ѧ����ѧ�ţ��������γ̺ţ��γ������ɼ�����Ϊ��ͼV_S_C_G
 create view V_S_C_G
 as
 select Student.sno,sName,SC.cno,cname,Grade
 from SC,Student,Course
 where SC.sno=Student.sno and Course.cno=SC.cno
 SELECT *FROM V_S_C_G
 
 --������ϵѧ��������ƽ�����䶨��Ϊ��ͼV_NUM_AVG
 create view V_NUM_AVG
 as 
 select sdept,COUNT(sno) ����, AVG(DATEDIFF(day,sBirthy,getdate())/365) ƽ������
 from Student
 group by sdept
 select *from V_NUM_AVG
 
 --4����һ����ӳѧ��������ݵ���ͼV_YEAR
 create view V_YEAR
 as
 select sno,YEAR(sBirthy) �������
 from Student
 SELECT *FROM V_YEAR
 
 --5����λѧ��ѡ�޿γ̵�������ƽ���ɼ�����Ϊ��ͼV_AVG_S_G
 create view V_AVG_S_G
 as 
 select sno,COUNT(cno) ����,AVG(Grade) ƽ���ɼ�
 from SC
 GROUP BY sno
 select *from V_AVG_S_G
 
 --�������ſγ̵�ѡ��������ƽ���ɼ�����Ϊ��ͼV_AVG_C_G
 create view V_AVG_C_G
 as
 select cno,COUNT(sno) ����,AVG(Grade) ƽ���ɼ�
 from SC
 GROUP BY cno
 
 select *from V_AVG_C_G
 
 --��ʹ����ͼ
 --1��ѯ������������ͼ�Ľ��
 select *from V_Computer
 SELECT *FROM V_S_C_G
 select *from V_NUM_AVG
 SELECT *FROM V_YEAR
 select *from V_AVG_S_G
 select *from V_AVG_C_G
 
 --2��ѯƽ���ɼ�Ϊ90�����ϵ�ѧ��ѧ�š������ͳɼ�
 select Student.sno,sName,Grade
 from V_AVG_S_G,Student,SC
 WHERE V_AVG_S_G.ƽ���ɼ�>90 AND V_AVG_S_G.sno=SC.sno
 and Student.sno=SC.sno
 
 --3��ѯ���γɼ�������ƽ���ɼ���ѧ��ѧ�š��������γ̺ͳɼ�
  select sno,sName,cno,Grade
  from V_S_C_G
  where Grade>(
  select AVG(Grade) 
  from V_S_C_G
  )
  
  --4��ϵͳ�Ƹ�ϵƽ���ɼ���80�����ϵ��������������������
    select sdept,COUNT(Student.sno) ����
    from V_AVG_S_G,Student
    where V_AVG_S_G.ƽ���ɼ�>80 and Student.sno=V_AVG_S_G.sno
    Group by sdept
    order by COUNT(Student.sno) Asc
    
 --�� �޸���ͼ
 select *from V_Computer
 SELECT *FROM V_S_C_G
 select *from V_NUM_AVG
 SELECT *FROM V_YEAR
 select *from V_AVG_S_G
 select *from V_AVG_C_G
--1 ͨ����ͼV_Computer���ֱ�ѧ��Ϊ��201���͡�202����ѧ����������Ϊ���Ÿ���,���Էɡ� ����ѯ���;
 update V_Computer set sName='���' where sno='201'   
 update V_Computer set sName='����' where sno='202'
 
--2ͨ����ͼV_Computer��������һ��ѧ����¼ ('214','����','1','1999-06-11','18178595955','����ϵ')������ѯ���
insert into V_Computer(sno,sName,sGender,sBirthy,sphone,sdept)
 values('214','����','1','1999-06-11','18178595955','����ϵ')
select *from Student

--4ͨ����ͼV_Computer��ɾ��ѧ��Ϊ��214����ѧ����Ϣ������ѯ���
delete from V_Computer
where sno='214'

--5Ҫͨ����ͼV_S_C_G����ѧ��Ϊ��201����������Ϊ����ڡ����Ƿ����ʵ�֣���˵��ԭ��
update V_S_C_G set sName='���' where sno='201'
select *from V_S_C_G
select *from Student
/*�ܽ����޸ģ���������ͼ��ʱ��û�н������ö���ͼ�޸ĵ�Լ���������ǶԻ���������ݵ��޸�*/

--6Ҫͨ����ͼV_AVG_S_G����ѧ��Ϊ��201����ƽ���ɼ���Ϊ90�֣��Ƿ����ʵ�֣���˵��ԭ��
select *from V_AVG_S_G
update V_AVG_S_G set ƽ���ɼ�='90' where sno='201'
/*���ܽ����޸�,��Ϊƽ���ɼ���������������������ģ������ǻ������������*/


---��������ѯ��ȸϵ��ѡ��ѡ����128�γ̺ŵ�ѧ������Ϣ
select *
from Student_v2,SC
WHERE SC.cno='128' and Student_v2.sno=SC.sno
select *from SC

---��������ѯƽ���ɼ���80�����ϵ�ѧ����ѧ���Լ�����
select t2.sno,t2.sName
from SC_v3 t1 ,Student t2
where t1.sno=t2.sno

----------------------------------�������-------------------
use EDUC
--1����Student��������רҵ��Ϊ�����ģ�������ѧ���Ϊ2006��ѧ��

select *from Student
--2����student��ɾ���Ա�Ϊ'1'������רҵΪ������ϵ��������Ϊ20���ѧ���ļ�¼��
delete from Student 
where sGender='1' and sdept='����ϵ' and (DATEDIFF(DAY,sBirthy,GETDATE())/365)=20

--3����student������һ���¼�¼�����ľ�����ϢΪ��ѧ�ţ�215��������³�ࡢ�Ա�1���������ڣ�1988-08-08,�ֻ���18178595796רҵ��������ϵ��
insert into Student(sno,sName,sGender,sBirthy,sphone,sdept)
values
('215','³��','1','1988-08-08','18178595796','����ϵ')

--4����student����������С��ѧ������ϵ��ʽȥ����
update Student set sphone=NULL WHERE sno in(
select sno 
from Student,(select min(DATEDIFF(DAY,sBirthy,GETDATE())/365) as age from Student ) as Min_S(age)
where (DATEDIFF(DAY,sBirthy,GETDATE())/365)=Min_S.age
)

--5����student����ƽ��������С��һ��רҵ��Ϊ'����ϵ'
update Student set sdept='����ϵ' where sdept in(
select Student.sdept
from Student,(select sdept,AVG(DATEDIFF(DAY,sBirthy,GETDATE())/365) ƽ���ɼ� from Student group by sdept ) AS AVG_sdept(sdept,ƽ���ɼ�) 
where Student.sdept=AVG_sdept.sdept
group by Student.sdept
having min(AVG_sdept.ƽ���ɼ�)='19'                            
)
select *from Student


update Student set sdept='����ϵ' where sdept='����ϵ'



/*select *from Student
update Student set sPhone='18178595973' where sPhone is null*/

--��ͼ�ĸ���
--����������ͼStudent_v2��ѧ��Ϊ213��ѧ����������ΪС��
update Student_v2 set sName='С��' where sno=213
select *from Student_v2

---------------------------------���̿������-------------
--whileѭ����
declare @num int
set @num=0;
while @num<5
begin 
   set @num+=1;
   print 'С����';
end 

---if else���̿������
--�������ж�С���ǲ�����ȸϵ�ģ��ǵĻ����yes���������no
if(select sdept from Student where sName='С��')='��ȸϵ'
print 'yes';
else
print 'no';


---while break continue ���̿�������ʹ��
--����������һ��@num int ���͵ı��������@numΪ8�� break Ϊ3 ��continue
declare @num int
set @num=0;
while @num<9
begin 
  set @num+=1;
 if @num=3 continue;
 if @num=8 break;
end
print @num;


---����=һ����� ���echo���൱��JS�е�function��
declare @num int;
set @num=0;
echo:
    print '��������˧';
    set @num=@num+1;
while  @num<10
begin
goto echo
end


---return������ʹ�� ֱ�ӷ���
declare @num int
set @num=0;
while @num<8
begin
  set @num+=1;
  print '������ʦҲ��˧';
     if @num=5
   return 
end;

--waitfor delay �Լ� waitfor time��ʹ��
--waitfor dalay ��ʾ�ȶ೤ʱ��
--waitfor time ��ʾ��ĳʱ��

waitfor delay '00:00:10'
print 'С����1'
waitfor time '10:25:00'
print 'С����2'

--------------------------------�α��ʹ��-------------
select *from Student
---------��ͨ�α꣺
declare cursor_name cursor for --�α�Ķ���
    select top 5 sno,sName from Student
    order by sno desc

--���α� 
open cursor_name
declare @Sname varchar(20),@Sno varchar(100) --��Ҫ��ץȡ�α����ݵ�ʱ�������
fetch next from cursor_name into @Sno,@Sname  ----ץȡһ���α�����
while @@FETCH_STATUS=0
  begin 
    declare @Sname varchar(100),@Sno varchar(100)
    --print 'ѧ��sno��'+@Sno +'   '+'ѧ��������'+@Sname
    fetch next from cursor_name into @Sno,@Sname  ----����ץȡ�����α�����
    print 'ѧ��sno��'+@Sno +'   '+'ѧ��������'+@Sname
  end;
  close cursor_name ---�ر��α�
  deallocate cursor_name  --�ͷ��α�
  
 ---------�����α꣺
 set nocount on  --�����ؼ���������������Ӱ�죬���Լ��ٲ���Ҫ������
 set nocount off --���ؼ���
 
 declare tt scroll cursor for
   select top 5 sno,sName from Student
   order by sno desc
 open tt
 FETCH LAST FROM tt   --���һ�е����ݣ�������ǰ��Ϊָ����
 FETCH RELATIVE 1 FROM tt  --����ڵ�ǰ�еĺ�1�����ݣ�������ǰ��Ϊָ����
 FETCH RELATIVE -2 FROM tt --����ڵ�ǰ�е�ǰ2�����ݣ�������ǰ��Ϊָ����
 FETCH PRIOR FROM tt   ----����ڵ�ǰ�е�ǰ1������
 FETCH FIRST FROM tt   --�տ�ʼ��һ�е����ݣ�������ǰ��Ϊָ����
 FETCH NEXT FROM tt    --����ڵ�ǰ�еĺ�1������
CLOSE C
DEALLOCATE C


------------------------------------Լ��----------------------
use EDUC
create table ����
(
 ���ź�     char(4),
 ����       varchar(20) not null,
 ������     varchar(8),
 ��ַ       varchar(50),
 �绰��     varchar(20),
 constraint PK_���ź� primary key(���ź�),
 constraint U_����    unique(����)
) 

--��Student�����Լ��
alter table Student
add constraint C1 check(sdept in('����ϵ','�׻�ϵ','��ȸϵ','����ϵ'))
--�����޷�����
insert into Student
values
(214,'�ݼ�',0,'1999-03-26','18012821222','ȸϵ')

--ɾ��Լ��
alter table Student
drop constraint C1 



------------------------------T-SQL���----------------
declare @@transcount int
print @@ERROR
print @@identity
print @@language
print @@max_connections
print @@rowcount
print @@servername
print @@transcount
print @@version

print 'SQL������������'+@@servername
print '�������İ汾��'+@@version


-----��ѯSC����ƽ���ɼ����Ұ���Ҫ��д���ȼ��ƶ�
use EDUC
GO
declare @st_avg float,@sno varchar(20),@�ȼ� varchar(20);
select @sno=sno,@st_avg=AVG(Grade),@�ȼ�=case
 when @st_avg>=90 then '��'
 when @st_avg between 80 and 90 then '��'
 when @st_avg<70 then '��'
end
from SC
where Grade is not null
group by sno
GO 

---����һ�ű����ڶԲ�������ӷ�Ҫ��Ĳ���
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
--�Զ��ӷֵ���Ŀ
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
 
 ---ͳ�Ƴɼ���ǰ3����߷ֵ�
 
 declare @st_avg float
 select @st_avg=AVG(Grade) from test
 if(@st_avg>98)
   begin 
    print '����ɼ����������ҳɼ�Ϊ'+convert(varchar(20),@st_avg)
    print '��߷ֵ�����Ϊ��'
    select top 3* from test order by  Grade desc
 end
 else
 begin
    print '����ɼ��Ƚϲ�������ĳɼ�Ϊ';
    select top 3*from test  order by Grade asc
 end
   
   
-------------------�洢���̵Ĵ���----------------
--������
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
--�����洢����
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
   
 --ִ�д洢����
 call procedure trade('12345','12346',500.00)    