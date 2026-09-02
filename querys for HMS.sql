use hospital_management_system;
-- basic level

-- 1 query to get doctors who qulification is MBBS
select * from doctors where qualification like '%MBBS%';

-- 2 get a patient details name kavya

select * from patients  where first_name = 'kavya';

-- 3 get a patients with test result pending

select p.patient_id,first_name,last_name,result_status from patients p join testresults t on p.Patient_id = t.patient_id where result_status = 'pending';


-- 4 write a query to find all patients whose age is above 65.
SELECT
    patient_id,
    first_name,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM Patients
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > 65;

-- 5 Retrieve all appointments scheduled for today.
select * from  appointments where Appointment_Date=now();

-- 6 Display all doctors working in the physiotherapy department.
select d.Doctor_ID,d.first_Name,d.last_name,dept.Department_Name 
from doctors d 
inner join departments dept on d.department_id=dept.Department_ID 
where dept.Department_Name LIKE '%physiotherapy%';

-- 7 Find the total number of appointments handled by each doctor.
select Doctor_ID,count(appointment_ID) as NoOfAppointments from appointments group by doctor_ID;

-- 8 Find all bills where the total amount exceeds ₹5000.
select * from billing where total_amount>5000;

-- 9 Display the top 10 highest payment amounts.
select * from payments order by amount_paid desc limit 10;

-- 10 Retrieve all appointments with status = 'Cancelled'.
select * from appointments where status="Cancelled";

-- 11 Find the average patient age grouped by gender.
select Gender, avg(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) GenderAvg from patients group by gender;

-- 12 Retrieve doctors having more than 10 years of experience.
select Doctor_ID,first_Name,last_name,Years_Experience from doctors where Years_Experience>10;

-- 13 Display all medicines with stock quantity below 100.
select prescription_item_id,dosage,quantity from prescriptionitems where quantity<100;

-- 14 Display the latest 20 admission records.[Admission Date column missing]
select * from admissions order by Admission_ID desc limit 20;

-- 15 Find the total hospital revenue generated through bills.
select sum(total_Amount) Tot_Revenue from billing;



-- Intermediate Level

-- 1. List all doctors along with their department name
SELECT d.doctor_id, d.first_name, d.last_name, d.specialization,
       dep.department_name
FROM Doctors d
JOIN Departments dep ON d.department_id = dep.department_id;

-- 2. Number of doctors in each department (only departments with 2+ doctors)
SELECT dep.department_name, COUNT(d.doctor_id) AS total_doctors
FROM Departments dep
JOIN Doctors d ON d.department_id = dep.department_id
GROUP BY dep.department_name
HAVING COUNT(d.doctor_id) >= 2
ORDER BY total_doctors DESC;

-- 3. Patients with their upcoming (Scheduled) appointments, including doctor name
SELECT p.patient_id, p.first_name, p.last_name,
       a.appointment_date, a.appointment_time,
       CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
       a.status
FROM Appointments a
JOIN Patients p ON p.patient_id = a.patient_id
JOIN Doctors doc ON doc.doctor_id = a.doctor_id
WHERE a.status = 'Scheduled'
ORDER BY a.appointment_date, a.appointment_time;

-- 4. Count of appointments per status (Scheduled / Completed / Cancelled / No-Show)
SELECT status, COUNT(*) AS total
FROM Appointments
GROUP BY status
ORDER BY total DESC;

-- 5. Doctors who have never had an appointment (LEFT JOIN + IS NULL)
SELECT d.doctor_id, d.first_name, d.last_name
FROM Doctors d
LEFT JOIN Appointments a ON a.doctor_id = d.doctor_id
WHERE a.appointment_id IS NULL;

-- 6. Currently admitted patients with bed/room/department info
SELECT p.first_name, p.last_name, adm.admission_date,
       r.room_number, r.room_type, dep.department_name,
       b.bed_number
FROM Admissions adm
JOIN Patients p ON p.patient_id = adm.patient_id
JOIN Beds b ON b.bed_id = adm.bed_id
JOIN Rooms r ON r.room_id = b.room_id
JOIN Departments dep ON dep.department_id = r.department_id
WHERE adm.status = 'Admitted';

-- 7. Average length of stay (in days) for discharged patients
SELECT p.patient_id, p.first_name, p.last_name,
       adm.admission_date, adm.discharge_date,
       DATEDIFF(adm.discharge_date, adm.admission_date) AS days_stayed
FROM Admissions adm
JOIN Patients p ON p.patient_id = adm.patient_id
WHERE adm.status = 'Discharged'
ORDER BY days_stayed DESC;

-- 8. Overall average length of stay across all discharged admissions
SELECT ROUND(AVG(DATEDIFF(discharge_date, admission_date)), 1) AS avg_stay_days
FROM Admissions
WHERE status = 'Discharged';

-- 9. Total revenue collected per payment method
SELECT payment_method, SUM(amount_paid) AS total_collected, COUNT(*) AS num_payments
FROM Payments
GROUP BY payment_method
ORDER BY total_collected DESC;

-- 10. Outstanding balance per bill (total_amount vs amount actually paid)
SELECT b.bill_id, b.patient_id, b.total_amount,
       IFNULL(SUM(pay.amount_paid), 0) AS amount_paid,
       b.total_amount - IFNULL(SUM(pay.amount_paid), 0) AS balance_due,
       b.payment_status
FROM Billing b
LEFT JOIN Payments pay ON pay.bill_id = b.bill_id
GROUP BY b.bill_id, b.patient_id, b.total_amount, b.payment_status
HAVING balance_due > 0
ORDER BY balance_due DESC;

-- 11. Top 5 doctors by number of completed appointments
SELECT doc.doctor_id, CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
       COUNT(a.appointment_id) AS completed_appointments
FROM Doctors doc
JOIN Appointments a ON a.doctor_id = doc.doctor_id
WHERE a.status = 'Completed'
GROUP BY doc.doctor_id, doctor_name
ORDER BY completed_appointments DESC
LIMIT 5;

-- 12. Most prescribed medicines (join Prescriptions -> PrescriptionItems -> Medicines)
SELECT m.medicine_name, SUM(pi.quantity) AS total_quantity_prescribed,
       COUNT(DISTINCT pi.prescription_id) AS num_prescriptions
FROM PrescriptionItems pi
JOIN Medicines m ON m.medicine_id = pi.medicine_id
GROUP BY m.medicine_name
ORDER BY total_quantity_prescribed DESC
LIMIT 10;

-- 13. Medicines that are low in stock (below a threshold) and near expiry
SELECT medicine_name, stock_quantity, expiry_date
FROM Medicines
WHERE stock_quantity < 20
   OR expiry_date <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)
ORDER BY expiry_date;

-- 14. Patients who have taken more than one lab test, with test count
SELECT p.patient_id, p.first_name, p.last_name, COUNT(tr.result_id) AS tests_taken
FROM TestResults tr
JOIN Patients p ON p.patient_id = tr.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(tr.result_id) > 1
ORDER BY tests_taken DESC;

-- 15. Pending lab test results with patient & doctor names
SELECT lt.test_name, p.first_name AS patient_first, p.last_name AS patient_last,
       CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
       tr.test_date, tr.result_status
FROM TestResults tr
JOIN LabTests lt ON lt.test_id = tr.test_id
JOIN Patients p ON p.patient_id = tr.patient_id
JOIN Doctors doc ON doc.doctor_id = tr.doctor_id
WHERE tr.result_status = 'Pending';


-- Advanced SQL 

-- 1. Rank doctors by revenue generated (via Billing.doctor_fee), within each department
--    Uses a CTE + window function RANK()
WITH doctor_revenue AS (
    SELECT doc.doctor_id,
           CONCAT(doc.first_name, ' ', doc.last_name) AS doctor_name,
           dep.department_name,
           SUM(b.doctor_fee) AS total_revenue
    FROM Doctors doc
    JOIN Departments dep ON dep.department_id = doc.department_id
    JOIN Billing b ON b.patient_id IN (
        SELECT patient_id FROM Appointments WHERE doctor_id = doc.doctor_id
    )
    GROUP BY doc.doctor_id, doctor_name, dep.department_name
)
SELECT *,
       RANK() OVER (PARTITION BY department_name ORDER BY total_revenue DESC) AS rank_in_dept
FROM doctor_revenue
ORDER BY department_name, rank_in_dept;
 
 -- 2. Running total of daily revenue collected (Payments), ordered by date
WITH daily_totals AS (
    SELECT DATE(payment_date) AS pay_date, SUM(amount_paid) AS daily_amount
    FROM Payments
    GROUP BY DATE(payment_date)
)
SELECT pay_date, daily_amount,
       SUM(daily_amount) OVER (ORDER BY pay_date
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM daily_totals
ORDER BY pay_date;
 
 
-- 3. For each patient, find their most recent admission and the one before it
--    (LAG window function) — useful for spotting readmissions
SELECT patient_id, admission_id, admission_date, discharge_date, status,
       LAG(admission_date) OVER (PARTITION BY patient_id ORDER BY admission_date) AS previous_admission_date,
       DATEDIFF(admission_date,
                LAG(discharge_date) OVER (PARTITION BY patient_id ORDER BY admission_date)
       ) AS days_since_last_discharge
FROM Admissions
ORDER BY patient_id, admission_date;
 
 
-- 4. Flag likely readmissions: patients readmitted within 30 days of a previous discharge
WITH admission_gaps AS (
    SELECT patient_id, admission_id, admission_date,
           LAG(discharge_date) OVER (PARTITION BY patient_id ORDER BY admission_date) AS prev_discharge
    FROM Admissions
)
SELECT patient_id, admission_id, admission_date, prev_discharge,
       DATEDIFF(admission_date, prev_discharge) AS gap_days
FROM admission_gaps
WHERE prev_discharge IS NOT NULL
  AND DATEDIFF(admission_date, prev_discharge) <= 30
ORDER BY gap_days;
 
 
-- 5. Top 3 highest-billed patients PER department (window function partitioned ranking)
WITH patient_dept_billing AS (
    SELECT p.patient_id, CONCAT(p.first_name,' ',p.last_name) AS patient_name,
           dep.department_name, SUM(b.total_amount) AS total_billed,
           ROW_NUMBER() OVER (PARTITION BY dep.department_name ORDER BY SUM(b.total_amount) DESC) AS rn
    FROM Billing b
    JOIN Patients p ON p.patient_id = b.patient_id
    JOIN Admissions adm ON adm.admission_id = b.admission_id
    JOIN Beds bed ON bed.bed_id = adm.bed_id
    JOIN Rooms r ON r.room_id = bed.room_id
    JOIN Departments dep ON dep.department_id = r.department_id
    GROUP BY p.patient_id, patient_name, dep.department_name
)
SELECT * FROM patient_dept_billing
WHERE rn <= 3
ORDER BY department_name, rn;



-- 6 (Stored Procedure, Triggers)

-- SECTION 1: STORED PROCEDURES

-- BookAppointment
-- condition : Books an appointment only if the doctor has no conflicting
-- appointment at the same date/time.
-- ------------------------------------------------------------
DELIMITER $$
 
CREATE PROCEDURE BookAppointment (
    IN p_patient_id INT,
    IN p_doctor_id  INT,
    IN p_date       DATE,
    IN p_time       TIME,
    IN p_reason     VARCHAR(255)
)
BEGIN
    DECLARE v_conflict_count INT;
 
    SELECT COUNT(*) INTO v_conflict_count
    FROM Appointments
    WHERE doctor_id = p_doctor_id
      AND appointment_date = p_date
      AND appointment_time = p_time
      AND status = 'Scheduled';
 
    IF v_conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Doctor already has an appointment at this date/time.';
    ELSE
        INSERT INTO Appointments (patient_id, doctor_id, appointment_date, appointment_time, reason)
        VALUES (p_patient_id, p_doctor_id, p_date, p_time, p_reason);
    END IF;
END$$
 
DELIMITER ;
 
-- Example call:
CALL BookAppointment(10, 4, '2026-08-15', '10:30:00', 'Follow-up checkup');

-- 7: Discharge a patient
-- Sets discharge_date, updates status, frees the bed, and
-- auto-generates a Billing row pre-filled with room charges
-- ============================================================
DELIMITER 
 
CREATE PROCEDURE sp_discharge_patient (
    IN p_admission_id INT
)
BEGIN
    DECLARE v_bed_id       INT;
    DECLARE v_patient_id   INT;
    DECLARE v_admit_date   DATETIME;
    DECLARE v_days_stayed  INT;
    DECLARE v_daily_rate   DECIMAL(10,2);
    DECLARE v_room_charges DECIMAL(10,2);
 
    -- Gather admission + room info
    SELECT adm.bed_id, adm.patient_id, adm.admission_date, r.daily_rate
    INTO v_bed_id, v_patient_id, v_admit_date, v_daily_rate
    FROM Admissions adm
    JOIN Beds b ON b.bed_id = adm.bed_id
    JOIN Rooms r ON r.room_id = b.room_id
    WHERE adm.admission_id = p_admission_id;
 
    -- Mark discharged
    UPDATE Admissions
    SET discharge_date = NOW(),
        status = 'Discharged'
    WHERE admission_id = p_admission_id;
 
    -- Free the bed
    UPDATE Beds
    SET is_occupied = FALSE
    WHERE bed_id = v_bed_id;
 
    -- Calculate room charges (minimum 1 day)
    SET v_days_stayed = GREATEST(DATEDIFF(NOW(), v_admit_date), 1);
    SET v_room_charges = v_days_stayed * v_daily_rate;
 
    -- Create the bill
    INSERT INTO Billing (patient_id, admission_id, room_charges, payment_status)
    VALUES (v_patient_id, p_admission_id, v_room_charges, 'Unpaid');
 
END$$
 
DELIMITER ;

-- Usage:
-- CALL sp_discharge_patient(7);

-- STORED PROCEDURE 8: Record a payment and auto-update bill status
-- ============================================================
DELIMITER $$

CREATE PROCEDURE sp_record_payment (
    IN p_bill_id         INT,
    IN p_amount          DECIMAL(10,2),
    IN p_method          VARCHAR(20),
    IN p_reference       VARCHAR(100)
)
BEGIN
    DECLARE v_total_amount DECIMAL(10,2);
    DECLARE v_total_paid   DECIMAL(10,2);

    INSERT INTO Payments (bill_id, amount_paid, payment_method, transaction_reference)
    VALUES (p_bill_id, p_amount, p_method, p_reference);

    SELECT total_amount INTO v_total_amount FROM Billing WHERE bill_id = p_bill_id;
    SELECT IFNULL(SUM(amount_paid), 0) INTO v_total_paid FROM Payments WHERE bill_id = p_bill_id;

    UPDATE Billing
    SET payment_status = CASE
            WHEN v_total_paid >= v_total_amount THEN 'Paid'
            WHEN v_total_paid > 0 THEN 'Partially Paid'
            ELSE 'Unpaid'
        END
    WHERE bill_id = p_bill_id;
END$$

DELIMITER ;

-- Usage:
CALL sp_record_payment(3, 1500.00, 'Cash', 'TXN-00123');


-- TRIGGER 1: Auto-mark bed as occupied when an Admission is inserted

DELIMITER $$

CREATE TRIGGER trg_after_admission_insert
AFTER INSERT ON Admissions
FOR EACH ROW
BEGIN
    UPDATE Beds
    SET is_occupied = TRUE
    WHERE bed_id = NEW.bed_id;
END$$
 
DELIMITER ;
 
 

-- TRIGGER 2: Auto-free the bed when an Admission is updated to 'Discharged'

DELIMITER $$

CREATE TRIGGER trg_after_admission_discharge
AFTER UPDATE ON Admissions
FOR EACH ROW
BEGIN
    IF NEW.status = 'Discharged' AND OLD.status <> 'Discharged' THEN
        UPDATE Beds
        SET is_occupied = FALSE
        WHERE bed_id = NEW.bed_id;
    END IF;
END$$
 
DELIMITER ;
 
 

-- TRIGGER 3: Deduct medicine stock when a PrescriptionItem is added,
-- and block the insert if there isn't enough stock

DELIMITER $$

CREATE TRIGGER trg_before_prescriptionitem_insert
BEFORE INSERT ON PrescriptionItems
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
 
    SELECT stock_quantity INTO v_stock
    FROM Medicines
    WHERE medicine_id = NEW.medicine_id;
 
    IF v_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient medicine stock for this prescription item.';
    END IF;
END$$
 
CREATE TRIGGER trg_after_prescriptionitem_insert
AFTER INSERT ON PrescriptionItems
FOR EACH ROW
BEGIN
    UPDATE Medicines
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE medicine_id = NEW.medicine_id;
END$$
 
DELIMITER ;



