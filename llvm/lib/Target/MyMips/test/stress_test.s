	.text
	.file	"stress_test.c"
	.globl	print_char                      # -- Begin function print_char
	.type	print_char,@function
print_char:                             # @print_char
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -1
	sw	$r4, 0($r29)
	lw	$r1, 0($r29)
	#APP
	output $r1
	#NO_APP
	addi	$r29, $r29, 1
	jr	$r31
.Lfunc_end0:
	.size	print_char, .Lfunc_end0-print_char
	.cfi_endproc
                                        # -- End function
	.globl	input_char                      # -- Begin function input_char
	.type	input_char,@function
input_char:                             # @input_char
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -1
	#APP
	input $r1
	#NO_APP
	sw	$r1, 0($r29)
	lw	$r2, 0($r29)
	addi	$r29, $r29, 1
	jr	$r31
.Lfunc_end1:
	.size	input_char, .Lfunc_end1-input_char
	.cfi_endproc
                                        # -- End function
	.globl	print_hex                       # -- Begin function print_hex
	.type	print_hex,@function
print_hex:                              # @print_hex
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	sw	$r31, 3($r29)
	sw	$r4, 2($r29)
	addi	$r4, $r0, 48
	jal	print_char
	addi	$r4, $r0, 120
	jal	print_char
	lw	$r1, 2($r29)
	addi	$r2, $r0, 4
	srl	$r1, $r1, $r2
	addi	$r2, $r0, 15
	and	$r1, $r1, $r2
	sw	$r1, 1($r29)
	lw	$r1, 1($r29)
	addi	$r2, $r0, 9
	bgt	$r1, $r2, .LBB2_2
	j	.LBB2_1
.LBB2_1:
	lw	$r1, 1($r29)
	addi	$r4, $r1, 48
	jal	print_char
	j	.LBB2_3
.LBB2_2:
	lw	$r1, 1($r29)
	addi	$r4, $r1, 55
	jal	print_char
	j	.LBB2_3
.LBB2_3:
	lw	$r1, 2($r29)
	addi	$r2, $r0, 15
	and	$r1, $r1, $r2
	sw	$r1, 0($r29)
	lw	$r1, 0($r29)
	addi	$r2, $r0, 9
	bgt	$r1, $r2, .LBB2_5
	j	.LBB2_4
.LBB2_4:
	lw	$r1, 0($r29)
	addi	$r4, $r1, 48
	jal	print_char
	j	.LBB2_6
.LBB2_5:
	lw	$r1, 0($r29)
	addi	$r4, $r1, 55
	jal	print_char
	j	.LBB2_6
.LBB2_6:
	addi	$r4, $r0, 32
	jal	print_char
	lw	$r31, 3($r29)
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end2:
	.size	print_hex, .Lfunc_end2-print_hex
	.cfi_endproc
                                        # -- End function
	.globl	register_pressure               # -- Begin function register_pressure
	.type	register_pressure,@function
register_pressure:                      # @register_pressure
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -11
	sw	$r4, 10($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 1
	sw	$r1, 9($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 2
	sw	$r1, 8($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 3
	sw	$r1, 7($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 4
	sw	$r1, 6($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 5
	sw	$r1, 5($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 6
	sw	$r1, 4($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 7
	sw	$r1, 3($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 8
	sw	$r1, 2($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 9
	sw	$r1, 1($r29)
	lw	$r1, 10($r29)
	addi	$r1, $r1, 10
	sw	$r1, 0($r29)
	lw	$r1, 9($r29)
	lw	$r2, 8($r29)
	add	$r1, $r1, $r2
	sw	$r1, 9($r29)
	lw	$r1, 7($r29)
	lw	$r2, 6($r29)
	add	$r1, $r1, $r2
	sw	$r1, 7($r29)
	lw	$r1, 5($r29)
	lw	$r2, 4($r29)
	add	$r1, $r1, $r2
	sw	$r1, 5($r29)
	lw	$r1, 3($r29)
	lw	$r2, 2($r29)
	add	$r1, $r1, $r2
	sw	$r1, 3($r29)
	lw	$r1, 1($r29)
	lw	$r2, 0($r29)
	add	$r1, $r1, $r2
	sw	$r1, 1($r29)
	lw	$r1, 9($r29)
	lw	$r2, 7($r29)
	add	$r1, $r1, $r2
	lw	$r2, 5($r29)
	lw	$r3, 3($r29)
	and	$r2, $r2, $r3
	add	$r1, $r1, $r2
	lw	$r2, 1($r29)
	sub	$r2, $r1, $r2
	addi	$r29, $r29, 11
	jr	$r31
.Lfunc_end3:
	.size	register_pressure, .Lfunc_end3-register_pressure
	.cfi_endproc
                                        # -- End function
	.globl	args_test                       # -- Begin function args_test
	.type	args_test,@function
args_test:                              # @args_test
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	sw	$r4, 3($r29)
	sw	$r5, 2($r29)
	sw	$r6, 1($r29)
	sw	$r7, 0($r29)
	lw	$r1, 3($r29)
	lw	$r2, 2($r29)
	add	$r1, $r1, $r2
	lw	$r2, 1($r29)
	and	$r1, $r1, $r2
	lw	$r2, 0($r29)
	or	$r2, $r1, $r2
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end4:
	.size	args_test, .Lfunc_end4-args_test
	.cfi_endproc
                                        # -- End function
	.globl	gcd_sub                         # -- Begin function gcd_sub
	.type	gcd_sub,@function
gcd_sub:                                # @gcd_sub
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	sw	$r31, 3($r29)
	sw	$r4, 1($r29)
	sw	$r5, 0($r29)
	lw	$r1, 1($r29)
	lw	$r2, 0($r29)
	bgt	$r1, $r2, .LBB5_2
	bgt	$r2, $r1, .LBB5_2
	j	.LBB5_1
.LBB5_1:
	lw	$r1, 1($r29)
	sw	$r1, 2($r29)
	j	.LBB5_9
.LBB5_2:
	lw	$r1, 1($r29)
	addi	$r2, $r0, 0
	bgt	$r1, $r2, .LBB5_4
	bgt	$r2, $r1, .LBB5_4
	j	.LBB5_3
.LBB5_3:
	lw	$r1, 0($r29)
	sw	$r1, 2($r29)
	j	.LBB5_9
.LBB5_4:
	lw	$r1, 0($r29)
	addi	$r2, $r0, 0
	bgt	$r1, $r2, .LBB5_6
	bgt	$r2, $r1, .LBB5_6
	j	.LBB5_5
.LBB5_5:
	lw	$r1, 1($r29)
	sw	$r1, 2($r29)
	j	.LBB5_9
.LBB5_6:
	lw	$r1, 1($r29)
	lw	$r2, 0($r29)
	# BLE PSEUDO
	j	.LBB5_7
.LBB5_7:
	lw	$r1, 1($r29)
	lw	$r5, 0($r29)
	sub	$r4, $r1, $r5
	jal	gcd_sub
	sw	$r2, 2($r29)
	j	.LBB5_9
.LBB5_8:
	lw	$r4, 1($r29)
	lw	$r1, 0($r29)
	sub	$r5, $r1, $r4
	jal	gcd_sub
	sw	$r2, 2($r29)
	j	.LBB5_9
.LBB5_9:
	lw	$r2, 2($r29)
	lw	$r31, 3($r29)
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end5:
	.size	gcd_sub, .Lfunc_end5-gcd_sub
	.cfi_endproc
                                        # -- End function
	.globl	mem_write                       # -- Begin function mem_write
	.type	mem_write,@function
mem_write:                              # @mem_write
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -2
	addi	$r1, $r0, 1024
	sw	$r1, 0($r29)
	lw	$r1, 0($r29)
	addi	$r2, $r0, 170
	sw	$r2, 0($r1)
	lw	$r1, 0($r29)
	addi	$r2, $r0, 187
	sw	$r2, 1($r1)
	lw	$r1, 0($r29)
	addi	$r2, $r0, 204
	sw	$r2, 2($r1)
	addi	$r29, $r29, 2
	jr	$r31
.Lfunc_end6:
	.size	mem_write, .Lfunc_end6-mem_write
	.cfi_endproc
                                        # -- End function
	.globl	mem_read_calc                   # -- Begin function mem_read_calc
	.type	mem_read_calc,@function
mem_read_calc:                          # @mem_read_calc
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	addi	$r1, $r0, 1024
	sw	$r1, 2($r29)
	lw	$r1, 2($r29)
	lw	$r1, 0($r1)
	sw	$r1, 1($r29)
	lw	$r1, 2($r29)
	lw	$r1, 2($r1)
	sw	$r1, 0($r29)
	lw	$r1, 0($r29)
	lw	$r2, 2($r29)
	sw	$r1, 0($r2)
	lw	$r1, 1($r29)
	lw	$r2, 2($r29)
	sw	$r1, 2($r2)
	lw	$r1, 2($r29)
	lw	$r1, 0($r1)
	lw	$r2, 2($r29)
	lw	$r2, 1($r2)
	add	$r2, $r1, $r2
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end7:
	.size	mem_read_calc, .Lfunc_end7-mem_read_calc
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -7
	sw	$r31, 6($r29)
	addi	$r1, $r0, 0
	sw	$r1, 5($r29)
	j	.LBB8_1
.LBB8_1:                                # =>This Inner Loop Header: Depth=1
	addi	$r4, $r0, 63
	jal	print_char
	jal	input_char
	sw	$r2, 4($r29)
	lw	$r1, 4($r29)
	addi	$r2, $r0, 49
	bgt	$r1, $r2, .LBB8_3
	bgt	$r2, $r1, .LBB8_3
	j	.LBB8_2
.LBB8_2:                                #   in Loop: Header=BB8_1 Depth=1
	addi	$r4, $r0, 82
	jal	print_char
	addi	$r4, $r0, 5
	jal	register_pressure
	sw	$r2, 3($r29)
	lw	$r4, 3($r29)
	jal	print_hex
	j	.LBB8_3
.LBB8_3:                                #   in Loop: Header=BB8_1 Depth=1
	lw	$r1, 4($r29)
	addi	$r2, $r0, 50
	bgt	$r1, $r2, .LBB8_5
	bgt	$r2, $r1, .LBB8_5
	j	.LBB8_4
.LBB8_4:                                #   in Loop: Header=BB8_1 Depth=1
	addi	$r4, $r0, 65
	jal	print_char
	addi	$r4, $r0, 1
	addi	$r5, $r0, 2
	addi	$r6, $r0, 3
	addi	$r7, $r0, 4
	jal	args_test
	sw	$r2, 2($r29)
	lw	$r4, 2($r29)
	jal	print_hex
	j	.LBB8_5
.LBB8_5:                                #   in Loop: Header=BB8_1 Depth=1
	lw	$r1, 4($r29)
	addi	$r2, $r0, 51
	bgt	$r1, $r2, .LBB8_7
	bgt	$r2, $r1, .LBB8_7
	j	.LBB8_6
.LBB8_6:                                #   in Loop: Header=BB8_1 Depth=1
	addi	$r4, $r0, 71
	jal	print_char
	addi	$r4, $r0, 12
	addi	$r5, $r0, 8
	jal	gcd_sub
	sw	$r2, 1($r29)
	lw	$r4, 1($r29)
	jal	print_hex
	j	.LBB8_7
.LBB8_7:                                #   in Loop: Header=BB8_1 Depth=1
	lw	$r1, 4($r29)
	addi	$r2, $r0, 52
	bgt	$r1, $r2, .LBB8_9
	bgt	$r2, $r1, .LBB8_9
	j	.LBB8_8
.LBB8_8:                                #   in Loop: Header=BB8_1 Depth=1
	addi	$r4, $r0, 77
	jal	print_char
	jal	mem_write
	jal	mem_read_calc
	sw	$r2, 0($r29)
	lw	$r4, 0($r29)
	jal	print_hex
	j	.LBB8_9
.LBB8_9:                                #   in Loop: Header=BB8_1 Depth=1
	addi	$r4, $r0, 10
	jal	print_char
	j	.LBB8_1
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
