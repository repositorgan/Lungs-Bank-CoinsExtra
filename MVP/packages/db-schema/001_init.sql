/********************************************************************
 USERS TABLE
 --------------------------------------------------------------------
 Purpose:
   - Represents a single human or demo user of CoinsExtra.
   - This is the ROOT ENTITY of the entire system.
   - Every other table ultimately references this table.
 ********************************************************************/
CREATE TABLE users (
  
  -- user_id primary identifier for the user.
  -- Stored as TEXT to support UUIDs (Cloudflare D1 best practice).
  -- UUIDs prevent guessable sequential IDs.
  user_id TEXT PRIMARY KEY,

  -- Now we want user email address.
  -- Must be unique so the same email cannot register twice.
  -- NOT NULL enforces that every user must have an email.
  email TEXT UNIQUE NOT NULL,

  
  -- Next, we want secure password storage.
  -- This NEVER stores plaintext passwords.
  -- It stores a hashed version (bcrypt/argon2/etc).
  password_hash TEXT NOT NULL,

  
  -- Following password, we need an optional and friendly name choice to show in the UI.
  -- Allows personalization without requiring real names.
  display_name TEXT,

  -- Next, build Timestamp of when the user account was created.
  -- Automatically set by the database at insert time.
  -- Allow to trace latest login datetime data
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME
);

/********************************************************************
 ACCOUNTS TABLE
 --------------------------------------------------------------------
 Purpose:
   - Represents financial buckets owned by a user.
   - Examples: cash, credit, investments.
   - A user can have MULTIPLE accounts.
 ********************************************************************/
CREATE TABLE accounts (

  -- Primary key for the account.
  -- Stored as UUID text for safety and global uniqueness.
  account_id TEXT PRIMARY KEY,

  -- Foreign key linking this account to a specific user.
  -- Enforces ownership at the database level.
  user_id TEXT NOT NULL,

  -- Defines what kind of account this is.
  -- CHECK constraint limits values to known types only.
  -- Prevents invalid account types from entering the system.
  account_type TEXT CHECK 
    (account_type IN ('cash', 'credit', 'investment')
  ),

  -- Current account balance.
  -- REAL used for MVP simplicity.
  -- Defaults to 0 so new accounts always start valid.
  balance REAL DEFAULT 0,

  -- Currency of the account.
  -- Defaults to USD but allows future expansion.
  currency TEXT DEFAULT 'USD',

  -- Enforces referential integrity:
  -- An account cannot exist without a valid user.
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/********************************************************************
 TRANSACTIONS TABLE
 --------------------------------------------------------------------
 Purpose:
   - Records all financial and coin-related events.
   - Provides a historical ledger.
   - Drives reporting, exports, and insights.
 ********************************************************************/
CREATE TABLE transactions (

  -- Unique ID for each transaction.
  -- Allows safe referencing and auditing.
  transaction_id TEXT PRIMARY KEY,
  
  -- Links transaction to a specific account.
  -- Transactions belong to accounts, not directly to users.
  account_id TEXT NOT NULL,

  -- Type of transaction.
  -- CHECK constraint prevents undefined behavior.
  type TEXT CHECK (
    type IN ('send', 'receive', 'purchase', 'coins_earn')
  ),

  -- Amount involved in the transaction.
  -- NOT NULL ensures every transaction has a value.
  amount REAL NOT NULL,

  -- Timestamp of the transaction.
  -- Defaults to when the record is inserted.
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Optional human-readable description.
  -- Example: "Coinsextra investing in API allowance builder."
  description TEXT,

  -- Optional conversion value for tech coins.
  -- Used when a transaction generates CoinsExtra coins.
  coin_equivalent REAL,

  -- Enforces that a transaction must belong to a valid account.
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

/********************************************************************
 DOCUMENTS TABLE
 --------------------------------------------------------------------
 Purpose:
   - Stores metadata for identity and certification documents.
   - Actual files live in Cloudflare R2.
   - This table stores references ONLY.
 ********************************************************************/
CREATE TABLE documents (

  -- Unique identifier for the document.
  document_id TEXT PRIMARY KEY,

  -- Links the document to a specific user.
  user_id TEXT NOT NULL,

  -- Type of document.
  -- Restricted to known, compliance-safe categories.
  doc_type TEXT CHECK (
    doc_type IN ('driver_license', 'library_card', 'certification', 'insurance')
  ),

  -- Secure URL or object key pointing to R2 storage.
  -- NOT a public URL.
  file_url TEXT NOT NULL,

  -- Expiration date.
  -- Useful for compliance and reminders.
  expiration_date DATETIME,

  -- Timestamp when document was uploaded.
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  -- Enforce document ownership.
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/********************************************************************
 TECH_COINS TABLE
 --------------------------------------------------------------------
 Purpose:
   - Tracks a user's accumulated CoinsExtra units.
   - Represents value derived from tech engagement.
   - One row per user (or per source, if expanded later).
 ********************************************************************/
CREATE TABLE tech_coins (

  -- Unique ID for the coins record.
  coin_id TEXT PRIMARY KEY,

  -- Links coins to a specific user.
  user_id TEXT NOT NULL,

  -- Total coins earned by the user. 
  -- Accumulates over time.
  coins_earned REAL DEFAULT 0,

  -- Total coins spent or redeemed.
  coins_spent REAL DEFAULT 0,
  
  -- Source of the activity that generated coins.
  -- Example: OpenAI, GitHub, Microsoft Learn.
  activity_source TEXT,

  -- Ensures coins cannot exist without a user.
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

/********************************************************************
 MARKET_DATA TABLE
 --------------------------------------------------------------------
 Purpose:
   - Stores snapshot market data for demo and reporting.
   - Read-only from the frontend.
   - Updated by backend cron or worker.
 ********************************************************************/
CREATE TABLE market_data (

  -- Stock ticker or crypto symbol.
  -- Example: AAPL, BTC, ETH.
  symbol TEXT PRIMARY KEY,

  --Latest known price. 
  price REAL NOT NULL,

  -- Percentage change since last update.
  change_percent REAL,

  -- Timestamp of last update.
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

