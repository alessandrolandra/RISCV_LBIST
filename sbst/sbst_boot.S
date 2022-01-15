	.section .text
	.global _sbst_boot
	.type _sbst_boot, @function

_sbst_boot:
	//add sp, sp, 16		// this creates space in the stack

	lui	a0, %hi(__TEST_DATA_START)
	addi	a0, a0, %lo(__TEST_DATA_START)
	
	// TODO: preserve all non-volatile registers (use section .TEST_DATA)
	// TODO: disable interrupts (if they were enabled)

	// here are some random instructions...
	la		t0, RF_PATTERNS
	lw		t1,	0*4(t0)  	
	lw		t2,	1*4(t0)

	// here I used tX registers, you should do it for all x1-x31

	// write the result (check label 'test_result') 
	
	// TODO: restore non-volatile registers
	// TODO: restore interrupts (if they were active before!)
	ret


// -------------------------------------
	.section ".TEST_DATA", "aw"
	.global test_result

test_result:
	.space 4
// Examples:
//variable1:	(4 * 4bytes)
//	.space 0x10
//variable2:
//	.space 4

// -------------------------------------
	.section ".TEST_RODATA", "a"

RF_PATTERNS:
	.long 0x12345678
	.long 0xcafecafe
	.long 0xdeadbeef

OTHER_PATTERNS:
	.long 0x0
	.long 0x0
