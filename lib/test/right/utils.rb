module Test
  module Right
    module Utils
      module SubclassTracking
        def inherited(subclass)
          @subclasses ||= [] 
          @subclasses << subclass 
        end

        def subclasses
          @subclasses
        end

        def wipe!
          @subclasses = []
        end
      end
    end
  end
end
