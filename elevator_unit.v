module elevator_unit #
(
    parameter FLOORS = 6,
    parameter ID = 0
)
(
    input clk,
    input rst,
    input [FLOORS-1:0] assign_in,
    output reg [$clog2(FLOORS)-1:0] cur_floor,
    output reg moving,
    output reg door_open,
    output reg [FLOORS-1:0] pending
);
    reg [1:0] state;
    localparam IDLE = 2'b00,
               MOVE = 2'b01,
               OPEN = 2'b10;
    
    integer i;
    reg [$clog2(FLOORS)-1:0] target;
    reg target_valid;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_floor <= 0;
            moving <= 0;
            door_open <= 0;
            pending <= 0;
            state <= IDLE;
        end else begin
            // Merge new assignments into pending (only if not already pending)
            pending <= pending | assign_in;
            
            case (state)
                IDLE: begin
                    door_open <= 0;
                    moving <= 0;
                    
                    // Find nearest pending request
                    target_valid = 0;
                    target = 0;
                    
                    for (i = 0; i < FLOORS; i = i + 1) begin
                        if (pending[i]) begin
                            target = i;
                            target_valid = 1;
                            i = FLOORS; // break out of loop
                        end
                    end
                    
                    if (target_valid) begin
                        if (target != cur_floor)
                            state <= MOVE;
                        else
                            state <= OPEN;
                    end
                end
                
                MOVE: begin
                    moving <= 1;
                    if (cur_floor < target) begin
                        cur_floor <= cur_floor + 1;
                        $display("[%0t ns] Elevator %0d moving up to floor %0d", $time, ID, cur_floor + 1);
                    end else if (cur_floor > target) begin
                        cur_floor <= cur_floor - 1;
                        $display("[%0t ns] Elevator %0d moving down to floor %0d", $time, ID, cur_floor - 1);
                    end
                    
                    if (cur_floor == target) begin
                        state <= OPEN;
                        moving <= 0;
                    end
                end
                
                OPEN: begin
                    moving <= 0;
                    door_open <= 1;
                    pending[cur_floor] <= 0; // Clear the request
                    $display("[%0t ns] Elevator %0d reached floor %0d (door open)", $time, ID, cur_floor);
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule