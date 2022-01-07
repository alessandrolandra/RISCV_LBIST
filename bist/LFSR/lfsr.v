// created by : Meher Krishna Patel
// date : 22-Dec-2016
// Modified by : Riccardo Cantoro (last change: 18-Nov-2020)


module lfsr
#(
    parameter SEED = 1
)

(
    input wire clk, reset, en,
    output wire [64:0] q
);

reg [64:0] r_reg;
wire [64:0] r_next;
wire feedback_value;
                        
always @(posedge clk, posedge reset)
begin 
    if (reset)
        r_reg <= SEED;  // use this or uncomment below two line
    else if (clk == 1'b1 && en == 1'b1)
        r_reg <= r_next;
end

//// Feedback polynomial : x^3 + x^2 + 1
assign feedback_value = r_reg[63] ~^ r_reg[62] ~^ r_reg[13] ~^ r_reg[4] ~^ r_reg[0];

assign r_next = {feedback_value, r_reg[64:1]};
assign q = r_reg;
endmodule
