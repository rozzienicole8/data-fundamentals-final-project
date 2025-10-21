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

<!-- PROJECT DESCRIPTION -->

#  Event Ticketing System <a name="about-project"></a>
This project demonstrates how to **secure a database using Admin Roles, Row Level Security (RLS), and Supabase Auth**.  
It builds upon the **Event Ticketing System** created in the **Data Tools Final Project** — extending it with real security features.

The system manages **users, events, tickets, and payments**, allowing users to buy tickets while admins manage events and oversee all data.  
This project focuses on **data access control**, **user roles**, and **safe database management**.

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

> Describe the tech stack and include only the relevant sections that apply to your project e.g SQL.

<details>
  <summary> Backend </summary>
  <ul>
 <li><a href="https://supabase.com/">Supabase</a></li>
  </ul>
</details>

<details>
  <summary>Database</summary>
  <ul>
   <li><a href="https://www.postgresql.org/">PostgreSQL 15+</a></li>
<details>
<summary>Security</summary>
   <ul>
    <li>Row Level Security (RLS)</li>
    <li>Role-Based Access Control (RBAC)</li>
    <li>Supabase Auth</li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

> Describe between 1-3 key features of the application.
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

<!--
Example command:

```sh
  cd my-project
  gem install
```
--->

### Usage

To run the project, execute the following command:

<!--
Example command:

```sh
  rails server
```
--->

### Run tests

To run tests, run the following command:

<!--
Example command:

```sh
  bin/rails test test/models/article_test.rb
```
--->

### Deployment

You can deploy this project using:

<!--
Example:

```sh

```
 -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

> Mention all of the collaborators of this project.

👤 **Author1**

- GitHub: [@githubhandle](https://github.com/githubhandle)
- Twitter: [@twitterhandle](https://twitter.com/twitterhandle)
- LinkedIn: [LinkedIn](https://linkedin.com/in/linkedinhandle)

👤 **Author2**

- GitHub: [@githubhandle](https://github.com/githubhandle)
- Twitter: [@twitterhandle](https://twitter.com/twitterhandle)
- LinkedIn: [LinkedIn](https://linkedin.com/in/linkedinhandle)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Future Features <a name="future-features"></a>

> Describe 1 - 3 features you will add to the project.

- [ ] **[new_feature_1]**
- [ ] **[new_feature_2]**
- [ ] **[new_feature_3]**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->

## ⭐️ Show your support <a name="support"></a>

> Write a message to encourage readers to support your project

If you like this project...

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments <a name="acknowledgements"></a>

> Give credit to everyone who inspired your codebase.

I would like to thank...

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FAQ (optional) -->

## ❓ FAQ (OPTIONAL) <a name="faq"></a>

> Add at least 2 questions new developers would ask when they decide to use your project.

- **[Question_1]**

  - [Answer_1]

- **[Question_2]**

  - [Answer_2]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

