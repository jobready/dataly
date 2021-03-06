require 'byebug'

module Dataly
  class Mapper
    attr_reader :model

    class << self
      def fields
        @fields ||= {}
      end

      def renames
        @renames ||= {}
      end

      def field(name, value: nil)
        fields[name] = { value: value }
      end

      def rename(from, to: nil)
        return unless to
        renames[from] = to
      end
    end

    def fields
      self.class.fields
    end

    def renames
      self.class.renames
    end

    def initialize(model)
      @model = model
    end

    def process(row)
      Hash[row.map do |heading, value|
        process_column(heading, value, row)
      end.compact]
    end

    private
    def process_column(k, v, row)
      key = map_to(k)
      val = mapping_exists?(key) ? transform(key, v, row) : v
      val = blank_to_nil(val)

      return [key.to_sym, val] if attributes.include?(key)
    end

    def map_to(k)
      renames[k] ? renames[k] : k
    end

    def transform(csv_field_name, csv_value, values)
      transformer = fields[csv_field_name][:value]

      if transformer.respond_to?(:call)
        transformer.call(csv_value, values)
      elsif transformer && respond_to?(transformer)
        method(transformer).call(csv_value, values)
      else
        csv_value
      end
    end

    def mapping_exists?(key)
      fields[key].present?
    end

    def blank_to_nil(val)
      val.is_a?(String) && val.empty? ? nil : val
    end

    def attributes
      @attributes ||= model.attribute_names.map(&:to_sym)
    end
  end
end
