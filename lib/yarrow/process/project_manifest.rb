module Yarrow
  module Process
    class ProjectManifest < Task
      accepts String
      provides String

      def before_step(content)

      end

      def step(content)
        "#{content} | ProjectManifest::Result"
      end

      def after_step(content)

      end
    end
  end
end
