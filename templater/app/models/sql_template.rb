class SqlTemplate < ActiveRecord::Base
  validates :body, :path, presence: true
  validates :format, inclusion: Mime::SET.symbols.map(&:to_s)
  validates :locale, inclusion: I18n.available_locales.map(&:to_s)
  validates :handler, inclusion: ActionView::Template::Handlers.extensions.map(&:to_s)

  after_save :expire_cache

  def expire_cache
    Resolver.instance.clear_cache
  end

  class Resolver < ActionView::Resolver
    require "singleton"
    include Singleton

    protected

    def find_templates(name, prefix, partial, details)
      conditions = {
          path: normalize_path(name, prefix),
          locale: normalize_array(details[:locale]).first,
          format: normalize_array(details[:formats]).first,
          handler: normalize_array(details[:handlers]),
          partial: partial || false
      }
      ::SqlTemplate.where(conditions).map do |record|
        initialize_template(record)
      end
    end

    # Normalize name and prefix so that the tuple ["index", "users"] becomes "index/users"
    # and the tuple ["index", nil] or ["index", ""] becomes "index"
    def normalize_path(name, prefix)
      prefix.present? ? "#{prefix}/#{name}" : name
    end

    #normalize array by converting symbols to stings
    def normalize_array(array)
      array.map(&:to_s)
    end

    # Initialize and ActionView::Template object based on the record found.
    def initialize_template(record)
      source = record.body
      identifier = "SqlTemplate - #{record.id} - #{record.path.inspect}"
      handler = ActionView::Template.registered_template_handler(record.handler)

      details = {
          format: Mime[record.format],
          updated_at: record.updated_at,
          virtual_path: virtual_path(record.path, record.partial)
      }

      ActionView::Template.new(source, identifier, handler, details)
    end

    # Make path as "users/users" become "users/_user" for partials
    def virtual_path(path, partial)
      return path unless partial
      if index = path.index("/")
        path.insert(index + 1, "_")
      else
        return "_#{path}"
      end
    end

  end

end
