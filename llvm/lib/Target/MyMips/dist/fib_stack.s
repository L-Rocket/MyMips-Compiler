	.text
	.file	"fib_stack.c"
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
	.globl	soft_div_10                     # -- Begin function soft_div_10
	.type	soft_div_10,@function
soft_div_10:                            # @soft_div_10
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -2
	sw	$r4, 1($r29)
	addi	$r1, $r0, 0
	sw	$r1, 0($r29)
	j	.LBB2_1
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	lw	$r1, 1($r29)
	addi	$r2, $r0, 10
	bgt	$r2, $r1, .LBB2_3
	j	.LBB2_2
.LBB2_2:                                #   in Loop: Header=BB2_1 Depth=1
	lw	$r1, 1($r29)
	addi	$r1, $r1, -10
	sw	$r1, 1($r29)
	lw	$r1, 0($r29)
	addi	$r1, $r1, 1
	sw	$r1, 0($r29)
	j	.LBB2_1
.LBB2_3:
	lw	$r2, 0($r29)
	addi	$r29, $r29, 2
	jr	$r31
.Lfunc_end2:
	.size	soft_div_10, .Lfunc_end2-soft_div_10
	.cfi_endproc
                                        # -- End function
	.globl	soft_mod_10                     # -- Begin function soft_mod_10
	.type	soft_mod_10,@function
soft_mod_10:                            # @soft_mod_10
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -1
	sw	$r4, 0($r29)
	j	.LBB3_1
.LBB3_1:                                # =>This Inner Loop Header: Depth=1
	lw	$r1, 0($r29)
	addi	$r2, $r0, 10
	bgt	$r2, $r1, .LBB3_3
	j	.LBB3_2
.LBB3_2:                                #   in Loop: Header=BB3_1 Depth=1
	lw	$r1, 0($r29)
	addi	$r1, $r1, -10
	sw	$r1, 0($r29)
	j	.LBB3_1
.LBB3_3:
	lw	$r2, 0($r29)
	addi	$r29, $r29, 1
	jr	$r31
.Lfunc_end3:
	.size	soft_mod_10, .Lfunc_end3-soft_mod_10
	.cfi_endproc
                                        # -- End function
	.globl	print_int                       # -- Begin function print_int
	.type	print_int,@function
print_int:                              # @print_int
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	sw	$r31, 3($r29)
	sw	$r4, 2($r29)
	lw	$r1, 2($r29)
	addi	$r2, $r0, -1
	bgt	$r1, $r2, .LBB4_2
	j	.LBB4_1
.LBB4_1:
	addi	$r4, $r0, 45
	jal	print_char
	lw	$r1, 2($r29)
	addi	$r2, $r0, 0
	sub	$r1, $r2, $r1
	sw	$r1, 2($r29)
	j	.LBB4_2
.LBB4_2:
	lw	$r4, 2($r29)
	jal	soft_div_10
	sw	$r2, 1($r29)
	lw	$r4, 2($r29)
	jal	soft_mod_10
	sw	$r2, 0($r29)
	lw	$r1, 1($r29)
	addi	$r2, $r0, 0
	beq	$r1, $r2, .LBB4_4
	j	.LBB4_3
.LBB4_3:
	lw	$r4, 1($r29)
	jal	print_int
	j	.LBB4_4
.LBB4_4:
	lw	$r1, 0($r29)
	addi	$r4, $r1, 48
	jal	print_char
	lw	$r31, 3($r29)
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end4:
	.size	print_int, .Lfunc_end4-print_int
	.cfi_endproc
                                        # -- End function
	.globl	fib                             # -- Begin function fib
	.type	fib,@function
fib:                                    # @fib
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -4
	sw	$r16, 3($r29)
	sw	$r31, 2($r29)
	sw	$r4, 0($r29)
	lw	$r1, 0($r29)
	addi	$r2, $r0, 0
	bgt	$r1, $r2, .LBB5_2
	j	.LBB5_1
.LBB5_1:
	addi	$r1, $r0, 0
	sw	$r1, 1($r29)
	j	.LBB5_5
.LBB5_2:
	lw	$r1, 0($r29)
	addi	$r2, $r0, 1
	bgt	$r1, $r2, .LBB5_4
	bgt	$r2, $r1, .LBB5_4
	j	.LBB5_3
.LBB5_3:
	addi	$r1, $r0, 1
	sw	$r1, 1($r29)
	j	.LBB5_5
.LBB5_4:
	lw	$r1, 0($r29)
	addi	$r4, $r1, -1
	jal	fib
	addi	$r16, $r2, 0
	lw	$r1, 0($r29)
	addi	$r4, $r1, -2
	jal	fib
	add	$r1, $r16, $r2
	sw	$r1, 1($r29)
	j	.LBB5_5
.LBB5_5:
	lw	$r2, 1($r29)
	lw	$r31, 2($r29)
	lw	$r16, 3($r29)
	addi	$r29, $r29, 4
	jr	$r31
.Lfunc_end5:
	.size	fib, .Lfunc_end5-fib
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	addi	$r29, $r29, -5
	sw	$r31, 4($r29)
	addi	$r1, $r0, 0
	sw	$r1, 3($r29)
	j	.LBB6_1
.LBB6_1:                                # =>This Inner Loop Header: Depth=1
	addi	$r4, $r0, 63
	jal	print_char
	addi	$r4, $r0, 32
	jal	print_char
	jal	input_char
	sw	$r2, 2($r29)
	lw	$r1, 2($r29)
	addi	$r2, $r0, 48
	bgt	$r2, $r1, .LBB6_4
	j	.LBB6_2
.LBB6_2:                                #   in Loop: Header=BB6_1 Depth=1
	lw	$r1, 2($r29)
	addi	$r2, $r0, 57
	bgt	$r1, $r2, .LBB6_4
	j	.LBB6_3
.LBB6_3:                                #   in Loop: Header=BB6_1 Depth=1
	lw	$r1, 2($r29)
	addi	$r1, $r1, -48
	sw	$r1, 1($r29)
	addi	$r4, $r0, 61
	jal	print_char
	addi	$r4, $r0, 32
	jal	print_char
	lw	$r4, 1($r29)
	jal	fib
	sw	$r2, 0($r29)
	lw	$r4, 0($r29)
	jal	print_int
	addi	$r4, $r0, 10
	jal	print_char
	j	.LBB6_4
.LBB6_4:                                #   in Loop: Header=BB6_1 Depth=1
	j	.LBB6_1
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
