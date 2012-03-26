require 'mktemp'
module FileUtils extend self

  include MkTemp

  # Shamelessly poached from homebrew
  def mktemp(opts={})
    tmp_prefix = ENV['TWAT_TEMP'] || Dir.pwd
    tmp=Pathname.new MkTemp.mktempdir("#{tmp_prefix}/twat_spec-XXXX")
    raise "Couldn't create build sandbox" if not tmp.directory?
    begin
      yield tmp
    ensure
      tmp.rmtree unless opts[:clean] == false
    end
  end

end
