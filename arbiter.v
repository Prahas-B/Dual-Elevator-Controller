module arbiter #
(
    parameter FLOORS = 6
)
(
    input clk,
    input rst,
    input [FLOORS-1:0] requests,
    input [FLOORS-1:0] pending0,
    input [FLOORS-1:0] pending1,
    input [$clog2(FLOORS)-1:0] e0_floor,
    input [$clog2(FLOORS)-1:0] e1_floor,
    output reg [FLOORS-1:0] assign_e0,
    output reg [FLOORS-1:0] assign_e1
);
    integer i;
    reg signed [7:0] dist0, dist1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            assign_e0 <= 0;
            assign_e1 <= 0;
        end else begin
            assign_e0 <= 0;
            assign_e1 <= 0;
            
            for (i = 0; i < FLOORS; i = i + 1) begin
                // Only assign if request is active and not already pending
                if (requests[i] && !pending0[i] && !pending1[i]) begin
                    // Calculate distances
                    dist0 = (i > e0_floor) ? (i - e0_floor) : (e0_floor - i);
                    dist1 = (i > e1_floor) ? (i - e1_floor) : (e1_floor - i);
                    
                    // Assign to closer elevator
                    if (dist0 <= dist1)
                        assign_e0[i] <= 1;
                    else
                        assign_e1[i] <= 1;
                end
            end
        end
    end
endmodule