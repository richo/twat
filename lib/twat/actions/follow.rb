module Twat

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

    def follow
      if defined?(Curses)
        Curses.noecho
        Curses.init_screen
      end

      twitter_auth
      failcount = 0
      @tweetstack = TweetStack.new

      # Get 5 tweets
      tweets = Twitter.home_timeline(:count => 5)
      while true do
        begin
          last_id = process_followed(tweets) if tweets.any?
          config.polling_interval.times do
            begin
              handle_input(STDIN.read_nonblock(128).chop)
            rescue Errno::EAGAIN
              nil
            rescue TweetTooLong
              puts "Too long".red
            end
            sleep 1
          end
          tweets = Twitter.home_timeline(:since_id => last_id)
          failcount = 0
        rescue Interrupt
          break
        rescue Twitter::ServiceUnavailable
          if failcount > 2
            puts "3 consecutive failures, giving up"
          else
            sleeptime = 60 * (failcount + 1)
            print "(__-){".red
            puts ": the fail whale has been rolled out, sleeping for #{sleeptime} seconds"
            sleep sleeptime
            failcount += 1
          end
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
      end
    end

    private

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
          puts "No such tweet".red
        end
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
