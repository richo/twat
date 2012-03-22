require 'twat'
require 'mocha'

describe Twat do

  # before(:each) do
  # end

  # after(:each) do
  # end

  it "Should call follow tag by default" do
    #Twat::Subcommands::FollowTag.any_instance.expects(:run)
    Twat::Subcommands::FollowTag.any_instance.stubs(:run => "rawr")
    # Twat::Subcommand.stubs(:run! => "rawr")
    # Twat::Subcommand.stubs(:run! => "rawr").at_least(5)
    Twat::Subcommand.expects(:run!).never

    ARGV = []
    Twat::Twat.new.cli_run
  end

  it "Should do something else" do
    m = mock()
    m.expects(:rawr).at_least(5)
    # puts m.thing
    puts m.rawr

    ARGV.expects(:gets).returns("rawr")
    Twat::Twat.expects(:cli_runasdf).at_least_once
    # 123.should == "123"
  end

end
