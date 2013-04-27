module horse(INIT, CLK, GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT, TILT, START_BALL, realscore, SCORE0, SCORE1, SCORE2, SCORE3, pres_state, next_state, ball_count);

input CLK, INIT;
input GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT;
input START_BALL, TILT;
output [0:2] ball_count;
reg [0:2] ball_count;
output [0:15] realscore;
reg [0:15] realscore;
output [0:1] pres_state, next_state;
reg [0:1] pres_state, next_state;
output [0:3] SCORE0, SCORE1, SCORE2, SCORE3;
reg [0:3] SCORE0, SCORE1, SCORE2, SCORE3;

parameter START = 3'b000, PLAY = 3'b001, END = 3'b010;

always@(posedge CLK or negedge INIT)
begin
	if(~INIT) begin
		pres_state = START;
		ball_count = 5;
		realscore = 0;
		SCORE0 = 0;
		SCORE1 = 0;
		SCORE2 = 0;
		SCORE3 = 0;
	end
	else
		pres_state = next_state;
	
end

always@(BOP_HIT or GO_HIT or BASH_HIT or WHAM_HIT or WIPE_OUT_HIT)
begin
if(!TILT) begin
	case(pres_state)
	START: 
		next_state = PLAY;		 
	PLAY: begin		
		if(ball_count > 0) begin		
			if(START_BALL)begin
				ball_count = ball_count - 1;				
			end
			if(GO_HIT)
					realscore = realscore + 100;
				else if(BOP_HIT)
					realscore = realscore + 300;
				else if(WHAM_HIT)
					realscore = realscore + 500;
				else if(BASH_HIT)
					realscore = realscore + 800;
				else if(WIPE_OUT_HIT) begin
					if(realscore > 1000)
						realscore = realscore - 1000;
					else
						realscore = 0;
				end
			end	
		else
			next_state = END;	
	end

	endcase
end
else begin
	ball_count = 0;
	next_state = END;
end		
end

always@(realscore)
begin
	SCORE0 = 0;
	SCORE1 = 0;
	if(realscore == 0) begin
		SCORE2 = 0;
		SCORE3 = 0;
	end
	if(realscore >= 100 && realscore < 1000) begin
		SCORE2 = (realscore / 100);
		SCORE3 = 0;
	end
	else if(realscore >= 1000) begin
		SCORE2 = (realscore / 100) % 10;
		SCORE3 = (realscore / 1000);
	end
end
endmodule




module testbench  (INIT, CLK, GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, 
	           WIPE_OUT_HIT, TILT, START_BALL, realscore,
		   SCORE0, SCORE1, SCORE2, SCORE3,
                   pres_state, next_state, ball_count);
output INIT, CLK;
reg INIT, CLK;
output GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT, TILT;
reg GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT, TILT;
output START_BALL;
reg START_BALL;
input [0:15] realscore;
input [0:1] pres_state;
input [0:1] next_state;
input [0:3] SCORE0;
input [0:3] SCORE1;
input [0:3] SCORE2;
input [0:3] SCORE3;
input [0:2] ball_count;

initial
  begin
     $dumpvars;
     $dumpfile ("prac3b.dump");
     CLK = 0;
     INIT = 0;
     GO_HIT = 0;
     BOP_HIT = 0;
     WHAM_HIT = 0;
     BASH_HIT = 0;
     WIPE_OUT_HIT = 0;
     START_BALL = 0;
     TILT = 0; 
#5   INIT = 1;
#20  ;
#20  START_BALL = 1; 
#10  BOP_HIT = 1;
#20  GO_HIT = 1;
     BOP_HIT = 0;
#20  WHAM_HIT = 1;
     GO_HIT = 0;
     START_BALL = 0;
#20  WIPE_OUT_HIT = 1;
     WHAM_HIT = 0;
     START_BALL = 1;
#20  BASH_HIT = 1;
     START_BALL = 0;
     WIPE_OUT_HIT = 0;
#10  GO_HIT = 1;
     GO_HIT = 0;
     START_BALL = 1;
#10  BASH_HIT = 0;
#10  START_BALL = 0;
#10  ;
#10  BOP_HIT = 1;
     START_BALL = 1;
#10  BOP_HIT = 1;
#10  BOP_HIT = 0;
#10  START_BALL = 0;
#10  TILT = 1;
#30  TILT = 0;
#10  ;
#10  $finish;
  end

always
#10 CLK = ~ CLK;

endmodule

module wiring;
wire CLK, INIT;
wire GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT;
wire [0:3] SCORE0, SCORE1, SCORE2, SCORE3;
wire START_BALL, TILT;
wire [0:2] ball_count;
wire [0:15] realscore;
wire [0:1] pres_state, next_state;
horse h(INIT, CLK, GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, WIPE_OUT_HIT, TILT, START_BALL, realscore, SCORE0, SCORE1, SCORE2, SCORE3, pres_state, next_state, ball_count);

testbench t(INIT, CLK, GO_HIT, BOP_HIT, WHAM_HIT, BASH_HIT, 
	           WIPE_OUT_HIT, TILT, START_BALL, realscore,
		   SCORE0, SCORE1, SCORE2, SCORE3,
                   pres_state, next_state, ball_count);

endmodule
