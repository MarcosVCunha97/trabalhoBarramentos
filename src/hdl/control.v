
module control(
    input clk,
    input rst_n,
    input [7:0] k_data, // Dados do teclado
    input k_flag, // Flag que indica quando o dado do teclado está pronto para ser lido
    // output k_en, // Habilitador do teclado
    output reg s_req, // Habilitador da serial
    output reg [7:0] s_data, // Dados da serial
    input s_ack // Flag que indica que o dado foi enviado
);

localparam IDLE = 0;
localparam WAIT_DATA = 1;
localparam SEND_DATA = 2;
localparam WAIT_ACK1 = 3;
localparam WAIT_ACK0 = 4;

//typedef enum { 
//    IDLE,
//    WAIT_DATA,
//    SEND_DATA,
//    WAIT_ACK1,
//    WAIT_ACK0
//} state_t;


reg [3:0]state;


always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        state <= IDLE;
        s_req <= 1'b0;
    end else begin
        case (state)
        IDLE: begin
            state <= WAIT_DATA;
        end
        WAIT_DATA: begin
            if(k_flag == 1'b1) begin
                s_data <= k_data;
                state <= SEND_DATA;
            end
        end
        SEND_DATA: begin
            if(~s_ack) begin
                s_req <= 1'b1;
                state <= WAIT_ACK1;
            end
        end
        WAIT_ACK1: begin
            if(s_ack) begin
                s_req <= 1'b0;
                state <= WAIT_ACK0;
            end
        end
        WAIT_ACK0: begin
            if(~s_ack) begin
                state <= WAIT_DATA;
            end
        end
        endcase
    end
end


endmodule