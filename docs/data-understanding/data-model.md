# Data Model

## Tables

- Users
- Transactions
- Notifications
- Devices

---

## Relationships

Users → Transactions (1 : Many)

Users → Notifications (1 : Many)

Users → Devices (1 : One)

---

## Join Key

All behavioural analysis uses:

`user_id`

as the primary relationship between datasets.
