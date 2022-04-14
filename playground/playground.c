/*
 * Copyright (C) 2018 ETH Zurich and University of Bologna
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdio.h>
#include <rt/rt_api.h>

int __rt_fpga_fc_frequency = 20000000; // e.g. 20000000 for 20MHz
int __rt_fpga_periph_frequency = 10000000; // e.g. 10000000 for 10MHz

unsigned int __rt_iodev_uart_baudrate = 115200;

int main()
{
  volatile int a, b;
  int add, sub, mul, div, mod;

  a = 30;
  b = 5;

  // change propagation policy to ONE
  __asm__( "li   x27,  0b1111111111111111111" );
  __asm__( "csrw 0x20, x27" );
  // store some tagged words, which are instructions, to memory
  __asm__( "li   x28, 0x1c001000" );  // base address
  __asm__( "li   x29, 0x00010001" );  // dummy instructions (2 NOPs)
  __asm__( "li   x30, 0xa001a001" );  // dummy instructions (2x jump to itself)
  __asm__( "sw   x29,  0 (x28)" );
  __asm__( "sw   x29,  4 (x28)" );
  // change propagation policy to ZERO
  __asm__( "li   x27,  0x0" );
  __asm__( "csrw 0x20, x27" );
  // store some more (untagged) words to memory -> they are also instructions
  __asm__( "sw   x29,  8 (x28)" );
  __asm__( "sw   x30, 12 (x28)" );
  __asm__( "nop" );
  __asm__( "nop" );
  __asm__( "nop" );
  // jump to the instructions in RAM
  __asm__( "jr x28" );
  __asm__( "nop" );
  __asm__( "nop" );

  add = a + b;
  sub = a - b;
  mul = a * b;
  div = a / b;
  mod = a % b;

  printf("add=%d sub=%d mul=%d div=%d mod=%d!\r\n", add, sub, mul, div, mod);
  return 0;
}
