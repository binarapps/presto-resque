class AccessLogStatusStat < ActiveRecord::Base

  scope :find_4xx_statuses, -> { where('status >= :min and status < :max_ex', { min: 400, max_ex: 500 }).order('count desc') }
  scope :find_5xx_statuses, -> { where('status >= :min and status < :max_ex', { min: 500, max_ex: 600 }).order('count desc') }

end
