j main
print_char:
output r4
jr	$r31
.Lfunc_end0:
input_char:
input r2
jr	$r31
.Lfunc_end1:
soft_div_10:
addi	r2, r0, 0
addi	r1, r0, 10
.LBB2_1:
bgt	r1, r4, .LBB2_3
j	.LBB2_2
.LBB2_2:
addi	r2, r2, 1
addi	r4, r4, -10
j	.LBB2_1
.LBB2_3:
jr	$r31
.Lfunc_end2:
soft_mod_10:
addi	r2, r4, 0
addi	r1, r0, 10
.LBB3_1:
bgt	r1, r2, .LBB3_3
j	.LBB3_2
.LBB3_2:
addi	r2, r2, -10
j	.LBB3_1
.LBB3_3:
jr	$r31
.Lfunc_end3:
print_int:
addi	$r29, $r29, -3
sw	r16, 2(r29)
sw	r17, 1(r29)
sw	r31, 0(r29)
addi	r16, r4, 0
addi	r1, r0, -1
bgt	r16, r1, .LBB4_2
j	.LBB4_1
.LBB4_1:
addi	r4, r0, 45
jal	print_char
addi	r1, r0, 0
sub	r16, r1, r16
.LBB4_2:
addi	r4, r16, 0
jal	soft_div_10
addi	r17, r2, 0
addi	r4, r16, 0
jal	soft_mod_10
addi	r16, r2, 0
addi	r1, r0, 0
beq	r17, r1, .LBB4_4
j	.LBB4_3
.LBB4_3:
addi	r4, r17, 0
jal	print_int
.LBB4_4:
addi	r4, r16, 48
jal	print_char
lw	r31, 0(r29)
lw	r17, 1(r29)
lw	r16, 2(r29)
addi	$r29, $r29, 3
jr	$r31
.Lfunc_end4:
fib:
addi	$r29, $r29, -3
sw	r16, 2(r29)
sw	r17, 1(r29)
sw	r31, 0(r29)
addi	r2, r0, 0
addi	r1, r0, 1
bgt	r1, r4, .LBB5_3
j	.LBB5_1
.LBB5_1:
addi	r2, r1, 0
beq	r4, r1, .LBB5_3
j	.LBB5_2
.LBB5_2:
addi	r1, r4, -1
addi	r17, r4, 0
addi	r4, r1, 0
jal	fib
addi	r16, r2, 0
addi	r4, r17, -2
jal	fib
add	r2, r16, r2
.LBB5_3:
lw	r31, 0(r29)
lw	r17, 1(r29)
lw	r16, 2(r29)
addi	$r29, $r29, 3
jr	$r31
.Lfunc_end5:
main:
addi	$r29, $r29, -12
sw	r16, 11(r29)
sw	r17, 10(r29)
sw	r18, 9(r29)
sw	r19, 8(r29)
sw	r20, 7(r29)
sw	r21, 6(r29)
sw	r22, 5(r29)
sw	r23, 4(r29)
sw	r30, 3(r29)
sw	r31, 2(r29)
addi	r1, r0, 63
sw	r1, 1(r29)
addi	r17, r0, 32
addi	r21, r0, 48
addi	r22, r0, 57
addi	r1, r0, 0
sw	r1, 0(r29)
addi	r30, r0, 1
addi	r16, r0, 3
addi	r23, r0, 58
addi	r18, r0, 61
addi	r19, r0, 10
.LBB6_1:
lw	r4, 1(r29)
jal	print_char
addi	r4, r17, 0
jal	print_char
.LBB6_2:
jal	input_char
bgt	r21, r2, .LBB6_2
j	.LBB6_3
.LBB6_3:
bgt	r2, r22, .LBB6_2
j	.LBB6_4
.LBB6_4:
lw	r20, 0(r29)
.LBB6_5:
sll	r1, r20, r30
sll	r3, r20, r16
add	r1, r3, r1
add	r1, r2, r1
addi	r20, r1, -48
jal	input_char
bgt	r21, r2, .LBB6_7
j	.LBB6_6
.LBB6_6:
bgt	r23, r2, .LBB6_5
j	.LBB6_7
.LBB6_7:
addi	r4, r18, 0
jal	print_char
addi	r4, r17, 0
jal	print_char
addi	r4, r20, 0
jal	fib
addi	r4, r2, 0
jal	print_int
addi	r4, r19, 0
jal	print_char
j	.LBB6_1
.Lfunc_end6: