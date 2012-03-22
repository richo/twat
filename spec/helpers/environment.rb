def set_argv(ary)
  while ARGV.length > 0
    ARGV.pop
  end

  ary.each { |e| ARGV << e }
end
