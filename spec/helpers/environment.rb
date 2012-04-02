def set_argv(ary)
  while ARGV.length > 0
    ARGV.pop
  end

  ary.each { |e| ARGV << e }
end

def set_env(pairs)
  orig = {}
  begin
    pairs.each do |k, v|
      # TODO Check what happens when unsetting keys
      orig[k] = ENV[k]
      ENV[k] = v
    end
    yield
  ensure
    orig.each do |k, v|
      ENV[k] = v
    end
  end
end

def with_config(cfg)
  FileUtils.mktemp do |dir|
    set_env('TWAT_CONFIG' => "#{dir}/twatrc") do
      File.open("#{dir}/twatrc", 'w') do |conf|
        conf.chmod(0600)
        conf.puts(cfg.to_yaml)
      end

      yield

    end
  end
end

def with_no_config
  FileUtils.mktemp do |dir|
    set_env('TWAT_CONFIG' => "#{dir}/twatrc") do

      yield

    end
  end
end
