module TF12
  class Resource
    def assert(value, &block)
      if block.call(value)
        value
      else
        raise "#{value.inspect} failed assertion."
      end
    end

    # Resource comparison across versions is version-pair specific
    def ==(other)
      case other
      when TF11::Resource
        version11_eq(other)
      when TF12::Resource
        self.action == other.action &&
          self.type == other.type &&
          self.path == other.path &&
          self.changed_attributes == other.changed_attributes
      else
        raise "Can only compare with TF11 or TF12, got #{other.class}"
      end
    end

    def initialize(text)
      @text = text
    end

    def to_s
      @text
    end

    def path
      assert path_components.join('.') do |path|
        path.size >= 2
      end
    end

    def type
      assert path_components[-2] do |type|
        type =~ /\A\w+(_\w+)*\z/
      end
    end

    def name
      assert path_components[-1] do |name|
        name =~ /\A\w+\z/
      end
    end

    def action
      assert first_line_parts[1].to_sym do |action|
        %i[created].include?(action)
      end
    end

    def changed_attributes(except: [])
      main_resource_text_block.inject({}) do |attr, line|
        key, value = line.gsub(/\A\s+\+\s+/, '').split(/\s+=\s+/)

        # exclude keys in `except` list
        return attr if except.include?(key.to_sym)

        value = case value
        when 'true'
          true
        when 'false'
          false
        when '(known after apply)'
          nil
        else
          value
        end

        # remove literal "-s from values
        if value.respond_to?(:gsub)
          value = value.gsub(/\A"/, '').gsub(/"\z/, '')
        end

        attr.merge(key.to_sym => value)
      end
    end

    private

    # This compares fields that are hopefully unchanged across versions
    def generic_eq(other)
      self.action == other.action &&
        self.type == other.type &&
        self.path == other.path
    end

    # Looks like 0.11 returns fewer attributes for at least some types of resources
    # so we'll have to exclude them from the comparison
    def version11_eq(other)
      case other.type
      when 'aws_instance'
        ignored_attributes = %i[
          ebs_block_device ephemeral_block_device metadata_options
          network_interfaces root_block_device
        ]

        generic_eq(other) &&
          self.changed_attributes(except: ignored_attributes) == other.changed_attributes
      else
        raise "Don't know how to compare #{other.class} type"
      end
    end

    def main_resource_text_block
      text_blocks[0].split(/\n/)[2..-1]
    end

    public def sub_resources
      text_blocks[1..-1].map { |text| Resource.new(text) }
    end

    # Subresources are split by empty line
    def text_blocks
      @text_blocks ||= @text.split(/\n\n/)
    end

    # First line looks like this `aws_instance.example will be created`
    def first_line_parts
      @first_line_parts ||= @text.split(/\n/)[0].strip.split(' will be ')
    end

    def path_components
      @path_components ||= first_line_parts[0].split('.')
    end
  end
end

