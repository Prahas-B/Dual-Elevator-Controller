Dual Elevator Controller (Verilog)
Overview

This project implements a dual elevator control system in Verilog as part of a DDCO project. The system simulates two elevators operating concurrently and handling multiple floor requests using an arbitration mechanism.

Each elevator independently manages its movement, door state, and pending requests, while a centralized arbiter assigns incoming requests efficiently.

Features
Two elevators operating in parallel
Dynamic handling of multiple floor requests
Distance-based request allocation
Finite State Machine (FSM) control for each elevator
Prevention of duplicate request assignments
Simulation support with waveform generation
Architecture
Top Module (dual_elevator_top.v)
Integrates all components
Instantiates the arbiter and two elevator units
Arbiter (arbiter.v)
Assigns requests to elevators
Uses distance calculation to choose the closest elevator
Ensures requests are not assigned if already pending
Elevator Unit (elevator_unit.v)

Each elevator:

Tracks current floor and pending requests
Operates using an FSM:
IDLE – waiting state
MOVE – moving toward target floor
OPEN – door operation
Executes assigned requests independently
Testbench (tb_dual_elevator.v)
Simulates real-time requests
Displays system behavior
Includes helper functions for readable output
Waveform (dual_elevator.vcd)
Generated during simulation
Can be viewed using tools like GTKWave
Working
Floor requests are provided as a bit vector
The arbiter evaluates which elevator is closer
The request is assigned accordingly
The elevator adds the request to its pending queue
The elevator moves to the target floor and opens the door
The system continuously processes incoming requests
Simulation Instructions
Using Icarus Verilog
iverilog -o dual_elevator tb_dual_elevator.v dual_elevator_top.v arbiter.v elevator_unit.v
vvp dual_elevator
View Waveform
gtkwave dual_elevator.vcd
Project Structure
├── arbiter.v
├── elevator_unit.v
├── dual_elevator_top.v
├── tb_dual_elevator.v
├── dual_elevator.vcd
Key Concepts
Finite State Machines (FSM)
Arbitration and scheduling logic
Parallel hardware design
Bitwise request handling
Distance-based decision making
Possible Improvements
Direction-based scheduling (up/down logic)
Priority queues for requests
Support for more than two elevators
Realistic timing delays
FPGA implementation
