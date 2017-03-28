module StripeMock
  module Util
    class CardTypeDetector
      attr_reader :number

      def initialize(number)
        @number = number
      end

      # TODO: Add more types support
      def card_type
        length = number.length
        if length == 15 && number =~ /^(34|37)/
          'American Express'
        elsif length == 16 && number =~ /^6011/
          'Discover'
        elsif length == 16 && number =~ /^5[1-5]/
          'Mastercard'
        elsif (length == 13 || length == 16) && number =~ /^4/
          'Visa'
        else
          'Unknown'
        end
      end
    end

    def self.rmerge(desh_hash, source_hash)
      return source_hash if desh_hash.nil?
      return nil if source_hash.nil?

      desh_hash.merge(source_hash) do |key, oldval, newval|
        if oldval.is_a?(Array) && newval.is_a?(Array)
          oldval.fill(nil, oldval.length...newval.length)
          oldval.zip(newval).map {|elems|
            elems[1].nil? ? elems[0] : rmerge(elems[0], elems[1])
          }
        elsif oldval.is_a?(Hash) && newval.is_a?(Hash)
          rmerge(oldval, newval)
        else
          newval
        end
      end
    end

    def self.fingerprint(source)
      Digest::SHA1.base64digest(source).gsub(/[^a-z]/i, '')[0..15]
    end

    def self.card_merge(old_param, new_param)
      if new_param[:number] ||= old_param[:number]
        if new_param[:last4]
          new_param[:number] = new_param[:number][0..-5] + new_param[:last4]
        else
          new_param[:last4] = new_param[:number][-4..-1]
        end

        new_param[:type] = CardTypeDetector.new(new_param[:number]).card_type
      end
      old_param.merge(new_param)
    end
  end
end
