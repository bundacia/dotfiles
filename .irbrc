require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 400
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"
