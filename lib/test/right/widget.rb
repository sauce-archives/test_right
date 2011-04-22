module Test
  module Right
    class Widget
      def self.inherited(subclass)
        if superclass.respond_to? :inherited 
          superclass.inherited(subclass) 
        end 
        @subclasses ||= [] 
        @subclasses << subclass 
      end

      def self.subclasses
        @subclasses
      end
    end
  end
end
