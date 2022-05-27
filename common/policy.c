// DIFT Policy
//  Functions to change the DIFT Propagation and Check Policies
// Autor:   Jakob Sailer, BSc
// created: 2021-04-25


//
// INCLUDES
//

#include "../common/policy.h"



//
// GLOBAL VARIABLES - IMPLEMENTATION
//

// standard propagation policy
const dift_prop_pol_t prop_policy_default = { .S =
    {
      .store    = 0b0001, // res=0, mode=0 (OR), en_addr=0, en_val=1
      .load     = 0b0001, // res=0, mode=0 (OR), en_addr=0, en_val=1
      .branch   = 0b0,    // not implemented yet
      .csr      = 0b0,    // en_csr=0
      .logic    = 0b01,   // mode=0 (OR), en=1
      .add      = 0b11,   // mode=1 (AND), en=1
      .mul      = 0b01,   // mode=0 (OR), en=1
      .shift    = 0b0011, // res=0, mode=0 (OR), en_shamt=1, en=1
      .comp     = 0b01,   // mode=0 (OR), en=1
      .fpu      = 0b01,   // mode=0 (OR), en=1
      .xpulp    = 0b01,   // mode=0 (OR), en=1
      .reserved = 0
    }
  };

const dift_prop_pol_t prop_policy_strict = { .S =
    {
      .store    = 0b0001, // res=0, mode=0 (OR), en_addr=0, en_val=1
      .load     = 0b0001, // res=0, mode=0 (OR), en_addr=0, en_val=1
      .branch   = 0b0,    // not implemented yet
      .csr      = 0b0,    // en_csr=0
      .logic    = 0b01,   // mode=0 (OR), en=1
      .add      = 0b01,   // mode=0 (OR), en=1  <== STRICT
      .mul      = 0b01,   // mode=0 (OR), en=1
      .shift    = 0b0011, // res=0, mode=0 (OR), en_shamt=1, en=1
      .comp     = 0b01,   // mode=0 (OR), en=1
      .fpu      = 0b01,   // mode=0 (OR), en=1
      .xpulp    = 0b01,   // mode=0 (OR), en=1
      .reserved = 0
    }
  };

// standard check policy
const dift_check_pol_t check_policy_default = { .S =
    {
      .exec     = 0b1,
      .store    = 0b1,
      .load     = 0b1,
      .jalr     = 0b1,
      .branch   = 0b000,  // mode=OFF, single_mode_select=OP_A
      .reserved = 0
    }
  };



//
// GLOBAL FUNCTIONS - IMPLEMENTATION
//

// change DIFT propagation policy
void change_prop_policy(dift_prop_pol_t prop_pol)
{
  uint32_t value;

  value = prop_pol.U;

  // CSR 0x20 is DIFT TPCR
  __asm__ volatile ( "csrw 0x20, %[value_reg]"
                   :
                   : [value_reg] "r" (value) );
}


// change DIFT check policy
void change_check_policy(dift_check_pol_t check_pol)
{
  uint32_t value;

  value = check_pol.U;

  // CSR 0x21 is DIFT TCCR
  __asm__ volatile ( "csrw 0x21, %[value_reg]"
                   :
                   : [value_reg] "r" (value) );
}


dift_prop_pol_t read_prop_policy(void)
{
  uint32_t value;
  dift_prop_pol_t prop_pol_value;

  __asm__ volatile ( "csrr %[value_reg], 0x20"
                   : [value_reg] "=r" (value) );

  prop_pol_value.U = value;

  return prop_pol_value;
}



// trap handler
void __rt_illegal_instr(void)
{
  void * mepc;  // Machine Exception PC
  uint32_t mcause;  // MCAUSE
  const char * mcause_str;
  const char mcause_str_none[] = "---";
  const char mcause_str_exec[] = "EXEC";
  const char mcause_str_stor[] = "STOR";
  const char mcause_str_load[] = "LOAD";
  const char mcause_str_jalr[] = "JALR";
  const char mcause_str_bran[] = "BRAN";

  // read out MEPC
  __asm__ volatile ( "csrr %[rd], 0x341"
                   : [rd] "=r" (mepc) );

  // read out MCAUSE
  __asm__ volatile ( "csrr %[rd], 0x342"
                   : [rd] "=r" (mcause) );

  switch(mcause)
  {
    case 0x10:
      mcause_str = mcause_str_exec;
      break;

    case 0x11:
      mcause_str = mcause_str_stor;
      break;

    case 0x12:
      mcause_str = mcause_str_load;
      break;

    case 0x13:
      mcause_str = mcause_str_jalr;
      break;

    case 0x14:
      mcause_str = mcause_str_bran;
      break;

    default:
      mcause_str = mcause_str_none;
  }

  printf("ATTACK DETECTED\r\n");
  printf("  mepc:   %p\r\n", mepc);
  printf("  mcause: 0x%x (%s)\r\n", mcause, mcause_str);



  while(1);
}

