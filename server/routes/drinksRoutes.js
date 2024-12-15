const express = require('express');
const router = express.Router();
const sql = require('mssql');

// GET: Fetch all drinks
router.get('/', async (req, res) => {
  try {
    const request = new sql.Request();
    const result = await request.query('SELECT id, name, price, ImageLink FROM Drinks;');
    res.json(result.recordset);
  } catch (error) {
    console.error('Error fetching drinks:', error);
    res.status(500).send('Internal Server Error');
  }
});

// POST: Add a new drink
router.post('/', async (req, res) => {
  const { name, price, ImageLink } = req.body;

  if (!name || !price || !ImageLink) {
    return res.status(400).json({ message: 'Name, price, and ImageLink are required.' });
  }

  try {
    const request = new sql.Request();
    await request
      .input('name', sql.VarChar(255), name)
      .input('price', sql.Decimal(10, 2), price)
      .input('ImageLink', sql.VarChar(500), ImageLink)
      .query(`
        INSERT INTO Drinks (name, price, ImageLink) 
        VALUES (@name, @price, @ImageLink)
      `);
    res.status(201).json({ message: 'Drink added successfully.' });
  } catch (error) {
    console.error('Error adding drink:', error);
    res.status(500).send('Internal Server Error');
  }
});

// DELETE: Remove a drink by ID
router.delete('/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const request = new sql.Request();
    const result = await request.input('id', sql.Int, id).query('DELETE FROM Drinks WHERE id = @id');

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ message: 'Drink not found.' });
    }

    res.json({ message: 'Drink deleted successfully.' });
  } catch (error) {
    console.error('Error deleting drink:', error);
    res.status(500).send('Internal Server Error');
  }
});

// PUT: Update a drink by ID
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { name, price, ImageLink } = req.body;

  if (!name || !price || !ImageLink) {
    return res.status(400).json({ message: 'Name, price, and ImageLink are required.' });
  }

  try {
    const request = new sql.Request();
    const result = await request
      .input('id', sql.Int, id)
      .input('name', sql.VarChar(255), name)
      .input('price', sql.Decimal(10, 2), price)
      .input('ImageLink', sql.VarChar(500), ImageLink)
      .query(`
        UPDATE Drinks 
        SET name = @name, price = @price, ImageLink = @ImageLink 
        WHERE id = @id
      `);

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ message: 'Drink not found.' });
    }

    res.json({ message: 'Drink updated successfully.' });
  } catch (error) {
    console.error('Error updating drink:', error);
    res.status(500).send('Internal Server Error');
  }
});

module.exports = router;
