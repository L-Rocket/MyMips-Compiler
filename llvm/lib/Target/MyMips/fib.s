	.text
	.file	"fib.c"
	.globl	fib                             # -- Begin function fib
	.type	fib,@function
fib:                                    # @fib
	.cfi_startproc
# %bb.0:                                # %entry
	addi	r2, $r0, 0
	addi	r1, $r0, 1
	bgt	r1, r4, .LBB0_3
	j	.LBB0_1
.LBB0_1:                                # %for.body.preheader
	addi	r3, $r0, 0
	addi	r5, r3, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	addi	r2, r1, 0
	add	r1, r5, r2
	addi	r4, r4, -1
	addi	r5, r2, 0
	bgt	r4, r3, .LBB0_2
	bgt	r3, r4, .LBB0_2
	j	.LBB0_3
.LBB0_3:                                # %return
	jr	$r31
.Lfunc_end0:
	.size	fib, .Lfunc_end0-fib
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
