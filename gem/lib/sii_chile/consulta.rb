module SIIChile
  class Consulta
    attr_reader :rut

    def initialize(rut)
      @rut = Rut.new(rut)
    end

    def resultado
      @resultado ||= self.fetch!
    end

    protected
      XPATH_RAZON_SOCIAL = '/html/body/center[2]/table[1]/tr[1]/td[2]/font'
      XPATH_ACTIVIDADES = '/html/body/center[2]/table[4]/tr/td[2]/table/tr'

      def fetch!
        raise 'Rut invalido' unless @rut.valid?

        response = Faraday.post('https://zeus.sii.cl/cvc_cgi/stc/getstc', {
          'RUT' => @rut.number,
          'DV' => @rut.code,
          'PRG' => 'STC',
          'OPC' => 'NOR'
        })

        data = Nokogiri::HTML(response.body)

        actividades = data.xpath(XPATH_ACTIVIDADES)[1..-1].map do |node|
          {
            :giro => node.xpath('./td[1]/font').text.strip,
            :codigo => node.xpath('./td[2]/font').text.strip.to_i,
            :categoria => node.xpath('./td[3]/font').text.strip,
            :afecta =>  node.xpath('./td[4]/font').text.strip == 'Si'
          }
        end rescue []

        {
          :rut => @rut.format,
          :razon_social => data.xpath(XPATH_RAZON_SOCIAL).text.strip,
          :actividades => actividades
        }
      rescue StandardError => e
        {
          :rut => @rut.format,
          :error => e.message
        }
      end
  end
end
