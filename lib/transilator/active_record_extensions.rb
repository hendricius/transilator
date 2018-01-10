module Transilator
  module ActiveRecordExtensions

    module ClassMethods

      def transilator(*args)

        args.each do |attribute|

          # read the attribute from the hstore attribute and return it.
          #
          # returns the attribute or an empty string if the attribute is nil
          define_method attribute do
            locale = I18n.locale.to_s
            attribute_value_hash = (self[attribute] || {})
            value = (attribute_value_hash)[locale] || ""
            # we have a value, so let's abort.
            return value unless value.empty?
            # now implement our fallback mechanism
            fallbacks_for_locale  = Transilator.config.get_fallbacks_for_locale(locale)
            return value if fallbacks_for_locale.empty?
            # now do the magic for figuring out the fallback
            fallback_locale_to_use = fallbacks_for_locale.find {|f| (attribute_value_hash)[f] }
            # no fallback that can be used found.
            return "" unless fallback_locale_to_use
            # return our value or an empty string
            attribute_value_hash[fallback_locale_to_use] || ""
          end

          # set the attribute on the model on the hstore hash
          #
          # returns the new value
          define_method "#{attribute}=" do |value|
            if value.is_a?(Hash)
              write_attribute attribute, value
            elsif self[attribute].present?
              write_attribute attribute, self[attribute].merge({I18n.locale => value })
              value
            else
              write_attribute attribute, {I18n.locale => value }
              value
            end
          end

          # returns the raw hstore directly
          define_method "#{attribute}_before_type_cast" do
            self[attribute] || {}
          end

          module_eval do
            serialize "#{attribute}", ActiveRecord::Coders::Hstore
          end if defined?(ActiveRecord::Coders::Hstore)


          # for each locale add a getter and setter method in the type of
          # title_de or title_en
          I18n.available_locales.map(&:to_s).each do |locale|

            define_method "#{attribute}_#{locale}" do
              (self[attribute] || {})[locale] || ""
            end

            define_method "#{attribute}_#{locale}=" do |value|
              if self[attribute].present?
                write_attribute attribute, self[attribute].merge({locale => value })
              else
                write_attribute attribute, {locale => value }
              end
            end

          end
        end
      end


    end

  end
end

ActiveRecord::Base.extend Transilator::ActiveRecordExtensions::ClassMethods
