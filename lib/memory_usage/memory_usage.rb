
path = File.expand_path __FILE__
path = File.dirname(path)

require "#{path}/memory_usage_optparse"

#Class which has function for gathering memory stats.
# Should work on unix/linux and OS X
# Example usage at the bottom
class MemoryUsage

   def initialize(argv=[""])
      @options = MemoryUsageOptparse.parse(argv)
      refresh
   end

   #Filter process by name when printing
   def filter (text="")
      @options.filter = (text)
   end

   #Filter processes using greater than x MB
   def gt( num=0 )
      @options.min = num
   end


   #Recalculate Memory usage. stops have to call MemoryUsage.new
   def refresh
      #Based on: http://gist.github.com/290988
      @total = 0.0
      @usage = Array.new
      @max = {:pid=>0, :rss=>0, :command=>0}

      `ps -u $USER -o pid,rss,command`.split("\n").each do |p|
         p.strip!
         if p.match(/^\d/) 
            p =~ /(\d+)\s+(\d+)\s+(.+)/
            
            pid, rss, command = [$1, $2, $3]

            # Some complicated logic
            #Allow if no options set OR
            #Allow if command matches filter but not with --filter (because that is this file)  OR
            #Filter is memory_usage we will allow it to profile itself
               rss = rss.to_f
               @usage << {:pid=>pid, :rss=>(rss/1024), :command=>command }
               @total += rss/1024

               if pid.to_s.size > @max[:pid]
                  @max[:pid] = pid.to_s.size
               end

               if rss.to_s.size > @max[:rss]
                  @max[:rss] = rss.to_s.size
               end
         
               if command.size > @max[:command]
                  @max[:command] = command.size
               end
            #puts pid + (" %.2f MB " % (rss/1024)) + command
            
         end
      end
       @usage = @usage.sort_by { |process| process[:rss] }
      #puts "Your total usage: %.2f MB" % (total / 1024)

   end

   #Display to stdout Error report
   def report
      @usage.each do |x|
         if  (@options.filter == "") or 
             ((x[:command].match(/.*#{@options.filter}.*/)) and (not x[:command].match(/.*--filter #{@options.filter}.*/) )) or
             ((x[:command].match(/.*#{@options.filter}.*/)) and (@options.filter.match(/.*memory_usage.*/)))
            if x[:rss] > @options.min 
               #rjust string.rjust(min length)
               puts x[:pid].rjust( @max[:pid] ) + (" %.2f MB " % x[:rss]).rjust( @max[:rss]+3 ) + x[:command]
            end
         end
      end
      puts "Total Memory Usage: %.2f MB" % @total
   end

   #Return total memory as a String
   def total
      "%.2f" % @total
   end
end
 




#Run example only if called directly
#ie not if included/required for class 
if $0 == __FILE__
   a = MemoryUsage.new
   a.report

   #a.refresh
   #a.report
   #puts a.total
   
   #command = MemoryUsage.new
   #exit command.run!

end

