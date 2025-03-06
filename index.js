const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

// Create Express app
const app = express();
app.use(express.json());

// Database connection pool
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'taxibook'
});

// Allowed customer types
const validCustomerTypes = ['normal_customer', 'cab_service_customer'];

// Create a new customer
app.post('/api/customers', async (req, res) => {
  try {
    let { customer_type, username, phone, password, email, account_status } = req.body;

    // Ensure valid customer_type
    if (!customer_type || !validCustomerTypes.includes(customer_type)) {
      customer_type = 'normal_customer';
    }

    // Hash the password before storing it
    const hashedPassword = await bcrypt.hash(password, 10);

    const [result] = await pool.execute(
      'INSERT INTO Customer (customer_type, username, phone, password, email, account_status) VALUES (?, ?, ?, ?, ?, ?)',
      [customer_type, username, phone, hashedPassword, email, account_status ?? 'active']
    );

    res.status(201).json({
      customer_id: result.insertId,
      customer_type,
      username,
      phone,
      email,
      account_status: account_status ?? 'active'
    });
  } catch (error) {
    console.error('Error creating customer:', error);
    res.status(500).json({ message: 'Error creating customer', error: error.message });
  }
});

// Get all customers
app.get('/api/customers', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Customer');
    res.json(rows);
  } catch (error) {
    console.error('Error fetching customers:', error);
    res.status(500).json({ message: 'Error fetching customers', error: error.message });
  }
});

// Get a customer by ID
app.get('/api/customers/:id', async (req, res) => {
  try {
    const [rows] = await pool.execute('SELECT * FROM Customer WHERE customer_id = ?', [req.params.id]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Error fetching customer:', error);
    res.status(500).json({ message: 'Error fetching customer', error: error.message });
  }
});

// Update a customer
app.put('/api/customers/:id', async (req, res) => {
  try {
    let { customer_type, username, phone, password, email, account_status } = req.body;
    const customerId = req.params.id;

    // Ensure valid customer_type
    if (!customer_type || !validCustomerTypes.includes(customer_type)) {
      customer_type = 'normal_customer';
    }

    const [checkRows] = await pool.execute('SELECT customer_id FROM Customer WHERE customer_id = ?', [customerId]);

    if (checkRows.length === 0) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    await pool.execute(
      'UPDATE Customer SET customer_type = ?, username = ?, phone = ?, password = ?, email = ?, account_status = ? WHERE customer_id = ?',
      [customer_type, username, phone, password, email, account_status, customerId]
    );

    res.json({
      customer_id: parseInt(customerId),
      customer_type,
      username,
      phone,
      email,
      account_status
    });
  } catch (error) {
    console.error('Error updating customer:', error);
    res.status(500).json({ message: 'Error updating customer', error: error.message });
  }
});

// Delete a customer
app.delete('/api/customers/:id', async (req, res) => {
  try {
    const customerId = req.params.id;

    const [result] = await pool.execute('DELETE FROM Customer WHERE customer_id = ?', [customerId]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    res.status(204).end();
  } catch (error) {
    console.error('Error deleting customer:', error);
    res.status(500).json({ message: 'Error deleting customer', error: error.message });
  }
});

// Customer login
app.post('/api/customers/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Validate phone and password
    if (!phone || !password) {
      return res.status(400).json({ message: 'Phone number and password are required' });
    }

    // Query the database to find the customer by phone number
    const [rows] = await pool.execute('SELECT * FROM Customer WHERE phone = ?', [phone]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    // Compare the provided password with the stored password (in a real scenario, you should hash the password before saving and compare hashed passwords)
    const customer = rows[0];
    if (customer.password !== password) {
      return res.status(401).json({ message: 'Incorrect password' });
    }

    // If credentials are valid, return success
    res.json({
      message: 'Login successful',
      customer_id: customer.customer_id,
      username: customer.username,
      phone: customer.phone,
      email: customer.email,
      customer_type: customer.customer_type,
      account_status: customer.account_status
    });

  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ message: 'Error during login', error: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Error handling for database connection
process.on('unhandledRejection', (error) => {
  console.error('Unhandled Promise Rejection:', error);
});
