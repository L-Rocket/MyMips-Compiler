; ModuleID = 'io.c'
source_filename = "io.c"
target datalayout = "e-m:e-p:32:32-i8:8:32-i16:16:32-i64:64-n32"
target triple = "mymips"

define void @test_io() {
entry:
  %val = call i32 asm "input $0", "=r"()
  call void asm sideeffect "output $0", "r"(i32 %val)
  ret void
}
