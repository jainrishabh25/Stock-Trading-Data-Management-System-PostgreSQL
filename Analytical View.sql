-- Client Portfolio Summary View
CREATE OR REPLACE VIEW view_client_wealth_summary AS
SELECT 
    c.client_code,
    c.first_name || ' ' || c.last_name AS client_name,
    c.risk_profile,
    a.account_number,
    a.balance AS cash_balance,
    p.portfolio_name,
    p.invested_value,
    p.current_value,
    p.total_return_pct
FROM clients c
JOIN accounts a ON c.client_id = a.client_id
JOIN portfolios p ON c.client_id = p.client_id
WHERE a.status = 'Active';

select * from view_client_wealth_summary

-- 2. Daily Market Performance View
CREATE OR REPLACE VIEW view_market_performance AS
SELECT 
    s.ticker,
    s.company_name,
    s.sector,
    m.close_price,
    m.change_pct,
    m.fifty_two_wk_high,
    m.fifty_two_wk_low,
    CASE 
        WHEN m.close_price >= m.fifty_two_wk_high * 0.95 THEN 'Near High'
        WHEN m.close_price <= m.fifty_two_wk_low * 1.05 THEN 'Near Low'
        ELSE 'Neutral'
    END as price_zone
FROM stocks s
JOIN market_data m ON s.stock_id = m.stock_id
WHERE m.trade_date = (SELECT MAX(trade_date) FROM market_data);

select * from view_market_performance;

-- 3. Broker Revenue Leaderboard
CREATE OR REPLACE VIEW view_broker_performance AS
SELECT 
    b.broker_code,
    b.first_name || ' ' || b.last_name AS broker_name,
    b.branch,
    COUNT(t.trade_id) AS total_trades_executed,
    SUM(t.trade_value) AS total_volume,
    SUM(t.brokerage) AS revenue_generated,
    AVG(b.rating) AS current_rating
FROM brokers b
LEFT JOIN trades t ON b.broker_id = t.broker_id
GROUP BY b.broker_id, b.broker_code, b.first_name, b.last_name, b.branch;
select * from view_broker_performance;