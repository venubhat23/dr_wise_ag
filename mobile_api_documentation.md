# InsureBook Mobile API Documentation

## Base URL
```
{{base_url}}/api/v1/mobile
```

## Authentication
Most endpoints require JWT token authentication. Include the token in headers:
```
Authorization: Bearer {{token}}
```

---

## 1. Authentication APIs

### 1.1 Login
**Endpoint:** `POST /auth/login`

**Description:** Authenticate user and receive JWT token

**Request Body:**
```json
{
  "username": "email@example.com",  // Can be email, mobile, or PAN number
  "password": "your_password"
}
```

**Alternate Parameters:**
- `email`: Email address
- `mobile`: Mobile number (10 digits, with or without +91)

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "token": "jwt_token_here",
    "username": "John Doe",
    "role": "customer",  // customer, agent, sub_agent, admin, ambassador
    "user_id": 123,
    "customer_id": 456,  // For customers
    "email": "user@example.com",
    "mobile": "9876543210",
    "password_reset_days": 180,
    "password_reset_required": false,
    "portfolio_summary": {  // For customers
      "total_policies": 5,
      "upcoming_installments": 2,
      "renewal_policies": 1
    },
    "commission_earned": 50000,  // For agents
    "customers_count": 25,  // For agents
    "policies_count": 45,  // For agents
    "dashboard_stats": {  // For agents
      "total_commission": 50000,
      "monthly_target": 75000,
      "achievement_percentage": 66.67,
      "policies_this_month": 5,
      "customers_this_month": 3,
      "conversion_rate": "75%"
    }
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Invalid username or password"
}
```

---

### 1.2 Register
**Endpoint:** `POST /auth/register`

**Description:** Register new customer or agent account

**Request Body for Customer:**
```json
{
  "role": "customer",  // or "agent"
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "mobile": "9876543210",
  "password": "securePassword123",
  "password_confirmation": "securePassword123"
}
```

**Request Body for Agent:**
```json
{
  "role": "agent",
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "mobile": "9876543210",
  "password": "securePassword123",
  "password_confirmation": "securePassword123",
  "pan_no": "ABCDE1234F",
  "address": "123 Main Street",
  "city": "Mumbai",
  "state": "Maharashtra",
  "gender": "Female",
  "occupation": "Insurance Agent",
  "annual_income": "500000"
}
```

**Valid Roles:**
- `customer` - Customer registration (auto-approved)
- `agent` - Agent registration (requires admin approval)

**Success Response (200):**
```json
{
  "success": true,
  "message": "Customer registration successful. You can now login with your credentials.",
  "data": {
    "customer_id": 123,
    "user_id": 456,
    "email": "john@example.com",
    "mobile": "9876543210",
    "role": "customer"
  }
}
```

**Error Responses:**
- **400** - Validation errors (invalid email, mobile, password)
- **409** - Email or mobile already exists

---

### 1.3 Forgot Password
**Endpoint:** `POST /auth/forgot_password`

**Description:** Request password reset

**Request Body:**
```json
{
  "email": "user@example.com"  // or "mobile": "9876543210"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Password reset instructions have been sent to your email"
}
```

---

## 2. Customer APIs

### 2.1 Get Portfolio
**Endpoint:** `GET /customer/portfolio`

**Description:** Get all policies for the authenticated customer

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "portfolio": [
      {
        "id": 1,
        "insurance_name": "Health Insurance",
        "insurance_type": "Health",
        "policy_number": "POL123456",
        "policy_holder": "Self",
        "start_date": "2024-01-01",
        "end_date": "2025-01-01",
        "total_premium": 25000,
        "sum_insured": 500000,
        "insurance_company": "HDFC ERGO",
        "payment_mode": "Yearly",
        "status": "Active",
        "days_until_expiry": 180,
        "document": "https://example.com/policy.pdf"
      }
    ],
    "total_policies": 5,
    "total_premium": 125000,
    "total_sum_insured": 2500000,
    "active_policies": 4,
    "expiring_policies": 1,
    "portfolio_summary": {
      "total_policies": 5,
      "upcoming_installments": 2,
      "renewal_policies": 1
    }
  }
}
```

---

### 2.2 Get Upcoming Installments
**Endpoint:** `GET /customer/upcoming_installments`

**Description:** Get all upcoming payment installments within next 60 days

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "upcoming_installments": [
      {
        "id": 1,
        "insurance_name": "Health Insurance",
        "insurance_type": "Health",
        "policy_number": "POL123456",
        "policy_holder": "Self",
        "insurance_company": "HDFC ERGO",
        "start_date": "2024-01-01",
        "end_date": "2025-01-01",
        "total_premium": 25000,
        "payment_mode": "Quarterly",
        "next_installment_date": "2024-04-01",
        "installment_amount": 6250,
        "days_until_installment": 7,
        "days_left_from_today": 7,
        "label": "Expiring in 7 days",
        "installment_type": "regular",
        "is_expired": false,
        "is_overdue": false,
        "document": "https://example.com/policy.pdf"
      }
    ],
    "total_installments": 3,
    "total_amount": 18750,
    "next_7_days": 1,
    "next_30_days": 2,
    "next_60_days": 3,
    "regular_installments": 2,
    "renewal_installments": 1,
    "overdue_installments": 0,
    "expired_policies": 0,
    "active_policies": 3,
    "next_installment": {...}  // Most urgent installment
  }
}
```

**Labels Explained:**
- `"Expired"` - Payment is overdue
- `"Expiring in X days"` - Due within 7 days
- `"Coming soon"` - Due within 30 days
- `"Upcoming"` - Due after 30 days

---

### 2.3 Get Upcoming Renewals
**Endpoint:** `GET /customer/upcoming_renewals`

**Description:** Get all policies requiring renewal within next 60 days

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "upcoming_renewals": [
      {
        "id": 1,
        "insurance_name": "Motor Insurance",
        "insurance_type": "Motor",
        "policy_number": "MOT123456",
        "policy_holder": "Self",
        "start_date": "2023-02-01",
        "end_date": "2024-02-01",
        "renewal_date": "2024-02-02",
        "total_premium": 15000,
        "sum_insured": 500000,
        "payment_mode": "Yearly",
        "days_until_renewal": 15,
        "renewal_status": "due_soon",
        "is_expired": false,
        "days_since_expiry": null,
        "insurance_company": "Bajaj Allianz",
        "document": "https://example.com/policy.pdf",
        "vehicle_number": "MH01AB1234",
        "vehicle_make": "Honda",
        "vehicle_model": "City"
      }
    ],
    "total_renewals": 2,
    "urgent_renewals": 0,
    "due_soon": 1,
    "approaching": 1,
    "upcoming": 0,
    "overdue": 0,
    "active_policies": 2,
    "expired_policies": 0,
    "customer_id": 123,
    "customer_name": "John Doe",
    "has_policies": true,
    "by_insurance_type": {
      "health": 0,
      "life": 0,
      "motor": 1,
      "travel": 0,
      "general": 1,
      "other": 0
    },
    "summary": {
      "next_7_days": 0,
      "next_30_days": 1,
      "next_60_days": 2,
      "overdue_count": 0,
      "total_premium_due": 35000,
      "most_urgent": {...},
      "insurance_types_covered": ["Motor", "General"]
    }
  }
}
```

**Renewal Status Values:**
- `urgent` - Expiring within 7 days
- `due_soon` - Expiring within 30 days
- `approaching` - Expiring within 60 days
- `upcoming` - Expiring after 60 days
- `overdue` - Already expired

---

### 2.4 Add Policy Request
**Endpoint:** `POST /customer/add_policy`

**Description:** Submit a new policy request for admin review

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "insurance_type": "health",  // health, life
  "plan_name": "Family Health Plan",
  "sum_insured": 500000,
  "premium_amount": 25000,  // or "premium amount"
  "renewal_date": "2025-01-15",  // or "Renewal date"
  "policy_number": "POL123456",  // Optional
  "insurance_company": "HDFC ERGO",  // Optional
  "remarks": "Need coverage for family of 4",
  "product_through_dr": true,  // or "product_through_dr_wise"
  "family_members": ["Spouse", "Child 1", "Child 2"]  // For health insurance
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Policy request submitted successfully! Our team will review your request and contact you within 24 hours.",
  "data": {
    "policy_id": 123,
    "policy_number": "REQ-1234567890",
    "insurance_type": "health",
    "plan_name": "Family Health Plan",
    "sum_insured": 500000,
    "premium_amount": 25000,
    "renewal_date": "2025-01-15",
    "product_through_dr": true,
    "status": "pending_approval",
    "family_members": ["Spouse", "Child 1", "Child 2"],
    "remarks": "Need coverage for family of 4",
    "submitted_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## 3. Agent APIs

### 3.1 Agent Dashboard
**Endpoint:** `GET /agent/dashboard`

**Description:** Get agent dashboard statistics

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "total_commission": 125000,
    "current_month_commission": 25000,
    "total_customers": 45,
    "total_policies": 78,
    "pending_leads": 12,
    "conversion_rate": "68%",
    "monthly_target": 75000,
    "achievement_percentage": 33.33,
    "recent_policies": [...],
    "commission_breakdown": {
      "health": 50000,
      "life": 45000,
      "motor": 30000
    }
  }
}
```

---

### 3.2 Get Customers
**Endpoint:** `GET /agent/customers`

**Description:** Get all customers associated with the agent

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Query Parameters:**
- `page` - Page number (default: 1)
- `per_page` - Items per page (default: 20)
- `search` - Search by name, email, or mobile

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "customers": [
      {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "mobile": "9876543210",
        "customer_type": "individual",
        "total_policies": 3,
        "total_premium": 75000,
        "created_at": "2024-01-01"
      }
    ],
    "total": 45,
    "page": 1,
    "per_page": 20
  }
}
```

---

### 3.3 Add Customer
**Endpoint:** `POST /agent/customers`

**Description:** Add a new customer

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "customer_type": "individual",  // individual, corporate
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "mobile": "9876543210",
  "pan_number": "ABCDE1234F",
  "aadhar_number": "123456789012",
  "date_of_birth": "1990-01-15",
  "gender": "Male",
  "address": "123 Main Street",
  "city": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400001"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Customer added successfully",
  "data": {
    "customer_id": 123,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

---

### 3.4 Get Policies
**Endpoint:** `GET /agent/policies`

**Description:** Get all policies created by the agent

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Query Parameters:**
- `type` - Filter by insurance type (health, life, motor, other)
- `status` - Filter by status (active, expired, pending)
- `customer_id` - Filter by customer

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "policies": [
      {
        "id": 1,
        "policy_number": "POL123456",
        "insurance_type": "health",
        "customer_name": "John Doe",
        "sum_insured": 500000,
        "premium": 25000,
        "commission": 5000,
        "status": "active",
        "start_date": "2024-01-01",
        "end_date": "2025-01-01"
      }
    ],
    "total": 78,
    "total_commission": 125000
  }
}
```

---

### 3.5 Add Health Policy
**Endpoint:** `POST /agent/policies/health`

**Description:** Create a new health insurance policy

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "customer_id": 123,
  "policy_holder": "Self",
  "plan_name": "Family Floater",
  "insurance_company_name": "HDFC ERGO",
  "insurance_type": "Family Floater",
  "policy_type": "New",
  "policy_number": "HDFC123456",
  "policy_booking_date": "2024-01-15",
  "policy_start_date": "2024-01-15",
  "policy_end_date": "2025-01-14",
  "payment_mode": "Yearly",
  "sum_insured": 500000,
  "net_premium": 21186,
  "gst_percentage": 18,
  "total_premium": 25000,
  "main_agent_commission_percentage": 20,
  "sub_agent_commission_percentage": 3,
  "family_members": [
    {
      "name": "Jane Doe",
      "relationship": "Spouse",
      "age": 35,
      "date_of_birth": "1989-05-20"
    }
  ]
}
```

---

### 3.6 Add Life Policy
**Endpoint:** `POST /agent/policies/life`

**Description:** Create a new life insurance policy

**Request Body:**
```json
{
  "customer_id": 123,
  "policy_holder": "Self",
  "plan_name": "Term Life Plan",
  "insurance_company_name": "LIC",
  "policy_type": "New",
  "policy_number": "LIC789012",
  "policy_booking_date": "2024-01-15",
  "policy_start_date": "2024-01-15",
  "policy_end_date": "2044-01-14",
  "payment_mode": "Yearly",
  "policy_term": 20,
  "premium_payment_term": 15,
  "sum_insured": 5000000,
  "net_premium": 42373,
  "first_year_gst_percentage": 18,
  "total_premium": 50000,
  "nominee_name": "Jane Doe",
  "nominee_relationship": "Spouse",
  "nominee_age": 35
}
```

---

### 3.7 Add Motor Policy
**Endpoint:** `POST /agent/policies/motor`

**Description:** Create a new motor insurance policy

**Request Body:**
```json
{
  "customer_id": 123,
  "policy_holder": "Self",
  "insurance_company_name": "Bajaj Allianz",
  "policy_type": "New",
  "policy_number": "BAJ456789",
  "vehicle_number": "MH01AB1234",
  "vehicle_make": "Honda",
  "vehicle_model": "City",
  "vehicle_type": "Car",
  "engine_number": "ENG123456",
  "chassis_number": "CHS789012",
  "mfy": "2020",
  "seating_capacity": 5,
  "policy_start_date": "2024-01-15",
  "policy_end_date": "2025-01-14",
  "idv_amount": 500000,
  "net_od_premium": 8475,
  "net_tp_premium": 3000,
  "gst_percentage": 18,
  "total_premium": 13500,
  "ncb": 20,
  "zero_depreciation": true,
  "roadside_assistance": true
}
```

---

### 3.8 Get Form Data
**Endpoint:** `GET /agent/form_data`

**Description:** Get dropdown data for policy forms

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "customers": [
      {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com"
      }
    ],
    "insurance_companies": [
      {
        "id": 1,
        "name": "HDFC ERGO"
      }
    ],
    "payment_modes": [
      "Monthly",
      "Quarterly",
      "Half Yearly",
      "Yearly"
    ],
    "policy_types": [
      "New",
      "Renewal",
      "Port"
    ]
  }
}
```

---

### 3.9 Get Insurance Companies
**Endpoint:** `GET /agent/insurance_companies`

**Description:** Get list of insurance companies

**Query Parameters:**
- `type` - Filter by insurance type (health, life, motor)

---

### 3.10 Get Leads
**Endpoint:** `GET /agent/leads`

**Description:** Get all leads assigned to the agent

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Query Parameters:**
- `status` - Filter by status (new, contacted, qualified, converted, lost)
- `priority` - Filter by priority (hot, warm, cold)

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "leads": [
      {
        "id": 1,
        "lead_id": "LEAD123456",
        "name": "John Doe",
        "mobile": "9876543210",
        "email": "john@example.com",
        "product_category": "insurance",
        "product_subcategory": "health",
        "current_stage": "contacted",
        "priority": "hot",
        "created_date": "2024-01-15",
        "notes": "Interested in family health insurance"
      }
    ],
    "total": 12,
    "by_status": {
      "new": 3,
      "contacted": 5,
      "qualified": 2,
      "converted": 1,
      "lost": 1
    }
  }
}
```

---

### 3.11 Add Lead
**Endpoint:** `POST /agent/leads`

**Description:** Create a new lead

**Request Body:**
```json
{
  "name": "John Doe",
  "mobile": "9876543210",
  "email": "john@example.com",
  "product_category": "insurance",
  "product_subcategory": "health",
  "priority": "hot",
  "notes": "Looking for family health insurance, budget 25k"
}
```

---

### 3.12 Get Commission Distribution
**Endpoint:** `GET /agent/commission_distribution`

**Description:** Get detailed commission distribution

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "total_commission": 125000,
    "by_insurance_type": {
      "health": 50000,
      "life": 45000,
      "motor": 30000
    },
    "by_month": {
      "2024-01": 25000,
      "2023-12": 20000,
      "2023-11": 18000
    },
    "pending_payouts": 15000,
    "paid_commission": 110000
  }
}
```

---

### 3.13 Get Commission Summary
**Endpoint:** `GET /agent/commission_summary`

**Description:** Get commission summary with filters

**Query Parameters:**
- `from_date` - Start date (YYYY-MM-DD)
- `to_date` - End date (YYYY-MM-DD)
- `insurance_type` - Filter by type

---

## 4. Settings APIs

### 4.1 Get Profile
**Endpoint:** `GET /settings/profile`

**Description:** Get user profile information

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "user_id": 123,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "role": "customer",
    "pan_number": "ABCDE1234F",
    "aadhar_number": "123456789012",
    "address": "123 Main Street",
    "city": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400001",
    "date_of_birth": "1990-01-15",
    "gender": "Male",
    "created_at": "2024-01-01"
  }
}
```

---

### 4.2 Update Profile
**Endpoint:** `PUT /settings/profile`

**Description:** Update user profile information

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "mobile": "9876543210",
  "address": "456 New Street",
  "city": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400002"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user_id": 123,
    "updated_fields": ["address", "pincode"]
  }
}
```

---

### 4.3 Change Password
**Endpoint:** `POST /settings/change_password`

**Description:** Change user password

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "current_password": "oldPassword123",
  "new_password": "newSecurePassword456",
  "password_confirmation": "newSecurePassword456"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

### 4.4 Get Terms and Conditions
**Endpoint:** `GET /settings/terms`

**Description:** Get terms and conditions

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "title": "Terms and Conditions",
    "content": "Full terms and conditions text...",
    "version": "1.0",
    "last_updated": "2024-01-01"
  }
}
```

---

### 4.5 Contact Us
**Endpoint:** `GET /settings/contact`

**Description:** Get contact information

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "support_email": "support@insurebook.com",
    "support_phone": "+91-1234567890",
    "office_address": "123 Business Park, Mumbai, Maharashtra 400001",
    "working_hours": "Monday to Friday, 9:00 AM to 6:00 PM IST"
  }
}
```

---

### 4.6 Submit Helpdesk Ticket
**Endpoint:** `POST /settings/helpdesk`

**Description:** Submit a support ticket

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "subject": "Unable to view policy document",
  "category": "technical",  // technical, policy, payment, general
  "priority": "high",  // low, medium, high, urgent
  "description": "I cannot download my health insurance policy document",
  "policy_number": "POL123456"  // Optional
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Support ticket created successfully",
  "data": {
    "ticket_id": "TICK123456",
    "status": "open",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

### 4.7 Get Notification Settings
**Endpoint:** `GET /settings/notifications`

**Description:** Get notification preferences

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "email_notifications": true,
    "sms_notifications": true,
    "push_notifications": true,
    "notification_types": {
      "policy_expiry": true,
      "payment_reminders": true,
      "promotional": false,
      "newsletter": true
    }
  }
}
```

---

### 4.8 Update Notification Settings
**Endpoint:** `PUT /settings/notifications`

**Description:** Update notification preferences

**Headers Required:**
```
Authorization: Bearer {{token}}
```

**Request Body:**
```json
{
  "email_notifications": true,
  "sms_notifications": false,
  "push_notifications": true,
  "notification_types": {
    "policy_expiry": true,
    "payment_reminders": true,
    "promotional": false,
    "newsletter": false
  }
}
```

---

## Error Responses

All APIs follow a standard error response format:

```json
{
  "success": false,
  "message": "Error description",
  "errors": ["Detailed error 1", "Detailed error 2"],  // Optional
  "error_code": "ERROR_CODE"  // Optional
}
```

### Common HTTP Status Codes:
- **200** - Success
- **400** - Bad Request (validation errors)
- **401** - Unauthorized (invalid/missing token)
- **403** - Forbidden (insufficient permissions)
- **404** - Resource Not Found
- **409** - Conflict (duplicate resource)
- **422** - Unprocessable Entity
- **500** - Internal Server Error

---

## Authentication Flow

1. **Register** (if new user) → Get confirmation
2. **Login** → Receive JWT token
3. **Include token** in all subsequent requests
4. **Token expiry**: 30 days
5. **Refresh**: Login again when token expires

---

## Rate Limiting

- **Default**: 100 requests per minute per IP
- **Login/Register**: 5 attempts per 5 minutes
- **Password Reset**: 3 attempts per hour

---

## Best Practices

1. **Always validate** response `success` field
2. **Store token securely** on client side
3. **Handle token expiry** gracefully
4. **Implement retry logic** for network failures
5. **Use HTTPS** in production
6. **Validate inputs** before sending requests
7. **Handle errors** appropriately in UI

---

## Testing Environment

**Base URL for Testing:**
```
https://dr-wise-ag.onrender.com/api/v1/mobile
```

**Test Credentials:**
```
Customer:
Email: customer@test.com
Password: Test@123

Agent:
Email: agent@test.com
Password: Test@123
```

---

## Support

For API support, contact:
- Email: api-support@insurebook.com
- Documentation: https://api-docs.insurebook.com
- Status Page: https://status.insurebook.com