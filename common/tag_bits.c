// Tag Bits
//  Functions to manually manipulate and read out the tag bits of registers/memory regions
// Autor:   Jakob Sailer, BSc
// created: 2021-04-24


//
// INCLUDES
//

#include "../common/tag_bits.h"



//
// GLOBAL FUNCTIONS - IMPLEMENTATIONS
//

// write tag bits for the passed memory range
void write_tag_bits_mem(uint32_t * addr, uint32_t bytes, uint8_t tag_value)
{
  uint32_t i;
  uint32_t words;

  // input sanitizing of tag_value (only last 4 bits are used and may be set)
  tag_value &= 0xf;

  // TODO: save prop policy
  // TODO: change prop policy to "normal" propagation

  words = bytes/4;
  bytes = bytes - (words*4);

  for(i = 0; i < words; i++)
  {
    uint32_t data;

    // read word
    data = *(addr);

    // set tag bits
    __asm__ volatile ( "tagset %[data_reg], %[tag_val_reg], 0x00f"
                     : [data_reg]    "+r" (data)
                     : [tag_val_reg] "r"  (tag_value << 4) );

    // store word
    *(addr) = data;

    // increment address (increments by 4)
    addr++;
  }

  // TODO: handle spilling bytes

  // TODO: restore saved prop policy
}


// set tag bits to 1 for the passed memory range
void set_tag_bits_mem(uint32_t * addr, uint32_t bytes)
{
  write_tag_bits_mem(addr, bytes, 0x0f);
}


// set tag bits to 0 for the passed memory range
void clear_tag_bits_mem(uint32_t * addr, uint32_t bytes)
{
  write_tag_bits_mem(addr, bytes, 0x00);
}


// read out the tag bits of a word in memory
uint8_t read_tag_bits_mem(uint32_t * addr)
{
  uint32_t data;
  uint32_t tag_bits;

  // TODO: save prop policy
  // TODO: change prop policy to "normal" propagation

  // read word
  data = *(addr);

  // read out tag bits
  __asm__ volatile ( "tagrd %[tag_val_reg], %[data_reg], 0x00f"
                   : [tag_val_reg] "=r" (tag_bits)
                   : [data_reg]    "r"  (data) );

  // TODO: restore saved prop policy

  return ((uint8_t) tag_bits);
}
