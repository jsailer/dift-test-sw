// DIFT Test Suite - Tag Propagation
//   OpClass: Load
//
// Jakob Sailer
// created 2022-02-26
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
#define RESULT_OFFSET_LW      (NUM_TESTCASES*1*0) //  0 bytes offset
#define RESULT_OFFSET_LH      (NUM_TESTCASES*1*1) // 13 bytes offset
#define RESULT_OFFSET_LB      (NUM_TESTCASES*1*2) // 26 bytes offset
#define RESULT_OFFSET_PROPPOL (NUM_TESTCASES*1*3) // 39 bytes offset

// byte offsets in dummy memory for different test scenarios of alignment
#define DUMMY_MEM_OFFSET_NONE   0
#define DUMMY_MEM_OFFSET_1      ((1*4) + 1)   // 5
#define DUMMY_MEM_OFFSET_2      ((2*4) + 2)   // 10
#define DUMMY_MEM_OFFSET_3      ((3*4) + 3)   // 15



//
// STATIC DATA
//
.section  .data

// Propagation Policies for LOAD tests
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
proppol_load:   .word   0b1001000100000000000, \
                        0b1001010100000000000, \
                        0b1001100100000000000, \
                        0b1001110100000000000, \
                        0b1001001000000000000, \
                        0b1001011000000000000, \
                        0b1001101000000000000, \
                        0b1001111000000000000, \
                        0b1001110000000000000, \
                        0b1001001100000000000

.align 4
// PROP |    TESTCASES -> [0]     [1]     [2]     [3]     [4]     [5]     [6]     [7]     [8]     [9]     [10]     [11]     [12]
// POL  v    VAL-ADDR     N-N   ALL-N   LSB-N   MSB-N   MID-N   N-ALL   N-LSB   N-MSB   N-MID  ALL-ALL LSB-MID  ALL-MSB  MID-ALL
result_lw_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lh_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lb_or00:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_lw_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_lh_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_lb_or01:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001

result_lw_or10:  .byte 0b0000, 0b1111, 0b0001, 0b1000, 0b0110, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111,  0b0001,  0b1111,  0b0110
result_lh_or10:  .byte 0b0000, 0b0011, 0b0001, 0b0000, 0b0010, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011,  0b0001,  0b0011,  0b0010
result_lb_or10:  .byte 0b0000, 0b0001, 0b0001, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001,  0b0001,  0b0001,  0b0000

result_lw_or11:  .byte 0b0000, 0b1111, 0b0001, 0b1000, 0b0110, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_lh_or11:  .byte 0b0000, 0b0011, 0b0001, 0b0000, 0b0010, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_lb_or11:  .byte 0b0000, 0b0001, 0b0001, 0b0000, 0b0000, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001


result_lw_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lh_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lb_and00: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_lw_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lh_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lb_and01: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_lw_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lh_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lb_and10: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_lw_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b1111,  0b0001,  0b1111,  0b0110
result_lh_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0011,  0b0001,  0b0011,  0b0010
result_lb_and11: .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0001,  0b0001,  0b0001,  0b0000


result_lw_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lh_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000
result_lb_zero:  .byte 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000, 0b0000,  0b0000,  0b0000,  0b0000

result_lw_one:   .byte 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111, 0b1111,  0b1111,  0b1111,  0b1111
result_lh_one:   .byte 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011, 0b0011,  0b0011,  0b0011,  0b0011
result_lb_one:   .byte 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001, 0b0001,  0b0001,  0b0001,  0b0001


// Dummy Memory TAG map
//    X .. don't care (not used)
//    this will be created in the setup phase
//                      3..0
// dummy_load_none  +0: 0000  = b0000   // dont care as 0
//                  +4: 000X  = b0000
//                  +8: 00X0  = b0000
//                 +12: 0X00  = b0000
//                 +16: X000  = b0000
//
// dummy_load_all   +0: 1111  = b1111   // dont care as 1
//                  +4: 111X  = b1111
//                  +8: 11X1  = b1111
//                 +12: 1X11  = b1111
//                 +16: X111  = b1111
//
// dummy_load_lsb   +0: 0001  = b0001   // dont care as 0
//                  +4: 001X  = b0010
//                  +8: 01X0  = b0100
//                 +12: 1X00  = b1000
//                 +16: X000  = b0000
//
// dummy_load_msb   +0: 1000  = b1000   // dont care as 0
//                  +4: 000X  = b0000
//                  +8: 00X1  = b0001
//                 +12: 0X10  = b0010
//                 +16: X100  = b0100
//
// dummy_load_mid   +0: 0110  = b0110   // dont care as 0
//                  +4: 110X  = b1100
//                  +8: 10X0  = b1000
//                 +12: 0X01  = b0001
//                 +16: X011  = b0011
.align 4
dummy_load_none:  .word 0xFF00FF00, 0xFF00FF00, 0xFF00FF00, 0xFF00FF00, 0xFF00FF00
dummy_load_all:   .word 0xFF11FF11, 0xFF11FF11, 0xFF11FF11, 0xFF11FF11, 0xFF11FF11
dummy_load_lsb:   .word 0xFF22FF22, 0xFF22FF22, 0xFF22FF22, 0xFF22FF22, 0xFF22FF22
dummy_load_msb:   .word 0xFF33FF33, 0xFF33FF33, 0xFF33FF33, 0xFF33FF33, 0xFF33FF33
dummy_load_mid:   .word 0xFF44FF44, 0xFF44FF44, 0xFF44FF44, 0xFF44FF44, 0xFF44FF44



//
// ROUTINES
//
.section  .text

// Register Usage
//  x10 &dummy    read address (for loading from dummy memory)
//  x11 &result   current address expected-results (points to result_lw_* variable)
//
//  x12..x14  expected values
//    x12     LW expected values
//    x13     LH / LHU expected values
//    x14     LB / LBU expected values
//
//  x15..x18  actual values
//    x15     aligned
//    x16     unaligned + 1byte
//    x17     unaligned + 2byte
//    x18     unaligned + 3byte
//
//  x19   temporary used register
//
//  x31   link register - return address from exercise_and_check routine

//
// MAIN TESTCASE routine
//
.global test_opclass_load
test_opclass_load:
  // basic setup
  jal x31, setup_load
  // load address for propagation policy array
  la R_PROPPOL_CUR_ADDR, proppol_load
  // init x11: holds the address of the current expected values array
  la x11, result_lw_or00

  // POLICY LOOP: loop through all different policy cases (to exercise each test case for each policy)
  addi R_PROPPOL_END_ADDR, R_PROPPOL_CUR_ADDR, NUM_PROPPOLS*4 // calculate end address of proppol_store array (10 entries with 4 bytes each)
  policy_loop_load:
    // load propagation policy value for this loop iteration into register x8
    lw R_PROPPOL_CUR_VAL, 0 (R_PROPPOL_CUR_ADDR)
    // change propagation policy
    csrw CSR_DIFT_TPCR, R_PROPPOL_CUR_VAL

    // TEST CASES
    testcases_load:
      // TEST CASE [0] : no operand tagged
      // addr/rs1 = b0000 , val/rs2 = b0000
      testcase_load_0:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_none   // value: none
        TAG_WR_NONE( x10 )        // addr:  none
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [1] : value all
      // addr/rs1 = b0000 , val/rs2 = b1111
      testcase_load_1:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_all    // value: all
        TAG_WR_NONE( x10 )        // addr:  none
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [2] : value LSB
      // addr/rs1 = b0000 , val/rs2 = b0001
      testcase_load_2:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_lsb    // value: LSB
        TAG_WR_NONE( x10 )        // addr:  none
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [3] : value MSB
      // addr/rs1 = b0000 , val/rs2 = b1000
      testcase_load_3:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_msb    // value: MSB
        TAG_WR_NONE( x10 )        // addr:  none
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [4] : value MID
      // addr/rs1 = b0000 , val/rs2 = b0110
      testcase_load_4:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_mid    // value: MID
        TAG_WR_NONE( x10 )        // addr:  none
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [5] : address all
      // addr/rs1 = b1111 , val/rs2 = b0000
      testcase_load_5:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_none   // value: none
        TAG_WR_ALL( x10 )         // addr:  all
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [6] : address LSB
      // addr/rs1 = b0001 , val/rs2 = b0000
      testcase_load_6:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_none   // value: none
        TAG_WR_LSB( x10 )         // addr:  LSB
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [7] : address MSB
      // addr/rs1 = b1000 , val/rs2 = b0000
      testcase_load_7:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_none   // value: none
        TAG_WR_MSB( x10 )         // addr:  MSB
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [8] : address MID
      // addr/rs1 = b0110 , val/rs2 = b0000
      testcase_load_8:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_none   // value: none
        TAG_WR_MID ( x10 )        // addr:  MID
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [9] : address all, value all
      // addr/rs1 = b1111 , val/rs2 = b1111
      testcase_load_9:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_all    // value: all
        TAG_WR_ALL( x10 )         // addr:  all
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [10] : address MID, value LSB
      // addr/rs1 = b0001 , val/rs2 = b0110
      testcase_load_10:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_lsb    // value: LSB
        TAG_WR_MID( x10 )         // addr:  MID
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [11] : address MSB, value all
      // addr/rs1 = b1111 , val/rs2 = b1000
      testcase_load_11:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_all    // value: all
        TAG_WR_MSB( x10 )         // addr:  MSB
        // run testcase
        jal x31, run_testcase_load

      // TEST CASE [12] : address all, value MID
      // addr/rs1 = b0110 , val/rs2 = b1111
      testcase_load_12:
        // setup read address (to accordingly tagged dummy memory) and setup tag bits of read address
        la x10, dummy_load_mid    // value: MID
        TAG_WR_ALL( x10 )         // addr:  all
        // run testcase
        jal x31, run_testcase_load

    // update expected values array address (x11)
    addi x11, x11, NUM_TESTCASES*2

    addi R_PROPPOL_CUR_ADDR, R_PROPPOL_CUR_ADDR, 4  // increment policy address
    bne R_PROPPOL_END_ADDR, R_PROPPOL_CUR_ADDR, policy_loop_load  // check if end of policy-array is reached

  ret


//
// SETUP routine
//
setup_load:
  // set propagation policy for setup tasks (store propagation - value enable)
  //        StorLoadAlShCoCMuFl
  li x19, 0b1001000000000000000
  csrw CSR_DIFT_TPCR, x19

  // setup tag bits in dummy memory (according to Dummy Memory TAG map, see above)
  li x11, 0x03020100
  li x12, 0x07060504
  li x13, 0x0b0a0908
  li x14, 0x0f0e0d0c
  li x15, 0x13121110
  // NONE
  la x10, dummy_load_none
  TAG_WR_NONE( x11 )
  TAG_WR_NONE( x12 )
  TAG_WR_NONE( x13 )
  TAG_WR_NONE( x14 )
  TAG_WR_NONE( x15 )
  sw x11,   0 (x10)
  sw x12,   4 (x10)
  sw x13,   8 (x10)
  sw x14,  12 (x10)
  sw x15,  16 (x10)
  // ALL
  la x10, dummy_load_all
  TAG_WR_ALL( x11 )
  TAG_WR_ALL( x12 )
  TAG_WR_ALL( x13 )
  TAG_WR_ALL( x14 )
  TAG_WR_ALL( x15 )
  sw x11,   0 (x10)
  sw x12,   4 (x10)
  sw x13,   8 (x10)
  sw x14,  12 (x10)
  sw x15,  16 (x10)
  // LSB
  la x10, dummy_load_lsb
  TAG_WR( x11, 0b0001 )
  TAG_WR( x12, 0b0010 )
  TAG_WR( x13, 0b0100 )
  TAG_WR( x14, 0b1000 )
  TAG_WR( x15, 0b0000 )
  sw x11,   0 (x10)
  sw x12,   4 (x10)
  sw x13,   8 (x10)
  sw x14,  12 (x10)
  sw x15,  16 (x10)
  // MSB
  la x10, dummy_load_msb
  TAG_WR( x11, 0b1000 )
  TAG_WR( x12, 0b0000 )
  TAG_WR( x13, 0b0001 )
  TAG_WR( x14, 0b0010 )
  TAG_WR( x15, 0b0100 )
  sw x11,   0 (x10)
  sw x12,   4 (x10)
  sw x13,   8 (x10)
  sw x14,  12 (x10)
  sw x15,  16 (x10)
  // MID
  la x10, dummy_load_mid
  TAG_WR( x11, 0b0110 )
  TAG_WR( x12, 0b1100 )
  TAG_WR( x13, 0b1000 )
  TAG_WR( x14, 0b0001 )
  TAG_WR( x15, 0b0011 )
  sw x11,   0 (x10)
  sw x12,   4 (x10)
  sw x13,   8 (x10)
  sw x14,  12 (x10)
  sw x15,  16 (x10)

  jr x31


//
// RUN TESTCASE routine
//
run_testcase_load:
  // load expected values to registers x14..x16
  lb x12,  RESULT_OFFSET_LW + 0 (x11)
  lb x13,  RESULT_OFFSET_LH + 0 (x11)
  lb x14,  RESULT_OFFSET_LB + 0 (x11)

  // LW
    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x15 )
    TAG_WR_MID( x16 )
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    // exercise
    lw x15, DUMMY_MEM_OFFSET_NONE (x10)
    nop
    lw x16, DUMMY_MEM_OFFSET_1    (x10)
    nop
    lw x17, DUMMY_MEM_OFFSET_2    (x10)
    nop
    lw x18, DUMMY_MEM_OFFSET_3    (x10)
    nop
    // check (actual vs expected)
    dift_assert_tag x15, x12
    dift_assert_tag x16, x12
    dift_assert_tag x17, x12
    dift_assert_tag x18, x12

  // LH
    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x15 )
    TAG_WR_MID( x16 )
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    // exercise
    lh x15, DUMMY_MEM_OFFSET_NONE (x10)
    nop
    lh x16, DUMMY_MEM_OFFSET_1    (x10)
    nop
    lh x17, DUMMY_MEM_OFFSET_2    (x10)
    nop
    lh x18, DUMMY_MEM_OFFSET_3    (x10)
    nop
    // check (actual vs expected)
    dift_assert_tag x15, x13
    dift_assert_tag x16, x13
    dift_assert_tag x17, x13
    dift_assert_tag x18, x13

  // LHU
    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x15 )
    TAG_WR_MID( x16 )
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    // exercise
    lhu x15, DUMMY_MEM_OFFSET_NONE (x10)
    nop
    lhu x16, DUMMY_MEM_OFFSET_1    (x10)
    nop
    lhu x17, DUMMY_MEM_OFFSET_2    (x10)
    nop
    lhu x18, DUMMY_MEM_OFFSET_3    (x10)
    nop
    // check (actual vs expected)
    dift_assert_tag x15, x13
    dift_assert_tag x16, x13
    dift_assert_tag x17, x13
    dift_assert_tag x18, x13

  // LB
    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x15 )
    TAG_WR_MID( x16 )
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    // exercise
    lb x15, DUMMY_MEM_OFFSET_NONE (x10)
    nop
    lb x16, DUMMY_MEM_OFFSET_1    (x10)
    nop
    lb x17, DUMMY_MEM_OFFSET_2    (x10)
    nop
    lb x18, DUMMY_MEM_OFFSET_3    (x10)
    nop
    // check (actual vs expected)
    dift_assert_tag x15, x14
    dift_assert_tag x16, x14
    dift_assert_tag x17, x14
    dift_assert_tag x18, x14

  // LBU
    // reset tag bits of actual values (results) registers
    TAG_WR_MID( x15 )
    TAG_WR_MID( x16 )
    TAG_WR_MID( x17 )
    TAG_WR_MID( x18 )
    // exercise
    lbu x15, DUMMY_MEM_OFFSET_NONE (x10)
    nop
    lbu x16, DUMMY_MEM_OFFSET_1    (x10)
    nop
    lbu x17, DUMMY_MEM_OFFSET_2    (x10)
    nop
    lbu x18, DUMMY_MEM_OFFSET_3    (x10)
    nop
    // check (actual vs expected)
    dift_assert_tag x15, x14
    dift_assert_tag x16, x14
    dift_assert_tag x17, x14
    dift_assert_tag x18, x14

  // update expected values base address -> next test case
  addi x11, x11, 1

  // return
  jr x31
