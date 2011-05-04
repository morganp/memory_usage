memory_usage
============

   [Homepage][memory_usage]

Installation
------------

    gem install memory_usage

Usage
-----

    require 'rubygems'
    require 'memory_usage'
    
    a = MemoryUsage.new
    a.report
    
    a.refresh
    a.report
    
    a.filter("iTunes")
    a.report
    
    a.filter("") #Turn process name filter off
    a.gt(100) #Processes using more then 100 MB
    a.report


[memory_usage]: http://amaras-tech.co.uk/software/memory_usage
