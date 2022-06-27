#ifndef CODEGEN_H
#define CODEGEN_H

#include "defs.h"

// funkcije za zauzimanje, oslobadjanje registra
int  take_reg(void);
void free_reg(void);
// oslobadja ako jeste indeks registra
void free_if_reg(int reg_index); 

// ispisuje simbol (u odgovarajucem obliku) 
// koji se nalazi na datom indeksu u tabeli simbola
void gen_sym_name(int index);

// generise CMP naredbu, parametri su indeksi operanada u TS-a 
void gen_cmp(int operand1_index, int operand2_index);

// generise MOV naredbu, parametri su indeksi operanada u TS-a 
void gen_mov(int input_index, int output_index);

// generisanje callback poziva sa parametrom
void generate_callback_call_parameter(int cb_idx, float arg);

// generisanje callback poziva bez parametra
void generate_callback_call_no_param(int cb_idx);

// generisanje celokupnog callback poziva
void generate_callback_call(int cb_func_idx[], float arguments[], int callback_idx);

#endif
