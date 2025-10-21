<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📖 About the Project](#about-project)
  - [🛠 Built With](#built-with)
    - [Tech Stack](#tech-stack)
    - [Key Features](#key-features)
  - [🚀 Live Demo](#live-demo)
- [💻 Getting Started](#getting-started)
  - [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Install](#install)
  - [Usage](#usage)
  - [Run tests](#run-tests)
  - [Deployment](#triangular_flag_on_post-deployment)
- [👥 Authors](#authors)
- [🔭 Future Features](#future-features)
- [🤝 Contributing](#contributing)
- [⭐️ Show your support](#support)
- [🙏 Acknowledgements](#acknowledgements)
- [❓ FAQ (OPTIONAL)](#faq)
- [📝 License](#license)
-----

#  Event Ticketing System <a name="about-project"></a>
This project demonstrates how to **secure a database using Admin Roles, Row Level Security (RLS), and Supabase Auth**.  
It builds upon the **Event Ticketing System** created in the **Data Tools Final Project** — extending it with real security features.

The system manages **users, events, tickets, and payments**, allowing users to buy tickets while admins manage events and oversee all data.  
This project focuses on **data access control**, **user roles**, and **safe database management**.

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Backend as service</summary>
  <ul>
 <li><a href="https://supabase.com/">Supabase</a></li>
  </ul>
</details>

<details>
<summary>Database</summary>
<ul>
<li><a href="https://www.postgresql.org/">PostgreSQL 15+</a></li>
<ul>


<details>
<summary>Security</summary>
<ul>
<li>Row Level Security (RLS)</li>
<li>Role-Based Access Control (RBAC)</li>
<li>Supabase Auth</li>
</ul>
</details>


### Key Features <a name="key-features"></a>
- **🔐 Row Level Security (RLS) – Ensures users can only access their own tickets, events, or payments.**
- **👥 Role-Based Access Control (RBAC) – Defines clear roles: Admin (full access) and User (limited access).**
- **🛡️ Admin Functions – Includes secure PostgreSQL functions for admin-only actions like deleting or managing events.**
- **🎟️ Organized Database Design – Features well-structured tables for users, events, tickets, and payments.**
- **🔒 Least Privilege Principle – Applies strict permissions so each role only has access to what it needs.**

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running, follow these steps:

### 🪜 Step 1: Set Up Supabase

1. Go to [Supabase Dashboard](https://app.supabase.com/)
2. Create a **new project**
3. Open the **SQL Editor**
4. Copy and paste your schema from `schema.sql` (from your Event Ticketing System)
5. Run the SQL to create all tables (`users`, `events`, `tickets`, `payments`)

---


### Prerequisites

In order to run this project you need:
- A [Supabase](https://supabase.com/) account (free tier available works perfectly)
- Basic understanding of SQL and PostgreSQL
- A SQL client or the Supabase SQL Editor


### Setup

Clone this repository to your desired folder:

```sh
  cd my-folder
  git clone https://github.com/rozzienicole8/data-fundamentals-final-project
```
--->

### Install

Install this project with:

1. Execute the Database Schema

- Open your Supabase project

- Navigate to the SQL Editor

- Copy and paste the entire contents of your schema.sql file

- Run the SQL commands to create the tables

2. Verify Table Creation

- Go to the Table Editor in Supabase

- Confirm you see the following tables:

   -  users

   - events

   -  tickets

   - payments

- Ensure each table contains at least 5 rows of sample data

3. Enable Authentication

- Navigate to Authentication → Providers in Supabase

- Enable Email/Password or Magic Link authentication

- (Optional) Customize your email templates for sign-in and sign-up messages
  
--->

### Usage
### 👤 For Regular Users:

- Sign up through Supabase Auth (Email or Magic Link)
- A new record is automatically created in the users table with role = 'user'
You can:
- Browse and view available events
- Purchase tickets for events
- View your own tickets and payment history
- You cannot view or edit other users’ data (protected by Row Level Security (RLS)

###  🛡️For Administrators:
- Admins are users with role = 'admin' in the users table
They can:
- Manage all users, events, tickets, and payments
- Add new events or update event details
- Monitor all transactions
- Run admin-only functions such as:
```sql
-- Delete any event
SELECT delete_event('event-id-here');

-- Get event attendance summary
SELECT * FROM get_event_statistics();

-- Archive past events
SELECT * FROM archive_old_events();
```
--->
  
### 🧱 Database Structure
### 🧍‍♂️ Users Table

|Column|Type|Description|
|-----|-----|-----------|
|id	|UUID|	Primary key|
|email|TEXT	|User email (unique)|
|full_name|	TEXT|	User’s full name|
|role|	TEXT	|'admin' or 'user'|
|created_at|	TIMESTAMP|	Record creation timestamp
###  🎟️ Events Table
|Column|	Type|	Description|
|------|------|------------|
|id	|UUID	|Primary key|
|organizer_id|UUID|Foreign key referencing users|
|event_name|TEXT|Name of the event|
|description|TEXT|Event details|
|location	|TEXT|Event location|
|event_date|DATE|Date of the event|
|event_time|TIME|Time of the event|
|created_at|TIMESTAMP|Record creation timestamp|
###  🎫 Tickets Table
|Column	|Type	|Description|
|-------|-----|-----------|
|id|UUID|Primary key|
|event_id|UUID|Foreign key referencing events|
|user_id|	UUID|Foreign key referencing users|
|status	|TEXT|'active', 'cancelled', or 'used'|
|purchase_date|	TIMESTAMP	|When the ticket was purchased|
### 💳 Payments Table
|Column	|Type|	Description|
|-------|----|-------------|
|id|UUID|Primary key|
|ticket_id|UUID|Foreign key referencing tickets|
|amount|DECIMAL|Payment amount|
|payment_status|TEXT|	'paid', 'pending', or 'failed'|
|created_at|TIMESTAMP|	Payment timestamp|
<p align="right">(<a href="#readme-top">back to top</a>)</p>

 ###  🔐 Security Implementation <a name="security"></a>

This project uses Row Level Security (RLS) and Role-Based Access Control (RBAC) to ensure safe, restricted data access.

## 👥 User Roles

Admin: Full access to all tables and admin-only functions

User: Can only access their own data (tickets, payments, and profile)

### 🧩 Row Level Security Policies
### Users Table Policies

✅ Users can view and update their own profiles (except role)

✅ Admins can view and manage all users

### Events Table Policies

✅ Organizers (users) can view and manage their own events

✅ Admins have full access to all events

### Tickets Table Policies

✅ Users can view, purchase, and cancel their own tickets

✅ Admins can view and manage all tickets

### Payments Table Policies

✅ Users can view their own payment history

✅ Admins can view and manage all payments

### ⚙️ Admin-Only Functions

1. delete_event(event_id UUID)

- Deletes any event regardless of ownership

- Uses SECURITY DEFINER for elevated privileges

2. get_event_statistics()

- Returns event attendance and ticket sales summaries

- Useful for admin dashboards

3. archive_old_events()

- Archives past events older than a specific date

- Returns the count of archived events

 📄 For more details, see `security_notes.md` 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

> Mention all of the collaborators of this project.

👤 **Author1**

- GitHub: [@[nicolerozzie9@gmail.com](https://github.com/nicolerozzie9)
- LinkedIn:[@[LinkedIn](https://linkedin.com/in/RozzieNicole) 


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Future Features <a name="future-features"></a>

> Describe 1 - 3 features you will add to the project.

 - [ ] Add audit logs for admin actions
 - [ ] Add email notifications when users buy tickets
 - [ ] Create admin dashboard with statistics
 - [ ] Add Two-Factor Authentication (2FA) for admins

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->
## ⭐️ Show your support <a name="support"></a>

> If this project helped you understand Supabase security, give it a ⭐ on GitHub!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments <a name="acknowledgements"></a>

- Supabase — for the easy PostgreSQL + Auth platform

- PostgreSQL community — for robust database security features

- Data Fundamentals Course — for inspiring this project

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FAQ (optional) -->

## ❓ FAQ (OPTIONAL) <a name="faq"></a>


- **Q: Why can’t I see other users’ tickets?**

  - A: Because RLS restricts access — only admins can view all data.

- **Q: How do I make a user an admin?**

  - A:
    ```SQL
    UPDATE users SET role = 'admin' WHERE email = 'admin@example.com';
    ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

