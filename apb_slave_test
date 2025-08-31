timeunit 1ns;
timeprecision 100ps;

module apb_slave_test;

    localparam ADDR_WIDTH = 5;
    localparam DATA_WIDTH = 32;
  
  	// Testbench signals to connect to the DUT
    logic PCLK = 1'b1;
    logic PRESETn;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic PREADY;
    logic PSLVERR;

    // Instantiate the DUT
    apb_slave #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
	) dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );
  
  `define PERIOD 10
  always #(`PERIOD/2) PCLK = ~PCLK;
  
  initial begin
      // Set the time format for readable logs
      $timeformat(-9, 2, "ns", 12);

      // Monitor key signals. This will print a new line whenever any of these signals change.
      $monitor("Time:%t | State=%s | PSEL=%b PENABLE=%b PWRITE=%b | PADDR=0x%h | PWDATA=0x%h | PRDATA=0x%h | PREADY=%b PSLVERR=%b",
               $time,
               dut.state_current.name(),  // Monitor the DUT's internal state
               PSEL, PENABLE, PWRITE,     // Control signals
               PADDR,                     // Address bus
               PWDATA,                    // Write data bus
               PRDATA,                    // Read data bus
               PREADY, PSLVERR            // Response signals
              );
  	end
  
  initial begin
    PRESETn = 0;
    #10;
    PRESETn = 1;
  end
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
  initial begin
    PADDR = 0;
    PWRITE = 0;
    PSEL = 0;
    PENABLE = 0;
    PWDATA = 0;
    wait (PRESETn == 1'b1);
    apb_write(5'h04,32'h12342567);
    apb_read(5'h04);
    apb_write(5'h00, 32'hAABBCDEF);
    apb_read(5'h00);
    apb_read(5'h08);
    repeat(2) @(posedge PCLK);
    $finish;
  end

    // Simulation Timeout
    initial begin
        #2000ns; // Wait for 2000 ns
        $error("SIMULATION TIMEOUT! Test did not finish.");
        $finish;
	end
  
  task apb_write(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
      @(posedge PCLK);
      PADDR <= addr;
      PWDATA <= data;
      PWRITE <= 1;
      PSEL <= 1;
      PENABLE <= 0;
      @(posedge PCLK);
      PENABLE <= 1;
      wait (PREADY);
      @(posedge PCLK);
      PADDR <= 0;
      PWDATA <= 0;
      PWRITE <= 0;
      PSEL <= 0;
      PENABLE <= 0;
    end
endtask
  
  task apb_read(input [ADDR_WIDTH-1:0] addr);
    begin
      @(posedge PCLK);
      PADDR <= addr;
      PWRITE <= 0;
      PSEL <= 1;
      PENABLE <= 0;
      @(posedge PCLK);
      PENABLE <= 1;
      wait (PREADY);
      @(posedge PCLK);
      PADDR <= 0;
      PSEL <= 0;
      PENABLE <= 0;
    end
endtask
  
endmodule