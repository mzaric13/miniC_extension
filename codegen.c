#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "codegen.h"
#include "symtab.h"


extern FILE *output;
int free_reg_num = 0;
char invalid_value[] = "???";

// REGISTERS

int take_reg(void) {
  if(free_reg_num > LAST_WORKING_REG) {
    err("Compiler error! No free registers!");
    exit(EXIT_FAILURE);
  }
  return free_reg_num++;
}

void free_reg(void) {
   if(free_reg_num < 1) {
      err("Compiler error! No more registers to free!");
      exit(EXIT_FAILURE);
   }
   else
      set_type(--free_reg_num, NO_TYPE);
}

// Ako je u pitanju indeks registra, oslobodi registar
void free_if_reg(int reg_index) {
  if(reg_index >= 0 && reg_index <= LAST_WORKING_REG)
    free_reg();
}

// SYMBOL
void gen_sym_name(int index) {
  if(index > -1) {
    if(get_kind(index) == VAR) // -n*4(%14)
      code("-%d(%%14)", get_atr1(index) * 4);
    else 
      if(get_kind(index) == PAR) // m*4(%14)
        code("%d(%%14)", 4 + get_atr1(index) *4);
      else
        if(get_kind(index) == LIT)
          code("$%s", get_name(index));
        else //function, reg
          code("%s", get_name(index));
  }else {
	code("%d(%%14)", index *4);
  }
}

// OTHER

void gen_cmp(int op1_index, int op2_index) {
  if(get_type(op1_index) == INT)
    code("\n\t\tCMPS \t");
  else
    code("\n\t\tCMPU \t");
  gen_sym_name(op1_index);
  code(",");
  gen_sym_name(op2_index);
  free_if_reg(op2_index);
  free_if_reg(op1_index);
}

void gen_mov(int input_index, int output_index) {
  code("\n\t\tMOV \t");
  gen_sym_name(input_index);
  code(",");
  gen_sym_name(output_index);

  //ako se smešta u registar, treba preneti tip 
  if(output_index >= 0 && output_index <= LAST_WORKING_REG)
    set_type(output_index, get_type(input_index));
  free_if_reg(input_index);
}

void generate_callback_call_parameter(int cb_idx, float arg) {
	//free_if_reg((int)arg);
	code("\n\t\tPUSH\t");
	gen_sym_name((int)arg);
	code("\n\t\tCALL\t%s", get_name(cb_idx));
	code("\n\t\tADDS\t%%15,$%d,%%15",  4);
}

void generate_callback_call_no_param(int cb_idx) {
	code("\n\t\tCALL\t%s", get_name(cb_idx));
}

void generate_callback_call(int cb_func_idx[], float arguments[], int gen_cb_idx) {
	if (cb_func_idx[gen_cb_idx] != 0) {
		if (get_atr1(cb_func_idx[gen_cb_idx]) == 1) {
			if (arguments[gen_cb_idx] == INFINITY)
				err("no argument for callback function");
			else {
				generate_callback_call_parameter(cb_func_idx[gen_cb_idx], arguments[gen_cb_idx]);
			}
		}else {
			if (arguments[gen_cb_idx] == INFINITY) {
				generate_callback_call_no_param(cb_func_idx[gen_cb_idx]);
			}else
				err("argument given for function without argument");
		}
	}
}

