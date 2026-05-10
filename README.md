# Messbook - Digital Mess Management Application

A comprehensive Flutter application for managing digital mess operations including expense tracking, member management, meal scheduling, billing, and inventory management.

## 📱 Features

### 1. **Dashboard**
- Real-time summary cards (Members, Total Expenses, Pending Bills, Inventory Value)
- Expenses breakdown by category
- Low stock alerts
- Recent expenses list
- Pending payments overview

### 2. **Members Management**
- Add new members with contact information
- View member profiles
- Activate/Deactivate members
- Delete members
- Member balance tracking

### 3. **Expense Tracking**
- Record expenses with multiple categories (Food, Utilities, Maintenance, Rent, Other)
- Split expenses among multiple members
- Track who paid for what
- View expense details and history
- Delete or modify expenses

### 4. **Meal Scheduling**
- Schedule meals (Breakfast, Lunch, Dinner)
- Track meal attendees
- Calculate cost per person
- Group meals by date
- View meal details and statistics

### 5. **Inventory Management**
- Track inventory items with quantities and prices
- Set low stock thresholds
- Get automatic alerts for low stock items
- Calculate total inventory value
- Update quantities easily

### 6. **Billing System**
- Generate bills for members
- Record payments
- Track billing status (Pending, Paid, Overdue)
- View pending payments
- Overdue bill alerts
- Payment history

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── models.dart              # Data models (Member, Expense, Meal, etc.)
├── database/
│   └── database_helper.dart     # SQLite database operations
├── providers/
│   └── mess_provider.dart       # State management (Provider)
└── screens/
    ├── dashboard_screen.dart    # Dashboard with analytics
    ├── members_screen.dart      # Members management
    ├── expenses_screen.dart     # Expenses tracking
    ├── meals_screen.dart        # Meal scheduling
    ├── inventory_screen.dart    # Inventory management
    └── bills_screen.dart        # Billing system
```

## 📦 Dependencies

- **provider**: State management
- **sqflite**: Local SQLite database
- **uuid**: Generate unique identifiers
- **intl**: Date formatting and internationalization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=2.18.0)
- Dart (>=2.18.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/atiqurrahmandipto/messbook.git
cd messbook
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📊 Data Models

### Member
- `id`: Unique identifier
- `name`: Member name
- `email`: Email address
- `phone`: Phone number
- `joinDate`: Join date
- `isActive`: Active status

### Expense
- `id`: Unique identifier
- `title`: Expense title
- `description`: Description
- `amount`: Expense amount
- `category`: Category (Food, Utilities, etc.)
- `paidBy`: Member who paid
- `splitAmong`: Members sharing the expense
- `date`: Expense date
- `receipt`: Receipt reference

### Meal
- `id`: Unique identifier
- `name`: Meal name
- `mealType`: Breakfast/Lunch/Dinner
- `date`: Meal date
- `attendees`: List of member IDs
- `costPerPerson`: Cost per person
- `notes`: Additional notes

### InventoryItem
- `id`: Unique identifier
- `name`: Item name
- `category`: Category
- `quantity`: Current quantity
- `unit`: Unit of measurement
- `unitPrice`: Price per unit
- `lastUpdated`: Last update timestamp
- `minThreshold`: Low stock threshold

### Bill
- `id`: Unique identifier
- `memberId`: Member ID
- `totalAmount`: Total bill amount
- `paid`: Amount paid
- `pending`: Pending amount
- `dueDate`: Due date
- `status`: Status (Pending/Paid/Overdue)
- `expenseIds`: Related expense IDs

### Settlement
- `id`: Unique identifier
- `fromMemberId`: From member
- `toMemberId`: To member
- `amount`: Settlement amount
- `date`: Settlement date
- `description`: Description
- `isSettled`: Settlement status

## 🎯 Key Features

✅ **Complete CRUD Operations** - Add, Edit, Delete for all features  
✅ **Real-time Analytics** - Dashboard with key metrics  
✅ **Smart Settlements** - Calculate who owes whom  
✅ **Low Stock Alerts** - Automatic inventory warnings  
✅ **Expense Splitting** - Distribute expenses fairly  
✅ **Overdue Tracking** - Bill overdue alerts  
✅ **Local Storage** - SQLite database persistence  
✅ **Clean Architecture** - Organized code structure  

## 📱 UI/UX Features

- Material Design 3 interface
- Bottom navigation for easy access
- Dialog-based forms for quick entry
- Responsive grid layouts
- Color-coded alerts and status indicators
- Easy-to-read summaries and lists
- Swipe actions for quick operations

## 💰 Calculations

### Member Balance
- Calculates total amount paid by member
- Calculates total amount owed based on expense splits
- Returns net balance (positive = they should receive, negative = they should pay)

### Expense Split
- Divides expense equally among selected members
- Each member owes: `expense.amount / splitAmong.length`

### Inventory Value
- Total value = `sum(quantity × unitPrice)` for all items

### Bill Status
- **Pending**: Bill generated, payment not complete
- **Paid**: Full payment received
- **Overdue**: Due date passed and bill not paid

## 🔐 Data Persistence

All data is stored locally using SQLite database. The database is automatically created on first run with the following tables:
- members
- expenses
- meals
- inventory
- bills
- settlements

## 🎨 Color Scheme

- **Blue**: Members, General actions
- **Orange**: Food expenses, Meals
- **Green**: Inventory, Available balance
- **Red**: Bills, Overdue, Warnings
- **Gray**: Inactive, Neutral

## 📝 Sample Usage

1. **Add Members**: Start by adding mess members
2. **Record Expenses**: Log all mess expenses with appropriate categories
3. **Track Meals**: Schedule meals and track who attended
4. **Manage Inventory**: Keep inventory updated with stock levels
5. **Generate Bills**: Create bills for members based on expenses
6. **Record Payments**: Update payment status as members pay
7. **Review Dashboard**: Check analytics and pending items

## 🐛 Troubleshooting

### Database Issues
- Clear app data if database gets corrupted
- Reinstall app for fresh database

### Sync Issues
- Restart the app to refresh data
- Check internet connection (if backend is added)

## 🚧 Future Enhancements

- Cloud backup and sync
- Photo upload for receipts
- Monthly reports and statistics
- SMS/Email notifications
- Transaction history and export
- Budget planning features
- Multi-mess support

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Atiqur Rahman Dipto**
- GitHub: [@atiqurrahmandipto](https://github.com/atiqurrahmandipto)

## 🤝 Contributing

Contributions are welcome! Feel free to fork and submit pull requests.

## 📞 Support

For issues and questions, please create an issue on GitHub.

---

**Made with ❤️ for better mess management**
