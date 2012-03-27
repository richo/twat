require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Twat do

  ["-n", "--account"].each do |flag|
    it "Should respect the #{flag} flag" do #{{{
      with_config(Fixtures::multiuser_config) do

        set_argv [flag, "secondAccount"]

        $args = ::Twat::Args.new
        conf = ::Twat::Config.new

        conf.account.should == Fixtures::multiuser_config[:accounts][:secondAccount]
      end
    end
  end #}}}

  ["-h", "--help"].each do |flag|
    it "Should print help and bail on the #{flag} flag" do #{{{
      set_argv [flag]

      STDOUT.expects(:puts) # Getting the exact usage string TODO
      lambda { args = ::Twat::Args.new }.should raise_error SystemExit
    end #}}}
  end

  ["-v", "--version"].each do |flag|
    it "Should print the version and exit on #{flag}" do #{{{
      set_argv [flag]

      STDOUT.expects(:puts).with("twat #{::Twat::VERSION}")
      lambda {
        args = ::Twat::Args.new }.should raise_error SystemExit

    end #}}}
  end

end
