require 'mimic'

Mimic.mimic :port => 9000, :fork => true do

  get '/authenticate' do
    'OK!'
  end

end
