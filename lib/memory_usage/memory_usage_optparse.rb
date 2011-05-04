require 'optparse'
require 'optparse/time'
require 'ostruct'

class MemoryUsageOptparse


    #
    # Return a structure describing the options.
    #
    def self.parse(args)
      @VERSION = "0.0.4"
      
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      
      options.verbose = false
      options.filter = ""
      options.min = 0.0
       

      opts = OptionParser.new do |opts|
         opts.banner = "Usage: #{__FILE__} [options]"
         opts.separator ""
         opts.separator "Common options:"

         # No argument, shows at tail. This will print an options summary.
         opts.on("-h", "--help", "Show this message") do
            puts opts
            exit
         end

         # Another typical switch to print the version.
         opts.on("--version", "Show version") do
            #puts OptionParser::Version.join('.')
            puts "Version #{@VERSION}"
            exit
         end

         # Boolean switch.
         #opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
         #   options.verbose = v
         #end

         opts.separator ""
         opts.separator "Specific options:"


         # Cast 'delay' argument to a Float.
         opts.on("--filter name", String, "text to filter process") do |n|
            options.filter = n
         end
         
         opts.on("--gt N", Float, "Memory usage greater than N") do |n|
            options.min = n
         end
         
        
      end
      
      options.leftovers = opts.parse!(args)
      options
    end # parse()

  end # class OptparseExample

