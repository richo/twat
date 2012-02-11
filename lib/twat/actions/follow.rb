module Twat
  POLLING_RESOLUTION = 20

  class NoSuchTweet < Exception; end

  class TweetStack
    # A circularly linked list representing all of the tweets printed thus far,
    # for the purposes of retrieving them after being printed
    def initialize
      @stack = {}
      @_next = 0
    end

    def [] k
      @stack[k]
    end

    def << v
      @stack[nxt] = v
    end

    def include? k
      @stack.keys.include?(k)
    end

    def last
      # I see the irony
      @_next
    end

    private

    def nxt
      if @_next == 99
        @_next = 1
      else
        @_next += 1
      end
    end

  end


  class Actions

    def initialize
      @buf = ""
    end

    def follow
      if defined?(Curses)
        Curses.noecho
        Curses.init_screen
      else
        $stty_saved = `stty -g`
        `stty -echo raw`
      end

      twitter_auth
      failcount = 0
      @tweetstack = TweetStack.new

      # Get 5 tweets
      tweets = Twitter.home_timeline(:count => 5)
      while true do
        begin
          last_id = process_followed(tweets) if tweets.any?
          (config.polling_interval * POLLING_RESOLUTION).times do
            begin
              this = STDIN.read_nonblock(128)
              # print this.inspect
              print_char(this)
              @buf += this
              # Bails here if no input
              exit if @buf.include?("\x03")
              ary = @buf.split("\r")

              # Work out if we got a complete command
              @buf = @buf[-1] == "\r" ? "" : ary.pop
              ary.each { |inp| handle_input(inp) }
            rescue Errno::EAGAIN
              nil
            rescue TweetTooLong
              puts "Too long".red
            end
            sleep 1.0/POLLING_RESOLUTION
          end
          tweets = Twitter.home_timeline(:since_id => last_id)
          failcount = 0
        rescue Interrupt
          break
        # rescue Twitter::ServiceUnavailable
        #   if failcount > 2
        #     puts "3 consecutive failures, giving up"
        #   else
        #     sleeptime = 60 * (failcount + 1)
        #     print "(__-){".red
        #     puts ": the fail whale has been rolled out, sleeping for #{sleeptime} seconds"
        #     sleep sleeptime
        #     failcount += 1
        #   end
        rescue Errno::ECONNRESET
        rescue Errno::ETIMEDOUT
          if failcount > 2
            puts "3 consecutive failures, giving up"
          else
            failcount += 1
          end
        end
      end
    ensure
      if defined?(Curses)
        Curses.echo
      else
        `stty #{$stty_saved}`
      end
    end

    private

    def print_char(c)
      case c
      when "\x7F"
        print "\x0b"
      else
        print c
      end
    end

    # The handling of the shared variable in the follow code makes a shitton
    # more sense in the context of a class (ala the subcommands branch).  For
    # now the kludginess must be tolerated

    # @return last_id
    def process_followed(tweets)
      last_id = nil
      tweets.reverse.each do |tweet|
        id = @tweetstack << tweet
        beep if config.beep? && tweet.text.mentions?(config.account_name)
        output(tweet, @tweetstack.last)
        last_id = tweet.id
      end

      return last_id
    end

    def handle_input(inp)
      case inp
      when /[rR][tT] ([0-9]{1,2})/
        begin
          retweet($1.to_i)
        rescue NoSuchTweet
          print "No such tweet\n".red
        end
      when /test/
      else
        # Assume they want to tweet something
        raise TweetTooLong if inp.length > 140

        Twitter.update(inp)
      end
    end

    def retweet(idx)
      raise NoSuchTweet unless @tweetstack.include?(idx)
      Twitter.retweet(@tweetstack[idx].id)
    end

  end

end
