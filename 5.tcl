set stop 100
set minth 0
set maxth 30
set adaptive 1
set window 30
set web 2
set type gsm
set opt(wrap) 100
set opt(srcTrace) is
set opt(dstTrace) bs2
set bwDL(gsm) 9600
set bwUL(gsm) 9600
set propDL(gsm) .500
set propUL(gsm) .500

set ns [new Simulator]
set tf [open 5.tr w]
$ns trace-all $tf
set nf [open 5.nam w]
$ns namtrace-all $nf

set n(is) [$ns node]
set n(lp) [$ns node]
set n(ms) [$ns node]
set n(bs1) [$ns node]
set n(bs2) [$ns node]

proc cell_topo {} {
global ns n
$ns duplex-link $n(lp) $n(bs1) 3Mbps 10n(ms) DropTail
$ns duplex-link $n(bs1) $n(ms) 1 1 RED
$ns duplex-link $n(ms) $n(bs2) 1 1 RED
$ns duplex-link $n(bs2) $n(is) 3Mbps 50n(ms) DropTail
puts "GSM cell topology"
}
proc set_link_para {t} {
global ns n bwDL bwUL propDL propUL buf
$ns bandwidth $n(bs1) $n(ms) $bwDL($t) duplex
$ns bandwidth $n(bs2) $n(ms) $bwDL($t) duplex
$ns delay $n(bs1) $n(ms) $propDL($t) duplex
$ns delay $n(bs2) $n(ms) $propDL($t) duplex
$ns queue-limit $n(bs1) $n(ms) 10
$ns queue-limit $n(bs2) $n(ms) 10
}

Queue/RED set adaptive_ $adaptive
Queue/RED set thresh_ $minth
Queue/RED set maxthresh_ $maxth
Agent/TCP set window_ $window

source "/home/bnmit/ns-allinone-2.35/ns-2.35/tcl/ex/wireless-scripts/web.tcl"

switch $type {
gsm -
gprs -
umts {cell_topo}
}

set_link_para $type
set tcp1 [new Agent/TCP]
$ns attach-agent $n(is) $tcp1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(lp) $sink1

$ns connect $tcp1 $sink1

$ns at 0.8 "[set ftp1] start"

proc stop {} {
global n opt nf
set wrap $opt(wrap)
set sid [$n($opt(srcTrace)) id]
set did [$n($opt(dstTrace)) id]
set a "5.tr"
set GETRC "/home/bnmit/ns-allinone-2.35/ns-2.35/bin/getrc"
set RAW2XG "/home/bnmit/ns-allinone-2.35/ns-2.35/bin/raw2xg"
exec $GETRC -s $sid -d $did -f 0 5.tr | \
$RAW2XG -s 0.01 -m $wrap -r > plot.xgr
exec $GETRC -s $did -d $sid -f 0 5.tr | \
$RAW2XG -a -s 0.01 -m $wrap >> plot.xgr
exec xgraph -x time -y packets plot.xgr &
exec nam 5.nam &
exit 0
}

$ns at $stop "stop"
$ns run
