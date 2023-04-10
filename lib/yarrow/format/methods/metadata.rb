module Yarrow
  module Format
    module Methods
      module Metadata
        module ClassMethods
          def read(path)
            text = File.read(path, :encoding => "utf-8")
            Yarrow::Format::Contents.new(nil, parse(text))
          end

          def parse(text)
            new(text)
          end
        end

        def self.included(base)
          base.extend(ClassMethods)
        end
      end
    end
  end
end