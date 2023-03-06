#########################################
#
#   TOWER OF HANOI - RECURSIVE STRUCTURE
#
#   project_02_JosephHaenel.asm
#
#   By Joseph Haenel, 385
#
##########################################

.data

MOVING:         .asciiz         "Moving " 
DISCS:          .asciiz         " discs ...\n"
MOVE:           .asciiz         "\n move a disc:  " 
TO:             .ascii          " -> "
PEG:            .asciiz         " peg "
END_PROCESS:    .asciiz         "\n\nThe end of the process ..."

.globl main

.text

main:

li $s0, 3                           # Hard coded # of discs = $s0

subu $sp, $sp, 8                    # Saving space for stack

sw $ra, 0($sp)                      # Saving $ra to stack

li $t1, 1                           # $t1 = origin peg
li $t2, 2                           # $t2 = intermediate peg
li $t3, 3                           # $t3 = destination peg

# Printing " Moving 3 discs ..."
li $v0, 4 
la $a0, MOVING
syscall

li $v0, 1
move $a0, $s0
syscall

la $a0, DISCS
syscall

# Going to recursive sub-ruitine
jal tower_of_hanoi

# Printing "The end of the process ..."
li $v0, 4
la $a0, END_PROCESS
syscall

lw $ra, 0($sp)                      # Loading $ra from stack

subu $sp, $sp, -8                   # Releasing stack

jr $31


# RECURSIVE SUB_ROUTINE
tower_of_hanoi:

li $t4, 1                           # Setting $t4 to 1 temporarily

beq $s0, $t4, exit_process          # Leave if discs == 1

subu $sp, $sp, 20                   # Saving space for stack

# Saving values to stack
sw $ra, 16($sp) 
sw $t1, 12($sp)                     # Origin
sw $t2, 8($sp)                      # Intermediate
sw $t3, 4($sp)                      # Destination
sw $s0, 0($sp)                      # Num discs

addi $t5, $t2, 0                    # Saving Intermediate Peg
addi $t2, $t3, 0                    # Intermediate Peg = Destination Peg
addi $t3, $t5, 0                    # Destination Peg = Intermediate Peg
subu $s0, $s0, 1                    # Num_Disks = Num_Disks - 1

# First Recursive Call
jal tower_of_hanoi

# Loading values from stack
lw $ra, 16($sp) 
lw $t1, 12($sp)                     # Origin
lw $t2, 8($sp)                      # Intermediate
lw $t3, 4($sp)                      # Destination
lw $s0, 0($sp)                      # Num discs

addi $t4, $zero, 1

# Printing moving disk from Origin Peg to Destination Peg
li $v0, 4
la $a0, MOVE
syscall

li $v0, 4
la $a0, PEG
syscall

# Printing origin peg
li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, TO
syscall
li $v0, 4
la $a0, PEG
syscall

# Printing destination peg
li $v0, 1
move $a0, $t3
syscall

addi $t5, $t2, 0                    # Saving Intermediate Peg
addi $t2, $t1, 0                    # Intermediate Peg = Origin Peg
addi $t1, $t5, 0                    # Origin Peg = Intermediate Peg
subu $s0, $s0, 1                    # Num_Disks = Num_Disks - 1

# Second Recursive Call
jal tower_of_hanoi

lw $ra, 16($sp)

subu $sp, $sp, -20

add $v0, $zero, $t6

jr $ra

exit_process:

# Printing moving LAST disc
li $v0, 4
la $a0, MOVE
syscall

li $v0, 4
la $a0, PEG
syscall

# Printing origin peg
li $v0, 1
move $a0, $t1
syscall

li $v0, 4
la $a0, TO
syscall

li $v0, 4
la $a0, PEG
syscall

# Printing destination peg
li $v0, 1
move $a0, $t3
syscall

jr $ra