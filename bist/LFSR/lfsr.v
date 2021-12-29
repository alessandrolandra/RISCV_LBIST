// created by : Meher Krishna Patel
// date : 22-Dec-2016
// Modified by : Riccardo Cantoro (last change: 18-Nov-2020)


module lfsr
#(
    parameter N = 16,
    parameter SEED = 1
)

(
    input wire clk, reset, 
    output wire [N:0] q
);

reg [N:0] r_reg;
wire [N:0] r_next;
wire feedback_value;
                        
always @(posedge clk, posedge reset)
begin 
    if (reset)
        r_reg <= SEED;
    else if (clk == 1'b1)
        r_reg <= r_next;
end

generate
case (N)

16: 	assign feedback_value = r_reg[16] ~^ r_reg[15] ~^ r_reg[13] ~^ r_reg[4] ~^ r_reg[0];

130: 	assign feedback_value = r_reg[130] ~^ r_reg[129] ~^ r_reg[128] ~^ r_reg[125] ~^ r_reg[0];

131: 	assign feedback_value = r_reg[131] ~^ r_reg[129] ~^ r_reg[128] ~^ r_reg[123] ~^ r_reg[0];


default: 
	begin
		 initial
			$display("Missing N=%d in the LFSR code, please implement it!", N);
	end		
endcase
endgenerate


assign r_next = {feedback_value, r_reg[N:1]};
assign q = r_reg;
endmodule
