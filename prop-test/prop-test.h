// DIFT Test Suite - Tag Propagation
//   Common Include File (Defines, Macros)
//
// Jakob Sailer
// created 2022-02-24
// ESP / MT DIFT


// ----------------------
//   Register Usage Map
// ----------------------
//
// x1   ra    Return address
//
// x2   sp    Test Case Counter (number of executed test cases)
// x3   gp    Test Passed Counter (number of passed test cases)
// x4   tp    Test Failed Counter (number of failed test cases)
// x5   t0    Test Overall Status (Char-String: INIT, FAIL, PASS)
// 
// x6   t1    Change Propagation Policy
// x7   t2    Change Propagation Policy
// x8   s0/fp Change Propagation Policy
// x9   s1    Assert routine (to read out tag bits)
//
// x10..x31   Opclass specific



//
// DEFINES
//

// Registers
#define R_RA        x1
#define R_CNT_TEST  x2
#define R_CNT_PASS  x3
#define R_CNT_FAIL  x4
#define R_STATUS    x5
#define R_PROPPOL_CUR_ADDR  x6
#define R_PROPPOL_END_ADDR  x7
#define R_PROPPOL_CUR_VAL   x8
#define R_ASSERT    x9

// CSR addresses
#define CSR_DSCRATCH0 0x7B2 // Debug Scratch Regiser 0
#define CSR_DSCRATCH1 0x7B3 // Debug Scratch Regiser 1
#define CSR_DIFT_TPCR 0x020 // TPCR .. Tag Propagation Configuration Register
#define CSR_DIFT_TCCR 0x021 // TCCR .. Tag Check Configuration Register

// Mini-Strings (4 bytes)
#define STR_INIT  0x494E4954
#define STR_PASS  0x50415353
#define STR_FAIL  0x4641494C

// Common Propagation Policy Values
#define PROPPOL_ZERO  0b0000000000000000000 
#define PROPPOL_ONE   0b1111111111111111111


//
// MACROS
//

// clean tags in memory, starting at the address of REG
// block of 16 bytes
.macro clean_mem_16bytes reg
  sw zero,  0 (\reg)
  sw zero,  4 (\reg)
  sw zero,  8 (\reg)
  sw zero, 12 (\reg)
.endm

// block of 20 words (80 bytes)
.macro clean_mem_20words reg
  sw zero,  0x0 (\reg)
  sw zero,  0x4 (\reg)
  sw zero,  0x8 (\reg)
  sw zero,  0xc (\reg)
  sw zero, 0x10 (\reg)
  sw zero, 0x14 (\reg)
  sw zero, 0x18 (\reg)
  sw zero, 0x1c (\reg)
  sw zero, 0x20 (\reg)
  sw zero, 0x24 (\reg)
  sw zero, 0x28 (\reg)
  sw zero, 0x2c (\reg)
  sw zero, 0x30 (\reg)
  sw zero, 0x34 (\reg)
  sw zero, 0x38 (\reg)
  sw zero, 0x3c (\reg)
  sw zero, 0x40 (\reg)
  sw zero, 0x44 (\reg)
  sw zero, 0x48 (\reg)
  sw zero, 0x4c (\reg)
.endm

// Assert routine
.macro dift_assert_tag reg_tag, reg_exp
              addi R_CNT_TEST, R_CNT_TEST, 1      // increment test case counter          
              tagrd R_ASSERT, \reg_tag, 0x00f     // read out tag bits (to x9)
              beq R_ASSERT, \reg_exp, ass_else\@  // check actual tag bits vs expected
  ass_if\@:   addi R_CNT_FAIL, R_CNT_FAIL, 1      // if TEST FAILED: increment test failed counter
              j ass_else\@+2
  ass_else\@: addi R_CNT_PASS, R_CNT_PASS, 1      // else (TEST PASSED): increment test passed counter
.endm

// write tags (write all 4 tag bits - to 1 and/or 0)
#define TAG_WR_ALL(REG)     tagset REG, x0, 0x0ff // val = 0xf  mask = 0xf
#define TAG_WR_LSB(REG)     tagset REG, x0, 0x01f // val = 0x1  mask = 0xf
#define TAG_WR_MSB(REG)     tagset REG, x0, 0x08f // val = 0x8  mask = 0xf
#define TAG_WR_MID(REG)     tagset REG, x0, 0x06f // val = 0x6  mask = 0xf
#define TAG_WR_NONE(REG)    tagset REG, x0, 0x00f // val = 0x0  mask = 0xf
#define TAG_WR(REG, IMM)    tagset REG, x0, (IMM<<4)|0xf

// set tags (only set the specified tag bits to 1)
#define TAG_SET_LSB(REG)    tagset REG, x0, 0x0f1 // val = 0xf  mask = 0x1
#define TAG_SET_MSB(REG)    tagset REG, x0, 0x0f8 // val = 0xf  mask = 0x8
#define TAG_SET_MID(REG)    tagset REG, x0, 0x0f6 // val = 0xf  mask = 0x6

// reset tags (only reset the specified tag bits to 0)
#define TAG_RESET_LSB(REG)  tagset REG, x0, 0x001 // val = 0x0  mask = 0x1
#define TAG_RESET_MSB(REG)  tagset REG, x0, 0x008 // val = 0x0  mask = 0x8
#define TAG_RESET_MID(REG)  tagset REG, x0, 0x006 // val = 0x0  mask = 0x6
