require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 400
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"

dir_name = Dir.pwd.split('/').last
IRB.conf[:PROMPT][:LS] = {
  :PROMPT_I=>"#{dir_name} >> ",
  :PROMPT_N=>"#{dir_name} >> ",
  :PROMPT_S=>nil,
  :PROMPT_C=>"#{dir_name} ?> ",
  :RETURN=>"=> %s\n"
}
IRB.conf[:PROMPT_MODE] = :LS
