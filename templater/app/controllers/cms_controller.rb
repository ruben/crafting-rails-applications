class CmsController < ActionController::Metal
  include ActionController::Rendering
  include AbstractController::Helpers
  include AbstractController::Layouts

  layout "cms"

  prepend_view_path SqlTemplate::Resolver.instance

  def show
    render template: params[:page]
  end

end