-- ============================================
-- EVENT TICKETING SYSTEM DATABASE SCHEMA
-- WITH ADMIN ROLES & SECURITY POLICIES
-- ============================================

-- USERS TABLE
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  phone VARCHAR(20),
  role VARCHAR(20) DEFAULT 'user',  -- Added role column ('admin' or 'user')
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EVENTS TABLE
CREATE TABLE events (
  event_id SERIAL PRIMARY KEY,
  event_name VARCHAR(150) NOT NULL,
  event_description TEXT,
  location VARCHAR(150),
  event_date DATE NOT NULL,
  event_time TIME NOT NULL,
  organizer_id INT REFERENCES users(user_id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TICKETS TABLE
CREATE TABLE tickets (
  ticket_id SERIAL PRIMARY KEY,
  event_id INT REFERENCES events(event_id) ON DELETE CASCADE,
  user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
  ticket_type VARCHAR(50),
  price DECIMAL(10,2) NOT NULL,
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'valid'
);

-- PAYMENTS TABLE
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  ticket_id INT REFERENCES tickets(ticket_id) ON DELETE CASCADE,
  payment_method VARCHAR(50),
  amount DECIMAL(10,2) NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'completed'
);

-- ============================================
-- SAMPLE DATA
-- ============================================

INSERT INTO users (name, email, phone, role)
VALUES
('Alice Mwangi','alice@gmail.com','+254712345786','admin'),
('Brian Otieno','brian@gmail.com','+254786967393','user'),
('Clara Njeri','clara@gmail.com', '+254712465890','user'),
('David Kimani','david@gmail.com','+254794867092','user');

INSERT INTO events (event_name, event_description, location, event_date, event_time, organizer_id)
VALUES
('Nairobi Tech Fest', 'A technology and innovation exhibition.','KICC Nairobi', '2025-11-10','09:00:00',1),
('Afrobeats Live Concert', 'A Night of African music and dance.','Carnivore Grounds','2025-12-05','08:00:00',2),
('Food and Culture Expo', 'Celebrating diverse cuisines and cultures.', 'Sarit Expo Centre','2025-10-25','10:00:00',3);

INSERT INTO tickets(event_id, user_id, ticket_type,price)
VALUES
(1,2,'VIP',2500.00),
(1,3,'Regular',1500.00),
(2,1,'Regular',2000.00),
(3,4,'Student',1000.00),
(3,1,'Regular',1500.00);

INSERT INTO payments (ticket_id, payment_method,amount)
VALUES
(1,'M-Pesa',2500.00),
(2,'Credit Card',1500.00),
(3,'M-Pesa',2000.00),
(4,'Cash',1000.00),
(5,'M-Pesa',1500.00);

-- ============================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- SECURITY POLICIES
-- ============================================

-- Users can view only their own account
CREATE POLICY "Users can view their own profile"
ON users
FOR SELECT
USING (auth.uid() = user_id);

-- Admins can view and manage all users
CREATE POLICY "Admins can manage users"
ON users
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));

-- Users can only view events
CREATE POLICY "Anyone can view events"
ON events
FOR SELECT
USING (true);

-- Admins can insert, update, delete any event
CREATE POLICY "Admins manage events"
ON events
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));

-- Users can only view and insert their own tickets
CREATE POLICY "Users can manage own tickets"
ON tickets
FOR SELECT USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Admins have full control of tickets
CREATE POLICY "Admins manage all tickets"
ON tickets
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));

-- Users can view their own payments
CREATE POLICY "Users view own payments"
ON payments
FOR SELECT
USING (EXISTS (
  SELECT 1 FROM tickets t WHERE t.ticket_id = payments.ticket_id AND t.user_id = auth.uid()
));

-- Admins can view and manage all payments
CREATE POLICY "Admins manage all payments"
ON payments
FOR ALL
USING (EXISTS (
  SELECT 1 FROM users u WHERE u.user_id = auth.uid() AND u.role = 'admin'
));

-- ============================================
-- ADMIN-ONLY FUNCTION
-- ============================================

CREATE OR REPLACE FUNCTION delete_event_by_admin(event_to_delete INT)
RETURNS VOID
LANGUAGE SQL
SECURITY DEFINER
AS $$
  DELETE FROM events WHERE event_id = event_to_delete;
$$;

COMMENT ON FUNCTION delete_event_by_admin IS 'Allows only admins to delete events.';

-- Grant execution rights only to admins
GRANT EXECUTE ON FUNCTION delete_event_by_admin TO authenticated;

