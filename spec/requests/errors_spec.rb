require 'rails_helper'

RSpec.describe "Errors", type: :request do
  it 'responds with 404 error page' do
    get '/404'
    expect(response.body).to match(/page you're looking for could not be found/i)
  end

  it 'responds with 500 error page' do
    get '/500'
    expect(response.body).to match(/something went wrong/i)
  end
end
