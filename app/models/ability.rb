# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    case user.user_type
    when 'admin'
      # Admin has full access to everything
      can :manage, :all
    when 'agent'
      # Agent can manage their own customers and policies
      can :read, :all
      can :manage, Customer
      can :manage, Policy, user: user
      can :manage, Lead
      can :read, InsuranceCompany
      can :read, AgencyBroker
    when 'sub_agent'
      # Sub-agent has limited access
      can :read, Customer
      can :create, Lead
      can :read, Policy, user: user
      can :read, InsuranceCompany
    else
      # Default permissions for any other role
      can :read, :dashboard
    end

    # Common abilities for all authenticated users
    if user.persisted?
      can :read, :dashboard
      can [:show, :edit, :update], User, id: user.id
    end
  end
end
