module ActiveAdminAddons
  module InputMethods
    def model_name
      if respond_to?(:builder) && builder.options[:as].present?
        builder.options[:as]
      else
        valid_object.class.to_s.underscore.tr('/', '_')
      end
    end

    def valid_method
      raise "invalid method given" if method.blank?

      method
    end

    def valid_object
      raise "blank object given" if @object.blank?

      @object
    end

    def object_class
      valid_object.class
    end

    def association_name
      valid_method.to_s.singularize.chomp("_id")
    end

    def method_model
      @options[:method_model] ||
        object_class.reflect_on_association(association_name).try(:klass) ||
        association_name.classify.constantize
    end

    def tableize_method
      association_name.tableize
    end

    def input_related_items
      valid_object.send(tableize_method)
    rescue NoMethodError
      raise "no association called #{tableize_method} on #{model_name} model"
    end

    def input_value
      @input_value ||= valid_object.send(valid_method)
    end

    def input_association_value
      @input_association_value ||= valid_object.send(association_name)
    end

    def translated_method
      valid_object.class.human_attribute_name(valid_method)
    end

    def url_from_method
      url = ["/"]

      if ActiveAdmin.application.default_namespace.present?
        url << "#{ActiveAdmin.application.default_namespace}/"
      end

      url << tableize_method
      url.join("")
    end

    def build_virtual_attr
      attribute_name = "virtual_#{valid_method}_attr"
      fail "#{attribute_name} is already defined" if valid_object.respond_to?(attribute_name)

      valid_object.singleton_class.send(:attr_accessor, attribute_name)
      attribute_name
    end
  end
end
