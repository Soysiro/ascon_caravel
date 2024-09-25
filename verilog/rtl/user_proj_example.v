`default_nettype none

module user_proj_example #(
    parameter BITS = 16
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // Logic Analyzer Signals

    // IOs
    input  [42:0] io_in,
    output [6:0] io_out,
    output [6:0] io_oeb
);
    wire clk;
    wire rst;

    wire clk = wb_clk_i;
    wire rst = !wb_rst_i;
    
    wire cipher_textxSO_out;
    wire plain_textxS0_out;
    wire tagxSO_out;
    wire dec_tagxSO_out;
    wire encryption_readyxSO_out;
    wire decryption_readyxSO_out;
    wire message_authentication_out;

    assign io_oeb = 1'b0;
    Ascon the_ascon(
        .clk(clk),
        .rst(rst),
        .keyxSI(io_in[5:0]),
        .noncexSI(io_in[10:6]),
        .associated_dataxSI(io_in[15:11]),
        .plain_textxSI(io_in[20:16]),
        .encryption_startxSI(io_in[21]),
        .decryption_startxSI(io_in[22]),
        .r_64xSI(io_in[36:23]),
        .r_128xSI(io_in[39:37]),
        .r_ptxSI(io_in[42:40]),
        .cipher_textxSO(cipher_textxSO_out),
        .plain_textxS0(plain_textxS0_out),
        .tagxSO(tagxSO_out),
        .dec_tagxSO(dec_tagxSO_out),
        .encryption_readyxSO(encryption_readyxSO_out),
        .decryption_readyxSO(decryption_readyxSO_out),
        .message_authentication(message_authentication_out)
    );
    assign io_out[0] = cipher_textxSO_out;
    assign io_out[1] = plain_textxS0_out;
    assign io_out[2] = tagxSO_out;
    assign io_out[3] = dec_tagxSO_out;
    assign io_out[4] = encryption_readyxSO_out;
    assign io_out[5] = decryption_readyxSO_out;
    assign io_out[6] = message_authentication_out;
endmodule
`default_nettype wire
