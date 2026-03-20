import React from 'react';
import { formatPrice, getStockLabel } from '../utils';

function ProductCard({ product, onAddToCart }) {
    const isStocked = product.inStock;

    return (
        <div className="product-card" data-testid={`product-card-${product.id}`}>
            {product.image && (
                <div className="product-image-container">
                    <img src={product.image} alt={product.name} className="product-image" loading="lazy" />
                </div>
            )}
            <div className="product-info">
                <h3>{product.name}</h3>
                <div className="category">{product.category}</div>
                
                <div className="price-stock-wrap">
                    <div className="price">{formatPrice(product.price)}</div>
                    <span className={`stock-badge ${isStocked ? 'in-stock' : 'out-of-stock'}`}>
                        {getStockLabel(isStocked)}
                    </span>
                </div>

                <button
                    className="add-to-cart-btn"
                    onClick={() => onAddToCart(product)}
                    disabled={!isStocked}
                >
                    {isStocked ? 'Add to Cart' : 'Out of Stock'}
                </button>
            </div>
        </div>
    );
}

export default ProductCard;
