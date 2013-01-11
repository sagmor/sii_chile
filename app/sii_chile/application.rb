require 'sii_chile'
require 'sinatra'
require 'dalli'
require 'rack/contrib/jsonp'
require 'multi_json'
require 'newrelic_rpm'

module SIIChile
  class Application < Sinatra::Base

    set :cache, Dalli::Client.new()
    use Rack::JSONP

    get '/' do
      redirect 'https://github.com/sagmor/sii_chile'
    end

    get '/consulta' do
      @consulta = Consulta.new(params[:rut])

      @resultado = settings.cache.get(@consulta.rut.format)
      cached = true

      unless @resultado
        @resultado = @consulta.resultado
        settings.cache.set(@consulta.rut.format, @resultado)
        cached = false
      end

      StatsMix.track('Request', 1, :meta => {
        rut: @consulta.rut.format,
        cached: cached,
        ip: request.ip,
        user_agent: request.user_agent,
        referer: request.referer
      })

      [
        200,
        {
          'Content-Type' => 'application/json',
          'Access-Control-Allow-Origin' => '*',
          'X-Version' => SIIChile::VERSION
        },
        MultiJson.dump(@resultado)
      ]
    end

  end
end
