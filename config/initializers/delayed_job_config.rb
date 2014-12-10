# Delayed::Worker.max_attempts = 25
# Delayed::Worker.delay_jobs = !Rails.env.local_test?
# Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 360
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
