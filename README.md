# HOSPITAL-MANAGEMENT-SYSTEM   


A SQL-based Hospital Management System developed using MySQL to manage and analyze hospital operations efficiently. This project demonstrates real-time database management concepts including patient management, appointments, billing, pharmacy, admissions, laboratory analytics, and hospital reporting.


# project overview

The Hospital Analytics System is designed to simulate real-world hospital database operations and analytics. The project focuses on:

  Database Design
  SQL Query Optimization
  Relational Database Management
  Hospital Data Analytics
  Reporting & Insights Generation

This project is ideal for showcasing SQL, database management, and analytics skills for internships, placements, and portfolio projects.

# features

# patient management
    medicine inventory tracking
    stock quantity management
    prescription handling
    
# Laboratory Management
    Store lab test details
    Maintain result status

# Admission & Room Management
    Patient admission handling
    Room allocation
    Occupancy tracking

# Billing & Payments
    Bill generation
    Payment tracking
    Revenue analysis

# Feedback System
    Patient feedback collection
    Doctor rating analytics

# Technologies Used

| Technology | Description |
|------------|-------------|
| Mysql | Database Management |
| Sql | Query Language |
| Mysql workbench | Database Modeling & Query Execution |

# Database Tables

| Table name | Description |
|------------|-------------|
| patients | Patient information |
| doctors | Doctor details |
| departments | Hospital departments |
| appointments | appointments |
| diagnosis | Disease diagnosis details |
| prescriptions | Medicine prescriptions |
| pharmacy | Medicine inventory |
| bills | Billing information |
| payments | Payment records |
| labtests | 	Laboratory tests |
| admissions | Patient admissions |
| rooms | Room details |
| insurance | Insurance information |
| staff | Hospital staff |
|nurses | Nurse details |
| feedback | Patient feedback |


# Entity Relationship Highlights

One patient can book multiple appointments
One doctor belongs to one department
One appointment can contain diagnosis and prescriptions
Bills are connected with payments
Patients can undergo multiple lab tests
Admissions are connected with rooms

# SQL Concepts Used
Joins
Aggregate Functions
Subqueries
CTEs
Window Functions
Views
Stored Procedures
Triggers
Constraints

# Sample Analytical Queries

# 1️ Most Prescribed Medicine

SELECT MedicineID,
       COUNT(MedicineID) AS Mostly_Prescribed
FROM prescriptions
GROUP BY MedicineID
ORDER BY COUNT(MedicineID) DESC;

# 2️ Department-wise Doctor Count

SELECT d.DepartmentName,
       COUNT(doc.DoctorID) AS TotalDoctors
FROM departments d
JOIN doctors doc
ON d.DepartmentID = doc.DepartmentID
GROUP BY d.DepartmentName;

# 3️ Total Hospital Revenue

SELECT SUM(TotalAmount) AS TotalRevenue
FROM bills;

# 4️ Patients with More Than 3 Lab Tests

SELECT p.PatientName,
       COUNT(l.LabTestID) AS TotalTests
FROM patients p
JOIN labtests l
ON p.PatientID = l.PatientID
GROUP BY p.PatientName
HAVING COUNT(l.LabTestID) > 3;

# Project Objectives
 
Improve hospital data management
Reduce manual record handling
Generate analytical insights
Support data-driven decision-making
Optimize hospital operations

# Learning Outcomes

This project helped in improving:

   Advanced SQL Skills
   Database Design
   Query Optimization
   Data Analytics
   Relational Database Modeling
   Real-time Reporting

# Future Enhancements

   Power BI Dashboard Integration
   Web Application Integration
   Authentication & Authorization
   AI-Based Healthcare Analytics
   Real-time Monitoring System

# How to Run the Project

# Step 1: Install MySQL

Install:

    MySQL Server
    MySQL Workbench

# Step 2: Create Database

     CREATE DATABASE hospital_management_system;
     USE Hospital_management_System;

# Step 3: Import SQL File

     Import the provided .sql file into MySQL Workbench.

# Step 4: Execute Queries

    Run analytical queries and generate reports.

# Author

# kavinesan I

      B.Tech student - Rathinam Technical Campus 
      Interested in SQL, Power BI, Data Analytics, and software developer

# Conclusion

The hospital management system is a real-time SQL analytics project that demonstrates strong knowledge in database design, query optimization, and healthcare data analysis. This project is suitable for academic presentations, internships, and software/data analyst portfolios.

