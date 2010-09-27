require 'rails/generators/generated_attribute'

module WebAppTheme
  class ThemedGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def initialize(args, *options)
      super(args, *options)
      initialize_views_variables(args)
    end
    
    def copy_views
      template 'view_tables.html.erb',  File.join('app/views', @controller_file_path, 'index.html.erb')
      template 'view_new.html.erb',     File.join('app/views', @controller_file_path, 'new.html.erb')
      template 'view_edit.html.erb',    File.join('app/views', @controller_file_path, 'edit.html.erb')
      template 'view_form.html.erb',    File.join('app/views', @controller_file_path, '_form.html.erb')
      template 'view_show.html.erb',    File.join('app/views', @controller_file_path, 'show.html.erb')
      template 'view_sidebar.html.erb', File.join('app/views', @controller_file_path, '_sidebar.html.erb')
    end
    
  protected
    
    def initialize_views_variables(args)
      @controller_path  = args.shift
      @model_name       = args.shift
      @base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_path)
      @controller_routing_path = @controller_file_path.gsub(/\//, '_')
      @model_name = @base_name.singularize unless @model_name
      @model_name = @model_name.camelize
    end
    
    def controller_routing_path
      @controller_routing_path
    end
    
    def singular_controller_routing_path
      @controller_routing_path.singularize
    end
    
    def model_name
      @model_name
    end
    
    def plural_model_name
      @model_name.pluralize
    end
    
    def resource_name
      @model_name.underscore
    end
    
    def plural_resource_name
      resource_name.pluralize
    end
    
    def columns
      excluded_column_names = %w[id created_at updated_at]
      Kernel.const_get(@model_name).columns.reject{|c| excluded_column_names.include?(c.name) }.collect{|c| Rails::Generators::GeneratedAttribute.new(c.name, c.type)}
    end
    
    def extract_modules(name)
      modules = name.include?('/') ? name.split('/') : name.split('::')
      name    = modules.pop
      path    = modules.map { |m| m.underscore }
      file_path = (path + [name.underscore]).join('/')
      nesting = modules.map { |m| m.camelize }.join('::')
      [name, path, file_path, nesting, modules.size]
    end 
  end
end