	.text
	.file	"simple.ll"
	.globl	test_add                        # -- Begin function test_add
	.type	test_add,@function
test_add:                               # @test_add
	.cfi_startproc
# %bb.0:
	add	r2, r4, r5
	jr	$r31
.Lfunc_end0:
	.size	test_add, .Lfunc_end0-test_add
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
