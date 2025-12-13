module ApplicationHelper
  # Permission checking helpers
  def current_user_can?(module_name, action = 'read')
    return true if current_user&.admin? || current_user&.user_type == 'admin'
    return current_user.has_permission?(module_name, action) if current_user&.role
    false
  end

  def show_sidebar_item?(module_name, action = 'read')
    current_user_can?(module_name, action)
  end

  def sidebar_item_class(current_path, module_paths = [])
    paths_to_check = [current_path] + module_paths
    paths_to_check.any? { |path| request.path.include?(path) } ? 'active' : ''
  end

  # Role and permission helpers
  def user_role_badge(user)
    return content_tag(:span, 'No Role', class: 'badge bg-secondary') unless user&.role

    role_colors = {
      'admin' => 'bg-danger',
      'manager' => 'bg-primary',
      'agent' => 'bg-success',
      'supervisor' => 'bg-warning',
      'sub_agent' => 'bg-info'
    }

    color_class = role_colors[user.role.name.downcase] || 'bg-secondary'
    content_tag(:span, user.role.display_name, class: "badge #{color_class}")
  end

  def permission_icon(action_type)
    icons = {
      'create' => 'bi-plus-circle',
      'read' => 'bi-eye',
      'update' => 'bi-pencil',
      'delete' => 'bi-trash',
      'export' => 'bi-download',
      'import' => 'bi-upload',
      'manage' => 'bi-gear'
    }

    content_tag(:i, '', class: "bi #{icons[action_type] || 'bi-circle'}")
  end

  def module_icon(module_name)
    icons = {
      'dashboard' => 'bi-grid-3x3-gap-fill',
      'customers' => 'bi-people-fill',
      'helpdesk' => 'bi-headset',
      'users' => 'bi-person-badge-fill',
      'sub_agents' => 'bi-people',
      'brokers' => 'bi-briefcase',
      'agency_codes' => 'bi-code-slash',
      'leads' => 'bi-funnel-fill',
      'life_insurance' => 'bi-heart-fill',
      'health_insurance' => 'bi-hospital',
      'motor_insurance' => 'bi-car-front',
      'other_insurance' => 'bi-shield-fill-check',
      'reports' => 'bi-graph-up',
      'settings' => 'bi-gear-fill',
      'roles' => 'bi-shield-check',
      'helpdesk' => 'bi-headset'
    }

    content_tag(:i, '', class: "bi #{icons[module_name] || 'bi-circle'}")
  end

  def get_module_icon(module_name)
    icons = {
      'dashboard' => 'bi-grid-3x3-gap-fill',
      'customers' => 'bi-people-fill',
      'policies' => 'bi-file-earmark-text-fill',
      'agents' => 'bi-person-badge-fill',
      'sub_agents' => 'bi-people',
      'brokers' => 'bi-briefcase',
      'agency_codes' => 'bi-code-slash',
      'leads' => 'bi-funnel-fill',
      'life_insurance' => 'bi-heart-fill',
      'health_insurance' => 'bi-hospital-fill',
      'motor_insurance' => 'bi-car-front-fill',
      'other_insurance' => 'bi-shield-fill-check',
      'reports' => 'bi-graph-up',
      'management' => 'bi-building-fill',
      'settings' => 'bi-gear-fill'
    }

    content_tag(:i, '', class: "bi #{icons[module_name] || 'bi-circle'}")
  end

  # Status helpers
  def status_badge(status, active_text = 'Active', inactive_text = 'Inactive')
    if status
      content_tag(:span, active_text, class: 'badge bg-success-soft text-success')
    else
      content_tag(:span, inactive_text, class: 'badge bg-danger-soft text-danger')
    end
  end

  # Form helpers
  def form_errors_for(object)
    return unless object&.errors&.any?

    content_tag(:div, class: 'alert alert-danger alert-dismissible fade show') do
      content_tag(:h6, 'Please correct the following errors:') +
      content_tag(:ul, class: 'mb-0') do
        object.errors.full_messages.map do |message|
          content_tag(:li, message)
        end.join.html_safe
      end +
      content_tag(:button, '', type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert')
    end
  end
end
