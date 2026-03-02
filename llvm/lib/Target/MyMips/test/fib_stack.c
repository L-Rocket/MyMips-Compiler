// fib_stack.c
// 这是一个可以在 Linux 上通过 Clang 编译成 LLVM IR 的 C 代码
// 它包含了适配 MyMips 的内联汇编 IO

// 定义 IO 函数 (内联汇编)
void print_char(int c) {
    // MyMips output 指令
    __asm__ volatile ("output %0" : : "r"(c + 48));
}

int input_char() {
    int res;
    // MyMips input 指令
    __asm__ volatile ("input %0" : "=r"(res));
    return res;
}

// 软件实现的除法 (因为 MyMips 还没有硬件除法指令)
int soft_div_10(int n) {
    int q = 0;
    while (n >= 10) {
        n = n - 10;
        q++;
    }
    return q;
}

int soft_mod_10(int n) {
    while (n >= 10) {
        n = n - 10;
    }
    return n;
}

// 递归打印整数
void print_int(int n) {
    if (n < 0) {
        print_char('-');
        n = -n;
    }
    
    int div = soft_div_10(n);
    int rem = soft_mod_10(n);
    
    if (div != 0) {
        print_int(div);
    }
    print_char(rem + '0');
}

// 递归斐波那契
int fib(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fib(n-1) + fib(n-2);
}

int main() {
    // 简单的交互循环
    while (1) {
        print_char('?'); // 提示符
        print_char(' ');
        
        int c = input_char();
        // 简单起见，这里只读一位数字 (0-9)
        // 实际代码可能需要完整的 atoi 实现
        if (c >= '0' && c <= '9') {
            int num = c - '0';
            
            print_char('=');
            print_char(' ');
            
            int res = fib(num);
            print_int(res);
            print_char('\n');
        }
    }
    return 0;
}
