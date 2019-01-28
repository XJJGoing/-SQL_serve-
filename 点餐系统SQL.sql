create database 餐饮管理数据库
on primary
(
 name='Order_Date',
 filename='G:\语言极其数据库\SQL\课设\点餐系统阶段二的设计\餐饮管理_LOG.mdf',
 size=20mb,
 maxsize=1000mb,
 filegrowth=5%
)

LOG on
( 
 name='Order_Log',
 filename='G:\语言极其数据库\SQL\课设\点餐系统阶段二的设计\餐饮管理_LOG.ldf',
 size=20mb,
 maxsize=1000mb,
 filegrowth=20mb
)
Use 餐饮管理数据库

----创建用户注册表(U_ser)
create table U_ser
(
  U_ID int primary key not null,
  U_name varchar(20),
  U_loginID varchar(30),
  U_password varchar(20),
  U_score int ,
  U_sex varchar(5) constraint CK_Sex check(U_sex in('男','女')),
  U_Email varchar(50),
  U_iphone varchar(11)
)
select *from U_ser
select *from U_ser


---创建菜单表（Food）
create table Food
(
 F_ID  varchar(100) not null,
 F_name varchar(50),
 F_price float,
 F_ischara Bit default(0),    ---0表示是，1表示不是
 primary key(F_ID)
)
select *from Food
insert into Food(F_ID,F_name,F_price,F_ischara)
values
('1号','爆炒田螺',99.9,1),
('2号','撒尿牛丸',29.9,0),
('3号','地锅鸡',59.9,1),
('4号','虾滑',69.9,1),
('5号','牛肚',58.8,0),
('6号','酸菜鱼',68.8,1)

select *from Food
drop table Food


---创建餐桌表（Take）
create table T_ake
(
 T_ID varchar(20),
 T_floor varchar(10),
 T_number int ,   --用餐人数
 T_rank varchar(50), --座位等级
 T_statue varchar(10) constraint CK_statue_Take check(T_statue in('有人','空')),
 primary key(T_ID)
)
select *from T_ake
insert into T_ake(T_ID,T_floor,T_number,T_rank,T_statue)
values
('WZ001','一楼',4,'4级桌','空'),
('WZ002','二楼',6,'3级桌','空'),
('WZ003','三楼',8,'2级桌','空'),
('WZ004','四楼',10,'1级桌','空'),
('WZ005','五楼',12,'豪华大桌','空')

--创建订单表（O_rder）
create table O_rder
(
F_ID varchar(100),
U_ID  int,
T_ID  varchar(20),
O_ID  varchar(50),
O_time date,
O_statue varchar(10) constraint CK_JD check(O_statue in('已接单','未接单')),
O_number int,                ----菜数量
O_total float,
O_paystatue Bit default(1), ---1代表已经支付，0代表未支付
O_note varchar(50),  --备注状态
primary key(F_ID,U_ID,T_ID,O_ID),
foreign key(F_ID) references Food(F_ID),
foreign key(U_ID) references U_ser(U_ID),
foreign key(T_ID) references T_ake(T_ID)
)
select *from O_rder
drop table O_rder

---创建厨师表(Cooker)
create table Cooker
(
 CK_ID varchar(20),
 CK_name varchar(20),
 CK_age int,
 CK_sex varchar(5) constraint CK_sex_Cooker check(CK_sex in('男','女')),
 CK_statue varchar(5) constraint CK_statue_Cooker check(CK_statue in('忙','闲')),
 primary key(CK_ID)
)
insert into Cooker(CK_ID,CK_name,CK_age,CK_sex,CK_statue)
values
('CS001','顾天乐',20,'男','闲'),
('CS002','刘泽华',20,'男','闲')

select *from Cooker

---创建做菜表（Make）
create table Make
(
 CK_ID varchar(20),
 F_ID varchar(100),
 M_ProduceID varchar(30) ,  --做菜的编号
 primary key(CK_ID,F_ID,M_ProduceID),
 foreign key(CK_ID) references Cooker(CK_ID),
 foreign key(F_ID) references Food(F_ID)
)

select*from Make
----创建服务员表(Waiter)
create table Waiter
(
  W_ID varchar(20),
  W_name varchar(20),
  W_age int,
  W_sex varchar(5) constraint CK_sex_Waiter check(W_sex in('男','女')),
  W_Statue varchar(5) constraint CK_statue_Waiter check(W_Statue in('忙','闲')),
  primary key(W_ID)
)
select *from Waiter
insert into Waiter(W_ID,W_name,W_age,W_sex,W_Statue)
values
('FW001','高瑾',20,'女','闲'),
('FW002','吕斌',20,'男','闲')

--创建上菜表(S_erver)
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




select *from U_ser             ---用户表
select *from T_ake             ---餐桌表
select *from Food              ---菜单表
select *from O_rder            ---订单表
select *from Cooker            ---厨师表
select *from Make              ---做菜表 
select *from Waiter            ---服务员表
select *from S_erver           ---服务员上菜表

drop table U_ser
drop table T_ake
drop table Food
drop table O_rderble 
drop table Cooker
drop table Make
drop table Waiter
drop table S_erver

---添加的一个约束条件
/*
select *from U_ser
alter table U_ser
add constraint CK_Sex check(U_sex in('男','女'))
drop constraint CK_Sex 
*/
---------------------功能实现部分--------------
--用户注册
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
exec  ZC 9226,'林永健','1499755237','123456',100,'男','1499755237@qq.com','18012822313'

select *from U_ser
drop proc ZC

---点餐功能
select *from O_rder
create proc DC
@F_ID varchar(100),
@U_ID  int,
@T_ID  varchar(20),
@O_ID  varchar(50),
@O_number int,
@O_note varchar(50)  ----备注
as 
declare
@O_total float,         --总价格
@O_paystatue Bit,       ---1代表已经支付，0代表未支付
@O_statue varchar(10),   ---订单的状态  
@F_Price float,
@O_time date
begin
	select  @F_Price=F_price from Food where F_ID=@F_ID
	set @O_statue='未接单'
	set @O_paystatue=1
	set @O_total= @F_Price*@O_number
	set @O_time=GETDATE()
	update T_ake set T_statue='有人' where T_ID=@T_ID
	insert into O_rder(F_ID,U_ID,T_ID,O_ID,O_time,O_statue,O_number,O_total,O_paystatue,O_note)
	values(@F_ID,@U_ID,@T_ID,@O_ID,@O_time,@O_statue,@O_number,@O_total,@O_paystatue,@O_note)
end
Go
exec DC '1号',9226,'WZ005','LB#001',10,'不吃辣'
select *from O_rder
select *from T_ake
drop proc DC


----厨师接单的存储过程
select *from Make
create proc CSJD
@CK_ID varchar(20),
@F_ID  varchar(100),
@M_ProduceID varchar(30)
as 
begin
 if not exists(select *from O_rder where F_ID=@F_ID)
   begin
    print '客户并没有点这个菜'
    rollback
   end
   insert into Make(CK_ID,F_ID,M_ProduceID)
   values(@CK_ID,@F_ID,@M_ProduceID)
   update Cooker set CK_statue='忙' where CK_ID=@CK_ID
end
GO
exec CSJD 'CS001','1号','M001'

select *from Make
drop proc CSJD

delete from Make
select *from Cooker


---服务员接单的存储过程
create proc FWYJD
@W_ID varchar(20),
@T_ID varchar(20),
@F_ID varchar(100),
@S_ProduceID varchar(30)
as 
 begin
    if not exists(select *from O_rder where T_ID=@T_ID)
     begin
       print'你选择上菜的餐桌有误';
       rollback;
     end
     if not exists(select *from O_rder where F_ID=@F_ID)
      begin
		  print '顾客并没有点这个菜';
		  rollback; 
      end
      insert into S_erver(W_ID,T_ID,F_ID,S_ProduceID)
      values(@W_ID,@T_ID,@F_ID,@S_ProduceID)
      update O_rder set O_statue='已接单'
      update Waiter set W_statue='忙' where W_ID=@W_ID
 end
GO
exec FWYJD 'FW001','WZ005','1号','SC001'
select *from Waiter
select *from S_erver
select *from O_rder
drop proc FWYJD


Use 餐饮管理数据库
select *from Cooker
select *from Food
select *from O_rder
select *from T_ake
select *from Waiter
select *from S_erver
select *from U_ser
select *from Make