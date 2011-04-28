require 'set'

module Test
  module Right
    class DataFactory
      def initialize(template)
        @template = template
        @used_ids = Set.new([nil])
      end

      def [](name)
        base = @template[name] || @template[name.to_s] || name.to_s
        id = nil
        while @used_ids.include? id
          id = rand(100000)
        end
        base += id.to_s
        return base
      end
    end
  end
end
