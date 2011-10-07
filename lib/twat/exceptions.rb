module Twat
  class NoSuchAccount < Exception; end
  class NoDefaultAccount < Exception; end
  class NoSuchCommand < Exception; end
  class NoConfigFile < Exception; end
  class RequiresOptVal < Exception; end
  class Usage < Exception; end
  class InvalidCredentials < Exception; end
  class ConfigVersionIncorrect < Exception; end
  class InvalidSetOpt < Exception; end
  class InvalidBool < Exception; end
end
