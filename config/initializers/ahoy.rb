class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false

# Track visits immediately (server-side tracking)
Ahoy.server_side_visits = :when_needed

# Track bot visits
Ahoy.track_bots = false

# Cookie settings
Ahoy.cookie_domain = :all
Ahoy.cookie_options = { httponly: true }

# Visit duration (30 minutes default)
Ahoy.visit_duration = 30.minutes

# Exclude tracking for certain paths
Ahoy.exclude_method = lambda do |controller, request|
  request.path.start_with?('/assets', '/admin/imports')
end
