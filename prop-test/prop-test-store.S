// DIFT Test Suite - Tag Propagation
//   OpClass: Store
//
// Jakob Sailer
// created 2022-02-24
// ESP / MT DIFT


//
// INCLUDES
//
#include "prop-test.h"



//
// DEFINES
//

// constant numbers
#define NUM_TESTCASES   13
#define NUM_PROPPOLS    10

// byte offsets in result array
#define RESULT_OFFSET_SW      (NUM_TESTCASES*1*0) //  0 bytes offset
#define RESULT_OFFSET_SH      (NUM_TESTCASES*1*1) // 13 bytes offset
#define RESULT_OFFSET_SB      (NUM_TESTCASES*1*2) // 26 bytes offset
#define RESULT_OFFSET_PROPPOL (NUM_TESTCASES*1*3) // 39 bytes offset



//
// STATIC DATA
//
.section  .data

// Propagation Policies for STORE tests
//    [0] OR   val=0 addr=0
//    [1] OR   val=0 addr=1
//    [2] OR   val=1 addr=0
//    [3] OR   val=1 addr=1
//    [4] AND  val=0 addr=0
//    [5] AND  val=0 addr=1
//    [6] AND  val=1 addr=0
//    [7] AND  val=1 addr=1
//    [8] ZERO val=1 addr=1
//    [9] ONE  val=0 addr=0
//                        StorLoadAlShCoCMuFl
proppol_store:  .word   0b0001100100000000000, \
                        0b0101100100000000000, \
                        0b1001100100000000000, \
                        0b1101100100000000000, \
                        0b0010100100000000000, \
                        0b0110100100000000000, \
                        0b1010100100000000000, \
                        0b1110100100000000000, \
                        0b1100100100000000000, \
                        0b0011100100000000000

.align 4
// PROP |    TESTCASES -> [0]     [1]     [2]     [3]     [4]     [5]     [6]     [7]     [8]     [9]     [10]     [11]     [12]
// POL  v    VAL-ADDR     N-N   ALL-N   LSB-N   MSB-N   MID-N   N-ALL   N-LSB   N-MSB   N-MID  ALL-ALL LSB-MID  ALL-MSB  MID-ALL
result_sw_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sh_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sb_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_sw_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_sh_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_sb_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001

result_sw_or10:  .byte 0b0000, 0b1111, 0b0001, 0b1000, 0b0110, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111,  0b0001,  0b1111,  0b0110
result_sh_or10:  .byte 0b0000, 0b0011, 0b0001, 0b0000, 0b0010, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011,  0b0001,  0b0011,  0b0010
result_sb_or10:  .byte 0b0000, 0b0001, 0b0001, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001,  0b0001,  0b0001,  0b0000

result_sw_or11:  .byte 0b0000, 0b1111, 0b0001, 0b1000, 0b0110, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_sh_or11:  .byte 0b0000, 0b0011, 0b0001, 0b0000, 0b0010, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_sb_or11:  .byte 0b0000, 0b0001, 0b0001, 0b0000, 0b0000, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001


result_sw_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sh_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sb_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_sw_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sh_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sb_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_sw_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sh_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sb_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_sw_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111,  0b0001,  0b1111,  0b0110
result_sh_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011,  0b0001,  0b0011,  0b0010
result_sb_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001,  0b0001,  0b0001,  0b0000


result_sw_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sh_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_sb_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_sw_one:   .byte 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_sh_one:   .byte 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_sb_one:   .byte 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001


// dummy memory (to write to in test cases)
.align 4
dummy_store:
.rept   4*5
  .word   0xACDCACDC
.endr



//
// ROUTINES
//
.section  .text

// Register Usage
//  x10 &dummy    address dummy memory - non-tagged
//  x11 &dummy    address dummy memory - tagged/non-tagged depending on test case
//  x12 dummy     write value (value that is written to dummy memory) - tagged/non-tagged depending on test case
//  x13 &result   current address expected-results (points to result_sw_* variable)
//
//  x14..x16  expected values
//    x14     SW expected values
//    x15     SH expected values
//    x16     SB expected values
//
//  x17..x28    actual values
//    x17..x20  SW actual values
//      x17     aligned
//      x18     unaligned + 1byte
//      x19     unaligned + 2byte
//      x20     unaligned + 3byte
//    x21..x24  SH actual values
//      ...
//    x25..x28  SB actual values
//      ...
//
//  x29   link register - return address from exercise_and_check routine

//
// MAIN TESTCASE routine
//
.global test_opclass_store
test_opclass_store:
  // basic setup
  // set propagation policy
    la R_PROPPOL_CUR_ADDR, proppol_store
    lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_ADDR)
    csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL
    // addr/rs1 = &dummy , val/rs2 = 0x123456
    la x10, dummy_store // x10: hold valid address (untagged - used for reading values back from memory cleanly)
    la x11, dummy_store // x11: hold address which is exercised in test as write address (might be tagged - depending on test case)
    li x12, 0x123456    // x12: hold value (might be tagged - depending on test case)
    la x13, result_sw_or00  // x13: hold address of the current expected values array

  // POLICY LOOP: loop through all different policy cases (to exercise each test case for each policy)
  addi R_PROPPOL_END_ADDR, R_PROPPOL_CUR_ADDR, NUM_PROPPOLS*4 // calculate end address of proppol_store array (10 entries with 4 bytes each)
  policy_loop_store:
    // load propagation policy value for this loop iteration into register x8
    lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_ADDR)

    // TEST CASES
    testcases_store:
      // TEST CASE [0] : no operand tagged
      // addr/rs1/x11 = b0000 , val/rs2/x12 = b0000
      testcase_store_0:
        // setup tag bits of write value and write address
        TAG_WR_NONE( x11 )
        TAG_WR_NONE( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [1] : value all
      // addr/rs1/x11 = b0000 , val/rs2/x12 = b1111
      testcase_store_1:
        // setup tag bits of write value and write address
        TAG_WR_NONE( x11 )
        TAG_WR_ALL( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [2] : value LSB
      // addr/rs1/x11 = b0000 , val/rs2/x12 = b0001
      testcase_store_2:
        // setup tag bits of write value and write address
        TAG_WR_NONE( x11 )
        TAG_WR_LSB( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [3] : value MSB
      // addr/rs1/x11 = b0000 , val/rs2/x12 = b1000
      testcase_store_3:
        // setup tag bits of write value and write address
        TAG_WR_NONE( x11 )
        TAG_WR_MSB( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [4] : value MID
      // addr/rs1/x11 = b0000 , val/rs2/x12 = b0110
      testcase_store_4:
        // setup tag bits of write value and write address
        TAG_WR_NONE( x11 )
        TAG_WR_MID( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [5] : address all
      // addr/rs1/x11 = b1111 , val/rs2/x12 = b0000
      testcase_store_5:
        // setup tag bits of write value and write address
        TAG_WR_ALL( x11 )
        TAG_WR_NONE( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [6] : address LSB
      // addr/rs1/x11 = b0001 , val/rs2/x12 = b0000
      testcase_store_6:
        // setup tag bits of write value and write address
        TAG_WR_LSB( x11 )
        TAG_WR_NONE( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [7] : address MSB
      // addr/rs1/x11 = b1000 , val/rs2/x12 = b0000
      testcase_store_7:
        // setup tag bits of write value and write address
        TAG_WR_MSB( x11 )
        TAG_WR_NONE( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [8] : address MID
      // addr/rs1/x11 = b0110 , val/rs2/x12 = b0000
      testcase_store_8:
        // setup tag bits of write value and write address
        TAG_WR_MID( x11 )
        TAG_WR_NONE( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [9] : address all, value all
      // addr/rs1/x11 = b1111 , val/rs2/x12 = b1111
      testcase_store_9:
        // setup tag bits of write value and write address
        TAG_WR_ALL( x11 )
        TAG_WR_ALL( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [10] : address MID, value LSB
      // addr/rs1/x11 = b0001 , val/rs2/x12 = b0110
      testcase_store_10:
        // setup tag bits of write value and write address
        TAG_WR_MID( x11 )
        TAG_WR_LSB( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [11] : address MSB, value all
      // addr/rs1/x11 = b1111 , val/rs2/x12 = b1000
      testcase_store_11:
        // setup tag bits of write value and write address
        TAG_WR_MSB( x11 )
        TAG_WR_ALL( x12 )
        // run testcase
        jal x29, run_testcase_store

      // TEST CASE [12] : address all, value MID
      // addr/rs1/x11 = b0110 , val/rs2/x12 = b1111
      testcase_store_12:
        // setup tag bits of write value and write address
        TAG_WR_ALL( x11 )
        TAG_WR_MID( x12 )
        // run testcase
        jal x29, run_testcase_store

    // update expected values array address (x13)
    addi x13, x13, NUM_TESTCASES*2

    addi R_PROPPOL_CUR_ADDR, R_PROPPOL_CUR_ADDR, 4  // increment policy address
    bne R_PROPPOL_END_ADDR, R_PROPPOL_CUR_ADDR, policy_loop_store  // check if end of policy-array is reached

  ret


//
// RUN TESTCASE routine
//
run_testcase_store:
  //
  // SETUP routine
  // clean memory from tag bits, set propagation policy, load expected values
  //    expects correct values in the following registers
  //      x8  R_PROPPOL_CUR_VAL
  //      x10 non-tagged address of dummy memory
  //      x13 address of current expected value for SW: &expected_values_sw_??[ test_case_nr ]
  //            addresses for SH and SB expected values can be calculated with fixed offset from SW expected values
  //      x29 return address
  //
  setup:
    // reset propagation policy for cleaning of memory
    csrw CSR_DIFT_TPCR, PROPPOL_ZERO
    // clean memory (set tag bits of dummy variable to 0)
    clean_mem_20words x10
    // reinstate desired propagation policy for the test run
    csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL
    // load expected values to registers x14..x16
    lb x14,  RESULT_OFFSET_SW + 0 (x13)
    lb x15,  RESULT_OFFSET_SH + 0 (x13)
    lb x16,  RESULT_OFFSET_SB + 0 (x13)

    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    TAG_WR_MID( x19 )
    TAG_WR_MID( x20 )
    TAG_WR_MID( x21 )
    TAG_WR_MID( x22 )
    TAG_WR_MID( x23 )
    TAG_WR_MID( x24 )
    TAG_WR_MID( x25 )
    TAG_WR_MID( x26 )
    TAG_WR_MID( x27 )
    TAG_WR_MID( x28 )

  //
  // EXERCISE AND CHECK routine
  // exercise test cases, load back values, check (actual vs. expected)
  //    expects correct values in the following registers
  //      x10 untagged base addres of dummy memory
  //      x11 write address of dummy memory (might be tagged or untagged - based on test case)
  //      x12 write value (might be tagged or untagged - based on test case)
  //      x14 expected value for SW
  //      x15 expected value for SH
  //      x16 expected value for SB
  //      x29 return address
  //
  //  uses registers x17..x28 (for storing actual values)
  exercise_and_check:
    // exercise - SW
    sw x12,  0 + 0 (x11)  // word aligned
    sw x12,  4 + 1 (x11)  // word offset +1 byte
    sw x12, 12 + 2 (x11)  // word offset +2 byte
    sw x12, 20 + 3 (x11)  // word offset +3 byte
    // load back values from memory
    lw x17,  0 + 0 (x10)
    lw x18,  4 + 1 (x10)
    lw x19, 12 + 2 (x10)
    lw x20, 20 + 3 (x10)
    // check (actual vs expected)
    dift_assert_tag x17, x14
    dift_assert_tag x18, x14
    dift_assert_tag x19, x14
    dift_assert_tag x20, x14

    // exercise - SH
    sh x12, 28 + 0 (x11)  // word aligned
    sh x12, 32 + 1 (x11)  // word offset +1 byte
    sh x12, 40 + 2 (x11)  // word offset +2 byte
    sh x12, 48 + 3 (x11)  // word offset +3 byte
    // load back values from memory
    lw x21, 28 + 0 (x10)
    lw x22, 32 + 1 (x10)
    lw x23, 40 + 2 (x10)
    lw x24, 48 + 3 (x10)
    // check (actual vs expected)
    dift_assert_tag x21, x15
    dift_assert_tag x22, x15
    dift_assert_tag x23, x15
    dift_assert_tag x24, x15

    // exercise - SB
    sb x12, 56 + 0 (x11)  // word aligned
    sb x12, 60 + 1 (x11)  // word offset +1 byte
    sb x12, 68 + 2 (x11)  // word offset +2 byte
    sb x12, 76 + 3 (x11)  // word offset +3 byte
    // load back values from memory
    lw x25, 56 + 0 (x10)
    lw x26, 60 + 1 (x10)
    lw x27, 68 + 2 (x10)
    lw x28, 76 + 3 (x10)
    // check (actual vs expected)
    dift_assert_tag x25, x16
    dift_assert_tag x26, x16
    dift_assert_tag x27, x16
    dift_assert_tag x28, x16

  // update expected values base address -> next test case
  addi x13, x13, 1

  // return
  jr x29
