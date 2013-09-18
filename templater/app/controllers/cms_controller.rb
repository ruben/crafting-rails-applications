class CmsController < ActionController::Base
  prepend_view_path SqlTemplate::Resolver.instance

  def show
    render template: params[:page]
  end

end