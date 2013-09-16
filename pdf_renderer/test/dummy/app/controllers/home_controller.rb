class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pdf { render pdf: "contents" }
    end
  end

  def another
    render template: "home/index", pdf: "contents"
  end
end
