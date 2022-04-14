// DIFT Test Suite - Tag Propagation
//   OpClass: ALU / Shift / Comp / MUL / Float
//
// Jakob Sailer
// created 2022-04-06
// ESP / MT DIFT


//
// INCLUDES
//
#include "prop-test.h"



//
// DEFINES
//

// constant numbers
#define NUM_PROPPOLS  4



//
// STATIC DATA
//
.section  .data

// Propagation Policies for ALU tests
//    [0] ZERO
//    [1] OR
//    [2] AND
//    [3] ONE
//                        StorLoadAlShCoCMuFl
proppol_alu:    .word   0b0000000000000000000, \
                        0b0000000001000000000, \
                        0b0000000010000000000, \
                        0b0000000011000000000
//                        StorLoadAlShCoCMuFl
proppol_shift:  .word   0b0000000000000000000, \
                        0b0000000000010000000, \
                        0b0000000000100000000, \
                        0b0000000000110000000
//                        StorLoadAlShCoCMuFl
proppol_comp:   .word   0b0000000000000000000, \
                        0b0000000000000100000, \
                        0b0000000000001000000, \
                        0b0000000000001100000
//                        StorLoadAlShCoCMuFl
proppol_mul:    .word   0b0000000000000000000, \
                        0b0000000000000000100, \
                        0b0000000000000001000, \
                        0b0000000000000001100

.align 4
// PROP |    TESTCASES -> [0]     [1]     [2]     [3]     [4]     [5]     [6]     [7]     [8]     [9]     [10]     [11]     [12]
// POL  v    Tag OpA-OpB  N-N   ALL-N   LSB-N   MSB-N   MID-N   N-ALL   N-LSB   N-MSB   N-MID  ALL-ALL LSB-MID  ALL-MSB  MID-ALL
result_alu_zero: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_alu_or:   .byte 0b0000, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_alu_and:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111,  0b1111,  0b1111,  0b1111
result_alu_one:  .byte 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111

//  The following expected values variables may be implemented later, if there are actual
//  differences in the tag propagation logic in different opclasses.
//  Currently they share all the same propagation logic hence the same expected values array is applicable.
//    result_shift_*
//    result_comp_*
//    result_mul_*
//    result_float_*



//
// ROUTINES
//
.section  .text

// Register Usage
//  x10 .. x14  address expected values
//    x10 &result_alu   current address expected-results ALU (points to result_alu_* variable)
//    x11 &result_shift current address expected-results Shift (points to result_shift_* variable)
//    x12 &result_comp
//    x13 &result_mul
//    x14 &result_float
//
//  x15..x19  expected values
//    x15     ALU / Shift / Comp / MUL / Float
//    x16     not used
//    x17     not used
//    x18     not used
//    x19     not used
//
//  x20..x21  input values
//    x20     operand A
//    x21     operand B
//
//  x22..x29  actual values
//
//  f0..f1    float input values
//    f0      float operand A
//    f1      float operand B
//
//  f3..f8    float actual values
//    todo
//
//  x31   link register - return address from exercise_and_check routine

//
// MAIN TESTCASE routine
//
.global test_opclass_alu
test_opclass_alu:
  // init address offset for propagation policy array
  li R_PROPPOL_CUR_ADDR, 0
  // init x10..x14: hold the addresses of the current expected value
  la x10, result_alu_zero
  la x11, result_alu_zero // may be changed later to result_shift_zero
  la x12, result_alu_zero // may be changed later to result_comp_zero
  la x13, result_alu_zero // may be changed later to result_mul_zero
  la x14, result_alu_zero // may be changed later to result_float_zero

  // load dummy values into the registers that are used for input values
  li x20, 0x123456
  li x21, 0xbaba07

  // POLICY LOOP: loop through all different policy cases (to exercise each test case for each policy)
  li R_PROPPOL_END_ADDR, NUM_PROPPOLS*4 // calculate end address offset of proppol_* array (4 entries with 4 bytes each)
  policy_loop_alu:
    // TEST CASES
    testcases_alu:
      // TEST CASE [0] : no operand tagged
      // op_a/rs1 = b0000 , op_b/rs2 = b0000
      testcase_alu_0:
        // setup tag bits of operands a and b
        TAG_WR_NONE( x20 )
        TAG_WR_NONE( x21 )
        // run testcases
        jal x31, run_testcase_alui
        jal x31, run_testcase_alu
        jal x31, run_testcase_shifti
        jal x31, run_testcase_shift
        jal x31, run_testcase_compi
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [1] : operand A ALL
      // op_a/rs1 = b1111 , op_b/rs2 = b0000
      testcase_alu_1:
        // setup tag bits of operands a and b
        TAG_WR_ALL( x20 )
        TAG_WR_NONE( x21 )
        // run testcases
        jal x31, run_testcase_alui
        jal x31, run_testcase_alu
        jal x31, run_testcase_shifti
        jal x31, run_testcase_shift
        jal x31, run_testcase_compi
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [2] : operand A LSB
      // op_a/rs1 = b0001 , op_b/rs2 = b0000
      testcase_alu_2:
        // setup tag bits of operands a and b
        TAG_WR_LSB( x20 )
        TAG_WR_NONE( x21 )
        // run testcases
        jal x31, run_testcase_alui
        jal x31, run_testcase_alu
        jal x31, run_testcase_shifti
        jal x31, run_testcase_shift
        jal x31, run_testcase_compi
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [3] : operand A MSB
      // op_a/rs1 = b1000 , op_b/rs2 = b0000
      testcase_alu_3:
        // setup tag bits of operands a and b
        TAG_WR_MSB( x20 )
        TAG_WR_NONE( x21 )
        // run testcases
        jal x31, run_testcase_alui
        jal x31, run_testcase_alu
        jal x31, run_testcase_shifti
        jal x31, run_testcase_shift
        jal x31, run_testcase_compi
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [4] : operand A MID
      // op_a/rs1 = b0110 , op_b/rs2 = b0000
      testcase_alu_4:
        // setup tag bits of operands a and b
        TAG_WR_MID( x20 )
        TAG_WR_NONE( x21 )
        // run testcases
        jal x31, run_testcase_alui
        jal x31, run_testcase_alu
        jal x31, run_testcase_shifti
        jal x31, run_testcase_shift
        jal x31, run_testcase_compi
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [5] : operand B ALL
      // op_a/rs1 = b0000 , op_b/rs2 = b1111
      testcase_alu_5:
        // setup tag bits of operands a and b
        TAG_WR_NONE( x20 )
        TAG_WR_ALL( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [6] : operand B LSB
      // op_a/rs1 = b0000 , op_b/rs2 = b0001
      testcase_alu_6:
        // setup tag bits of operands a and b
        TAG_WR_NONE( x20 )
        TAG_WR_LSB( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [7]: operand B MSB
      // op_a/rs1 = b0000 , op_b/rs2 = b1000
      testcase_alu_7:
        // setup tag bits of operands a and b
        TAG_WR_NONE( x20 )
        TAG_WR_MSB( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [8] : operand B MID
      // op_a/rs1 = b0000 , op_b/rs2 = b0110
      testcase_alu_8:
        // setup tag bits of operands a and b
        TAG_WR_NONE( x20 )
        TAG_WR_MID( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [9] : both ALL
      // op_a/rs1 = b1111 , op_b/rs2 = b1111
      testcase_alu_9:
        // setup tag bits of operands a and b
        TAG_WR_ALL( x20 )
        TAG_WR_ALL( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [10] : operand a LSB - operand b MID
      // op_a/rs1 = b0001 , op_b/rs2 = b0110
      testcase_alu_10:
        // setup tag bits of operands a and b
        TAG_WR_LSB( x20 )
        TAG_WR_MID( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [11] : operand a ALL - operand b MSB
      // op_a/rs1 = b1111 , op_b/rs2 = b1000
      testcase_alu_11:
        // setup tag bits of operands a and b
        TAG_WR_ALL( x20 )
        TAG_WR_MSB( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

      // TEST CASE [12] : operand a MID - operand b ALL
      // op_a/rs1 = b0110 , op_b/rs2 = b1111
      testcase_alu_12:
        // setup tag bits of operands a and b
        TAG_WR_MID( x20 )
        TAG_WR_ALL( x21 )
        // run testcase
        jal x31, run_testcase_alu
        jal x31, run_testcase_shift
        jal x31, run_testcase_comp
        jal x31, run_testcase_mul
        jal x31, run_testcase_float

    addi R_PROPPOL_CUR_ADDR, R_PROPPOL_CUR_ADDR, 4  // increment policy address
    bne R_PROPPOL_END_ADDR, R_PROPPOL_CUR_ADDR, policy_loop_alu  // check if end of policy-array is reached

  ret


//
// RUN TESTCASE routines
//

// ALU
run_testcase_alu:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_alu   // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x10)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )
  TAG_WR_MID( x24 )
  TAG_WR_MID( x25 )
  TAG_WR_MID( x26 )

  // exercise
  add x22, x20, x21   // ADD
  sub x23, x20, x21   // SUB
  xor x24, x20, x21   // XOR
  or  x25, x20, x21   // OR
  and x26, x20, x21   // AND

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15
  dift_assert_tag x24, x15
  dift_assert_tag x25, x15
  dift_assert_tag x26, x15

  // update expected value base address -> next test case
  addi x10, x10, 1

  // return
  jr x31


// ALU IMM
run_testcase_alui:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_alu  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x10)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )
  TAG_WR_MID( x24 )
  TAG_WR_MID( x25 )

  // exercise
  addi x22, x20, 0x0202 // ADDI
  xori x23, x20, 0x0202 // XOR
  ori  x24, x20, 0x0202 // OR
  andi x25, x20, 0x0202 // AND

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15
  dift_assert_tag x24, x15
  dift_assert_tag x25, x15

  // update expected value base address -> next test case
  //addi x10, x10, 1

  // return
  jr x31


// SHIFT
run_testcase_shift:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_shift  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x11)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )
  TAG_WR_MID( x24 )

  // exercise
  sll x22, x20, x21 // SLL
  srl x23, x20, x21 // SRL
  sra x24, x20, x21 // SRA

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15
  dift_assert_tag x24, x15

  // update expected value base address -> next test case
  addi x11, x11, 1

  // return
  jr x31


// SHIFT IMM
run_testcase_shifti:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_shift  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x11)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )
  TAG_WR_MID( x24 )

  // exercise
  slli x22, x20, 0x2 // SLLI
  srli x23, x20, 0x3 // SRLI
  srai x24, x20, 0x4 // SRAI

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15
  dift_assert_tag x24, x15

  // update expected value base address -> next test case
  //addi x11, x11, 1

  // return
  jr x31


// COMP
run_testcase_comp:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_comp  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x12)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )

  // exercise
  slt  x22, x20, x21 // SLT
  sltu x23, x20, x21 // SLTU

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15

  // update expected value base address -> next test case
  addi x12, x12, 1

  // return
  jr x31


// COMP IMM
run_testcase_compi:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_comp  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x12)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )

  // exercise
  slti  x22, x20, 0x0202 // SLTI
  sltiu x23, x20, 0x0202 // SLTIU

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15

  // update expected value base address -> next test case
  //addi x12, x12, 1

  // return
  jr x31


// MUL
run_testcase_mul:
  // change propagation policy
  la R_PROPPOL_CUR_VAL, proppol_mul  // load base address of propagation policy array
  add R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_VAL, R_PROPPOL_CUR_ADDR  // add address offset of current policy
  lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_VAL) // load propagation policy value to register
  csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL // activate this propagation policy

  // load expected value to register x15
  lb x15, (x13)

  // reset tag bits of actual values (results) registers
  TAG_WR_MID( x22 )
  TAG_WR_MID( x23 )
  TAG_WR_MID( x24 )
  TAG_WR_MID( x25 )
  TAG_WR_MID( x26 )
  TAG_WR_MID( x27 )
  TAG_WR_MID( x28 )
  TAG_WR_MID( x29 )

  // exercise
  mul    x22, x20, x21 // MUL
  mulh   x23, x20, x21 // MULH
  mulhsu x24, x20, x21 // MULHSU
  mulhu  x25, x20, x21 // MULHU
  //div    x26, x20, x21 // DIV
  //divu   x27, x20, x21 // DIVU
  //rem    x28, x20, x21 // REM
  //remu   x29, x20, x21 // REMU

  // check (actual vs expected)
  dift_assert_tag x22, x15
  dift_assert_tag x23, x15
  dift_assert_tag x24, x15
  dift_assert_tag x25, x15
  //dift_assert_tag x26, x15
  //dift_assert_tag x27, x15
  //dift_assert_tag x28, x15
  //dift_assert_tag x29, x15

  // update expected value base address -> next test case
  addi x13, x13, 1

  // return
  jr x31



//
// TODO

run_testcase_float:
  // return
  jr x31
