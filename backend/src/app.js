const express = require('express');
const cors = require('cors');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health Check Route
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'ShopSmart Backend is running',
    timestamp: new Date().toISOString()
  });
});

// Products Route
const PRODUCTS = [
  { id: 1, name: 'Premium Wireless Headphones', price: 12999, category: 'Electronics', inStock: true, image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80' },
  { id: 2, name: 'Organic Cotton T-Shirt', price: 2499, category: 'Clothing', inStock: true, image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&q=80' },
  { id: 3, name: 'Ceramic Coffee Mug', price: 1450, category: 'Home', inStock: false, image: 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=500&q=80' },
  { id: 4, name: 'Gaming Mouse', price: 4999, category: 'Electronics', inStock: true, image: 'https://images.unsplash.com/photo-1527814050087-379381547918?w=500&q=80' },
  { id: 5, name: 'Leather Wallet', price: 3999, category: 'Accessories', inStock: false, image: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=500&q=80' },
  { id: 6, name: 'Running Shoes', price: 8999, category: 'Clothing', inStock: true, image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&q=80' },
];

app.get('/api/products/search', (req, res) => {
  const query = (req.query.q || '').toLowerCase();

  if (!query) {
    return res.json(PRODUCTS);
  }

  const filtered = PRODUCTS.filter(p =>
    p.name.toLowerCase().includes(query) ||
    p.category.toLowerCase().includes(query)
  );

  res.json(filtered);
});

// Root Route (optional, just to show something)
app.get('/', (req, res) => {
  res.send('ShopSmart Backend Service');
});

module.exports = app;
// udita is chubby 