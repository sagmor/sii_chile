module SIIChile
  # "Stealed" from https://github.com/iortega/rut_validator/blob/master/lib/rut_validator/rut.rb
  class Rut
    attr_reader :number
    attr_reader :code

    def initialize(rut)
      @rut = rut.to_s.strip
      @number = @rut.gsub(/[^0-9K]/i,'')[0...-1]
      @code = @rut[-1].upcase
    end

    def valid?
      size_valid? && code_valid?
    end

    def size_valid?
      @number.size <= 8
    end

    def code_valid?
      @code == calculated_code
    end

    def calculated_code
      all_codes = (0..9).to_a + ['K']
      reverse_digits = @number.split('').reverse
      factors = (2..7).to_a * 2
      partial_sum = reverse_digits.zip(factors).inject(0) do |r, a|
        digit, factor = *a
        r += digit.to_i * factor
      end
      all_codes[(11 - partial_sum%11)%11].to_s
    end

    def number_with_delimiter(delimiter='.')
      @number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
    end

    def format(opts={})
      delimiter = opts[:delimiter] || '.'
      with_dash = opts[:with_dash].nil? ? true : opts[:with_dash]
      formatted_rut = number_with_delimiter(delimiter)
      formatted_rut << '-' if with_dash
      formatted_rut << @code
    end

    def to_s; format; end
  end
end