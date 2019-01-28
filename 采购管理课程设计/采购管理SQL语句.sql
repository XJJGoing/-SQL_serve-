------------------创建采购管理数据库---------------
create database 采购管理数据库
on primary
(
 name='Purchase_data',
 filename='G:\语言极其数据库\SQL\课设\采购管理_DATA.mdf',
 size=20mb,
 maxsize=1000mb,
 filegrowth=5%
)
LOG ON
(
name='Purchase_log',
filename='G:\语言极其数据库\SQL\课设\采购管理_LOG.ldf',
size=20mb,
maxsize=1000mb,
filegrowth=10mb
)
Use 采购管理数据库

--创建任务表
create table Task
(
 T_ID int ,
 T_time date ,
 T_statue varchar(20),
 T_component_id int,
 T_component_name varchar(20) ,
 T_jiliang varchar(10) ,
 T_number int ,
 T_find_time date,
 primary key(T_component_id)
)

truncate table Task
insert into Task(T_ID, T_time, T_statue,T_component_id,T_component_name,T_jiliang,T_number,T_find_time)
values
(001,'2017-01-31','未下达',1210,'波纹管257-04-00','只',80,'2019-01-01'),
(002,'2017-01-31','未下达',1410,'传动齿轮130','件',29,'2019-01-01'),
(003,'2017-01-31','未下达',1610,'传感器1638345—7','件',100,'2019-01-01'),
(004,'2017-01-31','未下达',1810,'弹簧座25','件',4,'2019-01-01'),
(005,'2017-01-31','未下达',1910,'弹簧杆','件',2,'2019-01-01'),
(006,'2017-01-31','未下达',2110,'弹性软管150*30','件',18,'2019-01-01'),
(007,'2017-01-31','未下达',2210,'挡圈22','件',2,'2019-01-01'),
(008,'2017-01-31','未下达',2410,'导气管','件',1,'2019-01-01'),
(009,'2017-01-31','未下达',2510,'底板','件',1,'2019-01-01'),
(010,'2017-01-31','未下达',2610,'底座','件',3,'2019-01-01'),
(011,'2017-01-31','未下达',2710,'垫片24','件',4175,'2019-01-01')
select *from Task
drop table Task
--员工表
create table Worker
(
  W_ID varchar(50) primary key,
  W_name varchar(50) not null,
  W_post varchar(20) not null,
  W_sex bit default(0), --0表示女，1表示男
  W_boss varchar(20),
  W_iphone varchar(11) 
)
insert into Worker(W_ID,W_name,W_post, W_sex, W_boss, W_iphone)
values
('#001','吕斌','询价人员',1,'办公室主任','18178595971'),
('#002','林永健','合同签订人',1,'办公室主任','18178595972')


select *from Worker
drop table Worker
--询价表
create table Inquiry
(
  T_component_id int ,
  I_name varchar(100) ,
  I_jiliang varchar(10) ,
  I_max float,
  I_min float,
  I_number int ,
  I_price float,
  primary key(T_component_id),
  foreign key(T_component_id) references Task(T_component_id) 
)
insert into Inquiry(T_component_id,I_name, I_jiliang, I_max,I_min,I_number,I_price)
values
/*(1210,'波纹管257-04-00','只',14.44,9.44,80,11.11),
(1410,'传动齿轮130','件',5237.71,3424.66,29,4029.01),
(1610,'传感器1638345—7','件',94.76,61.96,100,72.89),
(1810,'弹簧座25','件',21.83,14.27,4,16.79),
(1910,'弹簧杆','件',18.33,11.99,2,14.10),
(2110,'弹性软管150*30','件',55.17,36.07,18,42.44),
(2210,'挡圈22','件',69.88,45.69,2,53.75),
(2410,'导气管','件',23.00,15.04,1,17.69),
(2510,'底板0','件',64.97,42.48,1,49.98),
(2610,'底座','件',22.2,18.9,3,20.0),
(2710,'垫片24','件',3.4,2.8,4175,3)*/

select *from Inquiry
drop table Inquiry

--供应商表
create table Support
(
S_ID varchar(20) not null primary key,
S_name Varchar(50) not null
)
insert into Support(S_ID,S_name)
values
('Kh00951','南京机械有限公司'),
('Kh00963','浙江船舶配套公司'),
('Kh00968','浙江船舶配套科技公司'),
('Kh00102','常州袁海船用设备有限公司'),
('Kh00104','无锡标准件有限公司'),
('Kh00033','无锡管道件厂')
select *from Support
drop table Support
--审价表
create table Price_table
(
T_component_id int,  --
S_ID varchar(20),  --
S_name varchar(50) ,
W_ID varchar(50) , --
Pt_time date ,
Pt_number float,
Pt_price float ,
Pt_total float,
Pt_statue varchar(20),
primary key(T_component_id,S_ID,W_ID),
foreign key(T_component_id) references Inquiry(T_component_id),
foreign key(S_ID) references Support(S_ID),
foreign key(W_ID) references Worker(W_ID),
check(Pt_total=pt_number*pt_price)
)
/*insert into Price_table(T_component_id,S_ID,S_name,W_ID,Pt_time,Pt_number,Pt_price,Pt_total,Pt_statue)
values
(1210,'Kh00951','南京机械有限公司','#001','2018-12-30',80,12.0,960.0),
(1210,'Kh00963','浙江船舶配套公司','#001','2018-12-30',80,13.0,1040.0),
(1210,'Kh00968','浙江船舶配套科技公司','#001','2018-12-30',80,14.0,1120.0),

(1410,'Kh00951','南京机械有限公司','#001','2018-12-30',29,4000.0,116000.0),
(1410,'Kh00963','浙江船舶配套公司','#001','2018-12-30',29,4100.0,118900.0),
(1410,'Kh00968','浙江船舶配套科技公司','#001','2018-12-30',29,4200.0,121800),

(1610,'Kh00102','常州袁海船用设备有限公司','#001','2018-12-30',100,70.0,7000.0),
(1610,'Kh00104','无锡标准件有限公司','#001','2018-12-30',100,80.0,8000.0),

(1810,'Kh00104','无锡标准件有限公司','#001','2018-12-30',4,15.0,60.0),
(1810,'Kh00951','南京机械有限公司','#001','2018-12-30',4,20.0,80.0),

(1910,'Kh00963','浙江船舶配套公司','#001','2018-12-30',2,14.0,28.0),
(1910,'Kh00104','无锡标准件有限公司','#001','2018-12-30',2,15.0,30.0),

(2110,'Kh00102','常州袁海船用设备有限公司','#001','2018-12-30',18,40.0,720.0),
(2110,'Kh00968','浙江船舶配套科技公司','#001','2018-12-30',18,50.0,900.0),

(2210,'Kh00951','南京机械有限公司','#001','2018-12-30',2,50.0,100.0),
(2210,'Kh00104','无锡标准件有限公司','#001','2018-12-30',2,60.0,120.0),

(2410,'Kh00104','无锡标准件有限公司','#001','2018-12-30',1,15.0,15.0),
(2410,'Kh00033','无锡管道件厂','#001','2018-12-30',1,20.0,20.0),

(2510,'Kh00951','南京机械有限公司','#001','2018-12-30',1,50.0,50.0),
(2510,'Kh00968','浙江船舶配套科技公司','#001','2018-12-30',1,60.0,60.0),

(2610,'Kh00968','浙江船舶配套科技公司','#001','2018-12-30',3,20.0,60.0),
(2610,'Kh00102','常州袁海船用设备有限公司','#001','2018-12-30',3,30.0,90.0),

(2710,'Kh00102','常州袁海船用设备有限公司','#001','2018-12-30',4175,3.0,12525.0),
(2710,'Kh00104','无锡标准件有限公司','#001','2018-12-30',4175,4.0,16700.0)
*/

select *from Price_table
drop table Price_table

--Agreement合同表
create table Agreement
(
A_ID varchar(50)  not null,  --1
S_ID varchar(20) not null,   --2
W_ID varchar(50) not null,   --3
T_component_id int not null, --4
--T_component_name varchar(20),
A_jiliang varchar(10),
A_price float,
A_number float,
A_total float,
--A_support_name varchar(20) not null,
--A_worker_name varchar(20) not null,
A_project_id varchar(30) not null,
A_project_name varchar(50) not null,
primary key(A_ID,S_ID,W_ID,T_component_id),
foreign key(S_ID) references Support(S_ID),
foreign key(W_ID) references Worker(W_ID),
foreign key(T_component_id) references Task(T_component_id)
)
/*insert into Agreement(A_ID,S_ID,W_ID,T_component_id,A_jiliang,A_price,A_number,A_total,A_project_id,A_project_name)
values
('HT001','Kh00951','#002',1210,'只',12.0,80,960.0,'GC160010','上海船舶ccs'),
('HT001','Kh00951','#002',1410,'件',4000.0,29,116000.0,'GC160010','上海船舶ccs'),
('HT001','Kh00951','#002',2210,'件',50.0,2,100.0,'GC160010','上海船舶ccs'),
('HT001','Kh00951','#002',2510,'件',50.0,1,50.0,'GC160010','上海船舶ccs'),

('HT002','Kh00102','#002',1610,'件',70.0,100,7000.0,'GC160004','浙江船舶ccs'),
('HT002','Kh00102','#002',2110,'件',40.0,18,720.0,'GC160004','浙江船舶ccs'),
('HT002','Kh00102','#002',2710,'件',3.0,4175,12525.0,'GC160004','浙江船舶ccs'),

('HT003','Kh00104','#002',1810,'件',15.0,4,60.0,'GC160005',' 泸东船舶ccs'),
('HT003','Kh00104','#002',2410,'件',15.0,1,15.0,'GC160005',' 泸东船舶ccs'),

('HT004','Kh00963','#002',1910,'件',14.0,2,28.0,'GC160005',' 泸东船舶ccs'),

('HT005','Kh00968','#002',2610,'件',20.0,3,60.0,'GC160010','上海船舶ccs')
*/
select *from Agreement
drop table Agreement


--Bill表
create table Bill
(
T_component_id int not null,
S_ID varchar(20) not null,
B_ID varchar(50) not null ,
B_time Date not null,
B_type varchar(50) not null,
B_tax_price float not null,
B_tax float not null,
--B_w_id int not null,
--B_w_name varchar(20) not null,
B_doing varchar(50) not null,
primary key(T_component_id,S_ID,B_ID),
foreign key(T_component_id) references Task(T_component_id),
foreign key(S_ID) references Support(S_ID)
)
/*insert into Bill(B_ID,S_ID,T_component_id,B_time,B_type,B_tax_price,B_tax,B_doing)
values
('FP001','Kh00951',1210,'2019-01-02','企业发票',100.0,1060.0,'国家发票总局'),
('FP001','Kh00951',1410,'2019-01-02','企业发票',100.0,11700.0,'国家发票总局'),
('FP001','Kh00951',2510,'2019-01-02','企业发票',10.0,60.0,'国家发票总局'),
('FP001','Kh00951',2210,'2019-01-02','企业发票',20.0,120.0,'国家发票总局'),

('FP002','Kh00102',1610,'2019-01-02','企业发票',200.0,7200.0,'国家发票总局'),
('FP002','Kh00102',2110,'2019-01-02','企业发票',20.0,740.0,'国家发票总局'),
('FP002','Kh00102',2710,'2019-01-02','企业发票',1000.0,13525.0,'国家发票总局'),

('FP003','Kh00104',1810,'2019-01-02','企业发票',10.0,70.0,'国家发票总局'),
('FP003','Kh00104',2410,'2019-01-02','企业发票',5.0,20.0,'国家发票总局'),

('FP004','Kh00963',1910,'2019-01-02','企业发票',2.0,30.0,'国家发票总局'),

('FP005','Kh00968',2610,'2019-01-02','企业发票',20.0,80.0,'国家发票总局')
*/
select *from Bill
drop table Bill

--查询所有表的操作
select *from Agreement
select *from Bill 
select *from Inquiry 
select *from Price_table
select *from Support
select *from Task
select *from Worker

--删除所有表的操作
drop table Agreement
drop table Bill
drop table Inquiry
drop table Support

drop table Task
drop table Worker
drop table Price_table


-------------------------------------功能实现板块-----------------------
--下达采购任务：
create proc do_Task
@Tno int,
@T_Max float,
@T_Min float,
@T_Price float
AS declare
@T_component int ,    --- 下单任务标号的物资编号
@T_name varchar(20),  --物资零件的名称
@T_JI varchar(10),    --物资的计量单位
@T_num  int           ---物资的数量
 begin
   update Task set T_statue='已下达' where T_ID=@Tno
   select @T_component=T_component_id from Task  where T_ID=@Tno
   select @T_name=T_component_name from Task where T_ID=@Tno
   select @T_JI=T_jiliang from Task where T_ID=@Tno
   select @T_num=T_number from Task where T_ID=@Tno
   insert into Inquiry(T_component_id,I_name,I_jiliang,I_number,I_max,I_min,I_price)  
   values
   (@T_component,@T_name,@T_JI,@T_num,@T_Max,@T_Min,@T_Price)
   --执行生成审价单的过程
 end  
Go 
exec do_Task 001,14.44,9.44,11.11
--drop proc do_Task

select *from Task
select *from Inquiry

---撤销任务 
create proc cancel_Task
@Tno int
AS declare
@T_component int
  begin 
    select @T_component=T_component_id from Task where T_ID=@Tno
    update Task set T_statue='未下达' where T_ID=@Tno
    delete from Price_table
    delete from Inquiry  where T_component_id=@T_component	
  END
GO
exec  cancel_Task 001

select *from Task 
select *from Inquiry

select *from Price_table

--生成审价单的存储过程

select *from Inquiry

create proc Xun_Price
@T_component int,  ---供应零件的编号
@S_ID varchar(20),          ---供应商的编号
@S_name varchar(50), ---供应商的名字
@Pt_price float     --供应商给的价格
as declare
@Pt_number int,
@W_ID varchar(20),
@Pt_time date,
@pt_total float,
@statue varchar(10)
 begin 
  select @Pt_number=I_number from Inquiry where T_component_id=@T_component
  set @W_ID='#001'
  set @Pt_time='2018-12-30'
  set @pt_total=@Pt_number*@Pt_price
  set @statue='未审核'
  insert into Price_table(T_component_id,S_ID,S_name,W_ID,Pt_time,Pt_number,Pt_price,Pt_total,Pt_statue)
  values(@T_component,@S_ID,@S_name,@W_ID,@Pt_time,@Pt_number,@Pt_price,@pt_total,@statue)
 end 
Go

exec Xun_Price 1210,'Kh00951','南京机械有限公司',12.0
exec Xun_Price 1210,'Kh00963','浙江船舶配套公司',13.0
exec Xun_Price 1210,'Kh00968','浙江船舶配套科技公司',14.0

select *from Price_table
drop proc  Xun_Price

--审价选定
create proc XDSJ
@T_component int,      --物资的编号
@T_SID varchar(20)    --商家的编号
as 
 begin
  update Price_table set Pt_statue='已审核' where T_component_id=@T_component and S_ID=@T_SID;
 end
GO 
exec XDSJ  1210,'Kh00951'
drop proc XDSJ

select *from Price_table


select *from for_Agreement
drop view for_Agreement

--撤销审价的过程
create proc Cancel_Price
@T_component int,        --物资的编号
@T_SID varchar(20)    --商家的编号
AS 
  begin
    update Price_table set Pt_statue='未审核' where T_component_id=@T_component and S_ID=@T_SID
  end
Go

exec Cancel_Price 1210,'Kh00951'
select *from Price_table


--对已经审核的表提取出来生成一张视图，用来提供暂存放已经审核的元组
create view for_Agreement
as
select *from Price_table 
where Pt_statue='已审核'

select *from for_Agreement
    
drop view for_Agreement
--提交后实现下功能    
select*from Agreement 
                         ----对price_table表的审价的过程,并由选定的物资的供应商，生成相应的合同
create proc SJ_Price
@A_Ht varchar(20),    ------ 合同的编号
@T_component int,         ---物资的编号
@S_ID varchar(20),         ---商家的ID
@A_ProjectID  varchar(30),      ---工程的编号
@A_ProjectName  varchar(50)   --用于项目号的名称
as declare
@A_JL varchar(10),        ----计量单位
@A_P float,                  ----单价
@num int,                    --数量
@total float,               ---总价格
@W_ID varchar(20)          --签订合同的员工的ID
begin 
  select @A_JL=I_jiliang from Inquiry where T_component_id=@T_component
  select @A_P=Pt_price  from for_Agreement where T_component_id=@T_component
  select @num=Pt_number from for_Agreement where T_component_id=@T_component
  set @total=@num*@A_P
  set @W_ID='#002'
  insert into Agreement(A_ID,S_ID,W_ID,T_component_id,A_jiliang,A_price,A_number,A_total,A_Project_id,A_project_name)
  values(@A_Ht,@S_ID,@W_ID,@T_component,@A_JL,@A_P,@num,@total,@A_ProjectID,@A_ProjectName)
end
Go
exec SJ_Price 'HT001',1210,'Kh00951','GC160010','上海船舶ccs'



/*exec SJ_Price 'HT001',1410,'Kh00951','GC160010','上海船舶ccs'
exec SJ_Price 'HT001',2210,'Kh00951','GC160010','上海船舶ccs'
exec SJ_Price 'HT001',2510,'Kh00951','GC160010','上海船舶ccs'*/

select *from Agreement
delete from Agreement
drop PROC SJ_Price
----生成发票的过程
select *from Bill
delete from Bill
create proc SC_Bill
@T_component int,
@S_ID varchar(20),
@B_ID varchar(50),
@B_time  date
as 
declare

	@B_type varchar(20),
	@B_tax_price float,
	@B_tax float,
	@B_doing varchar(20),
	@B_m float -----------中间变量
begin
	set @B_type='企业发票'
	set @B_tax_price=100
	set @B_doing='企业发票局'
	select @B_m=A_total from Agreement where T_component_id=@T_component
	set @B_tax=@B_m+@B_tax_price
	insert into Bill(T_component_id,S_ID,B_ID,B_time,B_type,B_tax_price,B_tax,B_doing)
	values(@T_component,@S_ID,@B_ID,@B_time,@B_type,@B_tax_price,@B_tax,@B_doing)
end
Go
exec SC_Bill 1210,'Kh00951','FP001','2019-1-1'

exec SC_Bill 1410,'Kh00951','FP001','2019-1-1'
exec SC_Bill 2210,'Kh00951','FP001','2019-1-1'
exec SC_Bill 2510,'Kh00951','FP001','2019-1-1'
--删除
drop PROC SC_Bill


delete from  Inquiry
select *from Inquiry
select *from Price_table
select *from Agreement
select *from Bill

select *from Support
select *from Inquiry
select *from Price_table

delete from Price_table