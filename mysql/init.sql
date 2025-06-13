CREATE DATABASE IF NOT EXISTS employees; 
USE employees;

CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO employees (first_name, last_name, email, department, hire_date) VALUES
("Amaan", "Saiyed", "amaan.saiyed@company.com", "Cloud Engineering", "2024-09-01"),
("Zahrah", "Arif", "zahrah.arif@company.com", "Security", "2024-08-15"),
("Mehdi", "Akbari", "mehdi.akbari@company.com", "DevOps", "2024-07-10"),
("Isabel", "Garcia", "isabel.garcia@company.com", "Data Engineering", "2024-06-20"),
("Arjun", "Patel", "arjun.patel@company.com", "AI & ML", "2024-05-05");

