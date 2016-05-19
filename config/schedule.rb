every 1.day, at: '14:00' do
  runner "DailyDigestJob.perform_later"
end