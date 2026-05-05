
-- ============================================================
-- TABLE 1: brokers
-- ============================================================
CREATE TABLE brokers (
    broker_id       SERIAL PRIMARY KEY,
    broker_code     VARCHAR(10)  NOT NULL UNIQUE,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(20)  NOT NULL,
    branch          VARCHAR(50)  NOT NULL,
    city            VARCHAR(50)  NOT NULL,
    state           VARCHAR(50)  NOT NULL,
    license_number  VARCHAR(20)  NOT NULL UNIQUE,
    experience_years INT         NOT NULL,
    rating          NUMERIC(3,1) NOT NULL,
    status          VARCHAR(10)  NOT NULL CHECK (status IN ('Active','Inactive','Suspended')),
    joined_date     DATE         NOT NULL
);

INSERT INTO brokers (broker_code, first_name, last_name, email, phone, branch, city, state, license_number, experience_years, rating, status, joined_date)
SELECT
    'BRK' || LPAD(n::TEXT, 4, '0'),
    (ARRAY['Amit','Ravi','Sanjay','Priya','Neha','Vijay','Suresh','Kavitha','Deepak','Anita',
            'Rahul','Pooja','Kiran','Manoj','Sunita','Arun','Divya','Ramesh','Geeta','Harish'])[((n-1)%20)+1],
    (ARRAY['Sharma','Gupta','Verma','Singh','Mehta','Patel','Kumar','Reddy','Joshi','Nair',
            'Pillai','Iyer','Rao','Bose','Das','Chowdhury','Menon','Agarwal','Tiwari','Saxena'])[((n-1)%20)+1],
    'broker' || n || '@stockfirm.com',
    '9' || LPAD(((7000000 + n * 137) % 9000000 + 1000000)::TEXT, 9, '0'),
    (ARRAY['North','South','East','West','Central','HQ','Online','Premium'])[((n-1)%8)+1],
    (ARRAY['Mumbai','Delhi','Bengaluru','Chennai','Hyderabad','Pune','Kolkata','Ahmedabad'])[((n-1)%8)+1],
    (ARRAY['Maharashtra','Delhi','Karnataka','Tamil Nadu','Telangana','Maharashtra','West Bengal','Gujarat'])[((n-1)%8)+1],
    'LIC' || LPAD(n::TEXT, 6, '0'),
    (n % 20) + 1,
    ROUND((3.0 + (n % 20) * 0.1)::NUMERIC, 1),
    CASE WHEN n % 10 = 0 THEN 'Inactive' WHEN n % 25 = 0 THEN 'Suspended' ELSE 'Active' END,
    DATE '2005-01-01' + (n * 15 % 5000) * INTERVAL '1 day'
FROM generate_series(1, 50) n;

-- ============================================================
-- TABLE 2: clients
-- ============================================================
CREATE TABLE clients (
    client_id       SERIAL PRIMARY KEY,
    client_code     VARCHAR(10)  NOT NULL UNIQUE,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(20)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    gender          VARCHAR(10)  NOT NULL CHECK (gender IN ('Male','Female','Other')),
    pan_number      VARCHAR(10)  NOT NULL UNIQUE,
    aadhar_number   VARCHAR(12)  NOT NULL UNIQUE,
    city            VARCHAR(50)  NOT NULL,
    state           VARCHAR(50)  NOT NULL,
    pincode         VARCHAR(6)   NOT NULL,
    risk_profile    VARCHAR(20)  NOT NULL CHECK (risk_profile IN ('Conservative','Moderate','Aggressive')),
    client_type     VARCHAR(20)  NOT NULL CHECK (client_type IN ('Retail','HNI','Institutional')),
    broker_id       INT          NOT NULL REFERENCES brokers(broker_id),
    kyc_status      VARCHAR(10)  NOT NULL CHECK (kyc_status IN ('Verified','Pending','Rejected')),
    registration_date DATE       NOT NULL
);

INSERT INTO clients (client_code, first_name, last_name, email, phone, date_of_birth, gender, pan_number, aadhar_number, city, state, pincode, risk_profile, client_type, broker_id, kyc_status, registration_date)
SELECT
    'CLT' || LPAD(n::TEXT, 5, '0'),
    (ARRAY['Aarav','Vivaan','Aditya','Vihaan','Arjun','Sai','Reyansh','Ayaan','Krishna','Ishaan',
            'Ananya','Aadhya','Pari','Saanvi','Myra','Priya','Riya','Aisha','Sneha','Pooja',
            'Rohan','Vikram','Nikhil','Harsh','Tushar','Siddharth','Gaurav','Ankur','Rajesh','Sunil',
            'Meena','Rekha','Sunita','Lakshmi','Kavya','Usha','Nandini','Rupal','Shweta','Jyoti'])[((n-1)%40)+1],
    (ARRAY['Sharma','Gupta','Verma','Singh','Mehta','Patel','Kumar','Reddy','Joshi','Nair',
            'Pillai','Iyer','Rao','Bose','Das','Chowdhury','Menon','Agarwal','Tiwari','Saxena',
            'Kapoor','Khanna','Malhotra','Ahuja','Sethi','Chopra','Bhatia','Dhawan','Soni','Jain'])[((n-1)%30)+1],
    'client' || n || '@email.com',
    '9' || LPAD(((8000000 + n * 173) % 9000000 + 1000000)::TEXT, 9, '0'),
    DATE '1960-01-01' + (n * 47 % 14600) * INTERVAL '1 day',
    CASE WHEN n % 3 = 0 THEN 'Female' WHEN n % 11 = 0 THEN 'Other' ELSE 'Male' END,
    CHR(65 + (n % 26)) || CHR(65 + ((n*3) % 26)) || CHR(65 + ((n*7) % 26)) || CHR(65 + ((n*11) % 26)) || CHR(65 + ((n*13) % 26)) || LPAD((n * 97 % 9000 + 1000)::TEXT, 4, '0') || CHR(65 + ((n*17) % 26)),
    LPAD((n * 1000003 % 999999999999 + 100000000000)::TEXT, 12, '0'),
    (ARRAY['Mumbai','Delhi','Bengaluru','Chennai','Hyderabad','Pune','Kolkata','Ahmedabad','Jaipur','Lucknow',
            'Surat','Kanpur','Nagpur','Indore','Thane','Bhopal','Visakhapatnam','Patna','Vadodara','Ghaziabad'])[((n-1)%20)+1],
    (ARRAY['Maharashtra','Delhi','Karnataka','Tamil Nadu','Telangana','Maharashtra','West Bengal','Gujarat','Rajasthan','Uttar Pradesh',
            'Gujarat','Uttar Pradesh','Maharashtra','Madhya Pradesh','Maharashtra','Madhya Pradesh','Andhra Pradesh','Bihar','Gujarat','Uttar Pradesh'])[((n-1)%20)+1],
    LPAD((400000 + n * 7 % 99999)::TEXT, 6, '0'),
    (ARRAY['Conservative','Moderate','Aggressive'])[((n-1)%3)+1],
    CASE WHEN n % 15 = 0 THEN 'Institutional' WHEN n % 5 = 0 THEN 'HNI' ELSE 'Retail' END,
    (n % 50) + 1,
    CASE WHEN n % 10 = 0 THEN 'Pending' WHEN n % 30 = 0 THEN 'Rejected' ELSE 'Verified' END,
    DATE '2015-01-01' + (n * 13 % 3000) * INTERVAL '1 day'
FROM generate_series(1, 500) n;

-- ============================================================
-- TABLE 3: stocks
-- ============================================================
CREATE TABLE stocks (
    stock_id        SERIAL PRIMARY KEY,
    ticker          VARCHAR(10)  NOT NULL UNIQUE,
    company_name    VARCHAR(100) NOT NULL,
    sector          VARCHAR(50)  NOT NULL,
    industry        VARCHAR(50)  NOT NULL,
    exchange        VARCHAR(10)  NOT NULL CHECK (exchange IN ('NSE','BSE','NSE & BSE')),
    face_value      NUMERIC(10,2) NOT NULL,
    market_cap_cr   NUMERIC(15,2) NOT NULL,
    lot_size        INT          NOT NULL,
    isin_code       VARCHAR(12)  NOT NULL UNIQUE,
    stock_type      VARCHAR(20)  NOT NULL CHECK (stock_type IN ('Large Cap','Mid Cap','Small Cap')),
    listing_date    DATE         NOT NULL,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE
);

INSERT INTO stocks (ticker, company_name, sector, industry, exchange, face_value, market_cap_cr, lot_size, isin_code, stock_type, listing_date, is_active)
VALUES
('RELIANCE','Reliance Industries Ltd','Energy','Oil & Gas','NSE & BSE',10,1850000.00,1,'INE002A01018','Large Cap','1977-06-01',TRUE),
('TCS','Tata Consultancy Services','Technology','IT Services','NSE & BSE',1,1420000.00,1,'INE467B01029','Large Cap','2004-08-25',TRUE),
('HDFCBANK','HDFC Bank Ltd','Financials','Banking','NSE & BSE',1,1250000.00,1,'INE040A01034','Large Cap','1995-05-19',TRUE),
('INFY','Infosys Ltd','Technology','IT Services','NSE & BSE',5,780000.00,1,'INE009A01021','Large Cap','1993-02-03',TRUE),
('HINDUNILVR','Hindustan Unilever Ltd','Consumer Staples','FMCG','NSE & BSE',1,680000.00,1,'INE030A01027','Large Cap','1995-11-03',TRUE),
('ICICIBANK','ICICI Bank Ltd','Financials','Banking','NSE & BSE',2,750000.00,1,'INE090A01021','Large Cap','1997-09-17',TRUE),
('KOTAKBANK','Kotak Mahindra Bank','Financials','Banking','NSE & BSE',5,380000.00,1,'INE237A01028','Large Cap','1995-12-20',TRUE),
('BAJFINANCE','Bajaj Finance Ltd','Financials','NBFC','NSE & BSE',2,490000.00,1,'INE296A01024','Large Cap','2003-04-02',TRUE),
('LT','Larsen & Toubro Ltd','Industrials','Engineering','NSE & BSE',2,450000.00,1,'INE018A01030','Large Cap','1994-12-07',TRUE),
('AXISBANK','Axis Bank Ltd','Financials','Banking','NSE & BSE',2,320000.00,1,'INE238A01034','Large Cap','1998-11-16',TRUE),
('ASIANPAINT','Asian Paints Ltd','Materials','Paints','NSE & BSE',1,310000.00,1,'INE021A01026','Large Cap','1994-12-07',TRUE),
('MARUTI','Maruti Suzuki India','Consumer Disc','Automobiles','NSE & BSE',5,270000.00,1,'INE585B01010','Large Cap','2003-07-09',TRUE),
('SUNPHARMA','Sun Pharmaceutical','Healthcare','Pharmaceuticals','NSE & BSE',1,310000.00,1,'INE044A01036','Large Cap','1994-03-28',TRUE),
('TITAN','Titan Company Ltd','Consumer Disc','Jewellery','NSE & BSE',1,280000.00,1,'INE280A01028','Large Cap','1995-09-08',TRUE),
('WIPRO','Wipro Ltd','Technology','IT Services','NSE & BSE',2,280000.00,1,'INE075A01022','Large Cap','1995-11-24',TRUE),
('ULTRACEMCO','UltraTech Cement Ltd','Materials','Cement','NSE & BSE',10,240000.00,1,'INE481G01011','Large Cap','2004-07-12',TRUE),
('NESTLEIND','Nestle India Ltd','Consumer Staples','FMCG','NSE & BSE',1,210000.00,1,'INE239A01016','Large Cap','1990-12-17',TRUE),
('BAJAJFINSV','Bajaj Finserv Ltd','Financials','Financial Services','NSE & BSE',1,260000.00,1,'INE918I01026','Large Cap','2008-06-02',TRUE),
('TECHM','Tech Mahindra Ltd','Technology','IT Services','NSE & BSE',5,150000.00,1,'INE669C01036','Large Cap','2006-08-28',TRUE),
('HCLTECH','HCL Technologies Ltd','Technology','IT Services','NSE & BSE',2,320000.00,1,'INE860A01027','Large Cap','1999-11-12',TRUE),
('POWERGRID','Power Grid Corp','Utilities','Power Transmission','NSE & BSE',10,250000.00,1,'INE752E01010','Large Cap','2007-10-05',TRUE),
('NTPC','NTPC Ltd','Utilities','Power Generation','NSE & BSE',10,280000.00,1,'INE733E01010','Large Cap','2004-11-05',TRUE),
('ONGC','Oil & Natural Gas Corp','Energy','Oil & Gas','NSE & BSE',5,280000.00,1,'INE213A01029','Large Cap','1995-08-23',TRUE),
('COALINDIA','Coal India Ltd','Energy','Mining','NSE & BSE',10,200000.00,1,'INE522F01014','Large Cap','2010-11-04',TRUE),
('TATAMOTORS','Tata Motors Ltd','Consumer Disc','Automobiles','NSE & BSE',2,190000.00,1,'INE155A01022','Large Cap','1998-09-11',TRUE),
('JSWSTEEL','JSW Steel Ltd','Materials','Steel','NSE & BSE',1,210000.00,1,'INE019A01038','Large Cap','2002-11-04',TRUE),
('TATASTEEL','Tata Steel Ltd','Materials','Steel','NSE & BSE',1,165000.00,1,'INE081A01020','Large Cap','1998-09-11',TRUE),
('HINDALCO','Hindalco Industries','Materials','Aluminium','NSE & BSE',1,160000.00,1,'INE038A01020','Large Cap','1997-01-29',TRUE),
('SBIN','State Bank of India','Financials','Banking','NSE & BSE',1,630000.00,1,'INE062A01020','Large Cap','1993-03-01',TRUE),
('BAJAJ-AUTO','Bajaj Auto Ltd','Consumer Disc','Automobiles','NSE & BSE',10,220000.00,1,'INE917I01010','Large Cap','2008-05-26',TRUE),
-- Mid Cap
('MUTHOOTFIN','Muthoot Finance Ltd','Financials','NBFC','NSE & BSE',10,62000.00,1,'INE414G01012','Mid Cap','2011-05-06',TRUE),
('PIDILITIND','Pidilite Industries','Materials','Adhesives','NSE & BSE',1,140000.00,1,'INE318A01026','Mid Cap','1996-05-23',TRUE),
('VOLTAS','Voltas Ltd','Industrials','Cooling Products','NSE & BSE',1,38000.00,1,'INE226A01021','Mid Cap','1995-01-06',TRUE),
('GODREJCP','Godrej Consumer Products','Consumer Staples','FMCG','NSE & BSE',1,95000.00,1,'INE102D01028','Mid Cap','2001-04-27',TRUE),
('DABUR','Dabur India Ltd','Consumer Staples','FMCG','NSE & BSE',1,95000.00,1,'INE016A01026','Mid Cap','1996-04-02',TRUE),
('MARICO','Marico Ltd','Consumer Staples','FMCG','NSE & BSE',1,72000.00,1,'INE196A01026','Mid Cap','1996-05-01',TRUE),
('MPHASIS','Mphasis Ltd','Technology','IT Services','NSE & BSE',10,46000.00,1,'INE356A01018','Mid Cap','2004-06-04',TRUE),
('COFORGE','Coforge Ltd','Technology','IT Services','NSE & BSE',10,38000.00,1,'INE591G01017','Mid Cap','2004-07-21',TRUE),
('PERSISTENT','Persistent Systems','Technology','IT Services','NSE & BSE',10,55000.00,1,'INE262H01013','Mid Cap','2010-03-30',TRUE),
('LTTS','L&T Technology Services','Technology','Engineering R&D','NSE & BSE',2,42000.00,1,'INE010V01017','Mid Cap','2016-09-13',TRUE),
('ABCAPITAL','Aditya Birla Capital','Financials','Financial Services','NSE & BSE',2,35000.00,1,'INE674K01013','Mid Cap','2017-09-01',TRUE),
('AAVAS','AAVAS Financiers','Financials','Housing Finance','NSE & BSE',10,14000.00,1,'INE216P01012','Mid Cap','2018-10-08',TRUE),
('CHOLAFIN','Cholamandalam Finance','Financials','NBFC','NSE & BSE',2,92000.00,1,'INE121A01024','Mid Cap','1998-12-28',TRUE),
('SUNDARMFIN','Sundaram Finance','Financials','NBFC','NSE','10',32000.00,1,'INE660A01013','Mid Cap','1995-02-13',TRUE),
('LICHSGFIN','LIC Housing Finance','Financials','Housing Finance','NSE & BSE',2,28000.00,1,'INE115A01026','Mid Cap','1994-12-07',TRUE),
('ESCORTS','Escorts Kubota Ltd','Industrials','Farm Equipment','NSE & BSE',10,26000.00,1,'INE048A01002','Mid Cap','1995-12-06',TRUE),
('TVSMOTOR','TVS Motor Company','Consumer Disc','Automobiles','NSE & BSE',1,85000.00,1,'INE494B01023','Mid Cap','2000-08-31',TRUE),
('BALKRISIND','Balkrishna Industries','Consumer Disc','Tyres','NSE & BSE',2,52000.00,1,'INE787D01026','Mid Cap','2002-10-18',TRUE),
('CEATLTD','CEAT Ltd','Consumer Disc','Tyres','NSE & BSE',10,8500.00,1,'INE482M01015','Mid Cap','1993-07-19',TRUE),
('MRF','MRF Ltd','Consumer Disc','Tyres','NSE & BSE',10,46000.00,1,'INE883A01011','Mid Cap','1996-09-04',TRUE),
-- Small Cap
('RBLBANK','RBL Bank Ltd','Financials','Banking','NSE & BSE',10,9500.00,1,'INE976G01028','Small Cap','2016-08-24',TRUE),
('DCBBANK','DCB Bank Ltd','Financials','Banking','NSE & BSE',10,4800.00,1,'INE503A01015','Small Cap','2006-07-20',TRUE),
('UJJIVANSFB','Ujjivan Small Finance Bank','Financials','Banking','NSE & BSE',10,5200.00,1,'INE334L01012','Small Cap','2019-12-12',TRUE),
('SURYAROSNI','Surya Roshni Ltd','Industrials','Lighting','NSE & BSE',10,2800.00,1,'INE335G01011','Small Cap','1994-12-07',TRUE),
('ORIENTELEC','Orient Electric Ltd','Consumer Disc','Electronics','NSE & BSE',1,4200.00,1,'INE142Z01015','Small Cap','2018-05-03',TRUE),
('VAIBHAVGBL','Vaibhav Global Ltd','Consumer Disc','Retail','NSE & BSE',1,6300.00,1,'INE884I01012','Small Cap','2009-01-15',TRUE),
('GALAXYSURF','Galaxy Surfactants','Materials','Chemicals','NSE & BSE',10,9200.00,1,'INE474L01012','Small Cap','2018-02-08',TRUE),
('FINEORG','Fine Organic Industries','Materials','Chemicals','NSE & BSE',5,7800.00,1,'INE686Y01026','Small Cap','2018-06-22',TRUE),
('AARTIIND','Aarti Industries Ltd','Materials','Chemicals','NSE & BSE',5,18000.00,1,'INE769A01020','Small Cap','1995-09-15',TRUE),
('TATACHEM','Tata Chemicals Ltd','Materials','Chemicals','NSE & BSE',10,28000.00,1,'INE092A01019','Small Cap','1995-07-10',TRUE);

-- Pad stocks to 100 rows (used in trades/portfolio; no need for exactly 500 in master table)
INSERT INTO stocks (ticker, company_name, sector, industry, exchange, face_value, market_cap_cr, lot_size, isin_code, stock_type, listing_date, is_active)
SELECT
    'STK' || LPAD(n::TEXT, 4, '0'),
    'Company ' || n || ' Ltd',
    (ARRAY['Technology','Financials','Energy','Healthcare','Consumer Staples','Consumer Disc','Materials','Industrials','Utilities','Real Estate'])[((n-1)%10)+1],
    (ARRAY['IT Services','Banking','Oil & Gas','Pharmaceuticals','FMCG','Automobiles','Chemicals','Engineering','Power','Construction'])[((n-1)%10)+1],
    (ARRAY['NSE','BSE','NSE & BSE'])[((n-1)%3)+1],
    (ARRAY[1,2,5,10])[((n-1)%4)+1],
    ROUND((500 + n * 123.7)::NUMERIC, 2),
    (ARRAY[1,5,10,50,100])[((n-1)%5)+1],
    'INE' || LPAD(n::TEXT, 6, '0') || 'A01',
    (ARRAY['Large Cap','Mid Cap','Small Cap'])[((n-1)%3)+1],
    DATE '2000-01-01' + (n * 45 % 7000) * INTERVAL '1 day',
    CASE WHEN n % 12 = 0 THEN FALSE ELSE TRUE END
FROM generate_series(61, 500) n;

-- ============================================================
-- TABLE 4: accounts
-- ============================================================
CREATE TABLE accounts (
    account_id      SERIAL PRIMARY KEY,
    account_number  VARCHAR(15)  NOT NULL UNIQUE,
    client_id       INT          NOT NULL REFERENCES clients(client_id),
    account_type    VARCHAR(20)  NOT NULL CHECK (account_type IN ('Demat','Trading','Savings','Margin')),
    bank_name       VARCHAR(50)  NOT NULL,
    ifsc_code       VARCHAR(11)  NOT NULL,
    balance         NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    available_margin NUMERIC(15,2) NOT NULL DEFAULT 0.00,
    currency        VARCHAR(5)   NOT NULL DEFAULT 'INR',
    opened_date     DATE         NOT NULL,
    status          VARCHAR(10)  NOT NULL CHECK (status IN ('Active','Inactive','Frozen'))
);
ALTER TABLE accounts ALTER COLUMN ifsc_code TYPE VARCHAR(20);
INSERT INTO accounts (account_number, client_id, account_type, bank_name, ifsc_code, balance, available_margin, currency, opened_date, status)
SELECT
    'ACC' || LPAD(n::TEXT, 10, '0'),
    n,
    CASE WHEN n % 4 = 1 THEN 'Demat' WHEN n % 4 = 2 THEN 'Trading' WHEN n % 4 = 3 THEN 'Savings' ELSE 'Margin' END,
    (ARRAY['HDFC Bank','ICICI Bank','State Bank of India','Axis Bank','Kotak Mahindra Bank',
            'Punjab National Bank','Bank of Baroda','Canara Bank','Union Bank','IndusInd Bank'])[((n-1)%10)+1],
    (ARRAY['HDFC0001','ICIC0002','SBIN0003','UTIB0004','KKBK0005','PUNB0006','BARB0007','CNRB0008','UBIN0009','INDB0010'])[((n-1)%10)+1] || LPAD(n::TEXT, 6, '0'),
    ROUND((10000 + (n * 3731.17) % 990000)::NUMERIC, 2),
    ROUND((5000  + (n * 1531.11) % 495000)::NUMERIC, 2),
    'INR',
    DATE '2015-01-01' + (n * 13 % 3000) * INTERVAL '1 day',
    CASE WHEN n % 20 = 0 THEN 'Inactive' WHEN n % 50 = 0 THEN 'Frozen' ELSE 'Active' END
FROM generate_series(1, 500) n;

-- ============================================================
-- TABLE 5: market_data  (daily price snapshots)
-- ============================================================
CREATE TABLE market_data (
    market_data_id  SERIAL PRIMARY KEY,
    stock_id        INT          NOT NULL REFERENCES stocks(stock_id),
    trade_date      DATE         NOT NULL,
    open_price      NUMERIC(10,2) NOT NULL,
    high_price      NUMERIC(10,2) NOT NULL,
    low_price       NUMERIC(10,2) NOT NULL,
    close_price     NUMERIC(10,2) NOT NULL,
    previous_close  NUMERIC(10,2) NOT NULL,
    volume          BIGINT       NOT NULL,
    turnover_cr     NUMERIC(15,2) NOT NULL,
    change_pct      NUMERIC(6,2) NOT NULL,
    fifty_two_wk_high NUMERIC(10,2) NOT NULL,
    fifty_two_wk_low  NUMERIC(10,2) NOT NULL,
    pe_ratio        NUMERIC(8,2),
    market_cap_cr   NUMERIC(15,2) NOT NULL
);

INSERT INTO market_data (stock_id, trade_date, open_price, high_price, low_price, close_price, previous_close, volume, turnover_cr, change_pct, fifty_two_wk_high, fifty_two_wk_low, pe_ratio, market_cap_cr)
SELECT
    ((n-1) % 500) + 1 AS stock_id,
    DATE '2024-01-01' + ((n-1) / 500) * INTERVAL '1 day' AS trade_date,
    ROUND((100 + (n * 17.37) % 4900)::NUMERIC, 2) AS open_price,
    ROUND((100 + (n * 17.37) % 4900 + (n * 3.13) % 200)::NUMERIC, 2) AS high_price,
    ROUND((100 + (n * 17.37) % 4900 - (n * 2.71) % 150)::NUMERIC, 2) AS low_price,
    ROUND((100 + (n * 17.37) % 4900 + (n * 1.11) % 100 - 50)::NUMERIC, 2) AS close_price,
    ROUND((100 + (n * 17.37) % 4900)::NUMERIC, 2) AS previous_close,
    (100000 + (n * 77777) % 9900000)::BIGINT AS volume,
    ROUND(((100 + (n * 17.37) % 4900) * (100000 + (n * 77777) % 9900000) / 10000000)::NUMERIC, 2) AS turnover_cr,
    ROUND(((n * 1.1) % 10 - 5)::NUMERIC, 2) AS change_pct,
    ROUND((100 + (n * 17.37) % 4900 + (n * 5.23) % 500)::NUMERIC, 2) AS fifty_two_wk_high,
    ROUND((100 + (n * 17.37) % 4900 - (n * 4.17) % 400)::NUMERIC, 2) AS fifty_two_wk_low,
    CASE WHEN n % 7 = 0 THEN NULL ELSE ROUND((10 + (n * 2.31) % 80)::NUMERIC, 2) END AS pe_ratio,
    ROUND((5000 + (n * 123.7) % 1800000)::NUMERIC, 2) AS market_cap_cr
FROM generate_series(1, 500) n;

-- ============================================================
-- TABLE 6: orders
-- ============================================================
CREATE TABLE orders (
    order_id        SERIAL PRIMARY KEY,
    order_number    VARCHAR(15)  NOT NULL UNIQUE,
    client_id       INT          NOT NULL REFERENCES clients(client_id),
    broker_id       INT          NOT NULL REFERENCES brokers(broker_id),
    stock_id        INT          NOT NULL REFERENCES stocks(stock_id),
    account_id      INT          NOT NULL REFERENCES accounts(account_id),
    order_type      VARCHAR(10)  NOT NULL CHECK (order_type IN ('Market','Limit','Stop Loss','SL-M')),
    trade_type      VARCHAR(5)   NOT NULL CHECK (trade_type IN ('BUY','SELL')),
    quantity        INT          NOT NULL,
    price           NUMERIC(10,2) NOT NULL,
    trigger_price   NUMERIC(10,2),
    order_value     NUMERIC(15,2) NOT NULL,
    status          VARCHAR(15)  NOT NULL CHECK (status IN ('Pending','Executed','Cancelled','Rejected','Partial')),
    product_type    VARCHAR(10)  NOT NULL CHECK (product_type IN ('CNC','MIS','NRML')),
    exchange        VARCHAR(10)  NOT NULL CHECK (exchange IN ('NSE','BSE')),
    order_date      DATE         NOT NULL,
    order_time      TIME         NOT NULL,
    remarks         VARCHAR(200)
);

INSERT INTO orders (order_number, client_id, broker_id, stock_id, account_id, order_type, trade_type, quantity, price, trigger_price, order_value, status, product_type, exchange, order_date, order_time, remarks)
SELECT
    'ORD' || LPAD(n::TEXT, 10, '0'),
    a.client_id, -- Take from existing account
    (n % 50) + 1,
    (n % 500) + 1,
    a.account_id, -- Take from existing account
    (ARRAY['Market','Limit','Stop Loss','SL-M'])[((n-1)%4)+1],
    CASE WHEN n % 2 = 0 THEN 'BUY' ELSE 'SELL' END,
    (ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1],
    ROUND((100 + (n * 17.37) % 4900)::NUMERIC, 2),
    CASE WHEN n % 3 = 0 THEN ROUND((100 + (n * 17.37) % 4900 - 50)::NUMERIC, 2) ELSE NULL END,
    ROUND(((ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1] * (100 + (n * 17.37) % 4900))::NUMERIC, 2),
    (ARRAY['Pending','Executed','Cancelled','Rejected','Partial'])[((n-1)%5)+1],
    (ARRAY['CNC','MIS','NRML'])[((n-1)%3)+1],
    CASE WHEN n % 2 = 0 THEN 'NSE' ELSE 'BSE' END,
    DATE '2024-01-02' + (n % 250) * INTERVAL '1 day',
    (TIME '09:15:00' + (n * 37 % 375) * INTERVAL '1 minute'),
    CASE WHEN n % 10 = 0 THEN 'Bulk order' WHEN n % 15 = 0 THEN 'Intraday order' ELSE NULL END
FROM generate_series(1, 500) n
JOIN (
    -- This subquery assigns a row number to existing accounts to match them to 'n'
    SELECT account_id, client_id, ROW_NUMBER() OVER (ORDER BY account_id) as row_num 
    FROM accounts
) a ON a.row_num = n;




















-- ============================================================
-- TABLE 7: trades  (executed trades only)
-- ============================================================
CREATE TABLE trades (
    trade_id        SERIAL PRIMARY KEY,
    trade_number    VARCHAR(15)  NOT NULL UNIQUE,
    order_id        INT          NOT NULL REFERENCES orders(order_id),
    client_id       INT          NOT NULL REFERENCES clients(client_id),
    broker_id       INT          NOT NULL REFERENCES brokers(broker_id),
    stock_id        INT          NOT NULL REFERENCES stocks(stock_id),
    trade_type      VARCHAR(5)   NOT NULL CHECK (trade_type IN ('BUY','SELL')),
    quantity        INT          NOT NULL,
    trade_price     NUMERIC(10,2) NOT NULL,
    trade_value     NUMERIC(15,2) NOT NULL,
    brokerage       NUMERIC(10,2) NOT NULL,
    stt             NUMERIC(10,2) NOT NULL,
    exchange_charges NUMERIC(10,2) NOT NULL,
    gst             NUMERIC(10,2) NOT NULL,
    sebi_charges    NUMERIC(10,4) NOT NULL,
    net_amount      NUMERIC(15,2) NOT NULL,
    exchange        VARCHAR(10)  NOT NULL CHECK (exchange IN ('NSE','BSE')),
    settlement_type VARCHAR(5)   NOT NULL CHECK (settlement_type IN ('T+1','T+2')),
    trade_date      DATE         NOT NULL,
    trade_time      TIME         NOT NULL,
    settlement_date DATE         NOT NULL
);

INSERT INTO trades (trade_number, order_id, client_id, broker_id, stock_id, trade_type, quantity, trade_price, trade_value, brokerage, stt, exchange_charges, gst, sebi_charges, net_amount, exchange, settlement_type, trade_date, trade_time, settlement_date)
SELECT
    'TRD' || LPAD(n::TEXT, 10, '0'),
    o.order_id,    -- Real ID from the orders table
    o.client_id,   -- Real ID from the orders table
    o.broker_id,   -- Real ID from the orders table
    o.stock_id,    -- Real ID from the orders table
    o.trade_type,  -- Matching the trade type to the order
    o.quantity,
    o.price,       -- Using the price from the order
    o.order_value, -- Using the calculated value
    -- Brokerage calculation (0.03%)
    ROUND((o.order_value * 0.0003)::NUMERIC, 2),
    -- STT calculation (0.1%)
    ROUND((o.order_value * 0.001)::NUMERIC, 2),
    -- Exchange Charges (0.00325%)
    ROUND((o.order_value * 0.0000325)::NUMERIC, 2),
    -- GST on Brokerage (18%)
    ROUND((o.order_value * 0.0003 * 0.18)::NUMERIC, 2),
    -- SEBI Charges
    ROUND((o.order_value * 0.000001)::NUMERIC, 4),
    -- Net Amount calculation
    ROUND((o.order_value * (CASE WHEN o.trade_type = 'BUY' THEN 1.0013 ELSE 0.9987 END))::NUMERIC, 2),
    o.exchange,
    CASE WHEN n % 3 = 0 THEN 'T+1' ELSE 'T+2' END,
    o.order_date,
    o.order_time,
    o.order_date + (CASE WHEN n % 3 = 0 THEN 1 ELSE 2 END) * INTERVAL '1 day'
FROM generate_series(1, 500) n
JOIN (
    -- This ensures we only trade orders that actually exist
    SELECT *, ROW_NUMBER() OVER (ORDER BY order_id) as row_num 
    FROM orders
) o ON o.row_num = n;

-- ============================================================
-- TABLE 8: portfolios
-- ============================================================
CREATE TABLE portfolios (
    portfolio_id    SERIAL PRIMARY KEY,
    portfolio_code  VARCHAR(15)  NOT NULL UNIQUE,
    client_id       INT          NOT NULL REFERENCES clients(client_id),
    portfolio_name  VARCHAR(100) NOT NULL,
    portfolio_type  VARCHAR(20)  NOT NULL CHECK (portfolio_type IN ('Equity','Debt','Hybrid','SIP')),
    inception_date  DATE         NOT NULL,
    invested_value  NUMERIC(15,2) NOT NULL,
    current_value   NUMERIC(15,2) NOT NULL,
    unrealized_pnl  NUMERIC(15,2) NOT NULL,
    realized_pnl    NUMERIC(15,2) NOT NULL,
    total_return_pct NUMERIC(8,2) NOT NULL,
    risk_level      VARCHAR(15)  NOT NULL CHECK (risk_level IN ('Low','Medium','High')),
    status          VARCHAR(10)  NOT NULL CHECK (status IN ('Active','Closed'))
);

INSERT INTO portfolios (portfolio_code, client_id, portfolio_name, portfolio_type, inception_date, invested_value, current_value, unrealized_pnl, realized_pnl, total_return_pct, risk_level, status)
SELECT
    'PRT' || LPAD(n::TEXT, 10, '0'),
    n,
    (ARRAY['Growth Portfolio','Dividend Portfolio','Balanced Portfolio','Tech Portfolio',
            'Blue Chip Portfolio','Small Cap Portfolio','Sector Rotation','Income Portfolio',
            'Capital Preservation','Momentum Portfolio'])[((n-1)%10)+1],
    (ARRAY['Equity','Debt','Hybrid','SIP'])[((n-1)%4)+1],
    DATE '2018-01-01' + (n * 13 % 2190) * INTERVAL '1 day',
    ROUND((50000 + (n * 9371.33) % 950000)::NUMERIC, 2),
    ROUND((50000 + (n * 9371.33) % 950000 + (n * 2131.17) % 200000 - 50000)::NUMERIC, 2),
    ROUND(((n * 2131.17) % 200000 - 50000)::NUMERIC, 2),
    ROUND(((n * 1137.91) % 100000 - 20000)::NUMERIC, 2),
    ROUND((((n * 2131.17) % 200000 - 50000) / (50000 + (n * 9371.33) % 950000) * 100)::NUMERIC, 2),
    (ARRAY['Low','Medium','High'])[((n-1)%3)+1],
    CASE WHEN n % 20 = 0 THEN 'Closed' ELSE 'Active' END
FROM generate_series(1, 500) n;

-- ============================================================
-- TABLE 9: portfolio_holdings
-- ============================================================
CREATE TABLE portfolio_holdings (
    holding_id      SERIAL PRIMARY KEY,
    portfolio_id    INT          NOT NULL REFERENCES portfolios(portfolio_id),
    stock_id        INT          NOT NULL REFERENCES stocks(stock_id),
    quantity        INT          NOT NULL,
    avg_buy_price   NUMERIC(10,2) NOT NULL,
    current_price   NUMERIC(10,2) NOT NULL,
    invested_amount NUMERIC(15,2) NOT NULL,
    current_amount  NUMERIC(15,2) NOT NULL,
    unrealized_pnl  NUMERIC(15,2) NOT NULL,
    pnl_pct         NUMERIC(8,2) NOT NULL,
    weight_pct      NUMERIC(5,2) NOT NULL,
    first_buy_date  DATE         NOT NULL,
    last_transaction_date DATE   NOT NULL,
    holding_days    INT          NOT NULL
);

INSERT INTO portfolio_holdings (portfolio_id, stock_id, quantity, avg_buy_price, current_price, invested_amount, current_amount, unrealized_pnl, pnl_pct, weight_pct, first_buy_date, last_transaction_date, holding_days)
SELECT
    n AS portfolio_id,
    (n % 500) + 1 AS stock_id,
    (ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1] AS quantity,
    ROUND((100 + (n * 17.37) % 4900)::NUMERIC, 2) AS avg_buy_price,
    ROUND((100 + (n * 17.37) % 4900 + (n * 2.11) % 500 - 200)::NUMERIC, 2) AS current_price,
    ROUND(((ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1] * (100 + (n * 17.37) % 4900))::NUMERIC, 2) AS invested_amount,
    ROUND(((ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1] * (100 + (n * 17.37) % 4900 + (n * 2.11) % 500 - 200))::NUMERIC, 2) AS current_amount,
    ROUND(((ARRAY[1,5,10,25,50,100,200,500])[((n-1)%8)+1] * ((n * 2.11) % 500 - 200))::NUMERIC, 2) AS unrealized_pnl,
    ROUND((((n * 2.11) % 500 - 200) / (100 + (n * 17.37) % 4900) * 100)::NUMERIC, 2) AS pnl_pct,
    ROUND((2 + (n * 1.97) % 28)::NUMERIC, 2) AS weight_pct,
    DATE '2020-01-01' + (n * 17 % 1460) * INTERVAL '1 day' AS first_buy_date,
    DATE '2024-01-01' + (n * 7 % 365) * INTERVAL '1 day' AS last_transaction_date,
    (100 + n * 13 % 1200) AS holding_days
FROM generate_series(1, 500) n;

-- ============================================================
-- TABLE 10: transactions  (money in/out of accounts)
-- ============================================================
CREATE TABLE transactions (
    transaction_id   SERIAL PRIMARY KEY,
    transaction_ref  VARCHAR(20)  NOT NULL UNIQUE,
    account_id       INT          NOT NULL REFERENCES accounts(account_id),
    client_id        INT          NOT NULL REFERENCES clients(client_id),
    transaction_type VARCHAR(20)  NOT NULL CHECK (transaction_type IN ('Deposit','Withdrawal','Buy','Sell','Dividend','Brokerage Fee','STT','GST','Interest','Refund')),
    amount           NUMERIC(15,2) NOT NULL,
    balance_after    NUMERIC(15,2) NOT NULL,
    payment_mode     VARCHAR(20)  NOT NULL CHECK (payment_mode IN ('NEFT','RTGS','IMPS','UPI','Cheque','DD','Online')),
    reference_number VARCHAR(30),
    transaction_date DATE         NOT NULL,
    transaction_time TIME         NOT NULL,
    description      VARCHAR(200) NOT NULL,
    status           VARCHAR(10)  NOT NULL CHECK (status IN ('Success','Failed','Pending','Reversed'))
);

INSERT INTO transactions (transaction_ref, account_id, client_id, transaction_type, amount, balance_after, payment_mode, reference_number, transaction_date, transaction_time, description, status)
SELECT
    'TXN' || LPAD(n::TEXT, 12, '0'),
    a.account_id,
    a.client_id, -- Linked directly from the account record
    (ARRAY['Deposit','Withdrawal','Buy','Sell','Dividend','Brokerage Fee','STT','GST','Interest','Refund'])[((n-1)%10)+1],
    ROUND((100 + (n * 3731.17) % 99900)::NUMERIC, 2),
    -- Calculating a dummy "balance after" by adding/subtracting the amount
    CASE 
        WHEN n % 2 = 0 THEN ROUND(a.balance + (100 + (n * 3731.17) % 99900)::NUMERIC, 2)
        ELSE ROUND(a.balance - (50 + (n * 3731.17) % 50000)::NUMERIC, 2)
    END,
    (ARRAY['NEFT','RTGS','IMPS','UPI','Cheque','DD','Online'])[((n-1)%7)+1],
    CASE WHEN n % 5 = 0 THEN NULL ELSE 'REF' || LPAD((n * 97 % 999999999)::TEXT, 12, '0') END,
    DATE '2024-01-02' + (n % 365) * INTERVAL '1 day',
    (TIME '09:00:00' + (n * 53 % 540) * INTERVAL '1 minute'),
    (ARRAY[
        'Funds deposited via net banking',
        'Withdrawal to linked bank account',
        'Purchase of shares',
        'Sale of shares',
        'Dividend credit',
        'Brokerage charges deducted',
        'STT charges deducted',
        'GST on brokerage deducted',
        'Interest on idle funds',
        'Refund for cancelled order'
    ])[((n-1)%10)+1],
    CASE WHEN n % 15 = 0 THEN 'Failed' WHEN n % 25 = 0 THEN 'Pending' WHEN n % 40 = 0 THEN 'Reversed' ELSE 'Success' END
FROM generate_series(1, 500) n
JOIN (
    -- Maps the 1-500 series to existing IDs
    SELECT account_id, client_id, balance, ROW_NUMBER() OVER (ORDER BY account_id) as row_num 
    FROM accounts
) a ON a.row_num = n;

-- ============================================================
-- QUICK SANITY CHECK
-- ============================================================
SELECT 'brokers'           AS table_name, COUNT(*) AS row_count FROM brokers
UNION ALL SELECT 'clients',          COUNT(*) FROM clients
UNION ALL SELECT 'stocks',           COUNT(*) FROM stocks
UNION ALL SELECT 'accounts',         COUNT(*) FROM accounts
UNION ALL SELECT 'market_data',      COUNT(*) FROM market_data
UNION ALL SELECT 'orders',           COUNT(*) FROM orders
UNION ALL SELECT 'trades',           COUNT(*) FROM trades
UNION ALL SELECT 'portfolios',       COUNT(*) FROM portfolios
UNION ALL SELECT 'portfolio_holdings', COUNT(*) FROM portfolio_holdings
UNION ALL SELECT 'transactions',     COUNT(*) FROM transactions
ORDER BY table_name;


select * from orders;
select * from transactions;