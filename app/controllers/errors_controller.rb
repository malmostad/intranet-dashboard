class ErrorsController < ApplicationController
  before_filter { sub_layout(false) }

  def error_404
    not_found
  end

  def error_500
    server_error
  end
end
