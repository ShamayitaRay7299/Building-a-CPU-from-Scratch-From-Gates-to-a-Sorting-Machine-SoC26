// 2 states: left: when lemmings are walking left and right: when lemmings are walking right
module lemmings_1(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

    // parameter LEFT=0, RIGHT=1, ...
    parameter LEFT=0, RIGHT=1;
    reg state, next_state;
    always @(*) begin
        // State transition logic
        case (state)
            LEFT: next_state = (bump_left || (bump_left && bump_right)) ? RIGHT : LEFT;
            RIGHT: next_state = (bump_right || (bump_left && bump_right)) ? LEFT : RIGHT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) state <= LEFT;
        else state <= next_state;
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule
//4 states. left: walking left, right; walking right, left_fall: ground disappears while left, right_fall: ground disappears while right
module lemmings_2(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
    parameter left=0, right=1, left_fall=2, right_fall=3;
    
    reg[1:0] state, next_state;
    always @(*) begin
        // State transition logic
        case (state)
            left: case (ground)
                1: next_state = (bump_left || (bump_left && bump_right)) ? right : left;
                0: next_state = left_fall;
            endcase
            right: case (ground)
                1: next_state = (bump_right || (bump_left && bump_right)) ? left : right;
                0: next_state = right_fall;
            endcase
            left_fall: next_state = ground ? left : left_fall;
            right_fall: next_state = ground ? right : right_fall;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if (areset) state <= left;
        else state <= next_state;
    end
    assign walk_left = (state == left);
    assign walk_right = (state == right);
    assign aaah = (state == left_fall) | (state == right_fall);
endmodule
// 6 states. left: walking left, right: walking right, dig_l: digging when left, dig_r: digging when right, fall_l: ground disappears when dig_l or left, fall_r: ground disappears when dig_r or right
module lemmings_3(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter left=0, right=1, dig_l=2, dig_r=3, fall_l=4, fall_r=5;
    
    reg [2:0] state, next_state;
    always @(*) begin
        case(state)
            left: case(ground)
                0: next_state=fall_l;
                1: case(dig)
                    1: next_state = dig_l;
                    0: next_state = (bump_left || (bump_left && bump_right)) ? right : left;
                endcase
            endcase
            right: case(ground)
                0: next_state=fall_r;
                1: case(dig)
                    1: next_state = dig_r;
                    0: next_state = (bump_right || (bump_left && bump_right)) ? left : right;
                endcase
            endcase
            dig_l: next_state = ground ? dig_l : fall_l;
            dig_r: next_state = ground ? dig_r : fall_r;
            fall_l: next_state = ground ? left : fall_l;
            fall_r: next_state = ground ? right : fall_r;
        endcase
    end
    always @(posedge clk, posedge areset) begin
        if(areset) state <= left;
        else state <= next_state;
    end
    assign walk_left = (state == left);
    assign walk_right = (state == right);
    assign aaah = (state == fall_l) | (state == fall_r);
    assign digging = (state == dig_r) | (state == dig_l);
endmodule\

//7 states. left:walking left, right: walking right, dig_l: digging when left, dig_r: digging when right, fall_l: ground disappears when left or dig_l, fall_r: ground disappears when dig_r or right, splat: ground appears after falling for more than 20 clock periods.
module lemmings_4(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    parameter left=0, right=1, dig_l=2, dig_r=3, fall_l=4, fall_r=5, splatter = 6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count;

    always @(*) begin
        next_state = state;

        case(state)
            left:
                case(ground)
                    0: next_state = fall_l;
                    1:
                        case(dig)
                            1: next_state = dig_l;
                            0: next_state = bump_left ? right : left;
                        endcase
                endcase

            right:
                case(ground)
                    0: next_state = fall_r;
                    1:
                        case(dig)
                            1: next_state = dig_r;
                            0: next_state = bump_right ? left : right;
                        endcase
                endcase

            dig_l:
                next_state = ground ? dig_l : fall_l;

            dig_r:
                next_state = ground ? dig_r : fall_r;

            fall_l:
                next_state = ground ? left : fall_l;

            fall_r:
                next_state = ground ? right : fall_r;

            splatter:
                next_state = splatter;

            default:
                next_state = left;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= left;
            fall_count <= 0;
        end
        else if ((state == next_state) &&
                 ((state == fall_l) || (state == fall_r))) begin

            state <= next_state;

            if (fall_count < 20)
                fall_count <= fall_count + 1;
        end
        else if (((state == fall_l) || (state == fall_r)) &&
                 ((next_state == left) || (next_state == right))) begin

            if (fall_count > 19)
                state <= splatter;
            else
                state <= next_state;

            fall_count <= 0;
        end
        else begin
            state <= next_state;
        end
    end

    assign walk_left  = (state == left);
    assign walk_right = (state == right);
    assign aaah       = ((state == fall_l) || (state == fall_r)) ;
    assign digging    = (state == dig_l) || (state == dig_r);

endmodule
