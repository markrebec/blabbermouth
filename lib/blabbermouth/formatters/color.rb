module Blabbermouth
  # module Logging
    module Formatters
      class Color < Blabbermouth::Formatter
        # TODO make this a better config
        # TODO load color preferences from personal config???
        class Config
          class << self
            attr_accessor :highlight_color, :highlight_bold, :highlight_keys
            attr_accessor :hidden_color, :hidden_bold, :hidden_keys, :print_hidden
            attr_accessor :default_color, :default_bold, :inverse_color, :inverse_bold
            attr_accessor :preferred_keys, :deferred_keys

            def hidden_keys=(keys)
              @hidden_keys = Array.wrap(keys)
            end

            def highlight_keys=(keys)
              @highlight_keys = Array.wrap(keys)
            end
          end
        end

        def call(severity, timestamp, progname, message)
          @context = context.merge(level: severity)

          if message.is_a?(Hash) && message[:message].present?
            @context.merge!(message.except(:message))
            message = message[:message]
          end

          if message.blank? && context[:message].present?
            message = context.delete(:message)
          end

          # colorize the message before formatting
          message = colorize(message.to_s, severity_color(severity), severity_bold(severity)) unless message.is_a?(Enumerable)

          # format message and context and join them together
          formatted = [ format(message), format(context.except(:backtrace)) ].reject(&:blank?).join(" ")
          # use simpler formatting as a default
          formatted = [ "#{formatted}\n" ]
          # add a readable backtrace for exceptions if one exists
          formatted.push( "#{backtrace}\n" ) if context.key?(:error) && backtrace.present?
          formatted.push( "#{context.key?(:error) ? colorize("#{context[:error]}: ", severity_color(severity), severity_bold(severity)) : nil}#{message}\n\n" ) if context.key?(:error) && backtrace.present?
          # print it all out
          formatted.join
        ensure
          @context = nil
        end

        private

        def context
          return @context unless @context.nil?
          sort_keys(super)
        end

        def backtrace
          if context[:backtrace].present?
            backtrace = context[:backtrace]
            chars = backtrace.length.to_s.length + 2
            backtrace = backtrace.map.with_index { |line,l| "#{colorize((l+1).to_s.rjust(chars), severity_color(context[:level]), severity_bold(context[:level]))} #{colorize(line.gsub(/^#{Dir.pwd}/, '.'), inverse_color, inverse_bold)}"}
            backtrace.reverse.join("\n")
          end
        end

        def preferred_keys
          defaults = %w(message type level event metric error)
          return Config.preferred_keys.call if Config.preferred_keys.respond_to?(:call)
          return Config.preferred_keys unless Config.preferred_keys.nil?
          return defaults
        end

        def preferred_key?(key)
          preferred_keys.include?(key.to_s.downcase)
        end

        def deferred_keys
          defaults = %w(sql search query payload params)
          return defaults + Config.deferred_keys.call if Config.deferred_keys.respond_to?(:call)
          return defaults + Config.deferred_keys unless Config.deferred_keys.nil?
          defaults
        end

        def deferred_key?(key)
          deferred_keys.include?(key.to_s.downcase)
        end

        # TODO partitioning is nice, but this might be faster if we just sort keys?
        def sort_keys(hash)
          left, right = *hash.partition do |k,v|
            (preferred_key?(k) && !hidden_key?(k)) || highlight_key?(k) || !hidden_key?(k)
          end.map(&:to_h)
          left  = left.partition { |k,v| preferred_key?(k) || !deferred_key?(k) }.map(&:to_h).reduce(&:merge)
          right = right.partition { |k,v| !hidden_key?(k) && (preferred_key?(k) || !deferred_key?(k)) }.map(&:to_h).reduce(&:merge)
          left.merge(right)
        end

        # TODO move colors into this class and add support for more/modern terminals
        # TODO simplify ALL of this with 16 colors (instead of bold)
        def colorize(message, color, bold=false)
          return message if message.blank?
          ActiveSupport::LogSubscriber.new.send(:color, message, color, bold)
        end

        def color(color)
          ActiveSupport::LogSubscriber.const_get(color.upcase)
        end

        def default_color
          return Config.default_color.call if Config.default_color.respond_to?(:call)
          return Config.default_color unless Config.default_color.nil?
          return :black
        end

        def default_bold
          return Config.default_bold.call if Config.default_bold.respond_to?(:call)
          return Config.default_bold unless Config.default_bold.nil?
          return true
        end

        def inverse_color
          return Config.inverse_color.call if Config.inverse_color.respond_to?(:call)
          return Config.inverse_color unless Config.inverse_color.nil?
          return :white
        end

        def inverse_bold
          return Config.inverse_bold.call if Config.inverse_bold.respond_to?(:call)
          return Config.inverse_bold unless Config.inverse_bold.nil?
          return false
        end

        def hidden_key?(key)
          return Config.hidden_keys.call(key) if Config.hidden_keys.respond_to?(:call)
          return true if Config.hidden_keys.present? && Config.hidden_keys.any? do |hk|
            if hk.is_a?(Regexp)
              hk.match?(key.to_s.downcase)
            elsif hk.respond_to?(:call)
              hk.call(key.to_s.downcase)
            else
              hk.to_s.downcase == key.to_s.downcase
            end
          end
        end

        def hidden_color
          return Config.hidden_color.call if Config.hidden_color.respond_to?(:call)
          return Config.hidden_color unless Config.hidden_color.nil?
          return :black
        end

        def hidden_bold
          return Config.hidden_bold.call if Config.hidden_bold.respond_to?(:call)
          return Config.hidden_bold unless Config.hidden_bold.nil?
          return false
        end

        def highlight_key?(key)
          return Config.highlight_keys.call(key) if Config.highlight_keys.respond_to?(:call)
          return true if Config.highlight_keys.present? && Config.highlight_keys.any? do |hk|
            if hk.is_a?(Regexp)
              hk.match?(key.to_s.downcase)
            elsif hk.respond_to?(:call)
              hk.call(key.to_s.downcase)
            else
              hk.to_s.downcase == key.to_s.downcase
            end
          end
        end

        def highlight_color(key)
          return Config.highlight_color.call(key) if Config.highlight_color.respond_to?(:call)
          return Config.highlight_color unless Config.highlight_color.nil?
          return :cyan
        end

        def highlight_bold(key)
          return Config.highlight_bold.call(key) if Config.highlight_bold.respond_to?(:call)
          return Config.highlight_bold unless Config.highlight_bold.nil?
          return true
        end

        def severity_color(severity)
          case severity.to_s.downcase
            when 'debug', 'verbose'
              :black
            when 'info'
              :white
            when 'warn'
              :yellow
            when 'error', 'fatal'
              :red
            else
              :white
          end
        end

        def severity_bold(severity)
          case severity.to_s.downcase
            when 'fatal', 'debug', 'verbose'
              true
            else
              false
          end
        end

        def key_color(key, value)
          return highlight_color(key) if highlight_key?(key)
          return hidden_color if hidden_key?(key)

          keymeth = "#{key.to_s.downcase}_key_color".to_sym
          return send(keymeth, value) if respond_to?(keymeth, true)

          case key.to_s.downcase
            when 'duration'
              inverse_color
            else
              default_color
          end
        end

        def key_bold(key, value)
          return highlight_bold(key) if highlight_key?(key)
          return hidden_bold if hidden_key?(key)

          keymeth = "#{key.to_s.downcase}_key_bold".to_sym
          return send(keymeth, value) if respond_to?(keymeth, true)

          case key.to_s.downcase
            when 'error', 'exception'
              inverse_bold
            when 'sql', 'search', 'template', 'layout'
              default_bold
            when 'duration'
              inverse_bold
            when 'message'
              default_bold
            else
              default_bold
          end
        end

        def value_color(key, value)
          return highlight_color(key) if highlight_key?(key)
          return hidden_color if hidden_key?(key)

          valmeth = "#{key.to_s.downcase}_value_color".to_sym
          return send(valmeth, value) if respond_to?(valmeth, true)

          case key.to_s.downcase
            when 'error', 'exception'
              :red
            when 'sql'
              :blue
            when 'search'
              :white
            when 'template', 'layout'
              :magenta
            else
              key_color(key, value)
          end
        end

        def value_bold(key, value)
          return highlight_bold(key) if highlight_key?(key)
          return hidden_bold if hidden_key?(key)

          valmeth = "#{key.to_s.downcase}_value_bold".to_sym
          return send(valmeth, value) if respond_to?(valmeth, true)

          case key.to_s.downcase
            when 'error', 'exception', 'template', 'layout'
              inverse_bold
            when 'sql', 'search'
              inverse_bold
            when 'duration' # TODO let's just move this to config
              inverse_bold
            when 'message'
              default_bold
            else
              key_bold(key, value)
          end
        end

        alias_method :level_value_color, :severity_color
        def type_value_color(value)
          case value.to_s.downcase
            when 'event', 'metric'
              inverse_color
            when 'error', 'exception'
              :red
            else
              default_color
          end
        end

        def event_key_color(value)
          case context[:level].to_s.downcase
            when 'warn'
              :yellow
            when 'error', 'fatal'
              :red
            else
              inverse_color
          end
        end
        alias_method :metric_key_color, :event_key_color

        def event_value_color(value)
          case context[:level].to_s.downcase
            when 'debug'
              :cyan
            when 'info'
              :green
            when 'warn'
              :yellow
            when 'error', 'fatal'
              :red
            else
              inverse_color
          end
        end
        alias_method :metric_value_color, :event_value_color

        def error_key_color(value)
          value.blank? ? default_color : :red
        end

        alias_method :level_value_bold, :severity_bold
        def type_value_bold(value)
          case value.to_s.downcase
            when 'event', 'metric'
              inverse_bold
            when 'error', 'exception'
              context[:level].to_s.downcase == 'fatal' ? default_bold : inverse_bold
            else
              default_bold
          end
        end

        def event_key_bold(value)
          context[:level].to_s.downcase == 'fatal' ? default_bold : inverse_bold
        end
        alias_method :metric_key_bold, :event_key_bold

        def event_value_bold(value)
          context[:level].to_s.downcase == 'fatal' ? default_bold : inverse_bold
        end
        alias_method :metric_value_bold, :event_value_bold

        def separator_color(key, value)
          return hidden_color if hidden_key?(key) && !highlight_key?(key)
          inverse_color
        end

        def separator_bold(key, value)
          return hidden_bold if hidden_key?(key) && !highlight_key?(key)
          inverse_bold
        end

        def colorize_key(key, value)
          colorize(key, key_color(key, value), key_bold(key, value))
        end

        def colorize_value(key, value, formatted=nil)
          colorize((formatted || value), value_color(key, value), value_bold(key, value))
        end

        def colorize_separator(key, value, separator='=')
          colorize(separator, separator_color(key, value), separator_bold(key, value))
        end

        def format(message)
          return message.strip      if message.is_a?(String)
          return message.join(' ')  if message.is_a?(Array)

          if message.is_a?(Enumerable)
            return ORDERED_KEYS.merge(sort_keys(message.to_h)).compact.map do |key,val|
              if hidden_key?(key) && Config.print_hidden == false
                ""
              else
                formatted = format(val)

                if val.is_a?(Array)
                  formatted = "#{colorize_separator(key, val, '(')}#{colorize_value(key, val, formatted)}#{colorize_separator(key, val, ')')}"
                elsif val.is_a?(Enumerable)
                  if highlight_key?(key)
                    formatted = formatted.gsub(/#{color(default_color).gsub('[','\[')}/, color(highlight_color(key)))
                    if highlight_bold(key) && ((hidden_key?(key) && !hidden_bold) || !default_bold)
                      formatted = formatted.gsub(/#{color(highlight_color(key)).gsub('[','\[')}/, "#{color(highlight_color(key))}#{color(:bold)}")
                    elsif !highlight_bold(key) && ((hidden_key?(key) && hidden_bold) || default_bold)
                      formatted = formatted.gsub(/#{color(:bold).gsub('[','\[')}/, '')
                    end
                  elsif hidden_key?(key)
                    formatted = colorize_value(key, val, formatted.gsub(/\e\[(\d+)m/, ''))
                  end
                  formatted = "#{colorize_separator(key, val, '<')}#{formatted}#{colorize_separator(key, val, '>')}"
                else
                  formatted = colorize_value(key, val, formatted)
                end

                "#{colorize_key(key, val)}#{colorize_separator(key, val)}#{formatted}"
              end
            end.join(' ')
          end

          message.to_s.strip
        end

      end
    end
  # end
end
