// llvm/lib/Target/MyMips/MyMipsInstrInfo.td

// Define SDT_BR_CC and br_cc manually to ensure visibility
// Operand 0: CondCode (OtherVT)
// Operand 1: LHS (Any Type)
// Operand 2: RHS (Same as LHS)
// Operand 3: DestBB (OtherVT)
def SDT_BR_CC : SDTypeProfile<0, 4, [SDTCisVT<0, OtherVT>, 
                                     SDTCisSameAs<1, 2>, 
                                     SDTCisVT<3, OtherVT>]>;
def br_cc : SDNode<"ISD::BR_CC", SDT_BR_CC, [SDNPHasChain]>;

// =========================================================
// 1. Definitions & Operands
// =========================================================

// Define MyMips specific SDNodes
def MyMipsRet : SDNode<"MyMipsISD::Ret", SDTNone, [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

def SDT_MyMipsCall : SDTypeProfile<0, 1, [SDTCisVT<0, iPTR>]>;
def MyMipsCall : SDNode<"MyMipsISD::Call", SDT_MyMipsCall, [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue, SDNPVariadic]>;

// 17-bit signed immediate for I-Type instructions
def simm17 : Operand<i32> {
  let DecoderMethod = "DecodeSimm17";
}

def simm17_imm : PatLeaf<(imm), [{ return isInt<17>(N->getSExtValue()); }]>;

// 27-bit target address for J-Type instructions
def jumptarget : Operand<OtherVT> {
  let EncoderMethod = "getJumpTargetOpValue";
}

def calltarget : Operand<i32> {
  let EncoderMethod = "getJumpTargetOpValue";
}

// Operand for branch targets (machine basic blocks)
def brtarget : Operand<OtherVT> {
  let EncoderMethod = "getBranchTargetOpValue";
  let DecoderMethod = "DecodeBranchTarget";
}

// Match TargetGlobalAddress for JAL
def MyMipsTGlobalAddr : PatFrag<(ops), (tglobaladdr)>;

// =========================================================
// 2. Instruction Formats
// =========================================================

class MyMipsInst<dag outs, dag ins, string asmstr, list<dag> pattern> : Instruction {
  field bits<32> Inst;

  let Namespace = "MyMips";
  let Size = 4;
  let OutOperandList = outs;
  let InOperandList = ins;
  let AsmString = asmstr;
  let Pattern = pattern;
  let DecoderNamespace = "MyMips";
}

// R-Type: Opcode[31:27], Rd[26:22], Rs[21:17], Rt[16:12], Zeroes[11:0]
class FmtR<bits<5> op, dag outs, dag ins, string asmstr, list<dag> pattern>
    : MyMipsInst<outs, ins, asmstr, pattern> {
  bits<5> rd;
  bits<5> rs;
  bits<5> rt;

  let Inst{31-27} = op;
  let Inst{26-22} = rd;
  let Inst{21-17} = rs;
  let Inst{16-12} = rt;
  let Inst{11-0}  = 0;
}

// I-Type: Opcode[31:27], Rd[26:22], Rs[21:17], Immediate[16:0]
class FmtI<bits<5> op, dag outs, dag ins, string asmstr, list<dag> pattern>
    : MyMipsInst<outs, ins, asmstr, pattern> {
  bits<5>  rd;
  bits<5>  rs;
  bits<17> imm17;

  let Inst{31-27} = op;
  let Inst{26-22} = rd;
  let Inst{21-17} = rs;
  let Inst{16-0}  = imm17;
}

// J-Type: Opcode[31:27], Target[26:0]
class FmtJ<bits<5> op, dag outs, dag ins, string asmstr, list<dag> pattern>
    : MyMipsInst<outs, ins, asmstr, pattern> {
  bits<27> target;

  let Inst{31-27} = op;
  let Inst{26-0}  = target;
}

// =========================================================
// 3. Instructions
// =========================================================

// --- Arithmetic (R-Type) ---

// ADD: rd = rs + rt (Op: 00000)
def ADD : FmtR<0x00, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "add\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (add GPRRegs:$rs, GPRRegs:$rt))]>;

// SUB: rd = rs - rt (Op: 00001)
def SUB : FmtR<0x01, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "sub\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (sub GPRRegs:$rs, GPRRegs:$rt))]>;

// AND: rd = rs & rt (Op: 00010)
def AND : FmtR<0x02, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "and\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (and GPRRegs:$rs, GPRRegs:$rt))]>;

// OR: rd = rs | rt (Op: 00011)
def OR  : FmtR<0x03, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "or\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (or GPRRegs:$rs, GPRRegs:$rt))]>;

// SLL: rd = rs << rt[4:0] (Op: 00100)
def SLL : FmtR<0x04, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "sll\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (shl GPRRegs:$rs, GPRRegs:$rt))]>;

// SRL: rd = rs >> rt[4:0] (Op: 00101)
def SRL : FmtR<0x05, (outs GPRRegs:$rd), (ins GPRRegs:$rs, GPRRegs:$rt),
               "srl\t$rd, $rs, $rt",
               [(set GPRRegs:$rd, (srl GPRRegs:$rs, GPRRegs:$rt))]>;

// --- Immediate (I-Type) ---

// ADDI: rd = rs + imm (Op: 00110)
def ADDI : FmtI<0x06, (outs GPRRegs:$rd), (ins GPRRegs:$rs, simm17:$imm17),
                "addi\t$rd, $rs, $imm17",
                [(set GPRRegs:$rd, (add GPRRegs:$rs, simm17_imm:$imm17))]>;

// Define Node Transformation to divide immediate by 4
def Div4 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(N->getSExtValue() / 4, SDLoc(N), MVT::i32);
}]>;

// LW: rd = Mem[rs + imm] (Op: 00111)
def LW : FmtI<0x07, (outs GPRRegs:$rd), (ins GPRRegs:$rs, simm17:$imm17),
              "lw\t$rd, $imm17($rs)", []>;

def : Pat<(load (add GPRRegs:$rs, simm17_imm:$imm)),
          (LW GPRRegs:$rs, (Div4 simm17_imm:$imm))>;

// Handle (load reg) -> lw reg, 0(reg)
def : Pat<(load GPRRegs:$rs), (LW GPRRegs:$rs, 0)>;

// SW: Mem[rs + imm] = rd (Op: 01000)
def SW : FmtI<0x08, (outs), (ins GPRRegs:$rd, GPRRegs:$rs, simm17:$imm17),
              "sw\t$rd, $imm17($rs)", []>;

def : Pat<(store GPRRegs:$rd, (add GPRRegs:$rs, simm17_imm:$imm)),
          (SW GPRRegs:$rd, GPRRegs:$rs, (Div4 simm17_imm:$imm))>;

def : Pat<(store GPRRegs:$rd, GPRRegs:$rs), (SW GPRRegs:$rd, GPRRegs:$rs, 0)>;

// --- Branching (I-Type) ---

// BEQ: if (rd == rs) PC = PC + 1 + imm (Op: 01001)
let isBranch = 1, isTerminator = 1 in {
  def BEQ : FmtI<0x09, (outs), (ins GPRRegs:$rd, GPRRegs:$rs, brtarget:$imm17),
                 "beq\t$rd, $rs, $imm17",
                 [(br_cc SETEQ, GPRRegs:$rd, GPRRegs:$rs, bb:$imm17)]>;

  // BGT: if (rd > rs) PC = PC + 1 + imm (Op: 01010)
  def BGT : FmtI<0x0A, (outs), (ins GPRRegs:$rd, GPRRegs:$rs, brtarget:$imm17),
                 "bgt\t$rd, $rs, $imm17",
                 [(br_cc SETGT, GPRRegs:$rd, GPRRegs:$rs, bb:$imm17)]>;
}

// Handle Immediate operands for Branches (Legalization doesn't do this for Legal BR_CC)
// BEQ (Reg, Imm) -> BEQ (Reg, ADDI(R0, Imm))
def : Pat<(br_cc SETEQ, GPRRegs:$l, simm17_imm:$r, bb:$dst),
          (BEQ GPRRegs:$l, (ADDI R0, simm17_imm:$r), brtarget:$dst)>;

// BGT (Reg, Imm) -> BGT (Reg, ADDI(R0, Imm))
def : Pat<(br_cc SETGT, GPRRegs:$l, simm17_imm:$r, bb:$dst),
          (BGT GPRRegs:$l, (ADDI R0, simm17_imm:$r), brtarget:$dst)>;

// BGT (Imm, Reg) -> BGT (ADDI(R0, Imm), Reg)
def : Pat<(br_cc SETGT, simm17_imm:$l, GPRRegs:$r, bb:$dst),
          (BGT (ADDI R0, simm17_imm:$l), GPRRegs:$r, brtarget:$dst)>;

// Patterns for other conditions using swapping or inversion if possible.
// BGT $rd, $rs <-> BLT $rs, $rd
def : Pat<(br_cc SETLT, GPRRegs:$l, GPRRegs:$r, bb:$dst),
          (BGT GPRRegs:$r, GPRRegs:$l, brtarget:$dst)>;

// BLT (Reg, Imm) -> BGT (Imm, Reg) -> BGT (ADDI(Imm), Reg)
def : Pat<(br_cc SETLT, GPRRegs:$l, simm17_imm:$r, bb:$dst),
          (BGT (ADDI R0, simm17_imm:$r), GPRRegs:$l, brtarget:$dst)>;


// --- Control Flow (J-Type / I-Type) ---

// JR: PC = rd (Op: 01011)
// Use for indirect jump or return
let isBranch = 1, isTerminator = 1, isBarrier = 1, isIndirectBranch = 1 in
  def JR : FmtI<0x0B, (outs), (ins GPRRegs:$rd),
                "jr\t$rd",
                [(brind GPRRegs:$rd)]> {
    let rs = 0;
    let imm17 = 0;
  }

// RET (Return)
let isReturn = 1, isTerminator = 1, isBarrier = 1, rs = 0, imm17 = 0, rd = 31 in
def RET : FmtI<0x0B, (outs), (ins),
               "jr\t$$r31",
               [(MyMipsRet)]>;

// J: PC = N (Op: 01100)
let isBranch = 1, isTerminator = 1, isBarrier = 1 in
  def J : FmtJ<0x0C, (outs), (ins jumptarget:$target),
             "j\t$target",
             [(br bb:$target)]>;

// JAL: $r31 = PC + 1; PC = N (Op: 01101)
let isCall = 1, Defs = [R31, R2] in
def JAL : FmtJ<0x0D, (outs), (ins calltarget:$target),
               "jal\t$target",
               []>; // Pattern moved out

// Patterns for JAL
def : Pat<(MyMipsCall (tglobaladdr:$target)), (JAL $target)>;
def : Pat<(MyMipsCall (texternalsym:$target)), (JAL $target)>;

// =========================================================
// 4. Patterns
// =========================================================

// Small immediates: ADDI $dst, $zero, imm
def : Pat<(i32 simm17_imm:$imm), (ADDI R0, simm17_imm:$imm)>;

// BNE Pseudo for (a != b) -> (a > b) || (b > a)
let isBranch = 1, isTerminator = 1, isBarrier = 0, isPseudo = 1 in
def BNE : MyMipsInst<(outs), (ins GPRRegs:$rs, GPRRegs:$rt, brtarget:$target),
                     "# BNE PSEUDO",
                     [(br_cc SETNE, GPRRegs:$rs, GPRRegs:$rt, bb:$target)]>;

// BLE Pseudo for (a <= b)
let isBranch = 1, isTerminator = 1, isBarrier = 0, isPseudo = 1 in
def BLE : MyMipsInst<(outs), (ins GPRRegs:$rs, GPRRegs:$rt, brtarget:$target),
                     "# BLE PSEUDO",
                     [(br_cc SETLE, GPRRegs:$rs, GPRRegs:$rt, bb:$target)]>;

// BGE Pseudo for (a >= b)
let isBranch = 1, isTerminator = 1, isBarrier = 0, isPseudo = 1 in
def BGE : MyMipsInst<(outs), (ins GPRRegs:$rs, GPRRegs:$rt, brtarget:$target),
                     "# BGE PSEUDO",
                     [(br_cc SETGE, GPRRegs:$rs, GPRRegs:$rt, bb:$target)]>;

// Generic branch on condition register (assume 0/1 boolean)
// brcond $cond -> bgt $cond, $zero, target
def : Pat<(brcond GPRRegs:$cond, bb:$target),
          (BGT GPRRegs:$cond, R0, brtarget:$target)>;

// Arbitrary immediates: Not supported yet (requires LUI or similar)

// --- Input / Output (I-Type) ---

// Input: input $rd (Op: 01110)
// Format I: Op, Rd, Rs, Imm
let rs = 0, imm17 = 0 in
def INPUT : FmtI<0x0E, (outs GPRRegs:$rd), (ins),
                 "input\t$rd",
                 []>;

// Output: output $rd (Op: 01111)
// Format I: Op, Rd, Rs, Imm
// Rd is the source of the value to print
let rs = 0, imm17 = 0 in
def OUTPUT : FmtI<0x0F, (outs), (ins GPRRegs:$rd),
                  "output\t$rd",
                  []>;
