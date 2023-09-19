--Alexander MacDonald, Harmoni Larrabee, Shafath Zaman

-- #1a
CREATE VIEW TransportAndLabRequests AS
    SELECT A.requestID, A.role, A.status, A.requesterEmployeeID, A.handlerEmployeeID, floor, shortName, locationTypeID, C.patientID AS TransportPatient, C.itemID AS TransportVehicle, D.patientID AS LabPatient, D.labTest
    FROM ServiceRequest A
        JOIN (
            SELECT locationID, floor, shortName, locationTypeID
            FROM Location) B 
        ON A.destinationID = B.locationID
        FULL JOIN (
            SELECT requestID, patientID, itemID
            FROM TransportRequest) C 
        ON A.requestID = C.requestID 
        FULL JOIN (LabRequest) D
        ON A.requestID = D.requestID
    WHERE A.role = 'Transport' OR A.role = 'Lab'
    ORDER BY requestID;

-- #1b
SELECT status, COUNT(transportPatient), COUNT(labPatient)
FROM TransportAndLabRequests
GROUP BY status
ORDER BY status;

-- Problem 2
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE EmployeeLocation (e_firstName varchar2, e_lastName varchar2) IS
     CURSOR C1 IS
        SELECT
            employeeID, username, firstName, lastName, shortName
        FROM
            Employee E
            JOIN
            Location L
            ON E.locationID = L.locationID
        WHERE
            E.firstName = e_firstName AND E.lastName = e_lastName;
     Begin
        FOR rec IN C1 LOOP
            dbms_output.put_line(rec.firstName || ' ' || rec.lastName ||
                ' located in ' || rec.shortName ||
                '. EmployeeID: ' || rec.employeeID ||
                '. Username: ' || rec.username || '.');
        END LOOP;
     END EmployeeLocation;
/
-- Problem 3
CREATE OR REPLACE TRIGGER TransportationEquipment
BEFORE INSERT OR UPDATE ON TransportRequest
FOR EACH ROW
begin
    IF(:new.itemID NOT LIKE 'Recliner%' AND :new.itemID NOT LIKE 'WChair%') THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: The equipment type for the transportation request is not a recliner or wheelchair!');
    END IF;
end;
/

-- #4

CREATE OR REPLACE Trigger UniqueNPI
BEFORE INSERT ON Employee
FOR EACH ROW
DECLARE
    c_npi number;
BEGIN
    SELECT COUNT(npi) into c_npi
    FROM Employee
    WHERE :new.npi = Employee.npi;
    
    IF c_npi > 0 AND :new.npi IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: New doctor''s NPI number already exists in the system');
    END IF;
END;
/

--#5

create or replace trigger DefaultXRayLocation
before insert on LabRequest
for each row
when (new.labTest = 'XRay')
declare
    Sdest char(9);
begin
    select destinationID into Sdest from ServiceRequest
    where ServiceRequest.requestID = :new.requestID;
    
    IF (Sdest not like '%LABS%') then
        update ServiceRequest
        set destinationID = 'LABS002L1'
        where requestID = :new.requestID;
    END IF;
end;
/