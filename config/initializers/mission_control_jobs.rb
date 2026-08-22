# Reuse the existing admin auth (Devise session + Admin::ApplicationController#ensure_admin)
# instead of Mission Control's default HTTP Basic auth.
#
# Note: this must set MissionControl::Jobs's mattr_accessors directly rather than
# config.mission_control.jobs.*  — the engine copies that config hash over to the
# module during a `before_initialize` hook, which runs before config/initializers
# load, so assigning it here would silently no-op.
MissionControl::Jobs.base_controller_class = "Admin::ApplicationController"
MissionControl::Jobs.http_basic_auth_enabled = false
