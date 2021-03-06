.data
	arraySizeMsg: .asciiz "Enter the size of the array: "
	arrayValueMsg: .asciiz "Enter the values: "
	newLine: .asciiz "\n"
	isPal: .asciiz "The array is a palindrome."
	isNotPal: .asciiz "The array is not a palindrome."
	freqMsg: .asciiz "The number of occurrences of array element at index number are: "
	indexMsg: .asciiz "\nEnter index number: "
	
.text
	jal createPopulateArray
	
	jal checkPalindrome
	jal countFrequency

	jal quit
	
  createPopulateArray:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)

	# input size from user
	la $a0, arraySizeMsg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0 # s1 has size of array 
	
	# declaring dynamic array
	move $a0, $v0 
	li $v0, 9
	syscall
	move $s0, $v0 # s0 has the starting address

	# inputting values from user
	la $a0, arrayValueMsg
	li $v0, 4
	syscall
	
	# initiallising i to 0 in $s2
	li $s2, 0 
	
	# addressing memory in $s3
	move $s3, $s0
	
  forInput: 
	beq $s2, $s1, inputDone
	li $v0, 5
	syscall
	sw $v0, 0($s3)
	addi $s3, $s3, 4	
	addi $s2, $s2, 1
	j forInput
	 
  inputDone:
	move $v0, $s0
	move $v1, $s1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra

  checkPalindrome:

  	move $s0, $a0  # s0 has starting address of array
	move $s1, $a1  # s1 has size of array
  	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)	

	sll $s2, $s1, 2
	add $s2, $s2, $s0
	addi $s2, $s2, -4
	# to find index of middle value in $s3
	li $s3, 2
	div $s1, $s3
	mflo $s3
	
	# initialising i in $s4
	li $s4, 0
	
	jal palindrome
	move $s7, $v0
	bne $s7, $zero, isPalindrome
	beq $s7, $zero, isNotPalindrome

  donePal:	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
										
	jr $ra 

  isPalindrome:
	la $a0, isPal
	li $v0, 4
	syscall
	j donePal

  isNotPalindrome:
	la $a0, isNotPal
	li $v0, 4
	syscall
	j donePal

  palindrome:
 	beq $s4, $s3, palindromeDone
 	lw $s5, 0($s0)
 	lw $s6, 0($s2)
 	seq $v0, $s5, $s6
 	addi $s0, $s0, 4
 	addi $s2, $s2, -4
 	addi $s4, $s4, 1
 	j palindrome

  palindromeDone:
	jr $ra

  countFrequency:
	la $a0, indexMsg
	li $v0, 4
	syscall
	
	# store index in $a2
	li $v0, 5
	syscall
	move $a2, $v0

  	la $a0, newLine
	li $v0, 4
	syscall
	
	move $s0, $a0  # s0 has starting address of array
	move $s1, $a1  # s1 has size of array
  	
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)	

	sll $s2, $s1, 2
	add $s2, $s2, $s0
	addi $s2, $s2, -4

	addi $s4, $s4, 1  # s4 is frequency count set to 1

   	li $s5, 0
	
	jal freq
	
	# print frequency
	la $a0, freqMsg
	li $v0, 4
	syscall
		
	move $a0, $s4
	li $v0, 1
	syscall
				
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36

  freq: 
  	beq $s2, $s1, freqDone
	beq $s2, $a2, sum	
  	
	# traverse array
  	lw $s2, ($s0)
   	addi $s0, $s0, 4

	# increment index
	addi $s2, $s2, 1
			
	j freq				
  sum:
	# increment count
  	addi $s4, $s4, 1
  	j freq	
  								
  freqDone:
	jr $ra	

  quit:
	# Tells system that the program is over
	li $v0, 10
	syscall