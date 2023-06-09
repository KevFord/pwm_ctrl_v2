#Restart simulation
restart -f

# Define all input signals, reset active
force clk_50 0 0, 1 10 ns -r 20 ns

force reset 1
run 21 ns

force reset 0
run 21 ns

# Run a short time
run 0.5 us

force key_off 1
run 10 us
force key_off 0
run 21 ns
force key_up 1
run 10 us
force key_up 0
run 1 us

force key_on 1
run 21 ns

force key_on 0
run 21 ns

run 1 ms

force key_up 1
run 21 ns
force key_up 0
run 21 ns


force key_up 1
run 21 ns
force key_up 0
run 1 ms

force key_up 1
run 21 ns
force key_up 0
run 1 ms

force key_down 1
run 21 ns
force key_down 0
run 21 ns

force key_down 1
run 21 ns
force key_down 0
run 1 ms

force duty_cycle 55

run 1.7 ms

force reset 1
run 21 ns
force reset 0
run 1.321 ms

force key_off 1
run 21 ns
force key_off 0
run 1 ms