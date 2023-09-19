drop table MedRequest cascade constraints;
drop table LabRequest cascade constraints;
drop table TransportRequest cascade constraints;
drop table ServiceRequest cascade constraints;
drop table MedicalEquipment cascade constraints;
drop table Patient cascade constraints;
drop table Location cascade constraints;
drop table LocationType cascade constraints;
DROP TABLE Employees cascade constraints;
DROP TABLE EquipPerRequest cascade constraints;

create table LocationType (
	locationTypeID varchar2(4),
	description varchar2(40),
	constraint LocationType_locationTypeID_PK primary key (locationTypeID)
);

create table Location (
	locationID varchar2(9),
	xcoord number(5),
	ycoord number(5),
	floor varchar2(2),
	buildingName varchar2(40),
	longName varchar2(40),
	shortName varchar2(40),
	locationType varchar2(4),
	constraint Location_locationID_PK primary key (locationID),
	constraint Location_locationType_FK foreign key (locationType)
	references LocationType (locationTypeID),
	constraint Location_floor_values check (floor in ('L2','L1','1','2','3','4','5'))
);

create table MedicalEquipment (
	itemID varchar2(10),
	equipmentType varchar2(15),
	status varchar2(5),
	locationID varchar2(9),
	constraint MedEquip_itemID_PK primary key (itemID),
	constraint MedEquip_locationID_FK foreign key (locationID)
	references Location (locationID),
	constraint MedEquip_status_values check (status in ('CLEAN','DIRTY','INUSE')),
	constraint MedEquip_locationID_notnull check (locationID is not null)
);

create table Patient (
	patientID number(5),
	firstName varchar2(40),
	lastName varchar2(40),
	phoneNumber number(10),
	city varchar2(40),
	state varchar2(2),
	locationID varchar2(9),
	constraint Patient_patientID_PK primary key (patientID),
	constraint Patient_locationID_FK foreign key (locationID)
    	references Location (locationID)
);

CREATE TABLE Employees (
	employeeID VARCHAR2(40) NOT NULL,
	username VARCHAR2(40),
	password VARCHAR2(80),
	firstName VARCHAR2(40),
	lastName VARCHAR2(40),
	salaryGrade NUMBER(2),
	securityClearance VARCHAR2(40),
	npi NUMBER(10),
	locationID VARCHAR2(9),
    
	CONSTRAINT EMP_EMPLOYEEID_PK PRIMARY KEY (employeeID),
	CONSTRAINT EMP_LOCATIONID_FK FOREIGN KEY (locationID) REFERENCES Location (locationID),
	CONSTRAINT EMP_U1 UNIQUE (username),
	CONSTRAINT EMP_U2 UNIQUE (npi),
	CONSTRAINT EMP_SALARY_R1 CHECK ((salaryGrade BETWEEN 10 AND 45) OR (salaryGrade IS NULL)),
	CONSTRAINT EMP_SECURITY_R2 CHECK (securityClearance in ('A1','B1','B2','C1','C2','C3',NULL)),
	CONSTRAINT EMP_NPI_R3 CHECK (LENGTH(CAST(npi AS CHAR(10))) = 10 OR (npi IS NULL))
);

create table ServiceRequest (
	requestID number(5),
	requestType varchar2(40),
	status varchar2(40),
	requestingEmployee varchar2(40),
	assignedEmployee varchar2(40),
	destination varchar2(9),
	constraint ServReq_ID_type_PK primary key (requestID, requestType),
	constraint ServReq_requestingEmployee_FK foreign key (requestingEmployee) references Employees (employeeID),
	constraint ServReq_assignedEmployee_FK foreign key (assignedEmployee) references Employees (employeeID),
	constraint ServReq_destination_FK foreign key (destination) references Location (locationID),
	constraint ServReq_requestType_Val check (requestType in ('MED', 'LAB', 'TRA')),
	constraint ServReq_status_Val check (status in ('unassigned', 'assigned', 'beingProcessed', 'done', 'canceled'))
);

create table MedRequest (
	requestID number(5),
	requestType varchar2(40),
	medRequestType varchar2(40),
	medEquipmentIDs varchar2(15),
	constraint MedRequest_requestID_PK primary key (requestID),
	constraint MedRequest_requestType_Val check (requestType in ('MED')),
	constraint MedRequest_ID_type_FK foreign key (requestID, requestType) references ServiceRequest (requestID, requestType),
	constraint MedRequest_medRequestType_Val check (medRequestType in ('DELIVERY', 'CLEANING')),
	constraint MedRequest_medEquipmentIDs_FK foreign key (medEquipmentIDs) references MedicalEquipment (itemID)
);

create table LabRequest (
	requestID number(5),
	requestType varchar2(40),
	labType varchar2(40),
	patientID number(5),
	constraint LabRequest_requestID_PK primary key (requestID),
	constraint LabRequest_requestType_Val check (requestType in ('LAB')),
	constraint LabRequest_ID_type_FK foreign key (requestID, requestType) references ServiceRequest (requestID, requestType),
	constraint LabRequest_labType_Val check (labType in ('blood', 'urine', 'stool', 'XRay', 'MRI')),
	constraint LabRequest_patientID_FK foreign key (patientID) references Patient (patientID)
);

create table TransportRequest (
	requestID number(5),
	requestType varchar2(40),
	medEquipmentID varchar2(40),
	patientID number(5),
	constraint TraRequest_requestID_PK primary key (requestID),
	constraint TraRequest_requestType_Val check (requestType in ('TRA')),
	constraint TraRequest_ID_type_FK foreign key (requestID, requestType) references ServiceRequest (requestID, requestType),
	constraint TraRequest_medEquipmentID_FK foreign key (medEquipmentID) references MedicalEquipment (itemID),
	constraint TraRequest_patientID_FK foreign key (patientID) references Patient (patientID)
);

CREATE TABLE EquipPerRequest (
	requestID NUMBER(5) NOT NULL,
	itemID VARCHAR2(10) NOT NULL,
	
	CONSTRAINT EQUPERREQ_PK PRIMARY KEY (requestID, itemID),
    CONSTRAINT EQUPERREQ_REQID_FK FOREIGN KEY (requestID) REFERENCES MedRequest(requestID),
    CONSTRAINT EQUPERREQ_ITEMID_FK FOREIGN KEY (itemID)
    REFERENCES MedicalEquipment (itemID)
);


insert into LocationType values ('BATH', 'bathroom');
insert into LocationType values ('DEPT', 'department');
insert into LocationType values ('DIRT', 'medical equipment dirty area');
insert into LocationType values ('ELEV', 'elevator');
insert into LocationType values ('EXIT', 'building exit');
insert into LocationType values ('HALL', 'hallway');
insert into LocationType values ('INFO', 'information center');
insert into LocationType values ('LABS', 'laboratory');
insert into LocationType values ('PATI', 'patient room');
insert into LocationType values ('REST', 'restroom');
insert into LocationType values ('RETL', 'retail store');
insert into LocationType values ('SERV', 'hospital services');
insert into LocationType values ('STAI', 'stairs');
insert into LocationType values ('STOR', 'medical equipment storage area');

insert into Location values ('DEPT00101', 400, 150, '1', 'Tower', 'Center for International Medicine', 'CIM', 'DEPT');
insert into Location values ('DEPT00201', 420, 475, '1', 'Tower', 'Bretholtz Center for Patients Families', 'Bretholtz WR', 'DEPT');
insert into Location values ('DEPT00301', 577, 254, '1', 'Tower', 'Multifaith Chapel', 'Chapel', 'DEPT');
insert into Location values ('DEPT00401', 700, 500, '1', 'Tower', 'Sharf Admitting Center', 'Sharf Center', 'DEPT');
insert into Location values ('DEPT00501', 930, 650, '1', 'Tower', 'Emergency Department', 'Emergency', 'DEPT');
insert into Location values ('DEPT00601', 700, 385, '1', 'Tower', 'International Patient Center', 'IPC', 'DEPT');
insert into Location values ('EXIT00101', 887, 157, '1', 'Tower', 'Shattuck Street Lobby Exit', 'Shattuck St. Exit', 'EXIT');
insert into Location values ('EXIT00201', 618, 780, '1', 'Tower', '75 Francis Valet Drop-off', '75 Francis Exit', 'EXIT');
insert into Location values ('EXIT00301', 969, 719, '1', 'Tower', 'Emergency Department Entrance', 'Emergency Entrance', 'EXIT');
insert into Location values ('HALL00101', 969, 269, '1', 'Tower', 'Lower Pike Hallway Exit Lobby', 'Hallway F00101', 'HALL');
insert into Location values ('HALL00201', 922, 271, '1', 'Tower', 'Lobby Shattuck Street', 'Hallway F00201', 'HALL');
insert into Location values ('HALL00301', 887, 267, '1', 'Tower', 'Shattuck Street Lobby 1', 'Hallway F00301', 'HALL');
insert into Location values ('HALL00401', 841, 267, '1', 'Tower', 'Shattuck Street Lobby 2', 'Hallway F00401', 'HALL');
insert into Location values ('HALL00501', 820, 267, '1', 'Tower', 'Shattuck Street Lobby 3', 'Hallway F00501', 'HALL');
insert into Location values ('HALL00601', 735, 285, '1', 'Tower', 'Tower Lobby Entrance 1', 'Tower Entrance', 'HALL');
insert into Location values ('HALL00701', 625, 285, '1', 'Tower', 'Tower Elevator Entrance', 'Hallway F00701', 'HALL');
insert into Location values ('HALL00801', 625, 210, '1', 'Tower', 'Tower Hallway 1', 'Hallway F00801', 'HALL');
insert into Location values ('HALL00901', 496, 210, '1', 'Tower', 'Tower Hallway 2', 'Hallway F00901', 'HALL');
insert into Location values ('HALL01001', 496, 159, '1', 'Tower', 'Tower Hallway 3', 'Hallway F01001', 'HALL');
insert into Location values ('HALL01101', 496, 286, '1', 'Tower', 'Tower Hallway 4', 'Hallway F01101', 'HALL');
insert into Location values ('HALL01201', 405, 286, '1', 'Tower', 'Tower Staff Entrance', 'Hallway F01201', 'HALL');
insert into Location values ('HALL01301', 496, 188, '1', 'Tower', 'Tower Hallway 5', 'Hallway F01301', 'HALL');
insert into Location values ('HALL01401', 496, 388, '1', 'Tower', 'Tower Hallway 6', 'Hallway F01401', 'HALL');
insert into Location values ('HALL01501', 496, 416, '1', 'Tower', 'Tower Hallway 7', 'Hallway F01501', 'HALL');
insert into Location values ('HALL01601', 624, 416, '1', 'Tower', 'Tower Hallway 8', 'Hallway F01601', 'HALL');
insert into Location values ('HALL01701', 624, 311, '1', 'Tower', 'Tower Hallway 9', 'Hallway F01701', 'HALL');
insert into Location values ('HALL01801', 593, 311, '1', 'Tower', 'Tower Hallway 10', 'Hallway F01801', 'HALL');
insert into Location values ('HALL01901', 624, 474, '1', 'Tower', 'Tower Hallway 11', 'Hallway F01901', 'HALL');
insert into Location values ('HALL02001', 570, 474, '1', 'Tower', 'Tower Hallway 12', 'Hallway F02001', 'HALL');
insert into Location values ('HALL02101', 641, 505, '1', 'Tower', 'Tower Hallway Entrance', 'Tower Entrance 2', 'HALL');
insert into Location values ('HALL02201', 641, 639, '1', 'Tower', 'Hallway Lobby Entrance', 'Entrance Hallway', 'HALL');
insert into Location values ('HALL02301', 717, 639, '1', 'Tower', 'Lobby Hallway 1', 'Hallway F02301', 'HALL');
insert into Location values ('HALL02401', 837, 639, '1', 'Tower', 'Lobby Hallway 2', 'Hallway F02401', 'HALL');
insert into Location values ('HALL02501', 837, 598, '1', 'Tower', 'Lobby Hallway 3', 'Hallway F02501', 'HALL');
insert into Location values ('HALL02601', 900, 598, '1', 'Tower', 'Lobby Hallway 4', 'Hallway F02601', 'HALL');
insert into Location values ('HALL02701', 937, 598, '1', 'Tower', 'Lobby Hallway 7', 'Hallway F02701', 'HALL');
insert into Location values ('HALL02801', 619, 639, '1', 'Tower', 'Lobby Entrance Hallway', 'HallwayF02801', 'HALL');
insert into Location values ('HALL02901', 569, 639, '1', 'Tower', '75 Lobby', '75 Lobby', 'HALL');
insert into Location values ('HALL03001', 507, 604, '1', 'Tower', 'Lobby Hallway 5', 'Hallway F02701', 'HALL');
insert into Location values ('HALL03101', 902, 336, '1', 'Tower', 'Lobby Hallway 6', 'Hallway F02801', 'HALL');
insert into Location values ('HALL03201', 624, 388, '1', 'Tower', 'Tower Hallway 13', 'Hallway F03201', 'HALL');
insert into Location values ('HALL03301', 937, 649, '1', 'Tower', 'Emergency Hallway', 'Hallway F03301', 'HALL');
insert into Location values ('INFO00101', 569, 584, '1', 'Tower', '75 Lobby Information Desk', 'Lobby Info Desk', 'INFO');
insert into Location values ('LABS00101', 717, 609, '1', 'Tower', 'Obstetrics Admitting', 'Obs Admitting', 'LABS');
insert into Location values ('REST00101', 964, 336, '1', 'Tower', 'Bathroom 75 Lobby', 'Bathroom Lobby', 'REST');
insert into Location values ('RETL00101', 841, 206, '1', 'Tower', 'Lobby Vending Machine', 'VM Lobby', 'RETL');
insert into Location values ('RETL00201', 478, 604, '1', 'Tower', 'Au Bon Pain', 'ABP', 'RETL');
insert into Location values ('SERV00101', 820, 232, '1', 'Tower', 'Shattuck Street Lobby ATM', 'Lobby ATM', 'SERV');
insert into Location values ('SERV00201', 474, 388, '1', 'Tower', 'Tower Medical Cashier', 'Tower Cashier', 'SERV');
insert into Location values ('SERV00301', 569, 515, '1', 'Tower', 'Kessler Library', 'Kessler Library', 'SERV');
insert into Location values ('SERV00401', 593, 329, '1', 'Tower', 'Spiritual Care Office', 'SCO', 'DEPT');
insert into Location values ('SERV00501', 507, 639, '1', 'Tower', '75 Lobby Valet Cashier', 'Valet Cashier', 'SERV');
insert into Location values ('STAI00101', 902, 254, '1', 'Tower', 'Lobby Shattuck Street Stairs', 'Stairway F00101', 'STAI');
insert into Location values ('STAI00201', 542, 159, '1', 'Tower', 'Tower Stairway 1', 'Tower Stairs 1', 'STAI');
insert into Location values ('STAI00301', 820, 598, '1', 'Tower', 'Lobby Escalator', 'Lobby Escalator', 'STAI');
insert into Location values ('ELEV00L01', 681, 286, '1', 'Tower', 'Elevator L Floor 1', 'Elevator L1', 'ELEV');
insert into Location values ('ELEV00M01', 681, 639, '1', 'Tower', 'Elevator M Floor 1', 'Elevator M1', 'ELEV');
insert into Location values ('BATH00102', 481, 371, '2', 'Tower', 'Bathroom 1 Tower Floor 2', 'Bathroom 0102', 'BATH');
insert into Location values ('DEPT00102', 931, 697, '2', 'Tower', 'Endoscopy', 'Endoscopy', 'DEPT');
insert into Location values ('HALL00102', 746, 286, '2', 'Tower', 'Hallway Connector 1 Floor 2', 'Hallway H00102', 'HALL');
insert into Location values ('HALL00202', 832, 266, '2', 'Tower', 'Hallway Connector 2 Floor 2', 'Hallway H00202', 'HALL');
insert into Location values ('HALL00302', 914, 266, '2', 'Tower', 'Hallway Connector 3 Floor 2', 'Hallway H00302', 'HALL');
insert into Location values ('HALL00402', 746, 392, '2', 'Tower', 'Hallway Connector 4 Floor 2', 'Hallway H00402', 'HALL');
insert into Location values ('HALL00502', 700, 392, '2', 'Tower', 'Hallway Connector 5 Floor 2', 'Hallway H00502', 'HALL');
insert into Location values ('HALL00602', 645, 458, '2', 'Tower', 'Hallway Connector 6 Floor 2', 'Hallway H00602', 'HALL');
insert into Location values ('HALL00702', 617, 515, '2', 'Tower', 'Hallway Connector 7 Floor 2', 'Hallway H00702', 'HALL');
insert into Location values ('HALL00802', 617, 596, '2', 'Tower', 'Hallway Connector 8 Floor 2', 'Hallway H00802', 'HALL');
insert into Location values ('HALL00902', 617, 647, '2', 'Tower', 'Hallway Connector 9 Floor 2', 'Hallway H00902', 'HALL');
insert into Location values ('HALL01002', 931, 647, '2', 'Tower', 'Hallway Connector 10 Floor 2', 'Hallway H01002', 'HALL');
insert into Location values ('HALL01102', 617, 849, '2', 'Tower', 'Hallway Connector 11 Floor 2', 'Hallway H01102', 'HALL');
insert into Location values ('RETL00102', 810, 224, '2', 'Tower', 'Garden Cafe', 'Garden Cafe', 'RETL');
insert into Location values ('RETL00202', 487, 392, '2', 'Tower', 'Vending Machine Floor 2?', 'Vending Machine', 'RETL');
insert into Location values ('RETL00302', 700, 445, '2', 'Tower', 'Gift Shop Tower Floor 2', 'Gift Shop', 'RETL');
insert into Location values ('STAI00102', 935, 242, '2', 'Tower', 'Stairwell 1 Floor 2', 'Stairwell 0102', 'STAI');
insert into Location values ('STAI00202', 571, 535, '2', 'Tower', 'Stairwell 2 Tower Floor 2', 'Stairwell 0202', 'STAI');
insert into Location values ('STAI00302', 664, 596, '2', 'Tower', 'Escalator 1 Floor 2', 'Escalator 1 Floor 2', 'STAI');
insert into Location values ('ELEV00L02', 681, 286, '2', 'Tower', 'Elevator L Floor 2', 'Elevator L2', 'ELEV');
insert into Location values ('ELEV00M02', 700, 647, '2', 'Tower', 'Elevator M Floor 2', 'Elevator M2', 'ELEV');
insert into Location values ('BATH00103', 679, 190, '3', 'Tower', 'Bathroom 1 Tower Floor 3', 'Bathroom 0103', 'BATH');
insert into Location values ('BATH00203', 644, 344, '3', 'Tower', 'Bathroom 2 Tower Floor 3', 'Bathroom 0203', 'BATH');
insert into Location values ('DEPT00103', 619, 260, '3', 'Tower', 'Dialysis Waiting Room', 'Dialysis WR', 'DEPT');
insert into Location values ('DEPT00203', 576, 190, '3', 'Tower', 'MICU 3BC Waiting Room', 'MICU 3BC WR', 'DEPT');
insert into Location values ('HALL00103', 214, 1, '3', 'Tower', 'Hallway Connector 1 Floor 3', 'Hallway H00103', 'HALL');
insert into Location values ('HALL00203', 127, 343, '3', 'Tower', 'Hallway Connector 2 Floor 3', 'Hallway H00203', 'HALL');
insert into Location values ('HALL00303', 214, 343, '3', 'Tower', 'Hallway Connector 3 Floor 3', 'Hallway H00303', 'HALL');
insert into Location values ('HALL00403', 214, 648, '3', 'Tower', 'Hallway Connector 4 Floor 3', 'Hallway H00403', 'HALL');
insert into Location values ('HALL00503', 575, 648, '3', 'Tower', 'Hallway Connector 5 Floor 3', 'Hallway H00502', 'HALL');
insert into Location values ('HALL00603', 629, 286, '3', 'Tower', 'Hallway Connector 6 Floor 3', 'Hallway H00603', 'HALL');
insert into Location values ('HALL00703', 629, 260, '3', 'Tower', 'Hallway Connector 7 Floor 3', 'Hallway H00703', 'HALL');
insert into Location values ('HALL00803', 629, 225, '3', 'Tower', 'Hallway Connector 8 Floor 3', 'Hallway H00803', 'HALL');
insert into Location values ('HALL00903', 629, 180, '3', 'Tower', 'Hallway Connector 9 Floor 3', 'Hallway H00903', 'HALL');
insert into Location values ('HALL01003', 679, 180, '3', 'Tower', 'Hallway Connector 10 Floor 3', 'Hallway H01003', 'HALL');
insert into Location values ('HALL01103', 576, 180, '3', 'Tower', 'Hallway Connector 11 Floor 3', 'Hallway H01103', 'HALL');
insert into Location values ('HALL01203', 495, 180, '3', 'Tower', 'Hallway Connector 12 Floor 3', 'Hallway H01203', 'HALL');
insert into Location values ('HALL01303', 495, 392, '3', 'Tower', 'Hallway Connector 13 Floor 3', 'Hallway H01303', 'HALL');
insert into Location values ('HALL01403', 629, 392, '3', 'Tower', 'Hallway Connector 14 Floor 3', 'Hallway H01403', 'HALL');
insert into Location values ('HALL01503', 629, 344, '3', 'Tower', 'Hallway Connector 15 Floor 3', 'Hallway H01503', 'HALL');
insert into Location values ('LABS00103', 127, 225, '3', 'Tower', 'Reproductive Endocrine Labs', 'Reproductive Endocrine Labs', 'LABS');
insert into Location values ('SERV00103', 643, 225, '3', 'Tower', 'Nursing Room', 'Nursing Room', 'SERV');
insert into Location values ('STAI00103', 575, 632, '3', 'Tower', 'Stairwell 1 Floor 3', 'Stairwell', 'STAI');
insert into Location values ('ELEV00L03', 681, 286, '3', 'Tower', 'Elevator L Floor 3', 'Elevator L3', 'ELEV');
insert into Location values ('ELEV00M03', 707, 648, '3', 'Tower', 'Elevator M Floor 3', 'Elevator M3', 'ELEV');
insert into Location values ('DEPT002L1', 874, 208, 'L1', 'Tower', 'Day Surgery Family Waiting Floor L1', 'Department C002L1', 'DEPT');
insert into Location values ('DEPT003L1', 738, 208, 'L1', 'Tower', 'Day Surgery Family Waiting Exit Floor L1', 'Department C003L1', 'DEPT');
insert into Location values ('HALL001L1', 628, 286, 'L1', 'Tower', 'Hallway 1 Floor L1', 'Hallway C001L1', 'HALL');
insert into Location values ('HALL002L1', 649, 649, 'L1', 'Tower', 'Hallway 2 Floor L1', 'Hallway C002L1', 'HALL');
insert into Location values ('HALL003L1', 1020, 649, 'L1', 'Tower', 'Hallway 3 Floor L1', 'Hallway C003L1', 'HALL');
insert into Location values ('HALL004L1', 1020, 408, 'L1', 'Tower', 'Hallway 4 Floor L1', 'Hallway C004L1', 'HALL');
insert into Location values ('HALL005L1', 738, 286, 'L1', 'Tower', 'Hallway 5 Floor L1', 'Hallway C005L1', 'HALL');
insert into Location values ('HALL006L1', 500, 285, 'L1', 'Tower', 'Hallway 6 Floor L1', 'Hallway C006L1', 'HALL');
insert into Location values ('LABS001L1', 860, 649, 'L1', 'Tower', 'Outpatient Fluoroscopy Floor L1', 'Lab C001L1', 'LABS');
insert into Location values ('LABS002L1', 636, 455, 'L1', 'Tower', 'Pre-Op PACU Floor L1', 'Lab C002L1', 'LABS');
insert into Location values ('REST001L1', 616, 381, 'L1', 'Tower', 'Restroom L Elevator Floor L1', 'Restroom C001L1', 'REST');
insert into Location values ('REST002L1', 958, 635, 'L1', 'Tower', 'Restroom M Elevator Floor L1', 'Restroom C002L1', 'REST');
insert into Location values ('ELEV00LL1', 681, 286, 'L1', 'Tower', 'Elevator L Floor L1', 'Elevator LL1', 'ELEV');
insert into Location values ('ELEV00ML1', 713, 649, 'L1', 'Tower', 'Elevator M Floor L1', 'Elevator ML1', 'ELEV');
insert into Location values ('HALL001L2', 639, 646, 'L2', 'Tower', 'Hallway 1 Floor L2', 'Hallway C001L2', 'HALL');
insert into Location values ('HALL002L2', 639, 372, 'L2', 'Tower', 'Hallway 2 Floor L2', 'Hallway C002L2', 'HALL');
insert into Location values ('HALL003L2', 624, 372, 'L2', 'Tower', 'Hallway 3 Floor L2', 'Hallway C003L2', 'HALL');
insert into Location values ('HALL004L2', 624, 286, 'L2', 'Tower', 'Hallway 4 Floor L2', 'Hallway C004L2', 'HALL');
insert into Location values ('HALL005L2', 624, 215, 'L2', 'Tower', 'Hallway 5 Floor L2', 'Hallway C005L2', 'HALL');
insert into Location values ('HALL006L2', 1017, 215, 'L2', 'Tower', 'Hallway 6 Floor L2', 'Hallway C006L2', 'HALL');
insert into Location values ('ELEV00LL2', 681, 286, 'L2', 'Tower', 'Elevator L Floor L2', 'Elevator LL2', 'ELEV');
insert into Location values ('ELEV00ML2', 714, 646, 'L2', 'Tower', 'Elevator M Floor L2', 'Elevator ML2', 'ELEV');
insert into Location values ('HALL007L2', 639, 849, 'L2', 'Tower', 'Hallway Connector 7 Floor L2', 'Hallway W07L2', 'HALL');
insert into Location values ('STOR001L1', 487, 180, 'L1', 'Tower', 'OR Bed Park', 'Bed Park', 'STOR');
insert into Location values ('STOR00101', 380, 286, '1', 'Tower', 'West Plaza', 'West Plaza', 'STOR');
insert into Location values ('STOR00103', 430, 438, '3', 'Tower', 'Pod C Clean Storage', 'Pod C Clean', 'STOR');
insert into Location values ('STOR00203', 430, 141, '3', 'Tower', 'Pod B Clean Storage', 'Pod B Clean', 'STOR');
insert into Location values ('DIRT00103', 495, 286, '3', 'Tower', 'Floor 3 Dirty Pickup', 'Floor 3 Dirty', 'DIRT');
insert into Location values ('STOR00303', 571, 179, '3', 'Tower', 'Lower Bed Park', 'Lower Bed Park', 'STOR');
insert into Location values ('STOR00403', 571, 392, '3', 'Tower', 'Upper Bed Park', 'Upper Bed Park', 'STOR');
insert into Location values ('PATI00103', 407, 223, '3', 'Tower', 'Patient Room 3B31', 'PR3B31', 'PATI');
insert into Location values ('PATI00203', 350, 200, '3', 'Tower', 'Patient Room 3B32', 'PR3B32', 'PATI');
insert into Location values ('PATI00303', 331, 170, '3', 'Tower', 'Patient Room 3B33', 'PR3B33', 'PATI');
insert into Location values ('PATI00403', 324, 122, '3', 'Tower', 'Patient Room 3B34', 'PR3B34', 'PATI');
insert into Location values ('PATI00503', 338, 83, '3', 'Tower', 'Patient Room 3B35', 'PR3B35', 'PATI');
insert into Location values ('PATI00603', 366, 56, '3', 'Tower', 'Patient Room 3B36', 'PR3B36', 'PATI');
insert into Location values ('PATI00703', 408, 42, '3', 'Tower', 'Patient Room 3B37', 'PR3B37', 'PATI');
insert into Location values ('PATI00803', 455, 50, '3', 'Tower', 'Patient Room 3B38', 'PR3B38', 'PATI');
insert into Location values ('PATI00903', 484, 68, '3', 'Tower', 'Patient Room 3B39', 'PR3B39', 'PATI');
insert into Location values ('PATI01003', 506, 119, '3', 'Tower', 'Patient Room 3B40', 'PR3B40', 'PATI');
insert into Location values ('PATI01103', 408, 354, '3', 'Tower', 'Patient Room 3C51', 'PR3C51', 'PATI');
insert into Location values ('PATI01203', 360, 374, '3', 'Tower', 'Patient Room 3C52', 'PR3C52', 'PATI');
insert into Location values ('PATI01303', 334, 409, '3', 'Tower', 'Patient Room 3C53', 'PR3C53', 'PATI');
insert into Location values ('PATI01403', 332, 454, '3', 'Tower', 'Patient Room 3C54', 'PR3C54', 'PATI');
insert into Location values ('PATI01503', 344, 492, '3', 'Tower', 'Patient Room 3C55', 'PR3C55', 'PATI');
insert into Location values ('PATI01603', 376, 517, '3', 'Tower', 'Patient Room 3C56', 'PR3C56', 'PATI');
insert into Location values ('PATI01703', 414, 534, '3', 'Tower', 'Patient Room 3C57', 'PR3C57', 'PATI');
insert into Location values ('PATI01803', 449, 527, '3', 'Tower', 'Patient Room 3C58', 'PR3C58', 'PATI');
insert into Location values ('PATI01903', 489, 504, '3', 'Tower', 'Patient Room 3C59', 'PR3C59', 'PATI');
insert into Location values ('PATI02003', 504, 455, '3', 'Tower', 'Patient Room 3C60', 'PR3C60', 'PATI');
insert into Location values ('STOR00104', 401, 436, '4', 'Tower', 'Pod C Clean Storage', 'Pod C Clean', 'STOR');
insert into Location values ('STOR00204', 401, 141, '4', 'Tower', 'Pod B Clean Storage', 'Pod B Clean', 'STOR');
insert into Location values ('DIRT00104', 495, 286, '4', 'Tower', 'Floor 4 Dirty Pickup', 'Floor 4 Dirty', 'DIRT');
insert into Location values ('STOR00304', 571, 179, '4', 'Tower', 'Lower Bed Park', 'Lower Bed Park', 'STOR');
insert into Location values ('STOR00404', 571, 392, '4', 'Tower', 'Upper Bed Park', 'Upper Bed Park', 'STOR');
insert into Location values ('PATI00104', 407, 223, '4', 'Tower', 'Patient Room 4B31', 'PR4B31', 'PATI');
insert into Location values ('PATI00204', 350, 200, '4', 'Tower', 'Patient Room 4B32', 'PR4B32', 'PATI');
insert into Location values ('PATI00304', 331, 170, '4', 'Tower', 'Patient Room 4B33', 'PR4B33', 'PATI');
insert into Location values ('PATI00404', 324, 122, '4', 'Tower', 'Patient Room 4B34', 'PR4B34', 'PATI');
insert into Location values ('PATI00504', 338, 83, '4', 'Tower', 'Patient Room 4B35', 'PR4B35', 'PATI');
insert into Location values ('PATI00604', 366, 56, '4', 'Tower', 'Patient Room 4B36', 'PR4B36', 'PATI');
insert into Location values ('PATI00704', 408, 42, '4', 'Tower', 'Patient Room 4B37', 'PR4B37', 'PATI');
insert into Location values ('PATI00804', 455, 50, '4', 'Tower', 'Patient Room 4B38', 'PR4B38', 'PATI');
insert into Location values ('PATI00904', 484, 68, '4', 'Tower', 'Patient Room 4B39', 'PR4B39', 'PATI');
insert into Location values ('PATI01004', 506, 119, '4', 'Tower', 'Patient Room 4B40', 'PR4B40', 'PATI');
insert into Location values ('PATI01104', 408, 354, '4', 'Tower', 'Patient Room 4C51', 'PR4C51', 'PATI');
insert into Location values ('PATI01204', 360, 374, '4', 'Tower', 'Patient Room 4C52', 'PR4C52', 'PATI');
insert into Location values ('PATI01304', 334, 409, '4', 'Tower', 'Patient Room 4C53', 'PR4C53', 'PATI');
insert into Location values ('PATI01404', 332, 454, '4', 'Tower', 'Patient Room 4C54', 'PR4C54', 'PATI');
insert into Location values ('PATI01504', 344, 492, '4', 'Tower', 'Patient Room 4C55', 'PR4C55', 'PATI');
insert into Location values ('PATI01604', 376, 517, '4', 'Tower', 'Patient Room 4C56', 'PR4C56', 'PATI');
insert into Location values ('PATI01704', 414, 534, '4', 'Tower', 'Patient Room 4C57', 'PR4C57', 'PATI');
insert into Location values ('PATI01804', 449, 527, '4', 'Tower', 'Patient Room 4C58', 'PR4C58', 'PATI');
insert into Location values ('PATI01904', 489, 504, '4', 'Tower', 'Patient Room 4C59', 'PR4C59', 'PATI');
insert into Location values ('PATI02004', 504, 455, '4', 'Tower', 'Patient Room 4C60', 'PR4C60', 'PATI');
insert into Location values ('STOR00105', 429, 98, '5', 'Tower', 'Pod B Clean Storage', 'Pod B Clean', 'STOR');
insert into Location values ('STOR00205', 777, 134, '5', 'Tower', 'Pod A Clean Storage', 'Pod A Clean', 'STOR');
insert into Location values ('DIRT00105', 495, 286, '5', 'Tower', 'Floor 5 Dirty Pickup', 'Floor 5 Dirty', 'DIRT');
insert into Location values ('STOR00305', 571, 179, '5', 'Tower', 'Lower Bed Park', 'Lower Bed Park', 'STOR');
insert into Location values ('PATI00105', 407, 223, '5', 'Tower', 'Patient Room 5B31', 'PR5B31', 'PATI');
insert into Location values ('PATI00205', 350, 200, '5', 'Tower', 'Patient Room 5B32', 'PR5B32', 'PATI');
insert into Location values ('PATI00305', 331, 170, '5', 'Tower', 'Patient Room 5B33', 'PR5B33', 'PATI');
insert into Location values ('PATI00405', 324, 122, '5', 'Tower', 'Patient Room 5B34', 'PR5B34', 'PATI');
insert into Location values ('PATI00505', 338, 83, '5', 'Tower', 'Patient Room 5B35', 'PR5B35', 'PATI');
insert into Location values ('PATI00605', 366, 56, '5', 'Tower', 'Patient Room 5B36', 'PR5B36', 'PATI');
insert into Location values ('PATI00705', 408, 42, '5', 'Tower', 'Patient Room 5B37', 'PR5B37', 'PATI');
insert into Location values ('PATI00805', 455, 50, '5', 'Tower', 'Patient Room 5B38', 'PR5B38', 'PATI');
insert into Location values ('PATI00905', 484, 68, '5', 'Tower', 'Patient Room 5B39', 'PR5B39', 'PATI');
insert into Location values ('PATI01005', 506, 119, '5', 'Tower', 'Patient Room 5B40', 'PR5B40', 'PATI');
insert into Location values ('PATI01105', 636, 115, '5', 'Tower', 'Patient Room 5A11', 'PR5A11', 'PATI');
insert into Location values ('PATI01205', 653, 67, '5', 'Tower', 'Patient Room 5A12', 'PR5A12', 'PATI');
insert into Location values ('PATI01305', 690, 42, '5', 'Tower', 'Patient Room 5A13', 'PR5A13', 'PATI');
insert into Location values ('PATI01405', 743, 37, '5', 'Tower', 'Patient Room 5A14', 'PR5A14', 'PATI');
insert into Location values ('PATI01505', 781, 50, '5', 'Tower', 'Patient Room 5A15', 'PR5A15', 'PATI');
insert into Location values ('PATI01605', 816, 85, '5', 'Tower', 'Patient Room 5A16', 'PR5A16', 'PATI');
insert into Location values ('PATI01705', 827, 123, '5', 'Tower', 'Patient Room 5A17', 'PR5A17', 'PATI');
insert into Location values ('PATI01805', 821, 171, '5', 'Tower', 'Patient Room 5A18', 'PR5A18', 'PATI');
insert into Location values ('PATI01905', 797, 211, '5', 'Tower', 'Patient Room 5A19', 'PR5A19', 'PATI');
insert into Location values ('PATI02005', 750, 229, '5', 'Tower', 'Patient Room 5A20', 'PR5A20', 'PATI');

insert into MedicalEquipment values ('Bed01', 'Bed', 'INUSE', 'PATI00103');
insert into MedicalEquipment values ('Bed02', 'Bed', 'INUSE', 'PATI00203');
insert into MedicalEquipment values ('Bed03', 'Bed', 'INUSE', 'PATI00303');
insert into MedicalEquipment values ('Bed04', 'Bed', 'INUSE', 'PATI00403');
insert into MedicalEquipment values ('Bed05', 'Bed', 'INUSE', 'PATI00503');
insert into MedicalEquipment values ('Bed06', 'Bed', 'INUSE', 'PATI00603');
insert into MedicalEquipment values ('Bed07', 'Bed', 'INUSE', 'PATI00703');
insert into MedicalEquipment values ('Bed08', 'Bed', 'INUSE', 'PATI00803');
insert into MedicalEquipment values ('Bed09', 'Bed', 'INUSE', 'PATI00903');
insert into MedicalEquipment values ('Bed10', 'Bed', 'INUSE', 'PATI01003');
insert into MedicalEquipment values ('Bed11', 'Bed', 'CLEAN', 'STOR00303');
insert into MedicalEquipment values ('Bed12', 'Bed', 'INUSE', 'PATI01203');
insert into MedicalEquipment values ('Bed13', 'Bed', 'INUSE', 'PATI01303');
insert into MedicalEquipment values ('Bed14', 'Bed', 'INUSE', 'PATI01403');
insert into MedicalEquipment values ('Bed15', 'Bed', 'INUSE', 'PATI01503');
insert into MedicalEquipment values ('Bed16', 'Bed', 'INUSE', 'PATI01603');
insert into MedicalEquipment values ('Bed17', 'Bed', 'INUSE', 'PATI01703');
insert into MedicalEquipment values ('Bed18', 'Bed', 'INUSE', 'PATI01803');
insert into MedicalEquipment values ('Bed19', 'Bed', 'INUSE', 'PATI01903');
insert into MedicalEquipment values ('Bed20', 'Bed', 'INUSE', 'PATI02003');
insert into MedicalEquipment values ('Recliner01', 'Recliner', 'CLEAN', 'HALL00103');
insert into MedicalEquipment values ('Recliner02', 'Recliner', 'CLEAN', 'HALL00203');
insert into MedicalEquipment values ('Recliner03', 'Recliner', 'CLEAN', 'HALL00303');
insert into MedicalEquipment values ('Recliner04', 'Recliner', 'CLEAN', 'HALL00403');
insert into MedicalEquipment values ('Recliner05', 'Recliner', 'CLEAN', 'HALL00503');
insert into MedicalEquipment values ('Recliner06', 'Recliner', 'CLEAN', 'HALL00603');
insert into MedicalEquipment values ('XRay01', 'XRay', 'INUSE', 'PATI00103');
insert into MedicalEquipment values ('IPump01', 'IPumps', 'CLEAN', 'STOR00103');
insert into MedicalEquipment values ('IPump02', 'IPumps', 'CLEAN', 'STOR00203');
insert into MedicalEquipment values ('IPump03', 'IPumps', 'DIRTY', 'DIRT00103');
insert into MedicalEquipment values ('IPump04', 'IPumps', 'INUSE', 'PATI00103');
insert into MedicalEquipment values ('IPump05', 'IPumps', 'INUSE', 'PATI00203');
insert into MedicalEquipment values ('IPump06', 'IPumps', 'INUSE', 'PATI00303');
insert into MedicalEquipment values ('IPump07', 'IPumps', 'INUSE', 'PATI00403');
insert into MedicalEquipment values ('IPump08', 'IPumps', 'INUSE', 'PATI00503');
insert into MedicalEquipment values ('IPump09', 'IPumps', 'INUSE', 'PATI00603');
insert into MedicalEquipment values ('IPump10', 'IPumps', 'INUSE', 'PATI00703');
insert into MedicalEquipment values ('IPump11', 'IPumps', 'INUSE', 'PATI00803');
insert into MedicalEquipment values ('IPump12', 'IPumps', 'INUSE', 'PATI00903');
insert into MedicalEquipment values ('IPump13', 'IPumps', 'INUSE', 'PATI01003');
insert into MedicalEquipment values ('IPump14', 'IPumps', 'INUSE', 'PATI01103');
insert into MedicalEquipment values ('IPump15', 'IPumps', 'INUSE', 'PATI01203');
insert into MedicalEquipment values ('IPump16', 'IPumps', 'INUSE', 'PATI01303');
insert into MedicalEquipment values ('IPump17', 'IPumps', 'INUSE', 'PATI01403');
insert into MedicalEquipment values ('IPump18', 'IPumps', 'INUSE', 'PATI01503');
insert into MedicalEquipment values ('IPump19', 'IPumps', 'INUSE', 'PATI01603');
insert into MedicalEquipment values ('IPump20', 'IPumps', 'INUSE', 'PATI01703');
insert into MedicalEquipment values ('IPump21', 'IPumps', 'INUSE', 'PATI01803');
insert into MedicalEquipment values ('IPump22', 'IPumps', 'INUSE', 'PATI01903');
insert into MedicalEquipment values ('IPump23', 'IPumps', 'INUSE', 'PATI02003');
insert into MedicalEquipment values ('IPump24', 'IPumps', 'CLEAN', 'STOR00103');
insert into MedicalEquipment values ('IPump25', 'IPumps', 'CLEAN', 'STOR00203');
insert into MedicalEquipment values ('IPump26', 'IPumps', 'DIRTY', 'DIRT00103');
insert into MedicalEquipment values ('IPump27', 'IPumps', 'CLEAN', 'STOR00103');
insert into MedicalEquipment values ('IPump28', 'IPumps', 'CLEAN', 'STOR00203');
insert into MedicalEquipment values ('IPump29', 'IPumps', 'DIRTY', 'DIRT00103');
insert into MedicalEquipment values ('IPump30', 'IPumps', 'CLEAN', 'STOR00103');
insert into MedicalEquipment values ('Bed21', 'Bed', 'INUSE', 'PATI00104');
insert into MedicalEquipment values ('Bed22', 'Bed', 'INUSE', 'PATI00204');
insert into MedicalEquipment values ('Bed23', 'Bed', 'INUSE', 'PATI00304');
insert into MedicalEquipment values ('Bed24', 'Bed', 'INUSE', 'PATI00404');
insert into MedicalEquipment values ('Bed25', 'Bed', 'INUSE', 'PATI00504');
insert into MedicalEquipment values ('Bed26', 'Bed', 'INUSE', 'PATI00604');
insert into MedicalEquipment values ('Bed27', 'Bed', 'INUSE', 'PATI00704');
insert into MedicalEquipment values ('Bed28', 'Bed', 'INUSE', 'PATI00804');
insert into MedicalEquipment values ('Bed29', 'Bed', 'INUSE', 'PATI00904');
insert into MedicalEquipment values ('Bed30', 'Bed', 'INUSE', 'PATI01004');
insert into MedicalEquipment values ('Recliner07', 'Recliner', 'INUSE', 'PATI00104');
insert into MedicalEquipment values ('Recliner08', 'Recliner', 'INUSE', 'PATI00204');
insert into MedicalEquipment values ('Recliner09', 'Recliner', 'INUSE', 'PATI00304');
insert into MedicalEquipment values ('Recliner10', 'Recliner', 'INUSE', 'PATI00404');
insert into MedicalEquipment values ('Recliner11', 'Recliner', 'INUSE', 'PATI00504');
insert into MedicalEquipment values ('XRay02', 'XRay', 'INUSE', 'PATI00104');
insert into MedicalEquipment values ('IPump31', 'IPumps', 'CLEAN', 'STOR00104');
insert into MedicalEquipment values ('IPump32', 'IPumps', 'CLEAN', 'STOR00204');
insert into MedicalEquipment values ('IPump33', 'IPumps', 'DIRTY', 'DIRT00104');
insert into MedicalEquipment values ('IPump34', 'IPumps', 'INUSE', 'PATI00104');
insert into MedicalEquipment values ('IPump35', 'IPumps', 'INUSE', 'PATI00204');
insert into MedicalEquipment values ('IPump36', 'IPumps', 'INUSE', 'PATI00304');
insert into MedicalEquipment values ('IPump37', 'IPumps', 'INUSE', 'PATI00404');
insert into MedicalEquipment values ('IPump38', 'IPumps', 'INUSE', 'PATI00504');
insert into MedicalEquipment values ('IPump39', 'IPumps', 'INUSE', 'PATI00604');
insert into MedicalEquipment values ('IPump40', 'IPumps', 'INUSE', 'PATI00704');
insert into MedicalEquipment values ('IPump41', 'IPumps', 'INUSE', 'PATI00804');
insert into MedicalEquipment values ('IPump42', 'IPumps', 'INUSE', 'PATI00904');
insert into MedicalEquipment values ('IPump43', 'IPumps', 'INUSE', 'PATI01004');
insert into MedicalEquipment values ('IPump44', 'IPumps', 'INUSE', 'PATI01104');
insert into MedicalEquipment values ('IPump45', 'IPumps', 'INUSE', 'PATI01204');
insert into MedicalEquipment values ('Bed31', 'Bed', 'INUSE', 'PATI00105');
insert into MedicalEquipment values ('Bed32', 'Bed', 'INUSE', 'PATI00205');
insert into MedicalEquipment values ('Bed33', 'Bed', 'INUSE', 'PATI00305');
insert into MedicalEquipment values ('Bed34', 'Bed', 'INUSE', 'PATI00405');
insert into MedicalEquipment values ('Bed35', 'Bed', 'INUSE', 'PATI00505');
insert into MedicalEquipment values ('Bed36', 'Bed', 'INUSE', 'PATI00605');
insert into MedicalEquipment values ('Bed37', 'Bed', 'INUSE', 'PATI00705');
insert into MedicalEquipment values ('Bed38', 'Bed', 'INUSE', 'PATI00805');
insert into MedicalEquipment values ('Bed39', 'Bed', 'INUSE', 'PATI00905');
insert into MedicalEquipment values ('Bed40', 'Bed', 'INUSE', 'PATI01005');
insert into MedicalEquipment values ('Recliner12', 'Recliner', 'INUSE', 'PATI00105');
insert into MedicalEquipment values ('Recliner13', 'Recliner', 'INUSE', 'PATI00205');
insert into MedicalEquipment values ('Recliner14', 'Recliner', 'INUSE', 'PATI00305');
insert into MedicalEquipment values ('Recliner15', 'Recliner', 'INUSE', 'PATI00405');
insert into MedicalEquipment values ('Recliner16', 'Recliner', 'INUSE', 'PATI00505');
insert into MedicalEquipment values ('XRay03', 'XRay', 'INUSE', 'PATI00105');
insert into MedicalEquipment values ('IPump46', 'IPumps', 'CLEAN', 'STOR00105');
insert into MedicalEquipment values ('IPump47', 'IPumps', 'CLEAN', 'STOR00205');
insert into MedicalEquipment values ('IPump48', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump49', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump50', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump51', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump52', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump53', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump54', 'IPumps', 'CLEAN', 'STOR00105');
insert into MedicalEquipment values ('IPump55', 'IPumps', 'CLEAN', 'STOR00105');
insert into MedicalEquipment values ('IPump56', 'IPumps', 'CLEAN', 'STOR00105');
insert into MedicalEquipment values ('IPump57', 'IPumps', 'INUSE', 'PATI00905');
insert into MedicalEquipment values ('IPump58', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump59', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('IPump60', 'IPumps', 'DIRTY', 'DIRT00105');
insert into MedicalEquipment values ('Bed41', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('Bed42', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('Bed43', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('Bed44', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('Bed45', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('Bed46', 'Bed', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('WChair01', 'WheelChair', 'CLEAN', 'STOR00303');
insert into MedicalEquipment values ('WChair02', 'WheelChair', 'CLEAN', 'STOR00303');
insert into MedicalEquipment values ('WChair03', 'WheelChair', 'DIRTY', 'STOR00403');
insert into MedicalEquipment values ('WChair04', 'WheelChair', 'INUSE', 'PATI00404');
insert into MedicalEquipment values ('WChair05', 'WheelChair', 'CLEAN', 'STOR00303');

insert into Employees values ('Emp02', 'ShafathZ', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Shafath', 'Zaman', 30, 'B1', null, 'HALL00201');
insert into Employees values ('Emp03', 'HarmoniL', '11297115115119111114100', 'Harmoni', 'Larrabee', null, null, null, 'INFO00101');
insert into Employees values ('Emp04', 'AlexanderM', 'cGFzc3dvcmQ=', 'Alexander', 'MacDonald', 40, null, 1234567890, 'LABS00101');
insert into Employees values ('Emp05', 'Wwong2', 'wongdrip', 'Wilson', 'Wong', 45, 'A1', null, 'REST00101');
insert into Employees values ('Emp06', 'ThrilledSoftEngStudent', 'sofun', 'Happy', 'Thoughts', 10, null, null, 'ELEV00L01');
insert into Employees values ('Emp07', 'ADumbSecurityStudent', 'password', 'Phih', 'Shing', null, null, 9876543210, 'HALL002L1');
insert into Employees values ('Emp08', 'ADumberSecurityStudent', 'encrypt("password")', 'Encrip', 'Shun', 10, null, null, 'RETL00202');
insert into Employees values ('Emp09', 'pjohnson', 'heylouisitsme', 'Peter', 'Johnson', null, null, null, 'HALL00103');
insert into Employees values ('Emp010', 'lshmaria', 'peterjohnsonletmein', 'Lois', 'Shmaria', null, null, null, 'REST002L1');
insert into Employees values ('Emp011', 'mneilson', 'iforgotmykeys', 'Meghan', 'Neilson', null, 'C3', 6789012345, 'STOR00105');
insert into Employees values ('Emp012', 'snestle', 'iseeyoustandingthere', 'Stewart', 'Nestle', 25, null, null, 'PATI00505');
insert into Employees values ('Emp013', 'bbriansonman', 'stopignoringme', 'Brian', 'Briansonman', null, null, null, 'PATI01605');
insert into Employees values ('Emp014', 'qglenn', 'louisplease', 'Quagmire', 'Glenn', null, null, null, 'RETL00102');
insert into Employees values ('Emp015', 'jrichard', 'itsrainingiamgettingwet', 'Joe', 'Richard', null, null, null, 'BATH00203');
insert into Employees values ('Emp016', 'cohio', 'heheheheheh', 'Cleveland', 'Ohio', 44, null, null, 'REST002L1');
insert into Employees values ('Emp017', 'sdover', 'impeterjohnson', 'Stan', 'Dover', null, null, null, 'DIRT00103');

insert into Patient values (10001, 'Shafath', 'Zaman', 8323994925, 'Easton', 'MA', 'HALL00103');
insert into Patient values (10002, 'Harmoni', 'Larrabee', 9498127719, 'Worcester', 'MA', 'HALL02501');
insert into Patient values (10003, 'Alexander', 'MacDonald', 8150810365, 'Worcester', 'MA', 'ELEV00M01');
insert into Patient values (10004, 'Tom', 'McCarthy', 9548795354, 'Phoenix', 'AZ', 'STAI00202');
insert into Patient values (10005, 'Daniel', 'Cruz', 1602015549, 'Dallas', 'TX', 'LABS00103');
insert into Patient values (10006, 'Kathy', 'Lockheart', 2978350005, 'New Haven', 'CT', 'SERV00301');
insert into Patient values (10007, 'Jacob', 'Albarn', 3836253081, 'Brookhaven', 'NY', 'PATI01205');
insert into Patient values (10008, 'Cody', 'White', 1433417504, 'Dallas', 'TX', null);
insert into Patient values (10009, 'Lucy', 'Heartfield', 2254994329, 'Boston', 'MA', 'PATI01505');
insert into Patient values (10010, 'Ferdinand', 'Braun', 5654670838, 'Springfield', 'MA', 'PATI01905');
insert into Patient values (10011, 'Nyatasha', 'Kotova', null, 'Los Angeles', 'CA', 'PATI02005');
insert into Patient values (10012, 'Gilbert', 'Bougain', 8479379032, 'Fairfield', 'CT', 'DEPT00601');

insert into ServiceRequest values (10001, 'MED', 'unassigned', 'Emp02', null, 'PATI00103');
insert into ServiceRequest values (10002, 'MED', 'assigned', 'Emp03', 'Emp04', 'PATI00203');
insert into ServiceRequest values (10003, 'MED', 'beingProcessed', 'Emp04', 'Emp05', 'PATI00303');
insert into ServiceRequest values (10004, 'MED', 'done', 'Emp05', 'Emp06', 'PATI00403');
insert into ServiceRequest values (10005, 'MED', 'canceled', 'Emp06', 'Emp07', 'PATI00503');
insert into ServiceRequest values (20001, 'LAB', 'unassigned', 'Emp07', null, 'PATI00603');
insert into ServiceRequest values (20002, 'LAB', 'assigned', 'Emp08', 'Emp09', 'PATI00703');
insert into ServiceRequest values (20003, 'LAB', 'beingProcessed', 'Emp09', 'Emp010', 'PATI00803');
insert into ServiceRequest values (20004, 'LAB', 'done', 'Emp010', 'Emp011', 'PATI00903');
insert into ServiceRequest values (20005, 'LAB', 'canceled', 'Emp011', 'Emp012', 'PATI01003');
insert into ServiceRequest values (30001, 'TRA', 'unassigned', 'Emp012', null, 'PATI01103');
insert into ServiceRequest values (30002, 'TRA', 'assigned', 'Emp013', 'Emp014', 'PATI01203');
insert into ServiceRequest values (30003, 'TRA', 'beingProcessed', 'Emp014', 'Emp015', 'PATI01303');
insert into ServiceRequest values (30004, 'TRA', 'done', 'Emp015', 'Emp016', 'PATI01403');
insert into ServiceRequest values (30005, 'TRA', 'canceled', 'Emp016', 'Emp017', 'PATI01503');

insert into MedRequest values (10001, 'MED', 'DELIVERY', 'Bed01');
insert into MedRequest values (10002, 'MED', 'CLEANING', 'Recliner01');
insert into MedRequest values (10003, 'MED', 'DELIVERY', 'XRay01');
insert into MedRequest values (10004, 'MED', 'CLEANING', 'IPump01');
insert into MedRequest values (10005, 'MED', 'DELIVERY', 'Bed21');

insert into LabRequest values (20001, 'LAB', 'blood', 10001);
insert into LabRequest values (20002, 'LAB', 'urine', 10002);
insert into LabRequest values (20003, 'LAB', 'stool', 10003);
insert into LabRequest values (20004, 'LAB', 'XRay', 10004);
insert into LabRequest values (20005, 'LAB', 'MRI', 10005);

insert into TransportRequest values (30001, 'TRA', 'Bed02', 10006);
insert into TransportRequest values (30002, 'TRA', 'Recliner02', 10007);
insert into TransportRequest values (30003, 'TRA', 'Bed22', 10008);
insert into TransportRequest values (30004, 'TRA', 'Recliner12', 10009);
insert into TransportRequest values (30005, 'TRA', 'Recliner13', 10010);

insert into EquipPerRequest values (10001, 'Bed01');
insert into EquipPerRequest values (10001, 'Recliner01');
insert into EquipPerRequest values (10002, 'Recliner01');
insert into EquipPerRequest values (10003, 'XRay01');
insert into EquipPerRequest values (10004, 'IPump01');
insert into EquipPerRequest values (10005, 'Bed21');
insert into EquipPerRequest values (10005, 'Bed02');
insert into EquipPerRequest values (10005, 'Bed05');
