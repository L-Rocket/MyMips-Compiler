; ModuleID = 'stress_test.c'
source_filename = "stress_test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_char(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 %3) #1, !srcloc !6
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
define dso_local void @print_hex(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  call void @print_char(i32 noundef 48)
  call void @print_char(i32 noundef 120)
  %5 = load i32, ptr %2, align 4
  %6 = ashr i32 %5, 4
  %7 = and i32 %6, 15
  store i32 %7, ptr %3, align 4
  %8 = load i32, ptr %3, align 4
  %9 = icmp slt i32 %8, 10
  br i1 %9, label %10, label %13

10:                                               ; preds = %1
  %11 = load i32, ptr %3, align 4
  %12 = add nsw i32 %11, 48
  call void @print_char(i32 noundef %12)
  br label %17

13:                                               ; preds = %1
  %14 = load i32, ptr %3, align 4
  %15 = sub nsw i32 %14, 10
  %16 = add nsw i32 %15, 65
  call void @print_char(i32 noundef %16)
  br label %17

17:                                               ; preds = %13, %10
  %18 = load i32, ptr %2, align 4
  %19 = and i32 %18, 15
  store i32 %19, ptr %4, align 4
  %20 = load i32, ptr %4, align 4
  %21 = icmp slt i32 %20, 10
  br i1 %21, label %22, label %25

22:                                               ; preds = %17
  %23 = load i32, ptr %4, align 4
  %24 = add nsw i32 %23, 48
  call void @print_char(i32 noundef %24)
  br label %29

25:                                               ; preds = %17
  %26 = load i32, ptr %4, align 4
  %27 = sub nsw i32 %26, 10
  %28 = add nsw i32 %27, 65
  call void @print_char(i32 noundef %28)
  br label %29

29:                                               ; preds = %25, %22
  call void @print_char(i32 noundef 32)
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @register_pressure(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %13 = load i32, ptr %2, align 4
  %14 = add nsw i32 %13, 1
  store i32 %14, ptr %3, align 4
  %15 = load i32, ptr %2, align 4
  %16 = add nsw i32 %15, 2
  store i32 %16, ptr %4, align 4
  %17 = load i32, ptr %2, align 4
  %18 = add nsw i32 %17, 3
  store i32 %18, ptr %5, align 4
  %19 = load i32, ptr %2, align 4
  %20 = add nsw i32 %19, 4
  store i32 %20, ptr %6, align 4
  %21 = load i32, ptr %2, align 4
  %22 = add nsw i32 %21, 5
  store i32 %22, ptr %7, align 4
  %23 = load i32, ptr %2, align 4
  %24 = add nsw i32 %23, 6
  store i32 %24, ptr %8, align 4
  %25 = load i32, ptr %2, align 4
  %26 = add nsw i32 %25, 7
  store i32 %26, ptr %9, align 4
  %27 = load i32, ptr %2, align 4
  %28 = add nsw i32 %27, 8
  store i32 %28, ptr %10, align 4
  %29 = load i32, ptr %2, align 4
  %30 = add nsw i32 %29, 9
  store i32 %30, ptr %11, align 4
  %31 = load i32, ptr %2, align 4
  %32 = add nsw i32 %31, 10
  store i32 %32, ptr %12, align 4
  %33 = load i32, ptr %3, align 4
  %34 = load i32, ptr %4, align 4
  %35 = add nsw i32 %33, %34
  store i32 %35, ptr %3, align 4
  %36 = load i32, ptr %5, align 4
  %37 = load i32, ptr %6, align 4
  %38 = add nsw i32 %36, %37
  store i32 %38, ptr %5, align 4
  %39 = load i32, ptr %7, align 4
  %40 = load i32, ptr %8, align 4
  %41 = add nsw i32 %39, %40
  store i32 %41, ptr %7, align 4
  %42 = load i32, ptr %9, align 4
  %43 = load i32, ptr %10, align 4
  %44 = add nsw i32 %42, %43
  store i32 %44, ptr %9, align 4
  %45 = load i32, ptr %11, align 4
  %46 = load i32, ptr %12, align 4
  %47 = add nsw i32 %45, %46
  store i32 %47, ptr %11, align 4
  %48 = load i32, ptr %3, align 4
  %49 = load i32, ptr %5, align 4
  %50 = add nsw i32 %48, %49
  %51 = load i32, ptr %7, align 4
  %52 = load i32, ptr %9, align 4
  %53 = and i32 %51, %52
  %54 = add nsw i32 %50, %53
  %55 = load i32, ptr %11, align 4
  %56 = sub nsw i32 %54, %55
  ret i32 %56
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @args_test(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %9 = load i32, ptr %5, align 4
  %10 = load i32, ptr %6, align 4
  %11 = add nsw i32 %9, %10
  %12 = load i32, ptr %7, align 4
  %13 = and i32 %11, %12
  %14 = load i32, ptr %8, align 4
  %15 = or i32 %13, %14
  ret i32 %15
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @gcd_sub(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  store i32 %1, ptr %5, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load i32, ptr %5, align 4
  %8 = icmp eq i32 %6, %7
  br i1 %8, label %9, label %11

9:                                                ; preds = %2
  %10 = load i32, ptr %4, align 4
  store i32 %10, ptr %3, align 4
  br label %37

11:                                               ; preds = %2
  %12 = load i32, ptr %4, align 4
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  %15 = load i32, ptr %5, align 4
  store i32 %15, ptr %3, align 4
  br label %37

16:                                               ; preds = %11
  %17 = load i32, ptr %5, align 4
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %19, label %21

19:                                               ; preds = %16
  %20 = load i32, ptr %4, align 4
  store i32 %20, ptr %3, align 4
  br label %37

21:                                               ; preds = %16
  %22 = load i32, ptr %4, align 4
  %23 = load i32, ptr %5, align 4
  %24 = icmp sgt i32 %22, %23
  br i1 %24, label %25, label %31

25:                                               ; preds = %21
  %26 = load i32, ptr %4, align 4
  %27 = load i32, ptr %5, align 4
  %28 = sub nsw i32 %26, %27
  %29 = load i32, ptr %5, align 4
  %30 = call i32 @gcd_sub(i32 noundef %28, i32 noundef %29)
  store i32 %30, ptr %3, align 4
  br label %37

31:                                               ; preds = %21
  %32 = load i32, ptr %4, align 4
  %33 = load i32, ptr %5, align 4
  %34 = load i32, ptr %4, align 4
  %35 = sub nsw i32 %33, %34
  %36 = call i32 @gcd_sub(i32 noundef %32, i32 noundef %35)
  store i32 %36, ptr %3, align 4
  br label %37

37:                                               ; preds = %31, %25, %19, %14, %9
  %38 = load i32, ptr %3, align 4
  ret i32 %38
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @mem_write() #0 {
  %1 = alloca ptr, align 8
  store ptr inttoptr (i64 1024 to ptr), ptr %1, align 8
  %2 = load ptr, ptr %1, align 8
  %3 = getelementptr inbounds i32, ptr %2, i64 0
  store volatile i32 170, ptr %3, align 4
  %4 = load ptr, ptr %1, align 8
  %5 = getelementptr inbounds i32, ptr %4, i64 1
  store volatile i32 187, ptr %5, align 4
  %6 = load ptr, ptr %1, align 8
  %7 = getelementptr inbounds i32, ptr %6, i64 2
  store volatile i32 204, ptr %7, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @mem_read_calc() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store ptr inttoptr (i64 1024 to ptr), ptr %1, align 8
  %4 = load ptr, ptr %1, align 8
  %5 = getelementptr inbounds i32, ptr %4, i64 0
  %6 = load volatile i32, ptr %5, align 4
  store i32 %6, ptr %2, align 4
  %7 = load ptr, ptr %1, align 8
  %8 = getelementptr inbounds i32, ptr %7, i64 2
  %9 = load volatile i32, ptr %8, align 4
  store i32 %9, ptr %3, align 4
  %10 = load i32, ptr %3, align 4
  %11 = load ptr, ptr %1, align 8
  %12 = getelementptr inbounds i32, ptr %11, i64 0
  store volatile i32 %10, ptr %12, align 4
  %13 = load i32, ptr %2, align 4
  %14 = load ptr, ptr %1, align 8
  %15 = getelementptr inbounds i32, ptr %14, i64 2
  store volatile i32 %13, ptr %15, align 4
  %16 = load ptr, ptr %1, align 8
  %17 = getelementptr inbounds i32, ptr %16, i64 0
  %18 = load volatile i32, ptr %17, align 4
  %19 = load ptr, ptr %1, align 8
  %20 = getelementptr inbounds i32, ptr %19, i64 1
  %21 = load volatile i32, ptr %20, align 4
  %22 = add nsw i32 %18, %21
  ret i32 %22
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  br label %7

7:                                                ; preds = %0, %32
  call void @print_char(i32 noundef 63)
  %8 = call i32 @input_char()
  store i32 %8, ptr %2, align 4
  %9 = load i32, ptr %2, align 4
  %10 = icmp eq i32 %9, 49
  br i1 %10, label %11, label %14

11:                                               ; preds = %7
  call void @print_char(i32 noundef 82)
  %12 = call i32 @register_pressure(i32 noundef 5)
  store i32 %12, ptr %3, align 4
  %13 = load i32, ptr %3, align 4
  call void @print_hex(i32 noundef %13)
  br label %14

14:                                               ; preds = %11, %7
  %15 = load i32, ptr %2, align 4
  %16 = icmp eq i32 %15, 50
  br i1 %16, label %17, label %20

17:                                               ; preds = %14
  call void @print_char(i32 noundef 65)
  %18 = call i32 @args_test(i32 noundef 1, i32 noundef 2, i32 noundef 3, i32 noundef 4)
  store i32 %18, ptr %4, align 4
  %19 = load i32, ptr %4, align 4
  call void @print_hex(i32 noundef %19)
  br label %20

20:                                               ; preds = %17, %14
  %21 = load i32, ptr %2, align 4
  %22 = icmp eq i32 %21, 51
  br i1 %22, label %23, label %26

23:                                               ; preds = %20
  call void @print_char(i32 noundef 71)
  %24 = call i32 @gcd_sub(i32 noundef 12, i32 noundef 8)
  store i32 %24, ptr %5, align 4
  %25 = load i32, ptr %5, align 4
  call void @print_hex(i32 noundef %25)
  br label %26

26:                                               ; preds = %23, %20
  %27 = load i32, ptr %2, align 4
  %28 = icmp eq i32 %27, 52
  br i1 %28, label %29, label %32

29:                                               ; preds = %26
  call void @print_char(i32 noundef 77)
  call void @mem_write()
  %30 = call i32 @mem_read_calc()
  store i32 %30, ptr %6, align 4
  %31 = load i32, ptr %6, align 4
  call void @print_hex(i32 noundef %31)
  br label %32

32:                                               ; preds = %29, %26
  call void @print_char(i32 noundef 10)
  br label %7
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
!6 = !{i64 465}
!7 = !{i64 547}
