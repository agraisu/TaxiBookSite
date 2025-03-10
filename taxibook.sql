-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2025 at 10:01 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `taxibook`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `customer_type` enum('normal_customer','cab_service_customer') NOT NULL DEFAULT 'normal_customer',
  `username` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `account_status` enum('active','inactive','suspended') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `customer_type`, `username`, `phone`, `password`, `email`, `created_at`, `account_status`) VALUES
(4, 'normal_customer', 'Danzi', '0771265676', '$2b$10$PtDjvfUfOW.x0IFIbCfcmem9fQRMdhUmqc/2sg2jXsuXcqntvhVIq', 'danzi@example.com', '2025-03-06 06:56:27', 'active'),
(5, 'cab_service_customer', 'Ram', '0777765645', '$2b$10$Q2dAu9OE2uIWTsfWfJQiVebQHbQJAbK.ew5bnT7FiE6LQF1i/TYeC', 'ram@example.com', '2025-03-06 12:47:40', 'active'),
(6, 'cab_service_customer', 'Fred', '0725645656', '$2b$10$nKN7d/9P63ue8klz4121peSSVVodX9i00dGxdUT7HQX1tRJ8BDCIm', 'fred@example.com', '2025-03-06 13:02:49', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `trip`
--

CREATE TABLE `trip` (
  `trip_id` int(11) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `pickup_location` varchar(255) NOT NULL,
  `dropoff_location` varchar(255) NOT NULL,
  `trip_date` date NOT NULL,
  `trip_time` varchar(10) NOT NULL,
  `vehicle_type` varchar(100) NOT NULL,
  `passengers` int(11) NOT NULL CHECK (`passengers` > 0),
  `description` text DEFAULT NULL,
  `contact_number1` varchar(15) NOT NULL,
  `contact_number2` varchar(15) DEFAULT NULL,
  `driver_name` varchar(255) DEFAULT NULL,
  `confirmation_status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trip`
--

INSERT INTO `trip` (`trip_id`, `customer_name`, `pickup_location`, `dropoff_location`, `trip_date`, `trip_time`, `vehicle_type`, `passengers`, `description`, `contact_number1`, `contact_number2`, `driver_name`, `confirmation_status`, `created_at`) VALUES
(1, 'Sarah Johnson', 'International Airport Terminal 3', '742 Evergreen Terrace', '2025-03-15', '14:30', 'SUV', 3, 'Airport pickup with luggage, flight AC123 arriving at 14:15', '555-123-4567', '555-987-6543', 'Michael Rodriguez', 1, '2025-03-10 07:26:04'),
(2, 'James Wilson', 'Grand Hotel, 123 Main Street', 'Tech Park Tower, 456 Innovation Drive', '2025-03-12', '09:00', 'Luxury Sedan', 2, 'Business meeting, smart casual dress code for driver requested', '555-222-3333', '555-387-6544', 'Emma Clark', 1, '2025-03-10 07:26:04'),
(7, 'Robert Chen', '15 Parkview Lane', 'Symphony Hall, 789 Cultural Boulevard', '2025-03-16', '18:45', 'Sedan', 2, 'Evening concert, return trip will be booked separately', '555-444-5555', '', 'David Johnson', 0, '2025-03-10 08:03:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `trip`
--
ALTER TABLE `trip`
  ADD PRIMARY KEY (`trip_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `trip`
--
ALTER TABLE `trip`
  MODIFY `trip_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
