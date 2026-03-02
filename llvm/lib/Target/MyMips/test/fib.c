// fib.c
// 计算第 n 个斐波那契数 (迭代版本)
// Fibonacci Series: 0, 1, 1, 2, 3, 5, 8, 13, ...
// fib(0) = 0
// fib(1) = 1
// fib(2) = 1

int fib(int n) {
    int a = 0;
    int b = 1;
    int i;
    
    // 如果 n <= 0，返回 0
    if (n <= 0) return 0;
    
    for (i = 0; i < n; i++) {
        int t = a + b;
        a = b;
        b = t;
    }
    return a;
}
