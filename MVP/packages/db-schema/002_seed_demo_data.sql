/********************************************************************
 002_seed_demo_data.sql
 --------------------------------------------------------------------
 Purpose:
   - Populate the database with SAFE, FAKE, DEMO data.
   - Enables immediate usability of the CoinsExtra MVP.
   - No real users, no real money, no compliance risk.
 
 IMPORTANT:
   - This file assumes 001_init.sql has already been executed.
   - IDs are hard-coded UUID-style strings for clarity.
 ********************************************************************/


/********************************************************************
 DEMO USER
 --------------------------------------------------------------------
 Creates a single demo user that can be used to log in instantly.
 ********************************************************************/

INSERT INTO users (
  user_id,
  email,
  password_hash,
  display_name,
  created_at
) VALUES (
  'user-demo-001',
  'demo@coinsextra.com',
  'demo_password_hash_not_real',
  'Demo User',
  CURRENT_TIMESTAMP
);


/********************************************************************
 ACCOUNTS FOR DEMO USER
 --------------------------------------------------------------------
 Each account represents a financial bucket.
 ********************************************************************/

INSERT INTO accounts (
  account_id,
  user_id,
  account_type,
  balance,
  currency
) VALUES
  (
    'acct-demo-cash',
    'user-demo-001',
    'cash',
    4200.00,
    'USD'
  ),
  (
    'acct-demo-credit',
    'user-demo-001',
    'credit',
    -1200.00,
    'USD'
  ),
  (
    'acct-demo-investment',
    'user-demo-001',
    'investment',
    18500.00,
    'USD'
  );


/********************************************************************
 TRANSACTIONS
 --------------------------------------------------------------------
 Creates a small transaction history to demonstrate:
   - Purchases
   - Receives
   - Coin earning activity
 ********************************************************************/

INSERT INTO transactions (
  transaction_id,
  account_id,
  type,
  amount,
  description,
  coin_equivalent,
  timestamp
) VALUES
  (
    'txn-001',
    'acct-demo-cash',
    'receive',
    3000.00,
    'Initial deposit',
    NULL,
    CURRENT_TIMESTAMP
  ),
  (
    'txn-002',
    'acct-demo-cash',
    'purchase',
    -99.00,
    'GitHub Copilot Subscription',
    10,
    CURRENT_TIMESTAMP
  ),
  (
    'txn-003',
    'acct-demo-investment',
    'purchase',
    5000.00,
    'Purchased AAPL shares',
    NULL,
    CURRENT_TIMESTAMP
  ),
  (
    'txn-004',
    'acct-demo-cash',
    'coin_earn',
    0.00,
    'Tech engagement reward',
    25,
    CURRENT_TIMESTAMP
  );


/********************************************************************
 TECH COINS
 --------------------------------------------------------------------
 Tracks accumulated CoinsExtra units for the demo user.
 ********************************************************************/

INSERT INTO tech_coins (
  coin_id,
  user_id,
  coins_earned,
  coins_spent,
  activity_source
) VALUES (
  'coin-demo-001',
  'user-demo-001',
  35,
  0,
  'Demo Activity Engine'
);


/********************************************************************
 DOCUMENTS
 --------------------------------------------------------------------
 Inserts document metadata ONLY.
 Actual files should live in Cloudflare R2.
 ********************************************************************/

INSERT INTO documents (
  document_id,
  user_id,
  doc_type,
  file_url,
  expiration_date,
  created_at
) VALUES (
  'doc-demo-001',
  'user-demo-001',
  'certification',
  'r2://coinsextra-docs/demo-certification.pdf',
  '2026-12-31',
  CURRENT_TIMESTAMP
);


/********************************************************************
 MARKET DATA
 --------------------------------------------------------------------
 Demo snapshot of tech stocks and crypto.
 Updated later by backend cron jobs.
 ********************************************************************/

INSERT INTO market_data (
  symbol,
  price,
  change_percent,
  updated_at
) VALUES
  (
    'AAPL',
    195.22,
    1.35,
    CURRENT_TIMESTAMP
  ),
  (
    'MSFT',
    378.90,
    -0.45,
    CURRENT_TIMESTAMP
  ),
  (
    'BTC',
    43210.55,
    -0.80,
    CURRENT_TIMESTAMP
  ),
  (
    'ETH',
    2280.40,
    2.10,
    CURRENT_TIMESTAMP
  );
