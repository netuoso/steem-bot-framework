class ApplicationRecord < ActiveRecord::Base
  include ApplicationHelper

  self.abstract_class = true
end
