.data
board: .space 100
space: .asciiz " "
bar: .asciiz "- "
dash: .asciiz "|"
X: .asciiz "x"
O: .asciiz "o"
new_line: .asciiz "\n"
intro: .asciiz "Welcome to Tic Tac Toe. \nPlease read the rules below:"
rule: .asciiz "\n1. Player 1 will take x and go first, player 2 will take o and go later. \n2. During the first turn of both players, they are not allowed to choose the central point (row 3 & column 3). \n3. Any player who has 3 points in a row, column or diagonal will be the winner. \n4. Players can undo 1 move before the opponent plays. \n5. Each player chooses their desired position based on number of each cell numbered as the board below.\n"
input1: .asciiz "Player 1, please choose the desired space (1-25): "
input2: .asciiz "Player 2, please choose the desired space (1-25): "
win_1: .asciiz "The winner is player 1."
win_2: .asciiz "The winner is player 2."
tie: .asciiz "Tie game!"
change: "Would you  like to change move? Yes = 1, No = 0, please choose: "
promptChange: "Choose again (1-25): "
playAgain: .asciiz "Would you like to continue? (yes = 1, no = 0) "
invalid: "Invalid move, choose another: "
samp: .asciiz   "\n-----+-----+-----+-----+-----\n "
samp1: .asciiz    " 1  |  2  |  3  |  4  |  5  "
samp2: .asciiz    " 6  |  7  |  8  |  9  |  10 "
samp3: .asciiz    " 11 |  12 |  13 |  14 |  15 "
samp4: .asciiz    " 16 |  17 |  18 |  19 |  20 "
samp5: .asciiz    " 21 |  22 |  23 |  24 |  25 "

.text

introduction:
li $v0, 4
la $a0, intro
syscall
li $v0, 4
la $a0, rule
syscall
#display sample board and cell
li $v0, 4
la $a0, samp
syscall
li $v0, 4
la $a0, samp1
syscall
li $v0, 4
la $a0, samp
syscall
li $v0, 4
la $a0, samp2
syscall
li $v0, 4
la $a0, samp
syscall
li $v0, 4
la $a0, samp3
syscall
li $v0, 4
la $a0, samp
syscall
li $v0, 4
la $a0, samp4
syscall
li $v0, 4
la $a0, samp
syscall
li $v0, 4
la $a0, samp5
syscall
li $v0, 4
la $a0, samp
syscall

start:
la $a1, board # load board array to a1
add $t0, $zero, $zero
addi $t1, $zero, 1
addi $a2, $zero, 1
addi $t9, $zero, 1

loop:
sw $t0, 0($a1) # load value 0 into each element of board array
addi $t1, $t1, 1
addi $a1, $a1, 4
bne $t1, 25, print
j print

store_move:
la $a1, board
addi $t1, $zero, 1 # pointer points to the 1st position
check_position:
beq $t1, $t0, set_move
addi $t1, $t1, 1
addi $a1, $a1, 4
j check_position
set_move:
sw $t2, 0($a1)

print:
la $a1, board
add $t0, $zero, $zero
add $t1, $zero, $zero
subi $t3, $t3, 1

printBoard:
li $v0, 4
la $a0, space 
syscall
lw $t2, 0($a1) # get pos of 1st element to compare
beq $t2, 0, nothing
beq $t2, 2, setO
setX:
li $v0, 4
la $a0, X
syscall
j next
setO:
li $v0,4
la $a0, O
syscall 
j next

nothing:
li $v0, 4
la $a0, bar
syscall

next:
li $v0, 4
la $a0, dash
syscall
addi $t1, $t1, 1 # t1: counter to know how many elements are counted
addi $t0, $t0, 1 # t0: counter to know that if enough 5 elements, it will change to new line
addi $a1, $a1, 4
beq $t1, 25, check_row
beq $t0, 5, newLine
j printBoard

newLine:
li $v0, 4
la $a0, new_line
syscall
subi $t0, $t0, 5 # reset t0 
j printBoard

# Check winner
check_row:
la $a1, board
addi $t1, $zero, 1
addi $t0, $zero, 1
result_row:
lw $t5, 0($a1)
lw $t6, 4($a1)
lw $t7, 8($a1)
bne $t5, $t6, check_row_again
bne $t6, $t7, check_row_again
bne $t6, 0, winner
check_row_again:
beq $t0, 15, check_column # t0: counter to count cases can win according to row
beq $t1, 3, next_row # 1 hang toi da 3 truong hop co the thang ( 123,234,345) 
addi $t0, $t0, 1
addi $a1, $a1, 4
addi $t1, $t1, 1 # t1: counter to count winning cases
j result_row
next_row: # change to next row
addi $t1, $zero, 1
addi $t0, $t0, 1
addi $a1, $a1, 12
j result_row

check_column: 
la $a1, board
addi $t1, $zero, 1
addi $t0, $zero, 1
result_col:
lw $t5, 0($a1)
lw $t6, 20($a1)
lw $t7, 40($a1)
bne $t5, $t6, check_col_again
bne $t6, $t7, check_col_again
bne $t6, 0, winner
check_col_again:
beq $t0, 15, check_left_diagonal
beq $t1, 5, next_col 
addi $t0, $t0, 1
addi $t1, $t1, 1
addi $a1, $a1, 4
j result_col
next_col:
addi $t1, $zero, 1
addi $a1, $a1, 4
j result_col

check_left_diagonal: #check diagonal from left to right
la $a1, board
addi $t1, $zero, 1
addi $t0, $zero, 1
result_Ldiagonal:
lw $t5, 0($a1)
lw $t6, 24($a1)
lw $t7, 48($a1)
bne $t5, $t6, check_Ldiagonal_again
bne $t6, $t7, check_Ldiagonal_again
bne $t6, 0, winner
check_Ldiagonal_again:
beq $t0, 9, check_right_diagonal
beq $t1, 3, next_Ldiagonal
addi $t0, $t0, 1
addi $t1, $t1, 1
addi $a1, $a1, 4
j result_Ldiagonal
next_Ldiagonal:
addi $t0, $t0, 1
addi $t1, $zero, 1
addi $a1, $a1, 12
j result_Ldiagonal

check_right_diagonal:  # check diagonal from right to left
addi $t1, $zero, 1
la $a1, board
addi $t0, $zero, 1
result_Rdiagonal:
lw $t5, 8($a1)
lw $t6, 24($a1)
lw $t7, 40($a1)
bne $t5, $t6, check_Rdiagonal_again
bne $t6, $t7, check_Rdiagonal_again
bne $t6, 0, winner
check_Rdiagonal_again:
beq $t0, 15, if_tie
beq $t1, 3, next_Rdiagonal
addi $t0, $t0, 1
addi $t1, $t1, 1
addi $a1, $a1, 4
j result_Rdiagonal
next_Rdiagonal:
addi $t0, $t0, 1
addi $t1, $zero, 1
addi $a1, $a1, 12
j result_Rdiagonal

if_tie:
la $a1, board
addi $t8, $zero, 1
check_tie:
lw $t7, 0($a1)
beq $t7, 0, done
beq $t8, 25, tieGame
addi $t8, $t8, 1
addi $a1, $a1, 4
j check_tie

done:
li $v0, 4
la $a0, new_line
syscall

# determine who will play next
turn:
beq $a2, 1, player1
j player2

player1:
addi $t1, $zero, 1 
addi $t2, $zero, 1 # value to input array
li $v0, 4
la $a0, input1
syscall

Input1:
li $v0, 5
syscall
move $t0, $v0
beq $t9, 1, check_first_move # t9 = 1 to check if first move of each player is 13 or not
after_check_first_move1:
j check_valid
after_check_move1:
beq $t1, 0, out_turn1

changeMove1:
li $v0, 4
la $a0, change
syscall
li $v0,5
syscall
addi $t1, $t1, -1
beq $v0, 0, out_turn1
li $v0, 4
la $a0, promptChange
syscall
j Input1

out_turn1:
addi $a2, $a2, 1
j store_move

player2:
addi $t1, $zero, 1
addi $t2, $zero, 2
li $v0, 4
la $a0, input2
syscall

Input2:
li $v0, 5
syscall
move $t0, $v0
beq $t9, 1, check_first_move
after_check_first_move2:
j check_valid
after_check_move2:
beq $t1, 0, out_turn2

changeMove2:
li $v0, 4
la $a0, change
syscall
li $v0, 5
syscall
subi $t1, $t1, 1
beq $v0, 0, out_turn2
li $v0, 4
la $a0, promptChange
syscall
j Input2

out_turn2:
addi $t9, $zero, 10
subi $a2, $a2, 1
j store_move

check_valid:
beq $t2, 1, check_move
blt $t0, 1, invalidMove2
bgt $t0, 25, invalidMove2
j after_check_move2

check_move:
blt $t0, 1, invalidMove1
bgt $t0, 25, invalidMove1
j after_check_move1

check_first_move:
beq $t0, 13, remove_first_move
beq $t2, 1, after_check_first_move1
j after_check_first_move2

remove_first_move:
beq $t2, 1, invalidMove1
beq $t2, 2, invalidMove2

invalidMove1:
li $v0, 4
la $a0, invalid
syscall
j Input1

invalidMove2:
li $v0,4
la $a0, invalid
syscall
j Input2

winner:
li $v0, 4
la $a0, new_line
syscall
beq $a2, 1, player2_win
li $v0, 4
la $a0, win_1
syscall
j exit

player2_win:
li $v0, 4
la $a0, win_2
syscall
j exit

tieGame:
li $v0, 4
la $a0, new_line
syscall
li $v0, 4
la $a0, tie
syscall

exit:
li $v0, 10
	
