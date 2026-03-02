// 修复 1: 纯粹的输出函数，不修改数据
void print_char(int c) {
    // 移除 +48，直接输出寄存器中的值
    __asm__ volatile ("output %0" : : "r"(c));
}

int input_char() {
    int res;
    __asm__ volatile ("input %0" : "=r"(res));
    return res;
}

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
    // 修复 2: 在这里进行数字到字符的转换
    // 因为 print_char 现在是原样输出，所以这里必须加上 '0'
    print_char(rem + '0'); 
}

int fib(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return fib(n-1) + fib(n-2);
}

int main() {
    while (1) {
        // 这些字符现在可以被正确打印了
        print_char('?'); 
        print_char(' ');
        
        int c = input_char();
        
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