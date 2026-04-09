module dual_elevator_top #
(
    parameter FLOORS = 6
)
(
    input clk,
    input rst,
    input [FLOORS-1:0] requests,
    output [FLOORS-1:0] pending0,
    output [FLOORS-1:0] pending1,
    output [$clog2(FLOORS)-1:0] e0_floor,
    output [$clog2(FLOORS)-1:0] e1_floor
);
    wire [FLOORS-1:0] assign_e0, assign_e1;
    
    arbiter #(.FLOORS(FLOORS)) arb (
        .clk(clk), 
        .rst(rst),
        .requests(requests),
        .pending0(pending0),
        .pending1(pending1),
        .e0_floor(e0_floor),
        .e1_floor(e1_floor),
        .assign_e0(assign_e0),
        .assign_e1(assign_e1)
    );
    
    elevator_unit #(.FLOORS(FLOORS), .ID(0)) e0 (
        .clk(clk), 
        .rst(rst),
        .assign_in(assign_e0),
        .cur_floor(e0_floor),
        .moving(), 
        .door_open(), 
        .pending(pending0)
    );
    
    elevator_unit #(.FLOORS(FLOORS), .ID(1)) e1 (
        .clk(clk), 
        .rst(rst),
        .assign_in(assign_e1),
        .cur_floor(e1_floor),
        .moving(), 
        .door_open(), 
        .pending(pending1)
    );
endmodule