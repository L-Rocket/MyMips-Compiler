# 🏛️ Custom 32-Bit RISC CPU Architecture

本文档定义了自定义 32 位 RISC 处理器的指令集架构 (ISA)、内存模型及硬件接口规范。

---

## 1. 硬件概览 (Hardware Overview)

### 寄存器堆 (Register File)
处理器包含 32 个通用寄存器 ($r0 - $r31)，数据宽度为 32 位。

| 寄存器 | 名称 | 描述 |
| :--- | :--- | :--- |
| **$r0** | Zero | **恒定为 0**。写入无效，读取总是返回 0。 |
| **$r1 - $r30** | General | 通用寄存器，用于存储数据和地址。 |
| **$r31** | Link | 链接寄存器。`jal` 指令会自动将返回地址 (`PC+1`) 存入此处。 |

### 内存架构 (Memory Architecture)

* **架构类型：** 哈佛架构 (Harvard Architecture) - 指令内存 (IMEM) 与数据内存 (DMEM) 物理分离。
* **寻址方式：** **字寻址 (Word-Addressed)**。
    * 每一个地址对应一个完整的 32 位字 (Word)。
    * **程序计数器 (PC):** 下一条指令地址为 `PC + 1`（而非 `PC + 4`）。
* **有效地址空间：** `0` 到 `2047` (十进制)。
    * 这是一个拥有 2048 个字 (Words) 的地址空间。

---

## 2. 指令集列表 (Instruction Set)

本处理器支持 **R-Type** (寄存器操作), **I-Type** (立即数操作), 和 **J-Type** (跳转) 三种格式。

### 算术与逻辑运算 (ALU)

| 指令 | Opcode | 类型 | 汇编格式 | 操作 (RTL) |
| :--- | :--- | :--- | :--- | :--- |
| **add** | `00000` | R | `add $rd, $rs, $rt` | `$rd = $rs + $rt` |
| **sub** | `00001` | R | `sub $rd, $rs, $rt` | `$rd = $rs - $rt` |
| **and** | `00010` | R | `and $rd, $rs, $rt` | `$rd = $rs & $rt` |
| **or** | `00011` | R | `or $rd, $rs, $rt` | `$rd = $rs \| $rt` |
| **sll** | `00100` | R | `sll $rd, $rs, $rt` | `$rd = $rs << $rt[4:0]` (逻辑左移, 补0) |
| **srl** | `00101` | R | `srl $rd, $rs, $rt` | `$rd = $rs >> $rt[4:0]` (逻辑右移, 补0) |
| **addi** | `00110` | I | `addi $rd, $rs, N` | `$rd = $rs + SignExt(N)` |

### 内存访问 (Load / Store)

| 指令 | Opcode | 类型 | 汇编格式 | 操作 (RTL) |
| :--- | :--- | :--- | :--- | :--- |
| **lw** | `00111` | I | `lw $rd, N($rs)` | `$rd = Mem[$rs + SignExt(N)]` |
| **sw** | `01000` | I | `sw $rd, N($rs)` | `Mem[$rs + SignExt(N)] = $rd` |

### 控制流 (Control Flow)

注意：由于是字寻址，PC 的增量单位为 **1**。

| 指令 | Opcode | 类型 | 汇编格式 | 操作 (RTL) |
| :--- | :--- | :--- | :--- | :--- |
| **beq** | `01001` | I | `beq $rd, $rs, N` | `if ($rd == $rs) PC = PC + 1 + SignExt(N)` |
| **bgt** | `01010` | I | `bgt $rd, $rs, N` | `if ($rd > $rs) PC = PC + 1 + SignExt(N)` |
| **jr** | `01011` | I | `jr $rd` | `PC = $rd` |
| **j** | `01100` | J | `j N` | `PC = N` |
| **jal** | `01101` | J | `jal N` | `$r31 = PC + 1; PC = N` |

> **ALU 逻辑提示：** > * `beq/bgt` 的跳转目标是相对于**下一条指令** (`PC+1`) 的偏移量 `N`。
> * 例如：`N=0` 表示执行下一条指令；`N=1` 表示跳过下一条指令。

### 输入/输出 (I/O)

| 指令 | Opcode | 类型 | 汇编格式 | 操作 (RTL) |
| :--- | :--- | :--- | :--- | :--- |
| **input** | `01110` | I | `input $rd` | `$rd = KeyboardInput` <br> (Assert `input_ack` high) |
| **output** | `01111` | I | `output $rd` | `Display = $rd[7:0]` <br> (Assert `LCD_wren` high) |

---

## 3. 指令编码格式 (Instruction Formats)

所有指令均为 32 位宽。

### R-Type (Register)
用于算术和逻辑运算。
| Bits | 31:27 | 26:22 | 21:17 | 16:12 | 11:0 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Field** | **Opcode** | **Rd** (Dest) | **Rs** (Src 1) | **Rt** (Src 2/Shift) | **Zeroes** |

### I-Type (Immediate)
用于立即数、内存访问、分支和 I/O。
| Bits | 31:27 | 26:22 | 21:17 | 16:0 |
| :--- | :--- | :--- | :--- | :--- |
| **Field** | **Opcode** | **Rd** (Dest/Src*) | **Rs** (Src 1) | **Immediate** (Signed) |

> \*注：在 `beq`, `bgt`, `sw` 指令中，`$rd` 字段实际作为源操作数使用。

### J-Type (Jump)
用于无条件跳转。
| Bits | 31:27 | 26:0 |
| :--- | :--- | :--- |
| **Field** | **Opcode** | **Target Address** |

---

## 4. 硬件实现注意事项 (Implementation Notes)

1.  **PC 更新逻辑：**
    * 正常周期：`PC <= PC + 1`
    * 分支/跳转：直接加载目标地址或计算 `PC + 1 + Imm`。
    
2.  **内存边界：**
    * 数据内存和指令内存的有效地址范围均为 `0` 到 `2047`。
    * 地址总线宽度建议为 11 位 ($2^{11} = 2048$)。

3.  **ALU 标志位：**
    * 架构规范指出 ALU 输出 `isLessThan` 信号。
    * 实现 `bgt` (Greater Than) 时，需通过逻辑转换：`($rd > $rs)` 等价于 `!isLessThan && !isEqual`。

4.  **I/O 控制信号：**
    * `input` 指令：需生成一个周期的脉冲 `input_ack`。
    * `output` 指令：需生成一个周期的脉冲 `LCD_wren`。

---