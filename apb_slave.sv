timeunit 1ns;
timeprecision 100ps;

module apb_slave #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32)
(
    // APB interface
    input logic PCLK,
    input logic PRESETn,
    input logic [ADDR_WIDTH-1:0] PADDR,
    input logic PSEL,
    input logic PENABLE,
    input logic PWRITE,
    input logic [DATA_WIDTH-1:0] PWDATA,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic PREADY,
    output logic PSLVERR    
);
  
typedef enum logic [1:0] { IDLE, SETUP, ACCESS } state_t;
state_t state_current, state_next;

// Indexing register address
localparam REG_NUM = 4;
localparam INDEX_LSB = $clog2(DATA_WIDTH/8);
localparam INDEX_MSB = ($clog2(REG_NUM) + INDEX_LSB - 1);

logic [DATA_WIDTH-1:0] apb_reg[REG_NUM];

// Transfers
logic tf_write, tf_read;
assign tf_write = PSEL && PWRITE;
assign tf_read = PSEL && ~PWRITE;

// Sequence control
always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        state_current <= IDLE;
        apb_reg[0] <= '0;
        apb_reg[1] <= '0;
      	apb_reg[2] <= '0;
      	apb_reg[3] <= '0;
        PREADY <= 1'b1;
        PSLVERR <= 1'b0;
        end
    else begin
      state_current <= state_next;
      if (state_current == SETUP) begin
        if (tf_write && PENABLE) begin
          case (PADDR[INDEX_MSB:INDEX_LSB])
            0:  apb_reg[0] <= PWDATA;
            1:  apb_reg[1] <= PWDATA;
            2:  apb_reg[2] <= PWDATA;
            3:  apb_reg[3] <= PWDATA;
            default: ;
          endcase
        end
      end
	end
end

always_comb begin 
    unique case (state_current)
        IDLE: begin
            if (tf_write || tf_read) 
                state_next = SETUP;
            end
        SETUP: begin
            state_next = ACCESS;
			if (tf_read && PENABLE) begin
              case (PADDR[INDEX_MSB:INDEX_LSB])
                0:  PRDATA = apb_reg[0];
                1:  PRDATA = apb_reg[1];
                2:  PRDATA = apb_reg[2];
                3:  PRDATA = apb_reg[3];
                default: ;
              endcase
            end
            end
        ACCESS: begin
          	if (PREADY) begin
                if (tf_write || tf_read)
                    state_next = SETUP;
                else
                    state_next = IDLE;
            end
            end
        default: begin
            state_next = IDLE;
            end
    endcase
end
endmodule
