module HashMap
  class Mapper
    attr_reader :original, :hash_map
    def initialize(original, hash_map)
      @original = HashWithIndifferentAccess.new(original)
      @hash_map = hash_map
    end

    def output
      new_hash = HashWithIndifferentAccess.new
      hash_map.class.attributes.each do |struc|
        value = get_value(struc)
        new_hash.deep_merge! build_keys(struc[:key], value)
      end
      if wrapper = HashMap.configuration.middlewares[:after_map].new(new_hash).call
        wrapper
      else
        new_hash
      end
    end

    private

    def get_value(struct)
      value = if struct[:is_collection]
                map_collection(struct)
              elsif struct[:proc]
                execute_block(struct)
              elsif struct[:from]
                get_value_from_key(struct)
              end
      nil_to_default(value, struct)
    end

    def map_collection(struct)
      value = get_value_from_key(struct)
      value = Array.wrap(value)
      value.map { |elem| struct[:mapper].call(elem) }
    end

    def get_value_from_key(struct, from = :from)
      struct[from].inject(original) do |output, k|
        break unless output.respond_to?(:[])
        output.send(:[], k)
      end
    end

    def execute_block(struct)
      block = struct[:proc]
      if struct[:from_child]
        nested = get_value_from_key(struct, :from_child)
        hash_map.instance_exec nested, original, &block
      else
        hash_map.instance_exec original, original, &block
      end
    end

    def build_keys(ary, value)
      ary.reverse.inject(value) do |a, n|
        HashWithIndifferentAccess.new(n => a)
      end
    end

    def nil_to_default(value, struct)
      value.nil? ? struct[:default] : value
    end
  end
end
