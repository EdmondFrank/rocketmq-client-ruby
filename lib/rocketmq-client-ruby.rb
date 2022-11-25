module Rocketmq
  # :stopdoc:
  LIBPATH ||= __dir__ + ::File::SEPARATOR
  PATH ||= ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath(*args)
    rv = args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    if block_given?
      begin
        $LOAD_PATH.unshift LIBPATH
        rv = yield
      ensure
        $LOAD_PATH.shift
      end
    end
    rv
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path(*args)
    rv = args.empty? ? PATH : ::File.join(PATH, args.flatten)
    if block_given?
      begin
        $LOAD_PATH.unshift PATH
        rv = yield
      ensure
        $LOAD_PATH.shift
      end
    end
    rv
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to(fname, dir = nil)
    dir ||= ::File.basename(fname, ".*")
    search_me = ::File.expand_path(
      ::File.join(::File.dirname(fname), dir, "**", "*.rb")
    )

    Dir.glob(search_me).sort.each { |rb| require rb }
  end
end # module Rocketmq

require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "rocketmq")
require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "client/message")
require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "client/producer")
require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "client/push_consumer")
require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "client/transaction_mq_producer")
require File.join(Rocketmq::LIBPATH, "rocketmq-client-ruby", "client/received_message")
