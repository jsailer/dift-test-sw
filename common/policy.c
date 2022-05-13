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
      .floats   = 0b01,   // OR
      .mul      = 0b01,   // OR
      .csr      = 0b0,    // ZERO
      .comp     = 0b00,   // ZERO
      .shift    = 0b01,   // OR
      .alu      = 0b01,   // OR
      .load     = 0b1001, // val=1, addr=0, pol=OR
      .store    = 0b1001, // val=1, addr=0, pol=OR
      .reserved = 0
    }
  };

// standard check policy
const dift_check_pol_t check_policy_default = { .S =
    {
      .load     = 0b1,
      .store    = 0b1,
      .branch   = 0b000,  // mode=OFF, single_mode_select=OP_A
      .jalr     = 0b1,
      .exec     = 0b1,
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
