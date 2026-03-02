	.text
	.file	"io.c"
	.globl	test_io                         # -- Begin function test_io
	.type	test_io,@function
test_io:                                # @test_io
	.cfi_startproc
# %bb.0:                                # %entry
	#APP
	input r1
	#NO_APP
	#APP
	output r1
	#NO_APP
	jr	$r31
.Lfunc_end0:
	.size	test_io, .Lfunc_end0-test_io
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
