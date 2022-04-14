// DIFT Test Suite - Tag Propagation
//   Main File
//
// Jakob Sailer
// created 2022-02-17
// ESP / MT DIFT


//
// INCLUDES
//
#include "prop-test.h"



//
// MAIN
//
.global main
main:
  // setup test infrastructure
  // initialize counters (test case, passed, failed)
  li R_CNT_TEST, 0
  li R_CNT_PASS, 0
  li R_CNT_FAIL, 0
  // write info string (status message)
  li R_STATUS, STR_INIT

  // execute test cases
  jal ra, test_opclass_store
  jal ra, test_opclass_load
  jal ra, test_opclass_alu  // ALU, Shift, Comp, MUL
  // TODO: float
  jal ra, test_opclass_csr
  // change propagation policy
  li x31, PROPPOL_ONE
  csrw CSR_DIFT_TPCR, x31
  // execute test cases (for opclasses which do not have configurable policies)
  jal ra, test_opclass_xui
  jal ra, test_opclass_jump
  // reset propagation policy to ZERO propagation
  li x31, PROPPOL_ZERO
  csrw CSR_DIFT_TPCR, x31

  // if all tests passed: jump to test_passed_handler
  beq R_CNT_TEST, R_CNT_PASS, test_passed_handler
  // else: jump to test_failed_handler
  jal ra, test_failed_handler



//
// TEST INFRASTRUCTURE FUNCTIONS
//

// endless loop
loop:
  j loop

// PASSED handler
test_passed_handler:
  li R_STATUS, STR_PASS
  j loop

// FAILED handler
test_failed_handler:
  li R_STATUS, STR_FAIL
  j loop



//
// TEST CASES OPCLASSES
//

// XUI: LUI, AUIPC
test_opclass_xui:
  // setup actual result registers: with dummy values and fully tagged
  li x10, 0x123     // LUI
  TAG_WR_ALL( x10 )
  li x11, 0xabc     // AUIPC
  TAG_WR_ALL( x11 )
  
  // setup expected values: nothing tagged
  li x12, 0x0 // LUI
  li x13, 0x0 // AUIPC

  // exercise: with dummy values
  lui   x10, 0x45678
  auipc x11, 0xdef
  
  // check (actual vs expected)
  dift_assert_tag x10, x12
  dift_assert_tag x11, x13

  ret


// JUMP: JAL, JALR
test_opclass_jump:
  // setup expected value: nothing tagged
  li x12, 0x0 // JAL, JALR
  
  // setup jump target register for JALR
  la x14, test_opclass_jump_target

  // first setup actual result register, then exercise
  TAG_WR_ALL( x10 )
  jal  x10, test_opclass_jump_target
  TAG_WR_ALL( x10 )
  jalr x10, x14

  ret

test_opclass_jump_target:
  // check (actual vs expected)
  dift_assert_tag x10, x12
  // jump back
  jr x10


// CSR
test_opclass_csr:
  // setup: load write registers with dummy values
  li x10, 0xabc
  li x11, 0xdef
  // setup: set tag bits of write registers
  TAG_WR_ALL( x10 )
  TAG_WR_NONE( x11 )
  // setup: expected values
  li x14, 0x0
  li x15, 0xf

  // change to ZERO policy
  li x31, PROPPOL_ZERO
  csrw CSR_DIFT_TPCR, x31

  // exercise: write to CSR
  csrw CSR_DSCRATCH0, x10
  csrw CSR_DSCRATCH1, x11
  // setup: readback registers
  TAG_WR_MID( x12 )
  TAG_WR_MID( x13 )
  // exercise: read back from CSR
  csrr x12, CSR_DSCRATCH0
  csrr x13, CSR_DSCRATCH1
  // check (actual vs expected)
  dift_assert_tag x12, x14
  dift_assert_tag x13, x14

  // change to ONE policy
  li x31, PROPPOL_ONE
  csrw CSR_DIFT_TPCR, x31

  // exercise: write to CSR
  csrw CSR_DSCRATCH0, x10
  csrw CSR_DSCRATCH1, x11
  // setup: readback registers
  TAG_WR_MID( x12 )
  TAG_WR_MID( x13 )
  // exercise: read back from CSR
  csrr x12, CSR_DSCRATCH0
  csrr x13, CSR_DSCRATCH1
  // check (actual vs expected)
  dift_assert_tag x12, x15
  dift_assert_tag x13, x15

  ret
