SIZES="64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 232144"
for i in $SIZES; do
	echo Size $i
	echo -n $i ''>> data
	./closestPair.rb `echo $i` | echo `awk '{print $4}'` ''>> data
done
