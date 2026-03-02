; ModuleID = '/home/lea/prj/llvm-project-18/llvm/lib/Target/MyMips/fib_stack.c'
source_filename = "/home/lea/prj/llvm-project-18/llvm/lib/Target/MyMips/fib_stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @print_char(i32 noundef %0) local_unnamed_addr #0 {
  %2 = add nsw i32 %0, 48
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 %2) #5, !srcloc !5
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @input_char() local_unnamed_addr #0 {
  %1 = tail call i32 asm sideeffect "input $0", "=r,~{dirflag},~{fpsr},~{flags}"() #5, !srcloc !6
  ret i32 %1
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define dso_local i32 @soft_div_10(i32 noundef %0) local_unnamed_addr #1 {
  %2 = icmp sgt i32 %0, 9
  br i1 %2, label %3, label %9

3:                                                ; preds = %1
  %4 = add nuw i32 %0, 9
  %5 = tail call i32 @llvm.smin.i32(i32 %0, i32 19)
  %6 = sub i32 %4, %5
  %7 = udiv i32 %6, 10
  %8 = add nuw nsw i32 %7, 1
  br label %9

9:                                                ; preds = %3, %1
  %10 = phi i32 [ 0, %1 ], [ %8, %3 ]
  ret i32 %10
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define dso_local i32 @soft_mod_10(i32 noundef %0) local_unnamed_addr #1 {
  %2 = tail call i32 @llvm.smax.i32(i32 %0, i32 9)
  %3 = urem i32 %2, 10
  %4 = sub nsw i32 %3, %2
  %5 = add i32 %4, %0
  ret i32 %5
}

; Function Attrs: nounwind uwtable
define dso_local void @print_int(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 0
  br i1 %2, label %3, label %5

3:                                                ; preds = %1
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 93) #5, !srcloc !5
  %4 = sub nsw i32 0, %0
  br label %5

5:                                                ; preds = %3, %1
  %6 = phi i32 [ %4, %3 ], [ %0, %1 ]
  %7 = icmp sgt i32 %6, 9
  br i1 %7, label %8, label %14

8:                                                ; preds = %5
  %9 = add nuw i32 %6, 9
  %10 = tail call i32 @llvm.smin.i32(i32 %6, i32 19)
  %11 = sub i32 %9, %10
  %12 = udiv i32 %11, 10
  %13 = add nuw nsw i32 %12, 1
  br label %14

14:                                               ; preds = %5, %8
  %15 = phi i32 [ 0, %5 ], [ %13, %8 ]
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %18, label %17

17:                                               ; preds = %14
  tail call void @print_int(i32 noundef %15)
  br label %18

18:                                               ; preds = %17, %14
  %19 = tail call i32 @llvm.smax.i32(i32 %6, i32 9)
  %20 = urem i32 %19, 10
  %21 = add i32 %6, 96
  %22 = sub i32 %21, %19
  %23 = add i32 %22, %20
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 %23) #5, !srcloc !5
  ret void
}

; Function Attrs: nofree nosync nounwind memory(none) uwtable
define dso_local i32 @fib(i32 noundef %0) local_unnamed_addr #2 {
  br label %2

2:                                                ; preds = %8, %1
  %3 = phi i32 [ 0, %1 ], [ %12, %8 ]
  %4 = phi i32 [ %0, %1 ], [ %11, %8 ]
  %5 = icmp slt i32 %4, 1
  br i1 %5, label %13, label %6

6:                                                ; preds = %2
  %7 = icmp eq i32 %4, 1
  br i1 %7, label %13, label %8

8:                                                ; preds = %6
  %9 = add nsw i32 %4, -1
  %10 = tail call i32 @fib(i32 noundef %9)
  %11 = add nsw i32 %4, -2
  %12 = add nsw i32 %3, %10
  br label %2

13:                                               ; preds = %6, %2
  %14 = phi i32 [ 0, %2 ], [ 1, %6 ]
  %15 = add nsw i32 %3, %14
  ret i32 %15
}

; Function Attrs: noreturn nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #3 {
  br label %1

1:                                                ; preds = %7, %0
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 111) #5, !srcloc !5
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 80) #5, !srcloc !5
  %2 = tail call i32 asm sideeffect "input $0", "=r,~{dirflag},~{fpsr},~{flags}"() #5, !srcloc !6
  %3 = add i32 %2, -48
  %4 = icmp ult i32 %3, 10
  br i1 %4, label %5, label %7

5:                                                ; preds = %1
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 109) #5, !srcloc !5
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 80) #5, !srcloc !5
  %6 = tail call i32 @fib(i32 noundef %3)
  tail call void @print_int(i32 noundef %6)
  tail call void asm sideeffect "output $0", "r,~{dirflag},~{fpsr},~{flags}"(i32 58) #5, !srcloc !5
  br label %7

7:                                                ; preds = %5, %1
  br label %1, !llvm.loop !7
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{i64 254}
!6 = !{i64 368}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.unroll.disable"}
