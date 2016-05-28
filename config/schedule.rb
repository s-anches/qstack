every 1.day, at: '14:00' do
  runner "DailyDigestJob.perform_later"
end

every 60.minutes do
  rake "ts:index"
end