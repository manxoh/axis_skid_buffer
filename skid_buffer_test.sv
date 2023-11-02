module skid_buffer_test #();

  localparam int DWIDTH  = 8;
    
  reg  clk;
  reg  rstn;
  reg  reset_done;
  reg  o_valid_tb;
  reg  [DWIDTH-1:0] o_data_tb;
  reg  o_ready_tb;
  wire i_ready_tb;
  wire i_valid_tb;
  wire [DWIDTH-1:0] i_data_tb;
  int  i;
  int  valid;
  
  skid_buffer #(
                .DWIDTH(DWIDTH)
               )
              dut
               (.clk(clk),
               .rstn(rstn),
               .i_valid(o_valid_tb),
               .i_data(o_data_tb),
               .o_ready(i_ready_tb),                   
               .o_valid(i_valid_tb),
               .o_data(i_data_tb),
               .i_ready(o_ready_tb)                   
              );
  
  initial begin
	clk = 1;
	forever #5 clk = ~clk;
  end
  
  initial begin
    #1000 $finish;
  end
  
  initial begin
    reset_done = '0;
    rstn = '1;
    i = 1;
    @(negedge clk);
    rstn = '0;
    @(negedge clk);
    rstn = '1;
    reset_done = '1;
    o_valid_tb = '0;
  end
  
  /* AXI-S Bus Functional Model */
  initial begin
    @(posedge reset_done);
    @(posedge clk);
    forever begin
        valid = $urandom;
        if ((valid % 2) == 0) begin
          o_valid_tb <= '0;
          @(posedge clk);
        end
        else begin
          /* AXI-S protocol: Assert valid and wait for ready */
          o_valid_tb <= '1;
          o_data_tb <= i;
          do begin
            @(posedge clk);
            end
          while (i_ready_tb !== '1);
        end
    end
  end
  
  /* Handshake done modify data */
  always @(negedge clk) begin
    if ((o_valid_tb == '1) && (i_ready_tb == '1)) begin
      i <= i + 1;
    end
  end  
  
   initial begin
    @(posedge reset_done);
    @(posedge clk); 
    forever begin 
      o_ready_tb <= $urandom % 2; 
      @(posedge clk); 
    end
   end


//  initial begin
//    reset_done = '0;
//    rstn = '1;
//    i = 1;
//    @(posedge clk);
//    rstn = '0;
//    o_valid_tb = '0;
//    @(posedge clk)
//    @(posedge clk);
//    rstn = '1;
//    reset_done = '1;
//  end
//
// initial begin
//    @(posedge clk);
//    o_valid_tb <= '0;
//    @(posedge clk);
//    @(posedge clk);
//    @(posedge clk);
//    forever begin
//      /* AXI-S protocol: Assert valid and wait for ready */
//      o_valid_tb <= '1;
//      o_data_tb <= i;
//      do begin
//        @(posedge clk);
//        end
//      while (i_ready_tb !== '1);
//    end
//  end
//  
//  initial begin
//    @(posedge clk); 
//    o_ready_tb <= '0; 
//    @(posedge clk);
//    @(posedge clk);  
//    @(posedge clk);
//    o_ready_tb <= '1; 
//    @(posedge clk);
//    o_ready_tb <= '0;
//    @(posedge clk);
//    @(posedge clk);     
//    o_ready_tb <= '1;  
//    @(posedge clk);
//    @(posedge clk);     
//    o_ready_tb <= '0;
//    @(posedge clk);
//    @(posedge clk);     
//    o_ready_tb <= '1; 
//     @(posedge clk);     
//    o_ready_tb <= '0;
//    @(posedge clk);     
//    o_ready_tb <= '1;
//    @(posedge clk);
//    @(posedge clk);  
//    @(posedge clk);
//    o_ready_tb <= '0;    
//    @(posedge clk);
//    @(posedge clk);  
//    @(posedge clk);
//    o_ready_tb <= '1;
//    @(posedge clk);  
//    @(posedge clk);
//    o_ready_tb <= '0;
//  end

endmodule
