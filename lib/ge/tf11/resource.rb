module TF11
  class Resource
    def initialize(text)
      @text = text
    end

    def ==(other)
      other == self
    end

    def action
      {
        '+' => :created,
        '-' => :destroy,
        '~' => :replace,
        '' => :updated
      }.fetch(lines[0][0])
    end

    def type
      path_components[-2]
    end

    def path
      path_components[-2..-1].join('.')
    end

    def name
      path_components[-1]
    end

    def module
      mod = path_components[0..-3].join('.')
      mod == '' ? nil : mod
    end

    def changed_attributes
      rest_lines.inject({}) do |attr, line|
        key, value = line.strip.split(/:\s*/)

        # binding.pry if key == 'source_dest_check'
        value = case value
                when '"true"'
                  true
                when '"false"'
                  false
                when '<computed>'
                  nil
                else
                  value
                end

        if value.respond_to?(:gsub)
          value = value.gsub(/\A"/, '').gsub(/"\z/, '')
        end

        # remove trailing '.#' and '.%' from keys
        # TODO: figure out their significance
        key = key.gsub(/\.[#%]\z/, '')

        attr.merge(key.to_sym => value)
      end
    end

    def to_s
      @text
    end

    private

    def rest_lines
      lines[1..-1]
    end

    def lines
      @lines ||= @text.split(/\n/)
    end

    def path_components
      @path_compontent ||= lines[0][2..-1].split('.')
    end
  end
end
