// Tag Bits
//  Functions to manually manipulate and read out the tag bits of registers/memory regions
// Autor:   Jakob Sailer, BSc
// created: 2021-04-24


//
// INCLUDES
//

#include "../common/tag_bits.h"

#ifdef SIM
  #define STR_NL "\n"
#else
  #define STR_NL "\r\n"
#endif



//
// GLOBAL FUNCTIONS - IMPLEMENTATIONS
//

// write tag bits for the passed memory range
void write_tag_bits_mem(uint32_t * addr, uint32_t bytes, uint8_t tag_value)
{
  uint32_t i;
  uint32_t words;
  uint32_t data;

  // input sanitizing of tag_value (only last 4 bits are used and may be set)
  tag_value &= 0xf;

  // TODO: save prop policy
  // TODO: change prop policy to "normal" propagation

  words = bytes/4;
  bytes = bytes - (words*4);

  for(i = 0; i < words; i++)
  {
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

  // handle spilling bytes
  if(bytes > 0)
  {
    // read word
    data = *(addr);

    // set tag bits
    __asm__ volatile ( "tagset %[data_reg], %[tag_val_mask_reg], 0x000"
                     : [data_reg]         "+r" (data)
                     : [tag_val_mask_reg] "r"  ((tag_value << 4) | ((1 << bytes)-1)) );

    // store word
    *(addr) = data;
  }


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



void print_mem(void * start_addr, uint32_t num_words)
{
  uint32_t word = 0;
  uint32_t data;
  uint8_t  tag;

  printf("MEM DUMP:" STR_NL);
  //printf("  start addr: %p\n", start_addr);

  // always start printing with a 16-byte aligned address
  start_addr = (void *) ((uint32_t)start_addr & 0xfffffff0);
  printf("  start addr: %p" STR_NL, start_addr);

  // read mem and tag bits
  for( word = num_words; word > 0; word-- )
  {
    uint32_t * read_addr = ((uint32_t *)start_addr) + word;

    // read values
    data = *read_addr;
    tag  = read_tag_bits_mem(read_addr);

    // print values
    printf("%p: 0x%08X_%X" STR_NL, read_addr, data, tag);
  }
}

void print_stack_frame(void * frame_ptr_s0, void * stack_ptr_sp)
{
  uint32_t frame_size;
  uint32_t word_num;

  // calculate frame size
  frame_size = frame_ptr_s0 - stack_ptr_sp;
  word_num = frame_size >> 2;

  printf("STACK FRAME DUMP" STR_NL);
  printf("  fp/s0/x8: %p" STR_NL, frame_ptr_s0);
  printf("     sp/x2: %p" STR_NL, stack_ptr_sp);
  printf("   fr size: %d B / 0x%x B  (%d words / 0x%x words)" STR_NL, frame_size, frame_size, word_num, word_num);

  print_mem(stack_ptr_sp, word_num);
}
