##################################################################################################################
#
# project01_Joseph_Haenel.asm
#
# By Joseph Haenel 385
#
# Prompts user to enter two numbers. The first number is your current driving speed in MPH (1-200 Inclusive).	
# The second is the speed limit for the road you are currently on in MPH (15 to 70 Inclusive).			
# And determined the penalty you may recieve based on the criteria.
#			
###################################################################################################################

.data
	STR_FIRSTPROMPT: 	.asciiz "Enter your current driving speed in MPH (1 to 200): " 										# Prompt for driving speed

	STR_SECONDPROMPT: 	.asciiz "Enter the absolute speed limit specified for the road you are currently running on (15 - 70): " 				# Prompt for speed limit

	STR_FIRSTERROR: 	.asciiz "You made an invalid input for your current driving speed. Enter a valid input for your current driving speed. \n" 		# Driving speed invalid input message

	STR_SECONDERROR: 	.asciiz "You made an invalid input for the absolute speed limit. Enter a valid input for the absolute speed limit. \n"			# Speed limit invalid input message

	SAFE_DRIVER: 		.asciiz "\nYou are a safe driver!\n"

	FINE_ONE:		.asciiz "You may recieve a $120 fine\n" 															# Fine for 1-20 MPH over speed limit

	FINE_TWO:		.asciiz "You may recieve a $140 fine\n"															# Fine for 21-25 MPH over speed limit

	FINE_THREE:		.asciiz "You may recieve a class B misdemeanor and carries up to six months im jail and a maximum $1,500 in fines\n"					# Fine for 26-34 MPH over speed limit

	FINE_FOUR:		.asciiz "You may recieve a class A misdemeanor and carries up to one year in jail and a maximum $2,500 in fines\n"						# Fine for 35+ MPH over speed limit

.text
	.globl main

main:

first_prompt:
	li $v0 4						# System Call to print a message
	la $a0, STR_FIRSTPROMPT			# Loads address of STR_FIRSTPROMPT into $a0 register
	syscall							# syscall to output message

	li $v0, 5						# System Call to take user input
	syscall							# Input value goes into $v1 register

	li $t0, 200						# Loads 201 into $s0 register
	bgt $v0, $t0, first_error		# Checks if inputted value($v0) is greater than 201($s0)
	blt $v0, $zero, first_error		# Checks if inputted value($v0) is less than zero($zero)
	beq $v0, $zero, first_error		# Checks if inputted value($v0) is equal to zero($zero)
	move $t0, $v0 					# Move inputted speed to $t0 register **
	j continue_execution1			# If input passes checks, continue_execution1

first_error:
	li $v0 4
	la $a0, STR_FIRSTERROR
	syscall

	j first_prompt

continue_execution1:

	li $v0, 4 						# System call to print message
	la $a0, STR_SECONDPROMPT        
	syscall

	li $v0, 5						# System Call to take user input
	syscall

	li $t7, 70
	li $t8, 15
	bgt $v0, $t7, second_error
	blt $v0, $t8, second_error
	move $t1, $v0 					# Move inputted speed limit to $t1 register **
	j continue_execution2			# Continue

second_error:
	li $v0, 4
	la $a0, STR_SECONDERROR
	syscall

	j continue_execution1 			# Go back to continue_execution1

continue_execution2:
	sub $t2, $t0, $t1 				# $t2 = $t0 - $t1

	li $t3, 1  						# Stores integer 1
	li $t4, 21
	li $t5, 26
	li $t6, 35

	blt $t2, $t3, safe_driver		# Driving under/the speed limit
	blt $t2, $t4, fine_one			# Driving 1-20 MPH over the speed limit
	blt $t2, $t5, fine_two			# Driving 21-25 MPH over the speed limit
	blt $t2, $t6, fine_three		# Driving 26-34 MPH over the speed limit
	bge $t2, $t6, fine_four			# Driving 35+ MPH over the speed limit

									# Printing Penalties now
safe_driver:
	li $v0, 4
	la $a0, SAFE_DRIVER
	syscall

	j END_PROGRAM

fine_one:
	li $v0, 4
	la $a0, FINE_ONE
	syscall

	j END_PROGRAM

fine_two:
	li $v0, 4
	la $a0, FINE_TWO
	syscall

	j END_PROGRAM

fine_three:
	li $v0, 4
	la $a0, FINE_THREE
	syscall

	j END_PROGRAM

fine_four:
	li $v0, 4
	la $a0, FINE_FOUR
	syscall

	j END_PROGRAM

END_PROGRAM:
	jr $31
