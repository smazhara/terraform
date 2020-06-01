module TF11
  class Plan
    def initialize(text)
      @text = text
      validate!
    end

    def to_s
      @text
      body
    end

    def resources
      @resources ||= body.split(/^  #/)[1..-1].map do |text|
        Resource.new(text)
      end
    end

    def ==(other)
      raise "Expect TF11, got #{other.class}" unless other.is_a?(TF11)

      self.resources[0] == other.resources[0]
    end

    private

    def validate!
      raise 'No preamble found' unless @text.start_with?(prologue)
      raise 'No epilogue found' unless @text.end_with?(epilogue)
    end

    def prologue
      <<~END

      An execution plan has been generated and is shown below.
      Resource actions are indicated with the following symbols:
        + create

      Terraform will perform the following actions:

      END
    end

    def epilogue
      <<~END

      Plan: 1 to add, 0 to change, 0 to destroy.
      END
    end

    def body
      @body ||= @text
        .gsub(/^#{Regexp.escape(prologue)}/, '')
        .gsub(/#{Regexp.escape(epilogue)}$/, '')
    end
  end
end
