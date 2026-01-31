# CRUD Permissions System Guide

## Overview
The enhanced user sidebar feature now includes granular CRUD (Create, Read, Update, Delete) permissions for each module. Admins can control exactly what actions users can perform within each section of the application.

## Features

### 1. Permission Types
- **View (Read)**: User can see and access the module
- **Create**: User can add new records
- **Edit (Update)**: User can modify existing records
- **Delete**: User can remove records

### 2. Permission Rules
- **View is Required**: If View is not checked, all other permissions are disabled
- **Hierarchical Control**: Create, Edit, and Delete require View permission to be enabled
- **All Checkbox**: Quick select/deselect all permissions for a module

### 3. Super Admin Access
- `admin@drwise.com` always has full access to everything
- Regular admins without a specific role assignment also have full access
- Users with assigned roles (Data Entry, Tele Calling, Accounts) have restricted access based on their permissions

## Implementation

### Files Modified/Created

1. **Views**:
   - `/app/views/admin/settings/user_roles/new.html.erb` - Create user with CRUD permissions
   - `/app/views/admin/settings/user_roles/edit.html.erb` - Edit user with CRUD permissions
   - `/app/views/admin/customers/index.html.erb` - Example implementation with permission checks

2. **Controllers**:
   - `/app/controllers/admin/settings/user_roles_controller.rb` - Handles CRUD permission storage
   - `/app/controllers/application_controller.rb` - Includes permissions helper

3. **Helpers**:
   - `/app/helpers/permissions_helper.rb` - Core permission checking logic

## Usage in Views

### Checking Permissions
```erb
<!-- Check if user can create -->
<% if can_create?('customers') %>
  <%= link_to "Add New", new_admin_customer_path, class: "btn btn-primary" %>
<% end %>

<!-- Check if user can edit -->
<% if can_edit?('customers') %>
  <%= link_to "Edit", edit_admin_customer_path(customer), class: "btn btn-warning" %>
<% end %>

<!-- Check if user can delete -->
<% if can_delete?('customers') %>
  <%= button_to "Delete", admin_customer_path(customer), method: :delete, class: "btn btn-danger" %>
<% end %>

<!-- Check if user can view -->
<% if can_view?('customers') %>
  <%= link_to "View", admin_customer_path(customer), class: "btn btn-info" %>
<% end %>
```

### Available Helper Methods
- `can_view?(module_key)` - Check if user can view/read
- `can_create?(module_key)` - Check if user can create
- `can_edit?(module_key)` - Check if user can edit/update
- `can_delete?(module_key)` - Check if user can delete
- `has_any_permission?(module_key)` - Check if user has any permission for the module
- `is_super_admin?` - Check if user is a super admin

## Module Keys

The following module keys are available for permission control:

### Main Menu
- `dashboard` - Dashboard
- `analytics` - Analytics
- `leads` - Leads
- `customers` - Clients
- `sub_agents` - Affiliates
- `distributors` - Ambassadors

### Services
- `life_insurance` - Life Insurance
- `health_insurance` - Health Insurance
- `motor_insurance` - Motor Insurance
- `other_insurance` - General Insurance

### Vendor
- `brokers` - Broker
- `agency_codes` - Agency Code

### Payouts
- `payouts` - Commissions
- `affiliate_payouts` - Affiliate Payout
- `distributor_payouts` - Ambassador Payout

### Transactions
- `invoices` - Invoices

### Reports & Analytics
- `reports` - Commission Report
- `all_policy_reports` - All Policy Reports
- `expired_insurance_reports` - Expired Insurance
- `upcoming_renewal_reports` - Upcoming Renewal
- `lead_reports` - Lead Reports

### Management
- `investors` - Investors
- `client_requests` - Client Request
- `banners` - Banner Management
- `insurance_companies` - Companies
- `management` - Import Data

### Settings
- `settings` - System Settings

## Data Storage

Permissions are stored in the `sidebar_permissions` column of the `users` table as JSON:

### New CRUD Format:
```json
{
  "customers": {
    "view": true,
    "create": true,
    "edit": false,
    "delete": false
  },
  "leads": {
    "view": true,
    "create": false,
    "edit": false,
    "delete": false
  }
}
```

### Legacy Format (Backward Compatible):
```json
["customers", "leads", "reports"]
```
Legacy format is treated as view-only permissions.

## Controller Implementation

To implement permission checks in controllers:

```ruby
class Admin::CustomersController < ApplicationController
  before_action :check_view_permission, only: [:index, :show]
  before_action :check_create_permission, only: [:new, :create]
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_delete_permission, only: [:destroy]

  private

  def check_view_permission
    unless can_view?('customers')
      redirect_to root_path, alert: 'You do not have permission to view customers'
    end
  end

  def check_create_permission
    unless can_create?('customers')
      redirect_to admin_customers_path, alert: 'You do not have permission to create customers'
    end
  end

  def check_edit_permission
    unless can_edit?('customers')
      redirect_to admin_customers_path, alert: 'You do not have permission to edit customers'
    end
  end

  def check_delete_permission
    unless can_delete?('customers')
      redirect_to admin_customers_path, alert: 'You do not have permission to delete customers'
    end
  end
end
```

## Testing

Test users created:
1. **admin@drwise.com** - Super admin with full access
2. **test_limited@example.com** - Limited CRUD permissions (Password: Test@123)
3. **old_format@example.com** - Backward compatible view-only (Password: Test@123)

## Notes

- The system is backward compatible with the old array-based permission format
- Old format permissions are treated as view-only access
- Super admins bypass all permission checks
- Permissions are checked both in views (UI) and controllers (backend) for security