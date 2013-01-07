#
# Authors: Jeff Cox, David Zhang
# Copyright Syracuse University
#

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module VdsPip
  class Application < Rails::Application
    # Personal global variables
    # Accessible elsewhere via VdsPip::Application::STAGES

    # Order should match the flow chart
    STAGES = [
      "Assess",
      "Define",
      "Design",
      "Implement",
      "Monitor"
    ]

    # Order should match the flow chart
    FACTORS = [
      "Site and climate",
      "Internal configurations",
      "External enclosure including roof",
      "Environmental systems",
      "Energy and water",
      "Form and massing",
      "Material use"
    ]

    # Task data organized by Stages > Factors.
    # The order is important! Make sure tasks are grouped by factors, and then more broadly by stages.
    # project.rb uses a hash and counter and assumes the ordering of this is correct.
    TASKS = [ 
      # Stage: Assess
      "Identify Sites",
      "Assess Logistics & Urban Context",
      "Assess Environment",

      "Assess Program Type",
      "Assess Interior Design Scheme",

      "Assess Enclosure Opportunities",
      "Assess Enclosure Opportunities' Feasibility",

      "Assess Environmental System Needs & Resources",

      # Stage: Define
      "Define Site Development Strategies",
      "Define Site Development Goals",

      "Define Circulation Strategies",
      "Define Program Chart",
      "Define Interior Design Scheme Goals & Strategies",

      "Define Enclosure Strategies",
      "Define Performance Goals",

      "Define Environmental Systems Goals & Strategies",

      # Stage: Design
      "Design Landscape",
      "Analyze Impact on Performance",

      "Design Internal Configurations",
      "Outline Material/Finishing, Furniture/Equipment & Lighting Specifications",

      "Develop Enclosure Drawings & Specifications",
      "Analyze Impact on Performance",

      "Design Environmental Systems",
      "Analyze Impact on Performance"
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
