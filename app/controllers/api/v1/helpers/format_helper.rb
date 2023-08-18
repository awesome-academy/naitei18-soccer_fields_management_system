module API::V1::Helpers::FormatHelper
  extend Grape::API::Helpers

  Grape::Entity.format_with :time_format do |time|
    time.strftime(Settings.format.time)
  end

  Grape::Entity.format_with :date_format do |date|
    date.strftime(Settings.format.date)
  end
end
