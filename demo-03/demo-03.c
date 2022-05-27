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



//
// MAIN
//

int main()
{
  dift_prop_pol_t  propagation_policy;
  dift_check_pol_t check_policy;

  uint8_t user_input;

  printf("Starting Demo-03 program...\r\n");

  // setup DIFT policies
  propagation_policy  = prop_policy_default;
  propagation_policy  = prop_policy_strict;
  //propagation_policy.S.add = 0b11;  // mode=1 (AND), en=1
  //propagation_policy.S.load = 0b0011; // res=0, mode=0 (OR), en_addr=1, en_val=1
  check_policy        = check_policy_default;
  //check_policy.S.load  = 0; // no load check
  //check_policy.S.store = 0; // no store check
  //check_policy.S.jalr  = 0; // no jalr check
  //check_policy.S.exec  = 0; // no exec check
  //check_policy.S.branch  = 0b010; // 01x = OR, (xx0 = single_mode_select -> a)
  change_prop_policy(propagation_policy);
  change_check_policy(check_policy);

  // set user input
  user_input = 2;
  set_tag_bits_mem((uint32_t *)&user_input, 1);

  // switch
  switch(user_input)
  {
    case 0:
      printf("switch - selected option 0.\r\n");
      break;
    case 1:
      printf("switch - selected option 1.\r\n");
      break;
    case 2:
      printf("switch - selected option 2.\r\n");
      break;
    case 3:
      printf("switch - selected option 3.\r\n");
      break;
    case 4:
      printf("switch - selected option 4.\r\n");
      break;
    default:
      printf("switch - not a valid option selected.\r\n");
  }

  return 0;
}
