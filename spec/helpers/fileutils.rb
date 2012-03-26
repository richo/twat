module FileUtils extend self

  # Shamelessly poached from homebrew
  def mktemp(opts={})
    tmp_prefix = ENV['TWAT_TEMP'] || Dir.pwd
    tmp=Pathname.new `mktemp -d #{tmp_prefix}/twat_spec-XXXX`.strip
    raise "Couldn't create build sandbox" if not tmp.directory? or $? != 0
    begin
      yield tmp
    ensure
      tmp.rmtree unless opts[:clean] == false
    end
  end

end
