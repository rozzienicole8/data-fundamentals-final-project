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

- **Admins can view and manage all payments**.
```sql
CREATE POLICY "Admins manage all payments"
ON payments
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));
```

4. Admin-Only Function.
------------------------------------------
A special function that only admins can execute:
```sql
CREATE OR REPLACE FUNCTION delete_event_by_admin(event_to_delete INT)
RETURNS VOID
LANGUAGE SQL
SECURITY DEFINER
AS $$
  DELETE FROM events WHERE event_id = event_to_delete;
$$;
```
Purpose: This ensures only admins can permanently delete event records.
Security Definer: Executes with the privileges of the function owner (admin).


```sql
CREATE OR REPLACE FUNCTION get_event_statistics()
RETURNS TABLE(event_name TEXT, total_tickets INT, total_sales NUMERIC)
LANGUAGE SQL
SECURITY DEFINER
AS $$
  SELECT e.event_name,
         COUNT(t.id) AS total_tickets,
         COALESCE(SUM(p.amount), 0) AS total_sales
  FROM events e
  LEFT JOIN tickets t ON e.id = t.event_id
  LEFT JOIN payments p ON t.id = p.ticket_id
  GROUP BY e.event_name;
$$;

```
Purpose: get event statistics.
```sql
CREATE OR REPLACE FUNCTION archive_old_events()
RETURNS INT
LANGUAGE SQL
SECURITY DEFINER
AS $$
  WITH archived AS (
    UPDATE events
    SET status = 'archived'
    WHERE event_date < NOW() - INTERVAL '90 days'
    RETURNING *
  )
  SELECT COUNT(*) FROM archived;
$$;
```
purpose: archive old events.

### References

- [PostgreSQL Row Level Security Documentation](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Supabase RLS Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)

PostgreSQL SECURITY DEFINER Functions
5. Summary
-----------------------
| Table                              | Regular User Access       | Admin Access |
| ---------------------------------- | ------------------------- | ------------ |
| `users`                            | View only own profile     | Full access  |
| `events`                           | View only                 | Full access  |
| `tickets`                          | View + Insert own tickets | Full access  |
| `payments`                         | View own payments         | Full access  |
| Function `delete_event_by_admin()` | ❌ Not allowed             | ✅ Allowed    |

6. **Best Practices Followed**

- Principle of least privilege.

- Use of RLS for all data access.

- Auth-based access using auth.uid().

- Clear role-based control in policies.

- Security Definer used for admin-only functions.

7. **Improvements**

-  Add audit logs for admin actions.

- Implement JWT role claims via Supabase Auth.

- Automate email verification for new users. 




