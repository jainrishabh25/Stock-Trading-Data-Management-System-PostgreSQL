-- Speed up joining Clients to Brokers
create index idx_clients_broker_id on clients(broker_id);


-- Speed up joining Orders/Trades to Clients and Stocks
create index idx_orders_client_id on orders(client_id);
create index idx_orders_stock_id on orders(stock_id);
create index dx_trades_order_id  on trades(order_id);


-- Speed up Portfolio lookups
create index idx_holdings_portfolio_id on portfolio_holdings(portfolio_id);


-- Speed up fetching Market Data for a specific stock on a specific date
create index idx_market_data_stock_date on market_data(stock_id, trade_date);

-- Speed up searching for transactions by account and type (e.g., all 'Dividends' for Account 5)
create index idx_txn_acc_type on transactions(account_id, transaction_type);


-- Index ONLY the Active brokers (ignores Inactive/Suspended)
create index idx_active_brokers on brokers(broker_id) 
where status = 'Active';

-- Index ONLY the Pending orders for the Order Matching Engine
create index idx_pending_orders on orders(order_id) 
where status = 'Pending';


-- 71. Check index usage statistics
select relname as table_name, 
       indexrelname as index_name, 
       idx_scan as times_used
	   from pg_stat_user_indexes
order by idx_scan asc ;

-- 72. Find the size of each table and its indexes
select relname as table_name,
       pg_size_pretty(pg_total_relation_size(relid)) as total_size,
       pg_size_pretty(pg_relation_size(relid)) as table_size,
       pg_size_pretty(pg_indexes_size(relid)) as index_size
from pg_stat_user_tables
order by pg_total_relation_size(relid) desc;