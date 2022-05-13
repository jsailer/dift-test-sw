// Demo SW
//  Example SW demonstrating the basic functionality of the DIFT extension
// Autor:   Jakob Sailer, BSc
// created: 2021-04-14


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

// unsecure memory (used for demo)
int32_t unsecure_input[16];
uint32_t shellcode[10];



//
// PROTOTYPES
//

void vuln_jalr_numbers(int32_t* numbers);
int32_t dummy_processing(int32_t n);



//
// MAIN
//

int main()
{
  dift_prop_pol_t  propagation_policy;
  dift_check_pol_t check_policy;

  printf("Starting Demo program...\r\n");

  // setup DIFT policies
  propagation_policy  = prop_policy_default;
  check_policy        = check_policy_default;
  //check_policy.S.store = 0; // no store check
  //check_policy.S.jalr  = 0; // no jalr check
  //check_policy.S.exec  = 0; // no exec check

  change_prop_policy(propagation_policy);
  change_check_policy(check_policy);

  // setup unsecure memory used as input
  unsecure_input[0]  = 0x11;
  unsecure_input[1]  = 0x22;
  unsecure_input[2]  = 0x33;
  unsecure_input[3]  = 0x44;
  unsecure_input[4]  = 0x55;
  unsecure_input[5]  = 5; // overwriting counter variable i of vulnerable function
  unsecure_input[6]  = (int32_t) &shellcode[0];
  unsecure_input[7]  = (int32_t) &shellcode[0];
  unsecure_input[8]  = (int32_t) &shellcode[0];
  unsecure_input[9]  = (int32_t) &shellcode[0];
  unsecure_input[10] = (int32_t) &shellcode[0];
  unsecure_input[11] = (int32_t) &shellcode[0];
  unsecure_input[12] = (int32_t) &shellcode[0];
  unsecure_input[13] = (int32_t) &shellcode[0];
  unsecure_input[14] = (int32_t) &shellcode[0];
  unsecure_input[15] = 0;
  set_tag_bits_mem(unsecure_input, sizeof unsecure_input);

  // setup unsecure memory used as shellcode
  shellcode[0] = 0x00010001; // 2x NOP
  shellcode[1] = 0xa001a001; // 2x jump to itself (endless loop)
  set_tag_bits_mem(shellcode, sizeof shellcode);

  // call vulnerable function with malicious input operands
  printf("Calling vulnerable function...\r\n");
  vuln_jalr_numbers(unsecure_input);

  // simulate to do some more processing...
  dummy_processing(7);

  // finish in an endless loop
  while(1);

  return 0;
}



//
// LOCAL FUNCTION IMPLEMENTATIONS
//

// vulnerable function
//  has a local buffer (on the stack) of 5x4 bytes, but does not check the boundaries
void vuln_jalr_numbers(int32_t* numbers)
{
  uint32_t i = 0;
  int32_t  buf[5];  // can add max 5 numbers

  // read only positive numbers into buffer array (with size of only 5)
  while( *numbers != 0 )
  {
    buf[i] = *numbers; // vulnerability: no boundary check
    i++;
    numbers++;
  }

  // do some processing on the buf array

  // call any function (just so that vuln_jalr_numbers has to save the return address on the stack)
  (void) dummy_processing(5);

  return;
}


// just a dummy functions, doing some useless processing
int32_t dummy_processing(int32_t n)
{
  int32_t i, val;

  val = 7;

  for(i=1; i <= n; i++)
  {
    val = (val + i) * 2;
  }

  return val;
}



// trap handler
void __rt_illegal_instr(void)
{
  void * mepc;  // Machine Exception PC
  uint32_t mcause;  // MCAUSE

  // read out MEPC
  __asm__ volatile ( "csrr %[rd], 0x341"
                   : [rd] "=r" (mepc) );

  // read out MCAUSE
  __asm__ volatile ( "csrr %[rd], 0x342"
                   : [rd] "=r" (mcause) );

  printf("ATTACK DETECTED\r\n");
  printf("  mepc:   %p\r\n", mepc);
  printf("  mcause: 0x%x\r\n", mcause);

  while(1);
}
