#!/usr/bin/ruby

points = Array.new(ARGV.first.to_i){[rand(100), rand(100)]}

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

start = Time.now
puts dumbAlgo(points)
puts "#{ARGV.first} DumbAlgo: #{Time.now - start} seconds"

points.sort!{|x, y| x.first <=> y.first}

start = Time.now
puts slowDC(points)
puts "#{ARGV.first} SlowD&C: #{Time.now - start} seconds"

start = Time.now
puts fastDC(points)
puts "#{ARGV.first} FastD&C: #{Time.now - start} seconds"
