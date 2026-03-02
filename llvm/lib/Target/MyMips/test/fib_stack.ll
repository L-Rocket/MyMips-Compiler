; ModuleID = '/home/lea/prj/llvm-project-18/llvm/lib/Target/MyMips/test/fib_stack.c'
source_filename = "/home/lea/prj/llvm-project-18/llvm/lib/Target/MyMips/test/fib_stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_char(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = add nsw i32 %3, 48
  call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 %4) #1, !srcloc !6
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @input_char() #0 {
  %1 = alloca i32, align 4
  %2 = call i32 asm sideeffect "input $0", "=r,~{dirflag},~{fpsr},~{flags}"() #1, !srcloc !7
  store i32 %2, ptr %1, align 4
  %3 = load i32, ptr %1, align 4
  ret i32 %3
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @soft_div_10(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  br label %4

4:                                                ; preds = %7, %1
  %5 = load i32, ptr %2, align 4
  %6 = icmp sge i32 %5, 10
  br i1 %6, label %7, label %12

7:                                                ; preds = %4
  %8 = load i32, ptr %2, align 4
  %9 = sub nsw i32 %8, 10
  store i32 %9, ptr %2, align 4
  %10 = load i32, ptr %3, align 4
  %11 = add nsw i32 %10, 1
  store i32 %11, ptr %3, align 4
  br label %4, !llvm.loop !8

12:                                               ; preds = %4
  %13 = load i32, ptr %3, align 4
  ret i32 %13
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @soft_mod_10(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  br label %3

3:                                                ; preds = %6, %1
  %4 = load i32, ptr %2, align 4
  %5 = icmp sge i32 %4, 10
  br i1 %5, label %6, label %9

6:                                                ; preds = %3
  %7 = load i32, ptr %2, align 4
  %8 = sub nsw i32 %7, 10
  store i32 %8, ptr %2, align 4
  br label %3, !llvm.loop !10

9:                                                ; preds = %3
  %10 = load i32, ptr %2, align 4
  ret i32 %10
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_int(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %5 = load i32, ptr %2, align 4
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %10

7:                                                ; preds = %1
  call void @print_char(i32 noundef 45)
  %8 = load i32, ptr %2, align 4
  %9 = sub nsw i32 0, %8
  store i32 %9, ptr %2, align 4
  br label %10

10:                                               ; preds = %7, %1
  %11 = load i32, ptr %2, align 4
  %12 = call i32 @soft_div_10(i32 noundef %11)
  store i32 %12, ptr %3, align 4
  %13 = load i32, ptr %2, align 4
  %14 = call i32 @soft_mod_10(i32 noundef %13)
  store i32 %14, ptr %4, align 4
  %15 = load i32, ptr %3, align 4
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %19

17:                                               ; preds = %10
  %18 = load i32, ptr %3, align 4
  call void @print_int(i32 noundef %18)
  br label %19

19:                                               ; preds = %17, %10
  %20 = load i32, ptr %4, align 4
  %21 = add nsw i32 %20, 48
  call void @print_char(i32 noundef %21)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @fib(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  %4 = load i32, ptr %3, align 4
  %5 = icmp sle i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %1
  store i32 0, ptr %2, align 4
  br label %19

7:                                                ; preds = %1
  %8 = load i32, ptr %3, align 4
  %9 = icmp eq i32 %8, 1
  br i1 %9, label %10, label %11

10:                                               ; preds = %7
  store i32 1, ptr %2, align 4
  br label %19

11:                                               ; preds = %7
  %12 = load i32, ptr %3, align 4
  %13 = sub nsw i32 %12, 1
  %14 = call i32 @fib(i32 noundef %13)
  %15 = load i32, ptr %3, align 4
  %16 = sub nsw i32 %15, 2
  %17 = call i32 @fib(i32 noundef %16)
  %18 = add nsw i32 %14, %17
  store i32 %18, ptr %2, align 4
  br label %19

19:                                               ; preds = %11, %10, %6
  %20 = load i32, ptr %2, align 4
  ret i32 %20
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  br label %5

5:                                                ; preds = %0, %18
  call void @print_char(i32 noundef 63)
  call void @print_char(i32 noundef 32)
  %6 = call i32 @input_char()
  store i32 %6, ptr %2, align 4
  %7 = load i32, ptr %2, align 4
  %8 = icmp sge i32 %7, 48
  br i1 %8, label %9, label %18

9:                                                ; preds = %5
  %10 = load i32, ptr %2, align 4
  %11 = icmp sle i32 %10, 57
  br i1 %11, label %12, label %18

12:                                               ; preds = %9
  %13 = load i32, ptr %2, align 4
  %14 = sub nsw i32 %13, 48
  store i32 %14, ptr %3, align 4
  call void @print_char(i32 noundef 61)
  call void @print_char(i32 noundef 32)
  %15 = load i32, ptr %3, align 4
  %16 = call i32 @fib(i32 noundef %15)
  store i32 %16, ptr %4, align 4
  %17 = load i32, ptr %4, align 4
  call void @print_int(i32 noundef %17)
  call void @print_char(i32 noundef 10)
  br label %18

18:                                               ; preds = %12, %9, %5
  br label %5
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = !{i64 254}
!7 = !{i64 368}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.mustprogress"}
!10 = distinct !{!10, !9}
