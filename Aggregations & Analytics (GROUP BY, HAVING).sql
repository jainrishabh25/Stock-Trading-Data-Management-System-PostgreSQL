-- 11. Count number of clients per city
select city, count(*) as client_count from clients group by city;

-- 12. Find sectors with more than 5 stocks listed
select sector, count(*) from stocks group by sector having count(*) > 5;

-- 13. Calculate total brokerage earned per broker
select broker_id, sum(brokerage) as total_revenue from trades group by broker_id;


-- 14. Average rating of brokers per branch
select branch, round(avg(rating), 2) from brokers group by branch;

-- 15. Total turnover (Cr) per sector from market data
select s.sector, sum(m.turnover_cr) 
from stocks s join market_data m on s.stock_id = m.stock_id 
group by s.sector;

-- 16. Count orders by status (Executed, Pending, etc.)
select status, count(*) from orders group by status;

-- 17. Find brokers managing more than 10 clients
select broker_id, count(*) from clients group by broker_id having count(*) >10;

-- 18. Maximum and Minimum price reached by each stock
select stock_id, max(high_price), min(low_price) from market_data group by stock_id;

-- 19. Identify branches where average broker experience is < 10 years
select branch from brokers group by branch having avg(experience_years) <10 ;


-- 20. Total invested value per portfolio type
select portfolio_type, sum(invested_value) from portfolios group by portfolio_type;

-- 21. Total GST collected per month
select date_trunc('month', trade_date) as month, sum(gst) from trades group by month
order by month;

-- 22. Count clients by gender and risk profile
select gender, risk_profile, count(*) from clients group by gender, risk_profile;

-- 23. Average P/E ratio per industry
select s.industry, avg(m.pe_ratio) 
from market_data m join stocks s on m.stock_id = s.stock_id 
group by s.industry;

-- 24. Find clients who have made more than 5 trades
select client_id, count(*) from trades group by client_id having count(*) > 5;

-- 25. Sum of available margin across all 'Active' trading accounts
select sum(available_margin) from accounts where account_type = 'trading' and status = 'active';


