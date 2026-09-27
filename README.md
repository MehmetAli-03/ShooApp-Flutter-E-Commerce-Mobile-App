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
> I recently shared a comprehensive breakdown of the development journey, the backend N-Tier architecture, state management with Cubit, and how the AI Shopping Assistant was integrated.
> 
> 👉 **[Click here to watch the full video demonstration and join the discussion on LinkedIn!](https://lnkd.in/p/dEQ7dfZw)**

---

## 🌟 Highlight: AI Shopping Assistant
The application features a built-in smart assistant. Users can type natural phrases like *"I need a cheap running shoe under $50"* or *"Show me black Nike t-shirts,"* and the AI engine processes the intent, maps it to the database, and routes the user to a perfectly filtered product listing.

## 🚀 Key Features

### 📱 Mobile App (Flutter)
* **Smart Routing:** AI-driven intent recognition for personalized shopping.
* **State Management:** Reactive and predictable UI state handling using **Cubit (BLoC)**.
* **Networking & Interceptors:** Built with **Dio** for handling API calls, automated token injection, and global error handling.
* **Feature-First Architecture:** Modular and scalable project structure separating data and presentation layers per feature.
* **Authentication:** Secure Login/Register flows with local JWT session handling.
* **Product Discovery:** Advanced filtering (Price, Brand, Category) and intuitive search capabilities.
* **User Engagement:** Detailed product pages with a star-rating and text review system.
* **Seamless Checkout:** Complete cart management, order placement, and historical order tracking.

### ⚙️ Backend API (ASP.NET Core)
* **Clean Architecture:** Strictly implemented N-Tier architecture utilizing the Repository Pattern and DTOs (Data Transfer Objects) for clean data flow.
* **Security:** Microsoft Identity integration coupled with JWT (JSON Web Tokens) for robust endpoint protection.
* **Automated Mail Service:** Real-time email notifications dispatched automatically upon order creation and status updates.
* **Comprehensive Management:** Full CRUD operations for Products, Categories, Reviews, Carts, and Orders.

---

## 🏗️ Architecture & Project Structure

### 📱 Mobile Architecture (Feature-First + Cubit)
The mobile application follows a **Feature-First** pattern. Each feature contains its own data models, services, and UI presentation layer with **Cubit** managing the state transitions predictably.

```text
lib/
├── main.dart
│
├── core/                                 # Global, app-wide reusable components
│   ├── constants/                        # ApiConstants, AppColors, Endpoint paths
│   ├── network/                          # Dio Client instance & Interceptors
│   ├── theme/                            # App theme configurations
│   └── widgets/                          # Common UI components (Buttons, Loaders)
│
└── features/                             # Modular Business Logic Features
    ├── auth/                             # Authentication Feature
    │   ├── data/                         # Auth Models & Auth Services
    │   └── presentation/                 # Login/Register Pages & AuthCubit
    │
    ├── product/                          # Product Catalog & AI Search Feature
    │   ├── data/                         # Product Models & API Services
    │   └── presentation/                 # Product List, Details & ProductCubit
    │
    ├── cart/                             # Cart & Checkout Feature
    │   ├── data/                         # Cart Models & Payment Services
    │   └── presentation/                 # Cart View, Checkout & CartCubit
    │
    └── order/                            # Order Tracking Feature
        ├── data/                         # Order Models & Services
        └── presentation/                 # Order History Page & OrderCubit
