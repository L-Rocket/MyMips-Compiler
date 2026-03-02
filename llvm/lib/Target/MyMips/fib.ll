; ModuleID = 'fib.c'
source_filename = "fib.c"
target datalayout = "e-m:e-p:32:32-i8:8:32-i16:16:32-i64:64-n32"
target triple = "mymips"

define i32 @fib(i32 %n) {
entry:
  %cmp = icmp slt i32 %n, 1
  br i1 %cmp, label %return, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %b.04 = phi i32 [ %add, %for.body ], [ 1, %for.body.preheader ]
  %a.03 = phi i32 [ %b.04, %for.body ], [ 0, %for.body.preheader ]
  %add = add nsw i32 %a.03, %b.04
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %return, label %for.body

return:                                           ; preds = %for.body, %entry
  %retval.0 = phi i32 [ 0, %entry ], [ %b.04, %for.body ]
  ret i32 %retval.0
}
