module MailForm
  class Base
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    extend ActiveModel::Callbacks
    include ActiveModel::AttributeMethods
    include ActiveModel::Validations
    include MailForm::Validators
    attribute_method_prefix 'clear_'
    attribute_method_suffix '?'
    class_attribute :attribute_names
    self.attribute_names = []
    define_model_callbacks :deliver

    def self.attributes(*names)
      attr_accessor(*names)
      define_attribute_methods(*names)
      self.attribute_names += names
    end

    def clear_attribute(attribute)
      send("#{attribute}=", nil)
    end

    def attribute?(attribute)
      send(attribute).present?
    end

    def persisted?
      false
    end

    def initialize(attributes = {})
      attributes.each do |key, value|
        self.public_send("#{key}=", value)
      end if attributes
    end

    def deliver
      if valid?
        run_callbacks(:deliver) do
          MailForm::Notifier.contact(self).deliver
        end
      else
        false
      end
    end

  end
end