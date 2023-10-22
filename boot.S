# Stop compressed instruction forms emits.
.option norvc
# data section is used for declaring initialized data
.section .data
newline: .ascii  "\n\0"
welcome: .ascii  "Welcome to PseudOS\n\0"
iamhart: .ascii  "I am HART \0"

# Reserve a block of uninitialized memory space for stack space
# Reserves 8192 bytes of memory, initialized to zeros
_stack:
        .skip 8192,0

# text section
# Symbol global, allowing the linker to recognize _start as the entry point of the program.
.section .text.init
.global _start

# kernel starts here.
_start:
	# Setup a Stack for Hart 0-4
        csrr 	t0, mhartid
        la 	t1, _stack_start
        li 	t2, 1024
	# Multiply by the HART id to get next stack base.
        mul 	t3, t2, t0
        add 	sp, t3, t1

	# make all HARTS except 0 wait.
	li	t1, 1
        bne 	t0, t1, _wait

        # Setup UART + Print Welcome Message
        # call _setup_uart
        la 	a0, welcome
        call 	_write_uart
	
	# Wait for interrupts. Holds the program. 
	wfi

# ----------------------------------------------
# To save some space, a macro to push the return address
# to the local stack
.macro push
        sd ra, 0(sp)
        li t0, 8
        add sp, sp, t0
.endm

# And to pop it off again.
.macro pop
        li t0, -8
        add sp, sp, t0
        ld ra, 0(sp)
.endm

# UART device is Synopsys DW APB UART compatible https://linux-sunxi.org/images/d/d2/Dw_apb_uart_db.pdf
# Write letter to the THR - Transmit Holding Register
_write_uart:
	push
_write_uart_loop:
	# Line Status Register - TSR memory location load to the register
    	li 	t0, 0x10000014 
    	lbu     t1, (t0)
	# Check the 5th bit of the TSR
    	andi    t1, t1, 0x20  
    	beq     t1, zero, _write_uart_loop
	# Transmit Holding Register - THR memory location load to the register
    	li      t0, 0x10000000
    	lb      t1, (a0)
    	sb      t1, (t0)
    	li      t0, 1
    	add     a0, t0, a0
    	lb      t0, 0(a0)
    	beqz    t0, _write_uart_end
    	j _write_uart

_write_uart_end:
	pop
	ret

_writeln:
        push
        call 	_write_uart
        la 	a0, newline
        call	_write_uart
        pop
        ret

# Wait for interrupts
_wait:
        wfi
