# Create a new simulation object
set ns [new Simulator]

# Create a trace file for NAM visualization
set nf [open out.nam w]
$ns namtrace-all $nf

# Create nodes
set srcNode [$ns node]
set destNode1 [$ns node]
set destNode2 [$ns node]
set otherNode1 [$ns node]
set otherNode2 [$ns node]

# Create links
$ns duplex-link $srcNode $otherNode1 1Mb 10ms DropTail
$ns duplex-link $srcNode $otherNode2 1Mb 10ms DropTail
$ns duplex-link $otherNode1 $destNode1 1Mb 10ms DropTail
$ns duplex-link $otherNode2 $destNode2 1Mb 10ms DropTail

# Define distance vector routing
$srcNode set ragent [new Agent/Vector]
$srcNode attach $srcNode $srcNode
$srcNode set distvector [new Agent/Vector]
$srcNode attach $srcNode $srcNode(distvector)
$ns attach-agent $srcNode $srcNode(distvector)

# Schedule start of distance vector routing
$ns at 0.0 "$srcNode distvector start"

# Define destinations
set udp1 [new Agent/UDP]
$ns attach-agent $destNode1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $destNode1 $null1
$ns connect $udp1 $null1

set udp2 [new Agent/UDP]
$ns attach-agent $destNode2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $destNode2 $null2
$ns connect $udp2 $null2

# Schedule traffic generation from source to destinations
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set rate_ 1Mb
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.01
$ns at 1.0 "$cbr1 start"
$ns at 10.0 "$cbr1 stop"

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set rate_ 1Mb
$cbr2 set packetSize_ 1000
$cbr2 set interval_ 0.01
$ns at 2.0 "$cbr2 start"
$ns at 11.0 "$cbr2 stop"

# Define the termination condition
$ns at 12.0 "$ns halt"

# Run the simulation
$ns run
