// ==========================================
// MyMips 裸机压力测试套件 V2
// ==========================================
// 适配说明：
// 1. 无 XOR 指令 (使用 &, |, +, - 代替)
// 2. 无栈参数传递 (参数限制在 4 个以内)
// 3. 无乘除法 (使用移位)
// 4. 纯手动内存管理 (Volatile 指针)
// ==========================================

// --- I/O 定义 (内联汇编) ---
void print_char(int c) {
    __asm__ volatile ("output %0" : : "r"(c));
}

int input_char() {
    int res;
    __asm__ volatile ("input %0" : "=r"(res));
    return res;
}

// --- 基础工具函数 ---
// 打印 32 位整数的低 8 位 (Hex 格式)
void print_hex(int n) {
    print_char('0');
    print_char('x');
    
    // 高 4 位
    int high = (n >> 4) & 0xF;
    if (high < 10) print_char(high + '0');
    else print_char(high - 10 + 'A');
    
    // 低 4 位
    int low = n & 0xF;
    if (low < 10) print_char(low + '0');
    else print_char(low - 10 + 'A');
    
    print_char(' '); 
}

// ==========================================
// 测试 1: 寄存器压力测试 (Register Spilling)
// ==========================================
// 目标：强迫编译器将变量“溢出”到栈上 (Spill/Reload)
// 逻辑：使用了 10 个局部变量，超过了通常的 callee-saved 寄存器数量
int register_pressure(int start) {
    int a = start + 1;
    int b = start + 2;
    int c = start + 3;
    int d = start + 4;
    int e = start + 5;
    int f = start + 6;
    int g = start + 7;
    int h = start + 8;
    int i = start + 9;
    int j = start + 10;
    
    // 强制依赖链 (无 XOR)
    a = a + b; // 5+1 + 5+2 = 13
    c = c + d;
    e = e + f;
    g = g + h;
    i = i + j;
    
    // 复杂的算术逻辑，确保所有变量都是活跃的(Live)
    // 预期结果计算比较复杂，主要观察是否编译通过且运行不崩
    return (a + c) + (e & g) - i; 
}

// ==========================================
// 测试 2: 调用约定测试 (Calling Convention)
// ==========================================
// 目标：测试寄存器传参 ($r4 - $r7)
// 修改：参数减少到 4 个，避免触发 "Stack arguments not implemented"
int args_test(int a, int b, int c, int d) {
    // 逻辑：((a + b) & c) | d
    // 输入: 1, 2, 3, 4
    // (1+2) & 3 | 4 
    // 3 & 3 | 4
    // 3 | 4 = 7
    return ((a + b) & c) | d;
}

// ==========================================
// 测试 3: 递归与分支 (GCD 算法)
// ==========================================
// 目标：测试 $ra ($r31) 的保存与恢复，以及 BGT/BEQ 跳转指令
// 算法：欧几里得减法原理 (避免除法/取模)
int gcd_sub(int a, int b) {
    if (a == b) return a;
    if (a == 0) return b;
    if (b == 0) return a;
    
    if (a > b) 
        return gcd_sub(a - b, b);
    else 
        return gcd_sub(a, b - a);
}

// ==========================================
// 测试 4: 内存读写 (Memory Access)
// ==========================================
// 目标：测试 LW/SW 指令及偏移量计算
// 假设：DMEM 从地址 1024 开始可用
#define MEM_BASE ((volatile int*) 1024)

void mem_write() {
    volatile int* ptr = MEM_BASE;
    // 测试不同的偏移量
    ptr[0] = 0xAA; 
    ptr[1] = 0xBB; 
    ptr[2] = 0xCC; 
}

int mem_read_calc() {
    volatile int* ptr = MEM_BASE;
    int v0 = ptr[0]; // 0xAA
    int v2 = ptr[2]; // 0xCC
    
    // 交换写入，防止优化
    ptr[0] = v2;
    ptr[2] = v0;
    
    // 返回和：0xCC + 0xBB = 0x187 (低8位 0x87)
    return ptr[0] + ptr[1]; 
}

// ==========================================
// 主函数
// ==========================================
int main() {
    while(1) {
        print_char('?'); // 提示符
        int cmd = input_char();
        
        // --- 1. 寄存器压力 ---
        if (cmd == '1') {
            print_char('R');
            int res = register_pressure(5); 
            print_hex(res); // 只要输出不是乱码或崩溃即可
        }
        
        // --- 2. 参数传递 (寄存器) ---
        if (cmd == '2') {
            print_char('A');
            // 预期结果: 7
            int res = args_test(1, 2, 3, 4);
            print_hex(res);
        }
        
        // --- 3. 递归 (GCD) ---
        if (cmd == '3') {
            print_char('G');
            // GCD(12, 8) = 4
            int res = gcd_sub(12, 8);
            print_hex(res);
        }
        
        // --- 4. 内存测试 ---
        if (cmd == '4') {
            print_char('M');
            mem_write();
            int res = mem_read_calc();
            print_hex(res); // 预期结果: 0x87 (0x187 & 0xFF)
        }

        print_char('\n');
    }
    return 0;
}