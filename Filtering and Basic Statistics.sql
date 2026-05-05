-- 1. Find all active brokers with more than 10 years of experience
select * from brokers where status ='Active' and experience_years>10;

--2. List clients from Mumbai or Delhi with an 'Aggressive' risk profile
select * from clients where city in ('Mumbai','Delhi') and risk_profile='Aggressive';

-- 3. Identify stocks in the 'Technology' sector listed on both NSE & BSE
select ticker,company_name from stocks where sector ='Technology' and exchange= 'NSE & BSE';

-- 4. Find orders that have no remarks (NULL check)
select * from orders where remarks is null;

-- 5. List clients whose last name starts with 'S'
select * from clients where last_name like 'S%';

-- 6. Find trades with a net amount exceeding 5,00,000 INR
select * from trades where	 net_amount > 500000;

-- 7. Get all 'HNI' (High Net Worth) clients registered in 2021
select * from clients where client_type = 'HNI' AND registration_date >= '2021-01-01';

-- 8. Find brokers based in Maharashtra or Gujarat
select first_name, last_name, state from  brokers where state in ('Maharashtra', 'Gujarat');

-- 9. List the top 5 stocks by Market Cap
select ticker, market_cap_cr from stocks order by market_cap_cr DESC LIMIT 5;

-- 10. Find accounts that are currently 'Frozen'
select * from accounts where status = 'Frozen';