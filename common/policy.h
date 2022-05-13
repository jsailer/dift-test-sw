// DIFT Policy
//  Functions to change the DIFT Propagation and Check Policies
// Autor:   Jakob Sailer, BSc
// created: 2021-04-25

#ifndef INCLUDE_POLICY_H_
#define INCLUDE_POLICY_H_

//
// INCLUDES
//

#include <rt/rt_api.h>



//
// TYPE DEFINITIONS
//

// tag propagation policy
typedef union
{
  uint32_t U;
  struct
  {
    uint32_t floats   : 2;
    uint32_t mul      : 2;
    uint32_t csr      : 1;
    uint32_t comp     : 2;
    uint32_t shift    : 2;
    uint32_t alu      : 2;
    uint32_t load     : 4;
    uint32_t store    : 4;
    uint32_t reserved : 13;
  } S;
} dift_prop_pol_t;

// tag check policy
typedef union
{
  uint32_t U;
  struct
  {
    uint32_t load     : 1;
    uint32_t store    : 1;
    uint32_t branch   : 3;
    uint32_t jalr     : 1;
    uint32_t exec     : 1;
    uint32_t reserved : 25;
  } S;
} dift_check_pol_t;



//
// GLOBAL VARIABLE PROTOTYPES
//
extern const dift_prop_pol_t prop_policy_default;
extern const dift_check_pol_t check_policy_default;



//
// FUNCTION PROTOTYPES
//

void change_prop_policy(dift_prop_pol_t prop_pol);
void change_check_policy(dift_check_pol_t check_pol);
dift_prop_pol_t read_prop_policy(void);



#endif // INCLUDE_POLICY_H_
