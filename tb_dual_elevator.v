`timescale 1ns/1ps
module tb_dual_elevator;
    parameter FLOORS = 6;
    reg clk, rst;
    reg [FLOORS-1:0] requests;
    wire [FLOORS-1:0] pending0, pending1;
    wire [$clog2(FLOORS)-1:0] e0_floor, e1_floor;
    
    dual_elevator_top #(.FLOORS(FLOORS)) dut (
        .clk(clk),
        .rst(rst),
        .requests(requests),
        .pending0(pending0),
        .pending1(pending1),
        .e0_floor(e0_floor),
        .e1_floor(e1_floor)
    );
    
    // ----------------------------------------------------------
    // Function to print ALL active floor numbers as "{2,4,5}"
    // ----------------------------------------------------------
    function [255:0] floors_to_str;
        input [FLOORS-1:0] vec;
        integer i;
        reg [255:0] s;
        reg [31:0] tmp;
        reg first;
        begin
            s = "{";
            first = 1;
            for (i = 0; i < FLOORS; i = i + 1) begin
                if (vec[i]) begin
                    if (!first)
                        s = {s, ","};
                    tmp = i;
                    s = {s, tmp[7:0] + "0"};
                    first = 0;
                end
            end
            s = {s, "}"};
            floors_to_str = s;
        end
    endfunction
    
    // ----------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------
    initial begin
        $dumpfile("dual_elevator.vcd");
        $dumpvars(0, tb_dual_elevator);
        
        clk = 0; 
        rst = 1; 
        requests = 0;
        
        #20 rst = 0;
        
        // Example floor calls
        #30  requests[2] = 1;  // floor 2 at t=50ns
        #10  requests[2] = 0;  // pulse
        
        #90  requests[4] = 1;  // floor 4 at t=150ns
        #10  requests[4] = 0;
        
        #140 requests[5] = 1;  // floor 5 at t=300ns
        #10  requests[5] = 0;
        
        #1700 $finish;
    end
    
    always #5 clk = ~clk;
    
    // ----------------------------------------------------------
    // Output monitor with formatted display
    // ----------------------------------------------------------
    initial begin
        @(negedge rst); // Wait for reset to deassert
        #1;
        $display("T=%-7d | E0=%0d | E1=%0d | Req=%-8s | P0=%-8s | P1=%s",
                 0,
                 e0_floor,
                 e1_floor,
                 floors_to_str(requests),
                 floors_to_str(pending0),
                 floors_to_str(pending1));
        
        forever begin
            #50000;
            $display("T=%-7d | E0=%0d | E1=%0d | Req=%-8s | P0=%-8s | P1=%s",
                     $time,
                     e0_floor,
                     e1_floor,
                     floors_to_str(requests),
                     floors_to_str(pending0),
                     floors_to_str(pending1));
        end
    end
endmodule

//iverilog -o dual_elevator_sim tb_dual_elevator.v dual_elevator_top.v arbiter.v elevator_unit.v