// Handle item modifying in cart (Orders, orderDetails)
// Currently adding and deleting drinks, foods, top-ups, games from cart

const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.post('/', async (req, res) => {
  const { customer_id, item_id, item_type, quantity } = req.body;

  if (!customer_id || !item_id || !item_type || !quantity) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  try {
    // 1. Check if there's an existing order for this customer
    let request = new sql.Request();
    let orderResult = await request
      .input('customer_id', sql.Int, customer_id)
      .query(`SELECT TOP 1 order_id FROM Orders WHERE customer_id = @customer_id ORDER BY order_id DESC`);

    let order_id;
    if (orderResult.recordset.length === 0) {
      // No existing order, create a new one
      request = new sql.Request();
      const insertOrder = await request
        .input('customer_id', sql.Int, customer_id)
        .query(`
          INSERT INTO Orders (customer_id) VALUES (@customer_id);
          SELECT SCOPE_IDENTITY() AS new_order_id;
        `);
      order_id = insertOrder.recordset[0].new_order_id;
    } else {
      order_id = orderResult.recordset[0].order_id;
    }

    // 2. Get the price of the item. Create a new request object.
    request = new sql.Request();
    let pricePerItem;
    if (item_type === 'Drink') {
      const priceResult = await request
        .input('item_id', sql.Int, item_id)
        .query(`SELECT price FROM Drinks WHERE id = @item_id`);
      if (priceResult.recordset.length === 0) {
        return res.status(404).json({ error: 'Item not found in Drinks table' });
      }
      pricePerItem = priceResult.recordset[0].price;
    } 
    else if (item_type === 'Food') {
      const priceResult = await request
        .input('item_id', sql.Int, item_id)
        .query(`SELECT price FROM Foods WHERE id = @item_id`);
      if (priceResult.recordset.length === 0) {
        return res.status(404).json({ error: 'Item not found in Foods table' });
      }
      pricePerItem = priceResult.recordset[0].price;
    }
    else if (item_type === 'Games_Top_up') {
      const priceResult = await request
        .input('item_id', sql.Int, item_id)
        .query(`SELECT price FROM Games_top_up WHERE id = @item_id`);
      if (priceResult.recordset.length === 0) {
        return res.status(404).json({ error: 'Item not found in Games_Top_up table' });
      }
      pricePerItem = priceResult.recordset[0].price;
    } 
    else if (item_type === 'Top_up') {
      const priceResult = await request
        .input('item_id', sql.Int, item_id)
        .query(`SELECT price FROM Top_up WHERE id = @item_id`);
      if (priceResult.recordset.length === 0) {
        return res.status(404).json({ error: 'Item not found in Top_up table' });
      }
      pricePerItem = priceResult.recordset[0].price;
    }else {
      return res.status(400).json({ error: 'Unsupported item_type currently. Only "Drink", "Food", "Game_Top_up", "Top_up" is supported.' });
    }

    // 3. Insert the order detail. Use a new Request object again.
    request = new sql.Request();
    await request
    .input('order_id', sql.Int, order_id)
    .input('item_type', sql.VarChar(20), item_type)
    .input('item_id', sql.Int, item_id)
    .input('quantity', sql.Int, quantity)
    .input('price_per_item', sql.Decimal(10, 2), pricePerItem)
    .query(`
      INSERT INTO OrderDetails (order_id, item_type, item_id, quantity, price_per_item)
      VALUES (@order_id, @item_type, @item_id, @quantity, @price_per_item)
    `);
  

    res.json({ success: true, message: 'Item added to cart', order_id });
  } catch (error) {
    console.error('Error adding item to cart:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// DELETE route to remove an item from the cart
router.delete('/:detail_id', async (req, res) => {
  const { detail_id } = req.params;

  if (!detail_id) {
    return res.status(400).json({ error: 'detail_id is required' });
  }

  try {
    const request = new sql.Request();
    await request
      .input('detail_id', sql.Int, detail_id)
      .query(`
        DELETE FROM OrderDetails
        WHERE detail_id = @detail_id
          AND status = 'In-cart'
      `);

    res.json({ success: true, message: 'Item removed from cart successfully.' });
  } catch (error) {
    console.error('Error deleting item from cart:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
