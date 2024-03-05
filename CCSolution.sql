-- CREATE TABLE VEHICLETABLE 
create table if not exists VehicleTable(vehicleID int primary key,
make varchar(255),
model varchar(255),
year year,
dailyRate decimal(4,2),
status bit,
passengerCapacity int,
engineCapacity int);

 -- INSERTING VALUE TO VEHICLETABLE
insert into VehicleTable(vehicleID,make,model,year,dailyRate,status,passengerCapacity,engineCapacity) values
(1,'Toyota','Camry',2022,50.00,1,4,1450),
(2,'Honda','Civic',2023,45.00,1,7,1500),
(3,'Ford','Focus',2022,48.00,0,4,1400),
(4,'Nissan','Altima',2023,52.00,1,7,1200),
(5,'Chevrolet','Malibu',2022,47.00,1,4,1800),
(6,'Hyundai','Sonata',2023,49.00,0,7,1400),
(7,'BMW','3 Series',2023,60.00,1,7,2499),
(8,'Mercedes','C-Class',2022,58.00,1,8,2599),
(9,'Audi','A4',2022,55.00,0,4,2500),
(10,'Lexus','ES',2023,54.00,1,4,2500);

-- CHECKING TABLE OUTPUT
select * from VehicleTable;

-- CREATE TABLE CUSTOMERTABLE
create table CustomerTable(customerID int primary key,
firstName varchar(255),
lastName varchar(255),
email varchar(255),
phoneNumber varchar(255));

-- INSERTING VALUE IN CUSTOMERTABLE
insert into CustomerTable(customerID,firstName,lastName,email,phoneNumber) values
(1,'John','Doe','johndoe@example.com','555-555-5555'),
(2,'Jane','Smith','janesmith@example.com','555-123-4567'),
(3,'Robert','Johnson','robert@example.com','555-789-1234'),
(4,'Sarah','Brown','sarah@example.com','555-456-7890'),
(5,'David','Lee','david@example.com','555-987-6543'),
(6,'Laura','Hall','laura@example.com','555-234-5678'),
(7,'Michael','Davis','michael@example.com','555-876-5432'),
(8,'Emma','Wilson','emma@example.com','555-432-1098'),
(9,'William','Taylor','william@example.com','555-321-6547'),
(10,'Olivia','Adams','olivia@example.com','555-765-4321');

-- CHECKING TABLE OUTPUT
select * from CustomerTable;

-- CREATING TABLE LEASETABLE
create table if not exists LeaseTable(leaseID int primary key,
vehicleID int,
customerID int,
startDate date,
endDate date,
type varchar(255),
foreign key (vehicleID) references VehicleTable(vehicleID),
foreign key (customerID) references CustomerTable(customerID));

-- INSERTING VALUE IN LEASETABLE
insert into LeaseTable(leaseID,vehicleID,customerID,startDate,endDate,type) values
(1,1,1,'2023-01-01','2023-01-05','Daily'),
(2,2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,5,'2023-05-05','2023-05-10','Daily'),
(6,4,3,'2023-06-15','2023-06-30','Monthly'),
(7,7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,8,'2023-08-12','2023-08-15','Monthly'),
(9,3,3,'2023-09-07','2023-09-10','Daily'),
(10,10,10,'2023-10-10','2023-10-31','Monthly');

-- CHECKING TABLE OUTPUT
select * from LeaseTable;

-- CREATE TABLE PAYMENTTABLE
create table if not exists PaymentTable(paymentID int primary key,
leaseID int,
paymentDate date,
amount decimal(10,2),
foreign key (leaseID) references LeaseTable(leaseID));

-- INSERT VALUE IN PAYMENTTABLE
insert into PaymentTable(paymentID,leaseID,paymentDate,amount) values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7,'2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-25',1500.00);

-- CHECK TABLE OUTPUT
select * from PaymentTable;

-- QUESTION 1:

update VehicleTable set dailyRate = 68.00 where make = 'Mercedes';

-- QUESTION 2:

set @CustomerID = 1;

delete from PaymentTable where leaseID in(select leaseID from LeaseTable where customerID=@CustomerID);

delete from LeaseTable where customerID = @CustomerID;

delete from CustomerTable where customerID = @CustomerID;

-- QUESTION 3:

alter table PaymentTable change column paymentDate transactionDate date;

-- QUESTION 4:

select * from CustomerTable where email='sarah@example.com';

-- QUESTION 5:

select v.status,c.*,l.* from CustomerTable c join
LeaseTable l on c.customerID=l.customerID join
VehicleTable v on l.vehicleID=v.vehicleID where v.status=1 and c.customerID=3;

-- QUESTION 6:

select sum(amount) from PaymentTable p join 
LeaseTable l on p.leaseID=l.leaseID join
CustomerTable c on l.customerID=c.customerID where c.phoneNumber = '555-789-1234';

-- QUESTION 7:

select avg(dailyRate) from VehicleTable where status = 1;

-- QUESTION 8:

select vehicleID,make,model,dailyRate from VehicleTable order by dailyRate desc limit 1;

-- QUESTION 9:

select distinct c.customerID,c.firstName,c.lastName,v.vehicleID,v.make,v.model from CustomerTable c join
LeaseTable l on c.customerID = l.customerID join VehicleTable v on
l.vehicleID = v.vehicleID where c.customerID = 3;

-- QUESTION 10:

select * from LeaseTable order by endDate desc, startDate desc limit 1;

-- QUESTION 11:

select * from PaymentTable where year(transactionDate) = 2023;

-- QUESTION 12:

select c.* from CustomerTable c left join
LeaseTable l on c.customerID = l.customerID left join
PaymentTable p on l.leaseID = p.leaseID
where p.leaseID is null;


-- QUESTION 13:

select v.vehicleID,v.make,v.model,v.year, 
coalesce(sum(p.amount),0) as totalPayments from VehicleTable v left join
LeaseTable l on v.vehicleID = l.vehicleID left join
PaymentTable p on l.leaseID =p.leaseID group by v.vehicleID,v.make,v.model,v.year;
  

-- QUESTION 14:

select coalesce(sum(p.amount),0) as TotalPayments,c.* from CustomerTable c left join
LeaseTable l on c.customerID = l.customerID left join
PaymentTable p on l.leaseID = p.leaseID group by c.customerID,c.firstName,c.lastName;

-- QUESTION 15

select l.leaseID, v.* from LeaseTable l left join
VehicleTable v on l.vehicleID=v.vehicleID order by l.leaseID asc;


-- QUESTION 16:

select v.*,c.*,l.* from VehicleTable v join
LeaseTable l on v.vehicleID = l.vehicleID join
CustomerTable c on l.customerID = c.customerID where v.status=1;

-- QUESTION 17:

select sum(p.amount) as TotalPayments,c.* from CustomerTable c left join
LeaseTable l on c.customerID = l.customerID left join
PaymentTable p on l.leaseID = p.leaseID group by c.customerID,c.firstName,c.lastName 
order by TotalPayments desc limit 1;


-- QUESTION 18:

select v.vehicleID,v.make,v.model,v.year,l.startDate,l.endDate,c.customerID from
VehicleTable v join LeaseTable l on v.vehicleID = l.vehicleID join
CustomerTable c on l.customerID = c.customerID 
where l.startDate <= CURDATE() and l.endDate >= CURDATE();

-- The output is empty as there are no leases currently active.

















































 

