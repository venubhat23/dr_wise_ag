module Admin
  module Api
    class PoliciesController < Admin::ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user!

      def expiring
        days = params[:days].to_i || 30

        policies = []

        # Collect from all insurance types
        # Health Insurance
        HealthInsurance.includes(:customer)
                      .where(policy_end_date: Date.current..days.days.from_now)
                      .each do |policy|
          policies << format_policy(policy, 'health')
        end

        # Life Insurance
        LifeInsurance.includes(:customer)
                    .where(policy_end_date: Date.current..days.days.from_now)
                    .each do |policy|
          policies << format_policy(policy, 'life')
        end

        # Motor Insurance
        MotorInsurance.includes(:customer)
                      .where(policy_end_date: Date.current..days.days.from_now)
                      .each do |policy|
          policies << format_policy(policy, 'motor')
        end

        # Other Insurance
        if defined?(OtherInsurance)
          OtherInsurance.includes(:customer)
                        .where(policy_end_date: Date.current..days.days.from_now)
                        .each do |policy|
            policies << format_policy(policy, 'other')
          end
        end

        render json: {
          success: true,
          policies: policies.sort_by { |p| p[:end_date] }
        }
      end

      def expired
        policies = []

        # Recently expired policies — last 45 days only, matching the dashboard badge count
        forty_five_days_ago = Date.current - 45.days

        # Health Insurance
        HealthInsurance.includes(:customer)
                      .where(policy_end_date: forty_five_days_ago...Date.current)
                      .each do |policy|
          policies << format_policy(policy, 'health')
        end

        # Life Insurance
        LifeInsurance.includes(:customer)
                    .where(policy_end_date: forty_five_days_ago...Date.current)
                    .each do |policy|
          policies << format_policy(policy, 'life')
        end

        # Motor Insurance
        MotorInsurance.includes(:customer)
                      .where(policy_end_date: forty_five_days_ago...Date.current)
                      .each do |policy|
          policies << format_policy(policy, 'motor')
        end

        # Other Insurance
        if defined?(OtherInsurance)
          OtherInsurance.includes(:customer)
                        .where(policy_end_date: forty_five_days_ago...Date.current)
                        .each do |policy|
            policies << format_policy(policy, 'other')
          end
        end

        render json: {
          success: true,
          policies: policies.sort_by { |p| p[:end_date] }.reverse
        }
      end

      def processed
        policies = []

        # Policies renewed this month (matches dashboard logic)
        # Dashboard uses: created_at >= current_month_start
        current_month_start = Date.current.beginning_of_month

        # Health Insurance renewals
        HealthInsurance.includes(:customer)
                      .where('created_at >= ?', current_month_start)
                      .where(policy_type: 'Renewal')
                      .each do |policy|
          policies << format_policy(policy, 'health')
        end

        # Life Insurance renewals
        LifeInsurance.includes(:customer)
                    .where('created_at >= ?', current_month_start)
                    .where(policy_type: 'Renewal')
                    .each do |policy|
          policies << format_policy(policy, 'life')
        end

        # Motor Insurance renewals
        MotorInsurance.includes(:customer)
                      .where('created_at >= ?', current_month_start)
                      .where(policy_type: 'Renewal')
                      .each do |policy|
          policies << format_policy(policy, 'motor')
        end

        # Other Insurance renewals
        if defined?(OtherInsurance)
          OtherInsurance.includes(:customer)
                        .where('created_at >= ?', current_month_start)
                        .where(policy_type: 'Renewal')
                        .each do |policy|
            policies << format_policy(policy, 'other')
          end
        end

        render json: {
          success: true,
          policies: policies.sort_by { |p| p[:created_date] || p[:booking_date] }.reverse
        }
      end

      # Health specific endpoints
      def health_expiring
        policies = HealthInsurance.includes(:customer)
                                 .where(policy_end_date: Date.current..30.days.from_now)
                                 .map { |p| format_health_policy(p) }

        render json: {
          success: true,
          policies: policies.sort_by { |p| p[:days_left] }
        }
      end

      def health_expired_month
        # Match dashboard logic - ALL expired policies, not just this month
        policies = HealthInsurance.includes(:customer)
                                 .where('policy_end_date < ?', Date.current)
                                 .map { |p| format_health_policy(p) }

        render json: {
          success: true,
          policies: policies
        }
      end

      def health_opportunities
        # Policies that expired recently but haven't been renewed
        expired_policies = HealthInsurance.includes(:customer)
                                         .where(policy_end_date: 60.days.ago..Date.current)
                                         .where(policy_type: ['New', nil])

        # Check which ones don't have renewals
        opportunities = []
        expired_policies.each do |policy|
          renewal_exists = HealthInsurance.where(
            customer_id: policy.customer_id,
            policy_type: 'Renewal',
            policy_booking_date: policy.policy_end_date..Date.current
          ).exists?

          unless renewal_exists
            opportunities << format_health_policy(policy)
          end
        end

        render json: {
          success: true,
          policies: opportunities
        }
      end

      private

      def format_policy(policy, type)
        {
          id: policy.id,
          policy_number: policy.policy_number,
          customer_name: policy.customer&.display_name,
          customer_email: policy.customer&.email,
          insurance_type: type.capitalize,
          premium: policy.try(:total_premium) || policy.try(:premium_amount) || 0,
          end_date: policy.policy_end_date&.strftime('%d %b %Y'),
          booking_date: policy.policy_booking_date&.strftime('%d %b %Y'),
          created_date: policy.created_at&.strftime('%d %b %Y'),
          days_left: policy.policy_end_date ? (policy.policy_end_date - Date.current).to_i : 0,
          type_slug: "#{type}_insurances"
        }
      end

      def format_health_policy(policy)
        {
          id: policy.id,
          policy_number: policy.policy_number,
          customer_name: policy.customer&.display_name,
          customer_email: policy.customer&.email,
          sum_insured: policy.sum_insured || 0,
          premium: policy.total_premium || 0,
          end_date: policy.policy_end_date&.strftime('%d %b %Y'),
          days_left: policy.policy_end_date ? (policy.policy_end_date - Date.current).to_i : 0
        }
      end
    end
  end
end