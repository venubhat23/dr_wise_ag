@javascript
Feature: Client Services Commission Calculation
  As an admin
  I want to create investment/loan/taxation service records
  So that commissions are calculated correctly and records are tagged as drwise

  Background:
    Given I am logged in as admin
    And test prerequisites exist

  # ─── COMMISSION CALCULATION ────────────────────────────────────────────────

  Scenario: Investor actual amount updates when investor percentage changes
    Given a client service customer exists
    When I visit the new client service page for "investments_mutual_fund"
    And I set the investment amount to "10000"
    And I set the main agent commission percentage to "10"
    And I set the investor commission percentage to "2"
    Then the investor actual amount should equal "200.00"

  Scenario: Company actual amount updates when company percentage changes
    Given a client service customer exists
    When I visit the new client service page for "investments_mutual_fund"
    And I set the investment amount to "10000"
    And I set the main agent commission percentage to "10"
    And I set the company expenses percentage to "3"
    Then the company actual amount should equal "300.00"

  Scenario: Profit recalculates when investor and company percentages change
    Given a client service customer exists
    When I visit the new client service page for "investments_mutual_fund"
    And I set the investment amount to "10000"
    And I set the main agent commission percentage to "10"
    And I set the investor commission percentage to "2"
    And I set the company expenses percentage to "1"
    Then the profit percentage should equal "7.00"
    And the profit amount should equal "700.00"

  # ─── DRWISE RECORD TAGGING ─────────────────────────────────────────────────

  Scenario: Record created from admin panel is tagged as drwise
    Given a client service customer exists
    When I visit the new client service page for "investments_mutual_fund"
    And I fill in the minimum client service fields
    And I submit the client service form
    Then the last created client service should be marked as admin added

  Scenario: Record created via lead to customer flow is tagged as drwise
    Given a lead exists with a converted customer
    When I visit the new client service page with lead and customer params for "investments_mutual_fund"
    And I fill in the minimum client service fields
    And I submit the client service form
    Then the last created client service should be marked as admin added
