// Tag Bits
//  Functions to manually manipulate and read out the tag bits of registers/memory regions
// Autor:   Jakob Sailer, BSc
// created: 2021-04-24

#ifndef INCLUDE_TAG_BITS_H_
#define INCLUDE_TAG_BITS_H_

//
// INCLUDES
//

#include <rt/rt_api.h>



//
// PROTOTYPES
//

void write_tag_bits_mem(uint32_t * addr, uint32_t bytes, unsigned char tag_value);
void set_tag_bits_mem(uint32_t * addr, uint32_t bytes);
void clear_tag_bits_mem(uint32_t * addr, uint32_t bytes);
uint8_t read_tag_bits_mem(uint32_t * addr);



#endif // INCLUDE_TAG_BITS_H_
