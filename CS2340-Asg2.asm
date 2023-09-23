# Written by Vetriliaa Kumar for CS2340.003, assignment 2: Number Conversion, 
# Starting September 13th, 2023. NetID: vxk200058

# Assignment 2: This programs gets user input of numbers as a string and processes 
# and validates it. Valid input is added to the overall sum, and increments the 
# valid number counter. Invalid input is not accepted and increments the invalid 
# number counter.

		.include "Syscalls.asm"

		.data
buffer:         .space      	100
origBuffer:	.space		100
accumulator:    .word       	0               	# Initializes accumulator to 0
validCount:     .word       	0               	# Initializes valid num counter to 0
errorCount:     .word       	0               	# Initializes error counter to 0

usrPrompt:      .asciiz     	"Enter a number: "
errorMsg:       .asciiz     	"\nError: "
sumMsg:         .asciiz     	"\nSum = "
validCountMsg:  .asciiz     	"\nCount of valid numbers = "
errorCountMsg:  .asciiz     	"\nTotal number of errors: "

		.text
main:
    		li  		$t2, 0                 		# Initialize accumulator to 0
    		li  		$t3, 0                 		# Initialize a counter for valid numbers
    		li		$t1, 0				# Initialize a counter for sum
    		
read_input_loop:
    		
    		la  		$a0, usrPrompt         		# Address of user prompt
    		li  		$v0, SysPrintString     	# Print string syscall code
    		syscall

    		li  		$v0, SysReadString      	# Read string syscall code
    		la  		$a0, buffer             	# Loads buffer address into $a0
    		la		$a1, origBuffer
    		li  		$a1, 100                	# Loads max num of characters into $a1
    		syscall
		
    		la  		$t0, buffer             	# Loads buffer address into $t0 
    								# Check if the input is a newline (empty line)
    		lb  		$t6, ($t0)			# Loads first char of buffer into $t6
    		li  		$t5, '\n'                 	# Loads '\n' into $t5
    		beq 		$t6, $t5, end_program  		# If char == newline, jump to end_program

read_digit_loop: 
    		lb  		$t6, ($t0)              	# Load the character from the buffer

    		li  		$t5, '-'                	# Load '-' into $t5
    		beq 		$t6, $t5, check_negative  	# If character is '-', jump to negative_num routine

		li 		$s3, 0				# Flag to indicate program is currently parsing a number
    		
    		li  		$t7, '0'                	# Load '0' into $t7
   	 	blt 		$t6, $t7, process_input 	# If character < '0', jump to process_input
    		li  		$t8, '9'                	# Load '9' into $t8
    		bgt 		$t6, $t8, process_input 	# If character > '9', jump to process_input

    								# Process of conversion and calculating sum
    		sub 		$t6, $t6, $t7           	# Subtract '0' from input
    		mul 		$t2, $t2, 10           		# Multiply accumulator by 10
    		add 		$t2, $t2, $t6           	# Add new digit to accumulator
    		li 		$s3, 1 				# Flag indicates currently parsing a number
    		addiu 		$t0, $t0, 1           		# Move to next char in buffer
    		j 		read_digit_loop 		# Function calls itself to process nums > 9

check_negative: 
		bnez 		$s3, invalid_input  		# If currently parsing num and there's a second '-', invalid input
    		j 		set_negative  			# Else negative sign is at the beginning, marks num as negative 
		
negative_num:
    		lbu  		$t5, -1($t0)                	# Loads previous character from buffer into $t5

    		move 		$t7, $t0                    	# Copy the address of current character
    		subu 		$t7, $t7, $t0         		# Calculate the difference from start of string
    		beqz 		$t7, set_negative           	# If this is the very first char, go to set_negative

		j    		invalid_input 

set_negative:
    		li   		$t4, 1                     	# Flag to indicate that following number will be negative
    		addiu 		$t0, $t0, 1               	# Increment buffer pointer
    		j    		read_digit_loop           	# Go back to digit reading after handling negative sign
    
process_input: 
    	     	beqz 		$t4, add_to_sum   		# If the flag for negative is not 1, add it to sum as normal
             	j   		sub_from_sum	    		# Jump to sub_from_sum instead of add_to_sum

add_to_sum: 
    	     	add  		$t1, $t1, $t2     		# Summing up the number
             	j   		increment_counter   		# Jump to increment_counter

sub_from_sum: 
             	sub  		$t1, $t1, $t2     		# Subtracting the number from sum
             	j   		increment_counter   		# Jump to increment_counter

increment_counter:
             	addi 		$t3, $t3, 1       		# Increment the certain valid count
             	move 		$t2, $zero       	 	# Reset accumulator for the next number
             	li   		$t4, 0            		# Reset negative check to 0 for the next number

             							# Check if there is more input or if we've reached end of input
             	lb   		$t6, ($t0)			# Load current byte from buffer into $t6
             	bnez 		$t6, read_input_loop  		# If character is not null terminator, go back to reading the next number

             	j 		end_program            		# If it is the end of the input, jump to end_program

invalid_input:
    		
    		lw  		$t4, errorCount			# Load errorCount from memory into $t4 register
    		addi 		$t4, $t4, 1			# Increment errorCount by 1 
    		sw  		$t4, errorCount			# Store updated errorCount value in memory

    								# Check if there is more input
    		lb  		$t6, ($t0)			# Load current byte into $t6 register
    		beqz 		$t6, end_program      		# If char == null terminator, jump to print_result

    		
    		j 		read_input_loop			# If there is more input, continue to the next input

end_program:
    
    		la  		$a0, sumMsg             	# Load address of sumMsg into $a0
    		li  		$v0, SysPrintString     	# Print string syscall code
    		syscall

    		move    	$a0, $t1            		# Moves sum value to $a0
    		li  		$v0, SysPrintInt         	# Print integer syscall code
    		syscall

    		la  		$a0, validCountMsg      	# Moves validCountMsg to $a0
    		li  		$v0, SysPrintString     	# Print string syscall code
    		syscall

    		move    	$a0, $t3            		# Moves valid Count num to $a0
    		li  		$v0, SysPrintInt         	# Print integer syscall code
    		syscall

    		la  		$a0, errorCountMsg      	# Moves errorCountMsg to $a0
    		li  		$v0, SysPrintString     	# Print string syscall code
    		syscall

    		li  		$v0, SysPrintInt         	# Print integer syscall code
    		lw  		$a0, errorCount         	# Load error count into $a0
    		syscall

    		li  		$v0, SysExit            	# Exit the program syscall code
    		syscall
