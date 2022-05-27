// Demo SW
//  Non-control-data attack example (selecting a control path)
//  via direct buffer overlfow attack on the stack
// Autor:   Jakob Sailer, BSc
// created: 2021-05-14


//
// INCLUDES
//
#include <stdio.h>
#include <rt/rt_api.h>

#include "../common/policy.h"
#include "../common/tag_bits.h"



//
// GLOBAL DATA
//

// RT variables
int __rt_fpga_fc_frequency = 20000000; // e.g. 20000000 for 20MHz
int __rt_fpga_periph_frequency = 10000000; // e.g. 10000000 for 10MHz
unsigned int __rt_iodev_uart_baudrate = 115200;

// vulnerable buffer
char    vuln_buffer[8] = "";
// attack target
uint8_t authenticated  = 0;



//
// PROTOTYPES
//



//
// MAIN
//

int main()
{
  dift_prop_pol_t  propagation_policy;
  dift_check_pol_t check_policy;

  printf("Starting Demo-02 program...\r\n");

  // setup DIFT policies
  propagation_policy  = prop_policy_default;
  propagation_policy  = prop_policy_strict;
  check_policy        = check_policy_default;

  //check_policy.S.store = 0; // no store check
  //check_policy.S.jalr  = 0; // no jalr check
  //check_policy.S.exec  = 0; // no exec check
  //check_policy.S.branch  = 0b010; // 01x = OR, (xx0 = single_mode_select -> a)

  change_prop_policy(propagation_policy);
  change_check_policy(check_policy);

  // user is not authenticated
  authenticated = 0;

  // setup unsecure memory used as input
  //char unsecure_input [20] = "abcdefg\x001\x001\x001\x001";
  char unsecure_input [20] = "abc";
  set_tag_bits_mem((uint32_t *)unsecure_input, sizeof unsecure_input);

  // call unsafe memcpy function with tainted (malicious) input data
  strcpy(vuln_buffer, unsecure_input);

  // Check if the user is authenticated and print accordingly
  if(authenticated == 1)
  {
    printf("AUTHENTICATED: You have all rights!\r\n");
  }
  else
  {
    printf("not authenticated: You have no rights.\r\n");
  }

  // finish in an endless loop
  while(1);

  return 0;
}
