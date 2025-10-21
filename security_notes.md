 Security Notes — Event Ticketing System
 -----------------------
 Overview
--------------------
This document explains how roles, policies, and Row Level Security (RLS) are implemented in the Event Ticketing Database built with Supabase (PostgreSQL).The goal is to enforce the principle of least privilege, ensuring that users can only access or modify data they own — while admins retain full control.

1. Roles

The system defines two main roles in the users table:
| Role      | Description                                                   | Privileges                                       |
| --------- | ------------------------------------------------------------- | ------------------------------------------------ |
| **Admin** | Has full access to all tables (read, insert, update, delete). | Can manage users, events, tickets, and payments. |
| **User**  | Has restricted access to their own data.                      | Can only view and create their own records.      |

Example of role setup
---------------
```sql

ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'user';

-- Assign one user as admin
UPDATE users SET role = 'admin' WHERE email = 'alice@gmail.com';
```

2. Row Level Security (RLS).

RLS ensures that users can only interact with data they own.

Enabled for all key tables:

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
```
3. Security Policies
 Users Table
- **Users can only see their own profiles**.
```sql
CREATE POLICY "Users can view their own profile"
ON users
FOR SELECT
USING (auth.uid() = user_id);
```
- **Admins can manage all users**.
```sql
CREATE POLICY "Admins can manage users"
ON users
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));
```
Tickets Table
---------------------------------------------------
- **Users can view and create their own tickets**.
```sql
CREATE POLICY "Users can manage own tickets"
ON tickets
FOR SELECT USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
```
- **Admins have full access**.
```sql
CREATE POLICY "Admins manage all tickets"
ON tickets
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));
```
Events Table
----------------------------------------------
- **Anyone can view events**.
```sql
CREATE POLICY "Anyone can view events"
ON events
FOR SELECT USING (true);
```
- **Admins can create, update, and delete events**.
```sql

CREATE POLICY "Admins manage events"
ON events
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));
```
Payments Table
-----------------------------------------------
- **Users can only view their own payments**.
  ```sql
  CREATE POLICY "Users view own payments"
  ON payments
  FOR SELECT
  USING (EXISTS (
  SELECT 1 FROM tickets t WHERE t.ticket_id = payments.ticket_id AND t.user_id = auth.uid()
  ));
```









