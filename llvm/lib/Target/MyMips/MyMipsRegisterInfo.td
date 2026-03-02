// MyMipsRegisterInfo.td

// 1. 定义寄存器基类
class MyMipsReg<bits<16> Enc, string n> : Register<n> {
  let HWEncoding = Enc;
  let Namespace = "MyMips";
}

// 2. 定义通用寄存器 (GPR)
foreach i = 0-31 in {
  def R#i : MyMipsReg<i, "$r"#i>, DwarfRegNum<[i]>;
}

// 特殊寄存器别名
let Namespace = "MyMips" in {
  def ZERO : Register<"$r0">;
  def SP   : Register<"$r29">; 
  def RA   : Register<"$r31">; 
}

// 3. 定义寄存器组 (RegisterClass)
def GPRRegs : RegisterClass<"MyMips", [i32], 32, (add (sequence "R%u", 0, 31))>;

// 4. Callee Saved Registers (Standard O32-like convention)
// Preserved: R16-R23 (S0-S7), R29 (SP), R30 (FP/S8), R31 (RA)
def CSR_O32 : CalleeSavedRegs<(add (sequence "R%u", 16, 23), R29, R30, R31)>;