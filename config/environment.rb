# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

ENV['TZ'] = 'UTC'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'config_system'

::AppConfig = OpenStruct.new()
ConfigSystem.init

# Extensions
require_dependency 'railscollab_extras'

# SSL SMTP
begin
require 'smtp-tls'
rescue Exception
end

Rails::Initializer.run do |config|
  # Specify gems that this application depends on.
  # They can then be installed with "rake gems:install" on new installations.
  config.gem 'actionmailer', :version => '>=2.1.0'
  config.gem 'ferret',       :version => '>=0.11.6'
  config.gem 'icalendar',    :version => '>=1.0.2'
  config.gem 'ruby-openid',  :version => '>=2.1.2', :lib => 'openid'
  config.gem 'acts_as_ferret',    :version => '>=0.4.4'

  # optional gems
  config.gem 'RedCloth',     :version => '>= 4.0.0',   :lib => 'redcloth'

  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/config_handlers )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Note: make sure you have keys in config/app_keys.yml
  temp_key_yaml = YAML.load_file(RAILS_ROOT + "/config/app_keys.yml")
  config.action_controller.session = { 
    :session_key => temp_key_yaml['session'],
    :secret      => temp_key_yaml['secret']
  }
  
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # See Rails::Configuration for more options
end

ConfigSystem.post_init

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below

# Merge database & config.yml into AppConfig
ConfigSystem.load_config

# Ferret search
FERRETABLE_MODELS = %w[Tag Comment ProjectMessage ProjectTime ProjectTask ProjectTaskList ProjectMilestone ProjectFile ProjectFileRevision]
