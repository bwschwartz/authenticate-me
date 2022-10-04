class ApplicationController < ActionController::API
  # convert from camelCase to snake_case
  before_action :snake_case_params

  private

  def snake_case_paparams
    params.deep_transform_keys!(&:underscore)
  end

end
