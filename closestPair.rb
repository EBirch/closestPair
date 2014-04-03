#!/usr/bin/ruby

randPoints = Array.new(ARGV.first.to_i){[rand() * 100, rand() * 100]}
num = Math.sqrt(ARGV.first.to_i)
space = 100.0 / num
vOff = space / 2.0
hOff = Math.sqrt((space ** 2) - (vOff ** 2))
uniformPoints = (0..num).inject([]){|arr, i| (0..num).inject(arr){|arr, j| arr << [i * hOff, j * space + (i.even? ? vOff : 0)]}}[0...ARGV.first.to_i]
mixedPoints = Array.new(ARGV.first.to_i){|x| rand() < 0.95 ? uniformPoints[x] : [rand() * 100, rand() * 100]}

def dist(p1, p2)
	return Float::INFINITY if p1.nil? || p2.nil?
	Math.sqrt((p1.first - p2.first) ** 2 + (p1.last - p2.last) ** 2)
end

def dumbAlgo(points)
	(0..points.size).map{|x| (x..points.size).map{|y| x == y ? Float::INFINITY : dist(points[x], points[y])}.min}.min
end

def slowDC(points)
	return dist(points.first, points.last) if points.size == 2
	left, right = points.each_slice(points.size / 2).to_a
	min = [slowDC(left), slowDC(right)].min
	mid = points[points.size / 2].first
	[min, dumbAlgo(points.select{|x| (mid - min..mid + min) === x.first})].min
end

def fastDC(points)
	return dist(points.first, points.last) if points.size == 2
	left, right = points.each_slice(points.size / 2).to_a
	min = [fastDC(left), fastDC(right)].min
	mid = points[points.size / 2].first
	strip = points.select{|x| (mid - min..mid + min)}.sort{|x, y| x.last <=> y.last}
	[min, (0..strip.size).map{|x| (1..6).map{|y| dist(strip[x], strip[x + y])}.min}.min].min
end

def timeRun(proc, str)
	start = Time.now
	proc.call
	puts "#{ARGV.first} #{str}: #{Time.now - start} seconds"
end

timeRun(Proc.new{dumbAlgo(randPoints)}, "DumbAlgo Random")
timeRun(Proc.new{dumbAlgo(uniformPoints)}, "DumbAlgo Uniform")
timeRun(Proc.new{dumbAlgo(mixedPoints)}, "DumbAlgo Mixed")
timeRun(Proc.new{slowDC(randPoints.sort{|x, y| x.first <=> y.first})}, "SlowD&C Random")
timeRun(Proc.new{slowDC(uniformPoints.sort{|x, y| x.first <=> y.first})}, "SlowD&C Uniform")
timeRun(Proc.new{slowDC(mixedPoints.sort{|x, y| x.first <=> y.first})}, "SlowD&C Mixed")
timeRun(Proc.new{fastDC(randPoints.sort{|x, y| x.first <=> y.first})}, "FastD&C Random")
timeRun(Proc.new{fastDC(uniformPoints.sort{|x, y| x.first <=> y.first})}, "FastD&C Uniform")
timeRun(Proc.new{fastDC(mixedPoints.sort{|x, y| x.first <=> y.first})}, "FastD&C Mixed")
