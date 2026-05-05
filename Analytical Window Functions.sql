-- 46. rank brokers by experience within branch
select first_name, branch, experience_years,
       dense_rank() over(partition by branch order by experience_years desc) as exp_rank
from brokers;

-- 47. running total of transaction amounts
select account_id, transaction_date, amount,
       sum(amount) over(partition by account_id order by transaction_date) as running_balance
from transactions;

-- 48. price difference from previous day (lag)
select stock_id, trade_date, close_price,
       lag(close_price) over(partition by stock_id order by trade_date) as prev_close
from market_data;

-- 49. top 3 highest value trades per day
select * from (
    select trade_id, trade_date, trade_value,
           row_number() over(partition by trade_date order by trade_value desc) as rnk
    from trades
) t where rnk <= 3;

-- 50. percentile ranking of stocks by market cap
select ticker, percent_rank() over(order by market_cap_cr) as mcap_percentile from stocks;