🚗 Car Rental Database System

> A comprehensive Relational Database Management System (RDBMS) project built with MySQL, featuring sample data structures, relationship tables, and advanced SQL queries for a car rental business.

---

## 📊 Database Schema

The database consists of 4 core tables:
1. **`Araclar` (Vehicles):** Stores vehicle details, brands, models, daily rates, and status (`Uygun`, `Kirada`, `Bakımda`).
2. **`Musteriler` (Customers):** Keeps customer personal information, phone numbers, and emails.
3. **`Hizmetler` (Services):** Lists additional rental services and their respective prices.
4. **`Kiralamalar` (Rentals):** Relational bridge table connecting customers and vehicles with start and end dates.

---

## 🛠️ Features & SQL Operations

* **Table Creation & Relational Constraints:** Primary keys and foreign key constraints (`FOREIGN KEY`) ensuring data integrity.
* **Complex JOIN Queries:** Multi-table joins to track active rentals, customer booking counts, and service distributions.
* **Data Manipulation (DML):** `UPDATE` operations for price adjustments and vehicle status updates, alongside `DELETE` queries for data cleanup.
* **Aggregations & Filtering:** Grouping operations (`GROUP BY`, `HAVING`) and sorting mechanisms (`ORDER BY`).

---

## 🚀 Getting Started

To run and test this database on your local machine:

1. Clone or download this repository.
2. Open your preferred SQL client (MySQL Workbench, phpMyAdmin, DBeaver, etc.).
3. Execute the `car-rental-system.sql` script to create the database, tables, and insert sample records.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
