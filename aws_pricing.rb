#!/usr/bin/env ruby
require 'optparse'
require 'awscosts'

@region = 'us-west-2'
@instances = []
@hours = 24
@number = 1

parser = OptionParser.new do|opts|
  opts.banner = "Usage: aws_pricing.rb [options]"

  opts.on("--url=AMAZON_URL", "Amazon pricing URL, defaults to: #{@aws}" ) do |n|
    @aws = n
  end

  opts.on("-t INSTANCE_TYPE", "--type=INSTANCE_TYPE", "The instance type to calculate the price for.") do |n|
    @instances << n
  end

  opts.on('-i INSTANCES', "--instances=INSTANCE_TYPE1,INSTANCE_TYPE2,INSTANCE_TYPE3") do |n|
    @instances = n.split(",")
  end

  opts.on("-r REGION", "--region=REGION", "The region to get pricing for. Defautlts to #{@region}") do |n|
    @region = n
  end

  opts.on('-H HOURS', '--hours=HOURS', OptionParser::DecimalInteger, "Number of hours to calculate for. Defaults to 24.") do |n|
    @hours = n
  end

  opts.on('-n', '--number', OptionParser::DecimalInteger, "Number of instances to calculate for. Defaults to 1.") do |n|
    @number = n
  end

  opts.on("-h", "--help", "Returns help.") do
    puts opts
    exit
  end

end

parser.parse!


region = AWSCosts.region @region

base = 0
@instances.each do |i|
  base = base + region.ec2.on_demand(:linux).price(i)
end

puts base * @hours * @number



