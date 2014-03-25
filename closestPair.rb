#!/usr/bin/ruby

# points = Array.new(ARGV.first.to_i){[rand(100), rand(100)]}
# points = Array.new(16){[rand(100), rand(100)]}
points = [[46, 91], [85, 1], [2, 95], [52, 27], [80, 94], [23, 9], [6, 20], [94, 33], [47, 57], [50, 51], [49, 54], [42, 75], [8, 39], [42, 75], [86, 52], [51, 9]]

def dist(p1, p2)
	Math.sqrt((p1.first - p2.first) ** 2 + (p1.last - p2.last) ** 2)
end

def dumbAlgo(points)
	points.map{|x| points.map{|y| x == y ? Float::INFINITY : dist(x, y)}.min}.min
end

def slowDC(points)
	puts points.inspect
	return dist(points.first, points.last) if points.size == 2
	left, right = points.each_slice(points.size / 2).to_a
	min = [slowDC(left), slowDC(right)].min
	mid = points[points.size / 2].first
	puts "#{mid}, #{min}"
	# puts points.select{|x| (mid - min..mid + min) === x.first}.inspect, ''
	[min, slowDC(points.select{|x| (mid - min..mid + min) === x.first})].min
end

def fastDC(points)

end

# puts points.inspect

# puts dumbAlgo(points)

points.sort!{|x, y| x.first <=> y.first}
puts slowDC(points)
# puts points.inspect
