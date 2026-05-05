-- 26. CTE: Calculate daily profit/loss for each trade
with tradepl as (
    select trade_id, (trade_price * quantity) as gross, net_amount 
    from trades
)
select trade_id, (net_amount - gross) as total_charges from tradepl;


-- 27. Subquery: Find stocks that have never been traded
select ticker from stocks where stock_id not in (select distinct stock_id from trades);



-- 28. Join: List trades with client and broker names
select t.trade_number, c.first_name as client, b.first_name as broker 
from trades t
join clients c on t.client_id = c.client_id
join brokers b on t.broker_id = b.broker_id;


-- 29. CTE: Find the top performing portfolio for each client
with rankedportfolios as (
    select client_id, portfolio_name, total_return_pct,
           rank() over(partition by client_id order by total_return_pct desc) as rank
    from portfolios
)
select * from rankedportfolios where rank = 1;


-- 30. Subquery: Find clients who have a higher balance than the average balance
select first_name, email from clients c join accounts a on c.client_id = a.client_id
where a.balance > (select avg(balance) from accounts);

-- 31. Identify the most traded stock ticker using a Join
select s.ticker, count(t.trade_id) as trade_count
from stocks s join trades t on s.stock_id = t.stock_id
group by s.ticker order by trade_count desc limit 1;


-- 32. Find brokers who have 'Suspended' clients
select distinct b.first_name, b.last_name 
from brokers b join clients c on b.broker_id = c.broker_id
where c.kyc_status = 'rejected';


-- 33. CTE: Calculate the weight of each stock in a specific portfolio
with porttotal as (
    select portfolio_id, sum(current_amount) as total_val from portfolio_holdings group by portfolio_id
)
select ph.portfolio_id, ph.stock_id, (ph.current_amount / pt.total_val)*100 as calculated_weight
from portfolio_holdings ph join porttotal pt on ph.portfolio_id = pt.portfolio_id;

-- 34. List all 'BUY' orders for Large Cap stocks
select o.* from orders o join stocks s on o.stock_id = s.stock_id 
where s.stock_type = 'large cap' and o.trade_type = 'buy';

-- 35. Find clients who share the same city as their broker
select c.first_name as client, b.first_name as broker
from clients c join brokers b on c.broker_id = b.broker_id
where c.city = b.city;


-- 36. Market Cap Analysis: Mid Cap stocks > Large Cap average
select ticker, company_name, market_cap_cr
from stocks
where stock_type = 'mid cap' 
  and market_cap_cr > (select avg(market_cap_cr) from stocks where stock_type = 'large cap');


-- 37. Compliance: Pending KYC with high balance
select c.client_code, c.first_name, c.last_name, a.balance
from clients c
join accounts a on c.client_id = a.client_id
where c.kyc_status = 'pending' and a.balance > 100000;


-- 38. Broker Revenue Share: 10% incentive
select b.broker_code, b.first_name, b.last_name, 
       sum(t.brokerage) as total_brokerage,
       sum(t.brokerage) * 0.10 as broker_incentive
from brokers b
join trades t on b.broker_id = t.broker_id
group by b.broker_
id, b.broker_code, b.first_name, b.last_name;


-- 39. Risk Management: Over-concentration (>10%)
with portfolioweights as (
    select portfolio_id, stock_id, weight_pct
    from portfolio_holdings
    where weight_pct > 10.00
)
select c.first_name, p.portfolio_name, s.ticker, pw.weight_pct
from portfolioweights pw
join portfolios p on pw.portfolio_id = p.portfolio_id
join clients c on p.client_id = c.client_id
join stocks s on pw.stock_id = s.stock_id;

-- 40. Dormant Accounts: No orders since 2025
select first_name, last_name, email
from clients
where client_id not in (
    select distinct client_id from orders where order_date >= '2025-01-01'
);


-- 41. Sector Exposure: Total invested value
select s.sector, sum(ph.invested_amount) as total_sector_investment
from portfolio_holdings ph
join stocks s on ph.stock_id = s.stock_id
group by s.sector
order by total_sector_investment desc;


-- 42. High-Frequency Traders: >3 Sells in same stock
select client_id, stock_id, count(*) as trade_count
from trades
where trade_type = 'sell' and trade_date >= '2024-01-01'
group by client_id, stock_id
having count(*) > 3;


-- 43. Branch Performance: Total turnover
select b.branch, sum(t.trade_value) as branch_turnover
from brokers b
join trades t on b.broker_id = t.broker_id
group by b.branch;


-- 44. Top Gainer Search: >5% price increase
select s.ticker, m.close_price, m.previous_close, m.change_pct
from market_data m
join stocks s on m.stock_id = s.stock_id
where m.change_pct > 5.00;


-- 45. Margin Alert: Low balance vs Available Margin
select account_number, balance, available_margin
from accounts
where balance < (available_margin * 0.10) and status = 'active';