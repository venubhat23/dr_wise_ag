# InsureBook Application - Complete Test Scenarios Documentation
## Gherkin Format Test Cases - Module Wise

---

## Table of Contents
1. [User Authentication Module](#1-user-authentication-module)
2. [Customer Management Module](#2-customer-management-module)
3. [Health Insurance Module](#3-health-insurance-module)
4. [Life Insurance Module](#4-life-insurance-module)
5. [Motor Insurance Module](#5-motor-insurance-module)
6. [Other/General Insurance Module](#6-othergeneral-insurance-module)
7. [Sub-Agent Management Module](#7-sub-agent-management-module)
8. [Commission & Payout Module](#8-commission--payout-module)
9. [Lead Management Module](#9-lead-management-module)
10. [Reports & Analytics Module](#10-reports--analytics-module)
11. [Document Management Module](#11-document-management-module)
12. [Notification Module](#12-notification-module)

---

## 1. User Authentication Module

### Feature: User Login
```gherkin
Feature: User Authentication and Login
  As a user of InsureBook
  I want to securely log into the system
  So that I can access my authorized features

  Background:
    Given the InsureBook application is running
    And I am on the login page

  Scenario: Successful login with valid credentials
    Given I have a valid username "admin@insurebook.com"
    And I have a valid password "Admin@123"
    When I enter my username
    And I enter my password
    And I click the "Sign In" button
    Then I should be redirected to the dashboard
    And I should see a welcome message "Welcome, Admin"
    And my session should be active

  Scenario: Failed login with invalid credentials
    Given I enter username "invalid@user.com"
    And I enter password "wrongpassword"
    When I click the "Sign In" button
    Then I should see an error message "Invalid email or password"
    And I should remain on the login page
    And no session should be created

  Scenario: Login attempt with empty fields
    Given I leave the username field empty
    And I leave the password field empty
    When I click the "Sign In" button
    Then I should see validation errors
    And I should see "Email can't be blank"
    And I should see "Password can't be blank"

  Scenario: Password reset request
    Given I click on "Forgot your password?"
    When I enter my email "user@insurebook.com"
    And I click "Send reset instructions"
    Then I should see "You will receive password reset instructions"
    And a password reset email should be sent

  Scenario: Session timeout
    Given I am logged into the system
    And my session has been idle for 30 minutes
    When I try to perform any action
    Then I should be redirected to login page
    And I should see "Your session has expired"

  Scenario: Remember me functionality
    Given I enter valid credentials
    And I check the "Remember me" checkbox
    When I click the "Sign In" button
    And I close the browser
    And I reopen the browser within 7 days
    Then I should still be logged in
```

### Feature: User Logout
```gherkin
Feature: User Logout
  As a logged-in user
  I want to safely logout from the system
  So that my session is terminated securely

  Scenario: Successful logout
    Given I am logged into InsureBook
    When I click on the "Logout" button
    Then I should be redirected to the login page
    And I should see "Signed out successfully"
    And my session should be terminated
    And I should not be able to access protected pages
```

### Feature: User Role Management
```gherkin
Feature: User Role-Based Access Control
  As an administrator
  I want to manage user roles and permissions
  So that users can only access authorized features

  Scenario: Admin user access
    Given I am logged in as an "Admin" user
    When I navigate to any module
    Then I should have full access to all features
    And I should see all menu items
    And I should be able to perform CRUD operations

  Scenario: Agent user access
    Given I am logged in as an "Agent" user
    When I navigate to the dashboard
    Then I should only see agent-specific menu items
    And I should not see admin settings
    And I should not be able to access user management

  Scenario: Customer user access
    Given I am logged in as a "Customer" user
    When I navigate to the dashboard
    Then I should only see my policies
    And I should not see other customers' data
    And I should not have access to agent features
```

---

## 2. Customer Management Module

### Feature: Customer Creation
```gherkin
Feature: Customer Registration and Management
  As an admin or agent
  I want to manage customer information
  So that I can maintain accurate customer records

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Customer Management page

  Scenario: Create new individual customer
    Given I click on "Add New Customer"
    When I select customer type as "Individual"
    And I enter the following details:
      | Field            | Value                |
      | First Name       | John                 |
      | Last Name        | Doe                  |
      | Email            | john.doe@email.com   |
      | Mobile           | 9876543210           |
      | Date of Birth    | 01/01/1990          |
      | PAN Number       | ABCDE1234F          |
      | Aadhaar Number   | 123456789012        |
      | Address          | 123 Main Street      |
      | City             | Mumbai               |
      | State            | Maharashtra          |
      | Pincode          | 400001              |
    And I click "Create Customer"
    Then a new customer should be created
    And I should see "Customer created successfully"
    And the customer should appear in the customer list

  Scenario: Create new corporate customer
    Given I click on "Add New Customer"
    When I select customer type as "Corporate"
    And I enter the following details:
      | Field            | Value                |
      | Company Name     | ABC Corporation      |
      | GSTIN            | 27AABCU9603R1ZM     |
      | Email            | info@abccorp.com    |
      | Mobile           | 9876543210          |
      | Address          | Business Park       |
      | City             | Bangalore           |
      | State            | Karnataka           |
      | Pincode          | 560001             |
    And I click "Create Customer"
    Then a new corporate customer should be created
    And the GSTIN should be validated
    And I should see "Corporate customer created successfully"

  Scenario: Duplicate customer prevention
    Given a customer exists with email "existing@email.com"
    When I try to create a new customer with same email
    Then I should see an error "Email has already been taken"
    And the customer should not be created

  Scenario: Customer search functionality
    Given there are 100 customers in the system
    When I search for "John" in the search box
    Then I should see all customers with "John" in their name
    And the results should be paginated
    And I should see the total count of results

  Scenario: Edit customer information
    Given I select an existing customer "John Doe"
    When I click "Edit"
    And I update the mobile number to "9988776655"
    And I click "Update Customer"
    Then the customer information should be updated
    And I should see "Customer updated successfully"

  Scenario: Add family members to customer
    Given I am viewing customer "John Doe"
    When I click "Add Family Member"
    And I enter family member details:
      | Field            | Value                |
      | Name             | Jane Doe            |
      | Relationship     | Spouse              |
      | Date of Birth    | 15/03/1992         |
      | Mobile           | 9876543211         |
    And I click "Save Family Member"
    Then the family member should be added
    And I should see the family member in the list
```

### Feature: Customer Document Management
```gherkin
Feature: Customer Document Upload and Management
  As an admin or agent
  I want to manage customer documents
  So that all required documents are properly stored

  Scenario: Upload customer documents
    Given I am viewing customer "John Doe"
    When I click "Documents" tab
    And I upload the following documents:
      | Document Type    | File Name           |
      | PAN Card        | pan_card.pdf        |
      | Aadhaar Card    | aadhaar.pdf         |
      | Photo           | photo.jpg           |
    Then the documents should be uploaded
    And I should see all documents in the list
    And I should be able to download each document

  Scenario: Delete customer document
    Given a customer has uploaded documents
    When I click "Delete" on a document
    And I confirm the deletion
    Then the document should be removed
    And I should see "Document deleted successfully"
```

---

## 3. Health Insurance Module

### Feature: Health Insurance Policy Creation
```gherkin
Feature: Health Insurance Policy Management
  As an insurance agent
  I want to create and manage health insurance policies
  So that customers can have proper health coverage

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Health Insurance page

  Scenario: Create new health insurance policy
    Given I click "New Health Insurance"
    When I select customer "John Doe"
    And I enter policy details:
      | Field                    | Value                |
      | Policy Holder            | Self                 |
      | Insurance Company        | Star Health          |
      | Policy Type              | New                  |
      | Insurance Type           | Family Floater       |
      | Policy Number            | HEALTH-2024-001      |
      | Policy Booking Date      | 27/01/2024          |
      | Policy Start Date        | 01/02/2024          |
      | Policy End Date          | 31/01/2025          |
      | Payment Mode             | Yearly               |
      | Sum Insured              | 500000              |
      | Net Premium              | 25000               |
      | GST Percentage           | 18                  |
      | Total Premium            | 29500               |
      | Main Agent Commission %  | 15                  |
      | Sub Agent Commission %   | 3                   |
    And I add family members to the policy:
      | Member Name    | Age | Relationship |
      | Jane Doe      | 32  | Spouse       |
      | Jack Doe      | 8   | Son          |
    And I click "Create Health Insurance"
    Then a new health insurance policy should be created
    And commission payouts should be calculated automatically
    And I should see "Health insurance policy created successfully"

  Scenario: Health insurance policy renewal
    Given there is an existing policy expiring in 30 days
    When I click "Renew" on the policy
    Then I should see the renewal form pre-filled
    And the new policy start date should be next day of expiry
    And the policy type should be set to "Renewal"
    When I update the premium if needed
    And I click "Create Renewal Policy"
    Then a renewal policy should be created
    And the old policy should be marked as renewed

  Scenario: Health insurance with medical conditions
    Given I am creating a new health insurance
    When I add pre-existing diseases:
      | Disease          | Since Year |
      | Diabetes         | 2020       |
      | Hypertension     | 2018       |
    Then the premium should be calculated with loading
    And the policy should record medical conditions

  Scenario: Bulk health insurance upload
    Given I click "Bulk Upload"
    When I upload a CSV file with 50 health policies
    Then the system should validate all entries
    And show validation errors if any
    And successfully create valid policies
    And generate a report of uploaded policies

  Scenario: Health insurance claim tracking
    Given a health insurance policy exists
    When I click "Add Claim"
    And I enter claim details:
      | Field              | Value              |
      | Claim Number       | CLM-2024-001      |
      | Claim Date         | 15/01/2024        |
      | Hospital Name      | Apollo Hospital   |
      | Claim Amount       | 150000            |
      | Status             | Under Process     |
    Then the claim should be recorded
    And claim history should be maintained
```

---

## 4. Life Insurance Module

### Feature: Life Insurance Policy Management
```gherkin
Feature: Life Insurance Policy Creation and Management
  As an insurance agent
  I want to manage life insurance policies
  So that customers have life coverage

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Life Insurance page

  Scenario: Create term life insurance policy
    Given I click "New Life Insurance"
    When I select customer "John Doe"
    And I select policy type as "Term Life"
    And I enter policy details:
      | Field                    | Value                |
      | Insurance Company        | LIC                  |
      | Policy Number            | LIFE-2024-001        |
      | Policy Start Date        | 01/02/2024          |
      | Policy Term              | 20 years            |
      | Sum Assured              | 10000000            |
      | Annual Premium           | 50000               |
      | Payment Frequency        | Yearly              |
      | Nominee Name            | Jane Doe            |
      | Nominee Relationship    | Spouse              |
      | Nominee Percentage      | 100                 |
    And I click "Create Life Insurance"
    Then a new term life policy should be created
    And nominee details should be saved
    And commission should be calculated

  Scenario: Create ULIP policy
    Given I click "New Life Insurance"
    When I select policy type as "ULIP"
    And I enter ULIP specific details:
      | Field                | Value           |
      | Fund Type           | Equity          |
      | Investment Amount   | 100000          |
      | Lock-in Period     | 5 years         |
      | Expected Returns   | 12%             |
    Then ULIP policy should be created
    And fund allocation should be recorded

  Scenario: Life insurance maturity tracking
    Given there are life insurance policies
    When I view the maturity report
    Then I should see policies grouped by maturity year
    And I should see maturity amounts
    And I should be able to notify customers

  Scenario: Life insurance premium reminders
    Given a life insurance policy with monthly premium
    When the premium due date is in 7 days
    Then the system should generate a reminder
    And the customer should be notified
    And the agent should see in their dashboard

  Scenario: Life insurance surrender
    Given an existing life insurance policy
    When I click "Surrender Policy"
    And I enter surrender details:
      | Field              | Value         |
      | Surrender Date    | 01/01/2024    |
      | Surrender Value   | 200000        |
      | Reason            | Financial Need |
    Then the policy should be marked as surrendered
    And surrender value should be recorded
```

---

## 5. Motor Insurance Module

### Feature: Motor Insurance Policy Management
```gherkin
Feature: Motor Insurance Policy Creation
  As an insurance agent
  I want to manage motor insurance policies
  So that vehicles are properly insured

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Motor Insurance page

  Scenario: Create comprehensive motor insurance
    Given I click "New Motor Insurance"
    When I select customer "John Doe"
    And I select insurance type as "Comprehensive"
    And I enter vehicle details:
      | Field                    | Value                |
      | Vehicle Type            | Car                  |
      | Make                    | Honda                |
      | Model                   | City                 |
      | Year                    | 2022                 |
      | Registration Number     | MH01AB1234           |
      | Engine Number           | ENG123456789         |
      | Chassis Number          | CHS123456789         |
      | IDV                     | 800000              |
    And I enter policy details:
      | Field                    | Value                |
      | Insurance Company        | ICICI Lombard        |
      | Policy Number            | MOTOR-2024-001       |
      | Policy Start Date        | 01/02/2024          |
      | Policy End Date          | 31/01/2025          |
      | OD Premium              | 25000               |
      | TP Premium              | 15000               |
      | NCB Percentage          | 20                  |
      | Total Premium           | 40000               |
    And I select add-ons:
      | Add-on                   |
      | Zero Depreciation        |
      | Engine Protector         |
      | Roadside Assistance      |
    And I click "Create Motor Insurance"
    Then a comprehensive motor policy should be created
    And NCB discount should be applied
    And add-ons should be included

  Scenario: Create third-party motor insurance
    Given I click "New Motor Insurance"
    When I select insurance type as "Third Party"
    And I enter basic vehicle details
    And I enter TP premium as "5000"
    Then only third-party coverage should be created
    And OD premium should be zero

  Scenario: Motor insurance renewal with NCB
    Given an existing motor policy with 20% NCB
    When I renew the policy
    And there were no claims last year
    Then NCB should increase to 25%
    And premium should be calculated with new NCB

  Scenario: Motor insurance claim affects NCB
    Given a motor policy with 35% NCB
    When a claim is registered
    Then on renewal NCB should reset to 0%
    And premium should increase accordingly

  Scenario: Fleet insurance management
    Given I am creating insurance for a corporate customer
    When I add multiple vehicles:
      | Registration | Type  | IDV     |
      | MH01AB1234  | Car   | 500000  |
      | MH01CD5678  | Car   | 600000  |
      | MH01EF9012  | Truck | 1500000 |
    Then a fleet policy should be created
    And fleet discount should be applied
    And individual vehicle cards should be generated
```

---

## 6. Other/General Insurance Module

### Feature: General Insurance Management
```gherkin
Feature: Other Insurance Policy Management
  As an insurance agent
  I want to manage various general insurance policies
  So that customers have comprehensive coverage

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Other Insurance page

  Scenario: Create travel insurance policy
    Given I click "New Other Insurance"
    When I select insurance type as "Travel Insurance"
    And I enter travel details:
      | Field                | Value              |
      | Destination         | Europe             |
      | Travel Start Date   | 15/02/2024        |
      | Travel End Date     | 28/02/2024        |
      | Number of Travelers | 2                 |
      | Coverage Amount     | $100000           |
      | Premium             | 5000              |
    And I add traveler details:
      | Name      | Age | Passport    |
      | John Doe  | 35  | P1234567   |
      | Jane Doe  | 32  | P7654321   |
    Then travel insurance should be created
    And policy period should match travel dates

  Scenario: Create property insurance
    Given I click "New Other Insurance"
    When I select insurance type as "Property Insurance"
    And I enter property details:
      | Field              | Value           |
      | Property Type     | Residential     |
      | Property Value    | 10000000       |
      | Built-up Area     | 2000 sq ft     |
      | Construction Type | RCC            |
      | Coverage Type     | Building + Contents |
      | Sum Insured       | 12000000       |
    Then property insurance should be created
    And coverage details should be recorded

  Scenario: Create cyber insurance
    Given I click "New Other Insurance"
    When I select insurance type as "Cyber Insurance"
    And I select customer type as "Corporate"
    And I enter cyber coverage details:
      | Field                  | Value        |
      | Business Type         | IT Services  |
      | Annual Revenue        | 50000000    |
      | Number of Employees   | 100         |
      | Coverage Limit        | 10000000    |
      | Data Breach Coverage  | Yes         |
    Then cyber insurance should be created

  Scenario: Professional indemnity insurance
    Given I click "New Other Insurance"
    When I select insurance type as "Professional Indemnity"
    And I enter professional details:
      | Field              | Value          |
      | Profession        | Doctor         |
      | Specialization    | Surgeon        |
      | Coverage Amount   | 20000000      |
      | Retroactive Date  | 01/01/2020    |
    Then professional indemnity should be created
```

---

## 7. Sub-Agent Management Module

### Feature: Sub-Agent Registration and Management
```gherkin
Feature: Sub-Agent Management
  As an administrator
  I want to manage sub-agents
  So that they can sell policies and earn commissions

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Sub-Agent Management page

  Scenario: Register new sub-agent
    Given I click "Add New Sub-Agent"
    When I enter sub-agent details:
      | Field              | Value              |
      | First Name        | Rajesh             |
      | Last Name         | Kumar              |
      | Email             | rajesh@agent.com   |
      | Mobile            | 9876543210         |
      | PAN Number        | AGENT1234F         |
      | Commission Rate   | 5%                 |
      | Status            | Active             |
    And I set login credentials:
      | Username          | rajesh.kumar       |
      | Password          | Agent@123          |
    And I click "Create Sub-Agent"
    Then a new sub-agent should be created
    And login credentials should be sent via email
    And the agent should appear in active agents list

  Scenario: Sub-agent hierarchy management
    Given there are existing sub-agents
    When I assign "Junior Agent" under "Senior Agent"
    Then the hierarchy should be established
    And commission splitting should be configured
    And reporting structure should be updated

  Scenario: Sub-agent performance tracking
    Given a sub-agent "Rajesh Kumar" exists
    When I view their performance dashboard
    Then I should see:
      | Metric                  |
      | Total Policies Sold     |
      | Total Premium Generated |
      | Commission Earned       |
      | Pending Commissions     |
      | Customer Satisfaction   |
      | Monthly Targets         |

  Scenario: Sub-agent commission configuration
    Given I am editing sub-agent "Rajesh Kumar"
    When I configure commission rates:
      | Insurance Type    | Commission % |
      | Health           | 15%          |
      | Life             | 35%          |
      | Motor            | 10%          |
      | General          | 12%          |
    Then custom commission rates should be saved
    And future policies should use these rates

  Scenario: Deactivate sub-agent
    Given an active sub-agent exists
    When I click "Deactivate"
    And I provide reason "Performance issues"
    Then the agent should be deactivated
    And they should not be able to login
    And their pending commissions should be frozen
```

---

## 8. Commission & Payout Module

### Feature: Commission Calculation and Payout
```gherkin
Feature: Commission Management and Payouts
  As an administrator
  I want to manage commissions and payouts
  So that agents receive correct compensation

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Commission Management page

  Scenario: Automatic commission calculation
    Given a new health insurance policy is created
    With premium of "100000"
    And main agent commission of "15%"
    And sub-agent commission of "3%"
    When the policy is saved
    Then main agent commission should be "15000"
    And sub-agent commission should be "3000"
    And TDS should be calculated if applicable
    And net payable should be computed

  Scenario: Commission payout processing
    Given there are pending commissions for the month
    When I click "Process Monthly Payouts"
    Then I should see list of agents with amounts
    And I can select agents for payout
    When I click "Generate Payout"
    Then payout records should be created
    And payment files should be generated
    And agents should be notified

  Scenario: Commission reconciliation
    Given commission payouts have been processed
    When I upload bank statement
    Then the system should match transactions
    And mark successful payments
    And flag failed transactions
    And generate reconciliation report

  Scenario: Commission dispute management
    Given an agent raises commission dispute
    When I review the dispute
    And I find calculation error
    And I approve adjustment of "5000"
    Then commission should be adjusted
    And audit trail should be maintained
    And agent should be notified

  Scenario: Commission report generation
    Given I navigate to commission reports
    When I select date range "01/01/2024" to "31/01/2024"
    And I click "Generate Report"
    Then I should see:
      | Report Data              |
      | Total Commission Paid    |
      | Agent-wise Breakdown     |
      | Product-wise Commission  |
      | TDS Deducted            |
      | Net Payments            |
    And I should be able to export to Excel
```

---

## 9. Lead Management Module

### Feature: Lead Generation and Management
```gherkin
Feature: Lead Management System
  As a sales team member
  I want to manage insurance leads
  So that I can convert them to policies

  Background:
    Given I am logged in as a "Sales Agent"
    And I am on the Lead Management page

  Scenario: Create new lead manually
    Given I click "Add New Lead"
    When I enter lead information:
      | Field              | Value              |
      | Name              | Potential Customer |
      | Contact Number    | 9876543210        |
      | Email             | lead@email.com    |
      | Product Interest  | Health Insurance  |
      | Source            | Website           |
      | Budget            | 50000             |
    And I click "Save Lead"
    Then a new lead should be created
    And lead ID should be generated
    And lead should be in "New" stage

  Scenario: Lead stage progression
    Given a lead in "New" stage exists
    When I call the customer
    And I update notes "Customer interested, sending quote"
    And I change stage to "Qualified"
    Then lead stage should be updated
    And activity should be logged
    And stage timestamp should be recorded

  Scenario: Convert lead to policy
    Given a qualified lead exists
    When I click "Convert to Policy"
    And I create a health insurance policy
    Then lead should be marked as "Converted"
    And policy should be linked to lead
    And conversion metrics should be updated

  Scenario: Lead assignment to agents
    Given multiple new leads exist
    When I select leads
    And I click "Assign to Agent"
    And I select "Rajesh Kumar"
    Then leads should be assigned
    And agent should receive notification
    And leads should appear in agent's dashboard

  Scenario: Lead follow-up reminders
    Given a lead requires follow-up today
    When I view my dashboard
    Then I should see follow-up reminder
    When I complete the follow-up
    And I set next follow-up date
    Then reminder should be rescheduled

  Scenario: Lead analytics dashboard
    Given there are 1000 leads in system
    When I view lead analytics
    Then I should see:
      | Metric                    |
      | Total Leads              |
      | Conversion Rate          |
      | Average Conversion Time  |
      | Source-wise Distribution |
      | Agent Performance        |
      | Stage Funnel            |
```

---

## 10. Reports & Analytics Module

### Feature: Reporting and Analytics
```gherkin
Feature: Business Reports and Analytics
  As a management user
  I want to generate various reports
  So that I can make informed decisions

  Background:
    Given I am logged in as an "Admin" user
    And I am on the Reports page

  Scenario: Generate sales report
    Given I select "Sales Report"
    When I set parameters:
      | Parameter        | Value       |
      | Start Date      | 01/01/2024  |
      | End Date        | 31/01/2024  |
      | Group By        | Daily       |
      | Product Type    | All         |
    And I click "Generate Report"
    Then I should see sales data including:
      | Data Point               |
      | Total Premium Collected  |
      | Number of Policies      |
      | Average Ticket Size     |
      | Product Mix            |
      | Daily Trends           |

  Scenario: Generate agent performance report
    Given I select "Agent Performance Report"
    When I select time period "Last Quarter"
    And I click "Generate"
    Then I should see for each agent:
      | Metric                  |
      | Policies Sold          |
      | Premium Generated      |
      | Commission Earned      |
      | Conversion Rate        |
      | Customer Satisfaction  |
    And I should be able to rank agents

  Scenario: Generate renewal forecast report
    Given I select "Renewal Forecast"
    When I select next "3 months"
    Then I should see policies due for renewal
    Grouped by:
      | Grouping        |
      | Month          |
      | Product Type   |
      | Premium Range  |
      | Agent         |
    And expected renewal premium

  Scenario: Customer analytics report
    Given I select "Customer Analytics"
    When I click "Generate"
    Then I should see:
      | Analytics              |
      | Customer Demographics  |
      | Product Preferences   |
      | Premium Distribution  |
      | Retention Rate       |
      | Lifetime Value       |
      | Geographic Distribution |

  Scenario: Export reports
    Given I have generated a report
    When I click "Export"
    And I select format "Excel"
    Then report should be downloaded
    With all data and formatting preserved

  Scenario: Schedule automated reports
    Given I click "Schedule Report"
    When I configure:
      | Setting          | Value              |
      | Report Type     | Monthly Sales      |
      | Frequency       | Monthly           |
      | Day            | 1st               |
      | Time           | 09:00 AM          |
      | Recipients     | admin@company.com  |
    Then report should be scheduled
    And should be sent automatically
```

---

## 11. Document Management Module

### Feature: Document Management System
```gherkin
Feature: Document Upload and Management
  As a user
  I want to manage policy documents
  So that all documents are organized and accessible

  Background:
    Given I am logged in as an authorized user
    And I am on the Document Management page

  Scenario: Upload policy documents
    Given I am viewing a policy
    When I click "Upload Documents"
    And I select document type "Policy Copy"
    And I choose file "policy.pdf"
    And I click "Upload"
    Then document should be uploaded
    And document should be virus scanned
    And document should be stored securely

  Scenario: Bulk document upload
    Given I have multiple documents
    When I drag and drop 10 files
    Then all files should be uploaded
    And progress should be shown
    And failed uploads should be reported

  Scenario: Document categorization
    Given documents are uploaded
    When I categorize them as:
      | Document         | Category      |
      | policy.pdf      | Policy Copy   |
      | pan.pdf         | KYC          |
      | medical.pdf     | Medical      |
    Then documents should be organized
    And searchable by category

  Scenario: Document expiry tracking
    Given KYC documents are uploaded
    When document expiry is set
    Then system should track expiry
    And send alerts 30 days before
    And mark expired documents

  Scenario: Document sharing
    Given a policy document exists
    When I click "Share"
    And I enter email "customer@email.com"
    And I set expiry "7 days"
    Then secure link should be generated
    And email should be sent
    And access should expire after 7 days
```

---

## 12. Notification Module

### Feature: Notification Management
```gherkin
Feature: System Notifications and Alerts
  As a system user
  I want to receive relevant notifications
  So that I stay informed about important events

  Background:
    Given I am logged in to the system
    And notification service is running

  Scenario: Premium due notification
    Given a policy premium is due in 7 days
    Then customer should receive SMS
    And customer should receive email
    And agent should see dashboard alert
    And notification should be logged

  Scenario: Policy expiry notification
    Given a policy expires in 30 days
    When daily notification job runs
    Then renewal reminder should be sent
    With renewal quote attached
    And easy renewal link

  Scenario: Commission credit notification
    Given commission is processed
    When payout is completed
    Then agent should receive notification
    With commission details
    And payment reference

  Scenario: Birthday wishes
    Given today is customer's birthday
    When notification scheduler runs
    Then birthday wish should be sent
    And agent should be reminded
    To make courtesy call

  Scenario: Document expiry alert
    Given KYC document expires in 15 days
    Then customer should be notified
    And agent should be alerted
    And follow-up task should be created

  Scenario: System maintenance notification
    Given maintenance is scheduled
    When maintenance window approaches
    Then all users should be notified
    With downtime duration
    And alternative contact info

  Scenario: Notification preferences
    Given I access notification settings
    When I configure:
      | Type          | Email | SMS | Push |
      | Premium Due   | Yes   | Yes | No   |
      | Policy Expiry | Yes   | No  | Yes  |
      | Promotions    | No    | No  | No   |
    Then preferences should be saved
    And notifications should follow preferences
```

---

## Test Execution Priority

### Priority 1 - Critical (Must Test)
1. User Authentication (Login/Logout)
2. Customer Creation
3. Policy Creation (All types)
4. Commission Calculation
5. Payment Processing

### Priority 2 - High (Important)
1. Policy Renewal
2. Document Upload
3. Report Generation
4. Lead Conversion
5. Sub-agent Management

### Priority 3 - Medium (Should Test)
1. Bulk Operations
2. Search Functionality
3. Notifications
4. Data Export
5. Analytics

### Priority 4 - Low (Nice to Have)
1. UI Responsiveness
2. Theme Preferences
3. Help Documentation
4. Audit Logs
5. Archive Features

---

## Test Data Requirements

### Master Data
- 10 Insurance Companies per type
- 50 Test Customers (Individual + Corporate)
- 20 Sub-agents with hierarchy
- 100 Test Policies per type
- 500 Leads in various stages

### Test Credentials
```
Admin User: admin@insurebook.com / Admin@123
Agent User: agent@insurebook.com / Agent@123
Customer: customer@insurebook.com / Customer@123
Manager: manager@insurebook.com / Manager@123
```

---

## Test Environment Setup

### Prerequisites
1. Ruby 3.2.0 installed
2. PostgreSQL database running
3. Redis server for caching
4. SMTP configured for emails
5. SMS gateway configured

### Database Seeding
```bash
rails db:seed RAILS_ENV=test
```

### Test Execution Commands
```bash
# Run all tests
bundle exec rspec

# Run specific module tests
bundle exec rspec spec/features/health_insurance_spec.rb

# Run with coverage report
COVERAGE=true bundle exec rspec
```

---

## Acceptance Criteria

### Definition of Done
- [ ] All test scenarios pass
- [ ] Code coverage > 80%
- [ ] No critical bugs
- [ ] Performance benchmarks met
- [ ] Security scan passed
- [ ] Documentation updated

### Performance Benchmarks
- Page load time < 2 seconds
- API response time < 500ms
- Bulk upload: 1000 records < 1 minute
- Report generation < 5 seconds
- Search results < 1 second

### Security Requirements
- All passwords encrypted
- Session timeout after 30 minutes
- HTTPS enforced
- SQL injection prevented
- XSS protection enabled
- CSRF tokens implemented

---

## Test Automation Framework

### Recommended Tools
- **BDD Framework**: Cucumber with Capybara
- **Unit Testing**: RSpec
- **Integration Testing**: Rails System Tests
- **API Testing**: Postman/Newman
- **Performance Testing**: JMeter
- **Security Testing**: OWASP ZAP

### CI/CD Pipeline
```yaml
stages:
  - lint
  - test
  - security_scan
  - deploy

test:
  script:
    - bundle install
    - bundle exec rspec
    - bundle exec cucumber
```

---

## Defect Management

### Severity Levels
1. **Critical**: System crash, data loss, security breach
2. **Major**: Feature not working, incorrect calculations
3. **Minor**: UI issues, slow performance
4. **Trivial**: Typos, cosmetic issues

### Defect Report Template
```
Title: [Module] Brief description
Severity: Critical/Major/Minor/Trivial
Environment: Development/Staging/Production
Steps to Reproduce:
1. Step 1
2. Step 2
Expected Result:
Actual Result:
Screenshots/Logs:
```

---

## Sign-off Criteria

### UAT Sign-off Checklist
- [ ] All Priority 1 scenarios tested
- [ ] No open Critical/Major defects
- [ ] Business workflows validated
- [ ] Performance acceptable
- [ ] Security clearance obtained
- [ ] Training completed
- [ ] Documentation approved

---

*Document Version: 1.0*
*Last Updated: January 27, 2025*
*Prepared for: InsureBook Admin Application Testing*