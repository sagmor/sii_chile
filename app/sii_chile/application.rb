require 'sii_chile'
require 'sinatra'
require 'dalli'
require 'rack/contrib/jsonp'
require 'multi_json'
require 'newrelic_rpm'
require 'statsmix'

module SIIChile
  class Application < Sinatra::Base

    set :cache, Dalli::Client.new(ENV["MEMCACHIER_SERVERS"].split(","),
                    {:username => ENV["MEMCACHIER_USERNAME"],
                     :password => ENV["MEMCACHIER_PASSWORD"]})
    use Rack::JSONP

    get '/' do
      redirect 'https://github.com/sagmor/sii_chile'
    end

    get '/consulta' do
      @consulta = Consulta.new(params[:rut])

      @cache_key = 'v2'+@consulta.rut.format

      @resultado = settings.cache.get(@cache_key)
      cached = true

      unless @resultado
        @resultado = @consulta.resultado
        settings.cache.set(@cache_key, @resultado)
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
