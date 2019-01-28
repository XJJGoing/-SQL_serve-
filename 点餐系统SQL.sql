create database �����������ݿ�
on primary
(
 name='Order_Date',
 filename='G:\���Լ������ݿ�\SQL\����\���ϵͳ�׶ζ������\��������_LOG.mdf',
 size=20mb,
 maxsize=1000mb,
 filegrowth=5%
)

LOG on
( 
 name='Order_Log',
 filename='G:\���Լ������ݿ�\SQL\����\���ϵͳ�׶ζ������\��������_LOG.ldf',
 size=20mb,
 maxsize=1000mb,
 filegrowth=20mb
)
Use �����������ݿ�

----�����û�ע���(U_ser)
create table U_ser
(
  U_ID int primary key not null,
  U_name varchar(20),
  U_loginID varchar(30),
  U_password varchar(20),
  U_score int ,
  U_sex varchar(5) constraint CK_Sex check(U_sex in('��','Ů')),
  U_Email varchar(50),
  U_iphone varchar(11)
)
select *from U_ser
select *from U_ser


---�����˵���Food��
create table Food
(
 F_ID  varchar(100) not null,
 F_name varchar(50),
 F_price float,
 F_ischara Bit default(0),    ---0��ʾ�ǣ�1��ʾ����
 primary key(F_ID)
)
select *from Food
insert into Food(F_ID,F_name,F_price,F_ischara)
values
('1��','��������',99.9,1),
('2��','����ţ��',29.9,0),
('3��','�ع���',59.9,1),
('4��','Ϻ��',69.9,1),
('5��','ţ��',58.8,0),
('6��','�����',68.8,1)

select *from Food
drop table Food


---����������Take��
create table T_ake
(
 T_ID varchar(20),
 T_floor varchar(10),
 T_number int ,   --�ò�����
 T_rank varchar(50), --��λ�ȼ�
 T_statue varchar(10) constraint CK_statue_Take check(T_statue in('����','��')),
 primary key(T_ID)
)
select *from T_ake
insert into T_ake(T_ID,T_floor,T_number,T_rank,T_statue)
values
('WZ001','һ¥',4,'4����','��'),
('WZ002','��¥',6,'3����','��'),
('WZ003','��¥',8,'2����','��'),
('WZ004','��¥',10,'1����','��'),
('WZ005','��¥',12,'��������','��')

--����������O_rder��
create table O_rder
(
F_ID varchar(100),
U_ID  int,
T_ID  varchar(20),
O_ID  varchar(50),
O_time date,
O_statue varchar(10) constraint CK_JD check(O_statue in('�ѽӵ�','δ�ӵ�')),
O_number int,                ----������
O_total float,
O_paystatue Bit default(1), ---1�����Ѿ�֧����0����δ֧��
O_note varchar(50),  --��ע״̬
primary key(F_ID,U_ID,T_ID,O_ID),
foreign key(F_ID) references Food(F_ID),
foreign key(U_ID) references U_ser(U_ID),
foreign key(T_ID) references T_ake(T_ID)
)
select *from O_rder
drop table O_rder

---������ʦ��(Cooker)
create table Cooker
(
 CK_ID varchar(20),
 CK_name varchar(20),
 CK_age int,
 CK_sex varchar(5) constraint CK_sex_Cooker check(CK_sex in('��','Ů')),
 CK_statue varchar(5) constraint CK_statue_Cooker check(CK_statue in('æ','��')),
 primary key(CK_ID)
)
insert into Cooker(CK_ID,CK_name,CK_age,CK_sex,CK_statue)
values
('CS001','������',20,'��','��'),
('CS002','����',20,'��','��')

select *from Cooker

---�������˱�Make��
create table Make
(
 CK_ID varchar(20),
 F_ID varchar(100),
 M_ProduceID varchar(30) ,  --���˵ı��
 primary key(CK_ID,F_ID,M_ProduceID),
 foreign key(CK_ID) references Cooker(CK_ID),
 foreign key(F_ID) references Food(F_ID)
)

select*from Make
----��������Ա��(Waiter)
create table Waiter
(
  W_ID varchar(20),
  W_name varchar(20),
  W_age int,
  W_sex varchar(5) constraint CK_sex_Waiter check(W_sex in('��','Ů')),
  W_Statue varchar(5) constraint CK_statue_Waiter check(W_Statue in('æ','��')),
  primary key(W_ID)
)
select *from Waiter
insert into Waiter(W_ID,W_name,W_age,W_sex,W_Statue)
values
('FW001','���',20,'Ů','��'),
('FW002','����',20,'��','��')

--�����ϲ˱�(S_erver)
create table S_erver
(
  W_ID varchar(20),
  T_ID varchar(20),
  F_ID varchar(100),
  S_ProduceID varchar(30),
  Primary key(W_ID,T_ID,F_ID,S_ProduceID),
  foreign key(W_ID) references Waiter(W_ID),
  foreign key(T_ID) references T_ake(T_ID),
  foreign key(F_ID) references Food(F_ID)
)
select *from S_erver




select *from U_ser             ---�û���
select *from T_ake             ---������
select *from Food              ---�˵���
select *from O_rder            ---������
select *from Cooker            ---��ʦ��
select *from Make              ---���˱� 
select *from Waiter            ---����Ա��
select *from S_erver           ---����Ա�ϲ˱�

drop table U_ser
drop table T_ake
drop table Food
drop table O_rderble 
drop table Cooker
drop table Make
drop table Waiter
drop table S_erver

---��ӵ�һ��Լ������
/*
select *from U_ser
alter table U_ser
add constraint CK_Sex check(U_sex in('��','Ů'))
drop constraint CK_Sex 
*/
---------------------����ʵ�ֲ���--------------
--�û�ע��
create proc ZC
  @U_ID int,
  @U_name varchar(20),
  @U_loginID varchar(30),
  @U_password varchar(20),
  @U_score int ,
  @U_sex varchar(5),
  @U_Email varchar(50),
  @U_iphone varchar(11)
 AS 
   begin
    insert into U_ser(U_ID,U_name,U_loginID,U_password,U_score,U_sex,U_Email,U_iphone)
    values(@U_ID,@U_name,@U_loginID,@U_password,@U_score,@U_sex,@U_Email,@U_iphone) 
   end 
 Go  
exec  ZC 9226,'������','1499755237','123456',100,'��','1499755237@qq.com','18012822313'

select *from U_ser
drop proc ZC

---��͹���
select *from O_rder
create proc DC
@F_ID varchar(100),
@U_ID  int,
@T_ID  varchar(20),
@O_ID  varchar(50),
@O_number int,
@O_note varchar(50)  ----��ע
as 
declare
@O_total float,         --�ܼ۸�
@O_paystatue Bit,       ---1�����Ѿ�֧����0����δ֧��
@O_statue varchar(10),   ---������״̬  
@F_Price float,
@O_time date
begin
	select  @F_Price=F_price from Food where F_ID=@F_ID
	set @O_statue='δ�ӵ�'
	set @O_paystatue=1
	set @O_total= @F_Price*@O_number
	set @O_time=GETDATE()
	update T_ake set T_statue='����' where T_ID=@T_ID
	insert into O_rder(F_ID,U_ID,T_ID,O_ID,O_time,O_statue,O_number,O_total,O_paystatue,O_note)
	values(@F_ID,@U_ID,@T_ID,@O_ID,@O_time,@O_statue,@O_number,@O_total,@O_paystatue,@O_note)
end
Go
exec DC '1��',9226,'WZ005','LB#001',10,'������'
select *from O_rder
select *from T_ake
drop proc DC


----��ʦ�ӵ��Ĵ洢����
select *from Make
create proc CSJD
@CK_ID varchar(20),
@F_ID  varchar(100),
@M_ProduceID varchar(30)
as 
begin
 if not exists(select *from O_rder where F_ID=@F_ID)
   begin
    print '�ͻ���û�е������'
    rollback
   end
   insert into Make(CK_ID,F_ID,M_ProduceID)
   values(@CK_ID,@F_ID,@M_ProduceID)
   update Cooker set CK_statue='æ' where CK_ID=@CK_ID
end
GO
exec CSJD 'CS001','1��','M001'

select *from Make
drop proc CSJD

delete from Make
select *from Cooker


---����Ա�ӵ��Ĵ洢����
create proc FWYJD
@W_ID varchar(20),
@T_ID varchar(20),
@F_ID varchar(100),
@S_ProduceID varchar(30)
as 
 begin
    if not exists(select *from O_rder where T_ID=@T_ID)
     begin
       print'��ѡ���ϲ˵Ĳ�������';
       rollback;
     end
     if not exists(select *from O_rder where F_ID=@F_ID)
      begin
		  print '�˿Ͳ�û�е������';
		  rollback; 
      end
      insert into S_erver(W_ID,T_ID,F_ID,S_ProduceID)
      values(@W_ID,@T_ID,@F_ID,@S_ProduceID)
      update O_rder set O_statue='�ѽӵ�'
      update Waiter set W_statue='æ' where W_ID=@W_ID
 end
GO
exec FWYJD 'FW001','WZ005','1��','SC001'
select *from Waiter
select *from S_erver
select *from O_rder
drop proc FWYJD


Use �����������ݿ�
select *from Cooker
select *from Food
select *from O_rder
select *from T_ake
select *from Waiter
select *from S_erver
select *from U_ser
select *from Make