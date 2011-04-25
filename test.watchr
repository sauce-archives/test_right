def growl(title, message)
  growlnotify = `which growlnotify`.chomp
  image = message.include?('0 failures, 0 errors') ? "~/.watchr_images/passed.jpg" : "~/.watchr_images/failed.jpg"
  options = "-w -n Watchr --image '#{File.expand_path(image)}' -m '#{message}' '#{title}'"
  system %(#{growlnotify} #{options} &)
end

def run_test_file(file)
  system('clear')
  result = `rake test TEST=#{file}`
  growl file, result.split("\n").last rescue nil
  puts result
end

watch("test/test_.*\.rb") {|match| run_test_file(match[0])}
watch("lib/test/right/(.*)\.rb") {|match| run_test_file("test/test_#{match[1]}.rb")}
