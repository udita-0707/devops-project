import { useState, useEffect } from 'react'
import ProductList from './components/ProductList';

function App() {
    const [data, setData] = useState(null);
    const [cartCount, setCartCount] = useState(0);

    const handleAddToCart = (product) => {
        setCartCount(prev => prev + 1);
    };

    useEffect(() => {
        const apiUrl = import.meta.env.VITE_API_URL || '';
        fetch(`${apiUrl}/api/health`)
            .then(res => res.json())
            .then(data => setData(data))
            .catch(err => console.error('Error fetching health check:', err));
    }, []);

    return (
        <div className="app-container">
            <header className="app-header">
                <div className="header-content">
                    <h1 className="logo">ShopSmart</h1>
                    <div className="header-actions">
                        <div className="cart-badge">
                            🛒 Cart {cartCount > 0 && <span className="count">{cartCount}</span>}
                        </div>
                    </div>
                </div>
            </header>
            
            <main className="main-content">
                <div className="hero-section">
                    <h2>Discover Incredible Deals</h2>
                    <p>Shop the latest electronics, clothing, and home accessories with ShopSmart and save more every day.</p>
                </div>

                <ProductList onAddToCart={handleAddToCart} />
            </main>

            <footer className="app-footer">
                <div className="footer-content">
                    <div className="backend-status">
                        <h4>System Status</h4>
                        {data ? (
                            <div className="status-indicator">
                                <span className="status-dot online"></span>
                                Backend: <span className="status-ok">{data.status}</span>
                            </div>
                        ) : (
                            <div className="status-indicator">
                                <span className="status-dot offline"></span>
                                Backend: Checking...
                            </div>
                        )}
                    </div>
                </div>
            </footer>
        </div>
    )
}

export default App