require 'aruba/cucumber'

Aruba.configure do |config|
  config.before_cmd do |cmd|
    set_env 'BASTILLE_STORE', '.bastille'
  end
end
