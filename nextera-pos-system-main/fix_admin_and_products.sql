-- ================================================================
-- FIX FOR NEXTERA POS - Make User Admin & Add Sample Products
-- ================================================================

-- 1. UPDATE USER ROLE TO ADMIN
-- Replace 'shoaib zaynah' with your actual username or use email
UPDATE users 
SET role = 'admin',
    permissions = ARRAY['pos_access', 'inventory_manage', 'sales_view', 'reports_view', 'settings_manage', 'users_manage']
WHERE username = 'shoaib zaynah' 
   OR email = 'your_email@example.com'
   OR name ILIKE '%shoaib%';

-- Verify the update
SELECT id, username, name, email, role, permissions 
FROM users;

-- 2. ADD SAMPLE PRODUCTS FOR TESTING
INSERT INTO products (name, sku, barcode, price, cost, stock, min_stock, category, description, active, track_inventory)
VALUES
    ('Apple iPhone 15 Pro', 'IP15P-001', '1234567890123', 1199.99, 899.99, 50, 10, 'Electronics', 'Latest iPhone model with A17 Pro chip', true, true),
    ('Samsung Galaxy S24', 'SGS24-001', '1234567890124', 999.99, 749.99, 30, 5, 'Electronics', 'Flagship Samsung smartphone', true, true),
    ('Sony WH-1000XM5', 'SNWH5-001', '1234567890125', 399.99, 299.99, 25, 5, 'Electronics', 'Premium noise-canceling headphones', true, true),
    ('MacBook Air M3', 'MBA-M3-001', '1234567890126', 1299.99, 999.99, 15, 3, 'Electronics', 'Thin and light laptop with M3 chip', true, true),
    ('Nike Air Max 270', 'NAM270-001', '1234567890127', 159.99, 89.99, 100, 20, 'Clothing', 'Popular Nike sneakers', true, true),
    ('Levi''s 501 Jeans', 'LV501-001', '1234567890128', 79.99, 39.99, 150, 30, 'Clothing', 'Classic straight-fit jeans', true, true),
    ('Coca-Cola 330ml', 'CC330-001', '1234567890129', 1.99, 0.89, 500, 100, 'Food & Beverage', 'Classic Coke can', true, true),
    ('Doritos Chips', 'DRT-001', '1234567890130', 3.99, 1.99, 200, 50, 'Food & Beverage', 'Nacho cheese flavor', true, true),
    ('Coffee Maker', 'CFM-001', '1234567890131', 89.99, 49.99, 20, 5, 'Home & Garden', 'Programmable coffee maker', true, true),
    ('Desk Lamp', 'DLMP-001', '1234567890132', 34.99, 19.99, 40, 10, 'Home & Garden', 'LED desk lamp with USB charging', true, true)
ON CONFLICT (sku) DO NOTHING;

-- 3. VERIFY PRODUCTS CREATED
SELECT id, name, sku, price, stock, category, active 
FROM products 
ORDER BY category, name;

-- 4. CHECK APP SETTINGS
SELECT * FROM app_settings LIMIT 1;

-- If no settings exist, insert default
INSERT INTO app_settings (
    store_name, 
    currency, 
    tax_rate, 
    interface_mode, 
    theme
)
SELECT 
    'Nextera POS Store',
    'USD',
    0.0875,
    'touch',
    'light'
WHERE NOT EXISTS (SELECT 1 FROM app_settings)
LIMIT 1;

-- ================================================================
-- VERIFICATION QUERIES
-- ================================================================

-- Check user role
SELECT 
    name,
    username, 
    email,
    role,
    permissions,
    active
FROM users;

-- Check products count by category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(stock) as total_stock
FROM products
WHERE active = true
GROUP BY category
ORDER BY category;

-- Check if ready to use
SELECT 
    (SELECT COUNT(*) FROM users WHERE role = 'admin') as admin_users,
    (SELECT COUNT(*) FROM products WHERE active = true) as active_products,
    (SELECT COUNT(*) FROM categories) as categories,
    (SELECT COUNT(*) FROM app_settings) as settings_configured;
