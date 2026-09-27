# 🛒 ShooApp - AI-Powered E-Commerce Platform

[![LinkedIn Post](https://img.shields.io/badge/LinkedIn-Read_The_Post-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://lnkd.in/p/dEQ7dfZw)
![Flutter](https://img.shields.io/badge/Mobile-Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![ASP.NET Core](https://img.shields.io/badge/Backend-ASP.NET_Core-purple?style=for-the-badge&logo=.net)
![AI Assistant](https://img.shields.io/badge/Feature-AI_Shopping_Assistant-FF9900?style=for-the-badge&logo=openai)
![Architecture](https://img.shields.io/badge/Architecture-N--Tier_%7C_Feature--First-brightgreen?style=for-the-badge)

ShooApp is a full-stack, scalable mobile e-commerce platform built with **Flutter** and powered by a robust **ASP.NET Core Web API**. 

Going beyond standard e-commerce functionality, ShooApp integrates an **AI-Powered Shopping Assistant** that understands natural language queries to provide highly personalized product recommendations. The system is designed with enterprise-grade architecture, featuring secure JWT authentication, automated email notifications, and a clean, layered backend structure.

## 📢 Featured on LinkedIn

> **Want to see the behind-the-scenes and the app in action?** 🚀
> I recently shared a comprehensive breakdown of the development journey, the backend N-Tier architecture, and how the AI Shopping Assistant was integrated.
> 
> 👉 **[Click here to watch the full video demonstration and join the discussion on LinkedIn!](https://lnkd.in/p/dEQ7dfZw)**

---

## 🌟 Highlight: AI Shopping Assistant
The application features a built-in smart assistant. Users can type natural phrases like *"I need a cheap running shoe under $50"* or *"Show me black Nike t-shirts,"* and the AI engine processes the intent, maps it to the database, and routes the user to a perfectly filtered product listing.

## 🚀 Key Features

### 📱 Mobile App (Flutter)
* **Smart Routing:** AI-driven intent recognition for personalized shopping.
* **State Management & Networking:** Built with **Cubit (BLoC)** and **Dio** utilizing a Feature-First architecture.
* **Authentication:** Secure Login/Register flows with local session handling.
* **Product Discovery:** Advanced filtering (Price, Brand, Category) and intuitive search capabilities.
* **User Engagement:** Detailed product pages with a star-rating and text review system.
* **Seamless Checkout:** Complete cart management, order placement, and historical order tracking.

### ⚙️ Backend API (ASP.NET Core)
* **Clean Architecture:** Strictly implemented N-Tier architecture utilizing the Repository Pattern and DTOs (Data Transfer Objects) for clean data flow.
* **Security:** Microsoft Identity integration coupled with JWT (JSON Web Tokens) for robust endpoint protection.
* **Automated Mail Service:** Real-time email notifications dispatched automatically upon order creation and status updates.
* **Comprehensive Management:** Full CRUD operations for Products, Categories, Reviews, Carts, and Orders.

## 🛠️ Technology Stack

| Component | Technologies Used |
| :--- | :--- |
| **Frontend** | Flutter, Dart, Cubit (BLoC), Dio, Shared Preferences |
| **Backend** | ASP.NET Core Web API, C#, Entity Framework Core |
| **Database** | SQL Server (Relational Database) |
| **Security** | ASP.NET Core Identity, JWT Bearer Authentication |
| **Services** | AI NLP Integration, SMTP/Email Service |
| **Architecture**| Feature-First (Mobile), N-Tier & Repository Pattern (Backend) |

## 📂 Backend Architecture Overview
The API is divided into distinct layers to ensure maintainability and scalability:
1.  **Core / Domain Layer:** Entities and Interfaces.
2.  **Data Access Layer:** Entity Framework configurations, Migrations, and Repositories.
3.  **Business / Service Layer:** Business logic, DTO mappings, and external service integrations (AI, Mail).
4.  **API Layer:** Controllers exposing RESTful endpoints.

## ⚙️ Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* [.NET SDK](https://dotnet.microsoft.com/download)
* SQL Server

### Setup Instructions
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/MehmetAli-03/ShooApp-Flutter-E-Commerce-Mobile-App.git](https://github.com/MehmetAli-03/ShooApp-Flutter-E-Commerce-Mobile-App.git)
    ```
2.  **Backend Setup:**
    * Navigate to the ASP.NET Core project folder.
    * Update the `appsettings.json` with your SQL Server connection string and Email SMTP credentials.
    * Run Entity Framework migrations to build the database: `dotnet ef database update`
    * Run the API: `dotnet run`
3.  **Frontend Setup:**
    * Navigate to the Flutter project folder.
    * Update `lib/core/constants/api_constants.dart` with your local API IP address.
    * Run `flutter pub get` and build the app `flutter run`.

---
*Architected and developed as a complete full-stack solution.*
