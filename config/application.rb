require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module StreampixBackendDevcurumin
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :"pt-BR"
    config.time_zone = "Brasilia"
    config.active_record.default_timezone = :local

    config.action_cable.mount_path = "/ws"

    config.api_only = true
  end
end
