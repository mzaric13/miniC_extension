%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include <string.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int lab_num = -1;

  int array_elem_num = 0;
  int array_idx = 0;
  int arrays[100];

  int type_check_arrays = 0;
  int type_check = 0;
  int type_check_numexp[100];

  int array_decl_cnt = 0;
  int array_decl_vars[100];
  int array_decl_idx = 0;
  int arrays_decl[100];

  int is_callback = 0;
  int callback_idx = 0;
  int cb_param = 0;
  int primary_func_idx[100];
  int cb_func_idx[100];
  float arguments[100] = {[0 ... 99] = INFINITY};
  int gen_cb_idx = -1;

  FILE *output;
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _SLBRACKET
%token _SRBRACKET
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _COMMA
%token _DOT
%token _FOREACH
%token <i> _AROP
%token <i> _RELOP
%token _CALLBACK

%type <i> num_exp exp literal
%type <i> function_call argument rel_exp if_part

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
      }
  ;

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);

        code("\n%s:", $2);
        code("\n\t\tPUSH\t%%14");
        code("\n\t\tMOV \t%%15,%%14");
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
	
	callback_idx++;  
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  | _CALLBACK
	{
		set_atr1(fun_idx, 1);
		set_atr2(fun_idx, VOID);
		primary_func_idx[callback_idx] = fun_idx;
	}
  ;

body
  : _LBRACKET variable_list
      {
        if(var_num) {
		if (array_idx > 0) {
			int places = var_num;
			int i;
			for(i = 0; i < array_idx; i++) {
				places += get_atr2(arrays[i]);
			}
			places -= array_idx;
			code("\n\t\tSUBS\t%%15,$%d,%%15", 4*places);
			i = 0;
			int j = 0;
			int k = 0;
			while(i < array_decl_idx) {
				int arr_idx = get_variable_stack_position(var_num, arrays_decl[i]);
				while (j < get_atr2(arrays_decl[i]) && j + k < array_decl_cnt) {
					gen_mov(array_decl_vars[j + k], -(arr_idx + j));
					j++;
				}
				k = j;
				j = 0;
				i++;
			}
			array_decl_cnt = 0;		
		}else {
			code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
		}
	}
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
	{
		array_idx = 0;
		array_decl_idx = 0;
	}
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE _ID _SEMICOLON
      {
        if(lookup_symbol($2, VAR|PAR) == NO_INDEX)
           insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $2);
      }
  | _TYPE _ID _SLBRACKET literal _SRBRACKET _SEMICOLON
	{
		int idx = NO_INDEX;
		if (lookup_symbol($2, VAR|PAR|ARRAY) == NO_INDEX)
			idx = insert_symbol($2, ARRAY, $1, ++var_num, atoi(get_name($4))); // u atr2 - broj elemenata niza
		else
			err("redefinition of '%s'", $2);
		arrays[array_idx] = idx;
		array_idx++;
	}
  | _TYPE _ID _SLBRACKET _SRBRACKET _ASSIGN _LBRACKET literal_list _RBRACKET _SEMICOLON
	{
		int idx = NO_INDEX;
		if (lookup_symbol($2, VAR|PAR|ARRAY) == NO_INDEX)
			idx = insert_symbol($2, ARRAY, $1, ++var_num, array_elem_num); // u atr2 - broj elemenata niza
		else
			err("redefinition of '%s'", $2);
		arrays[array_idx] = idx;
		arrays_decl[array_decl_idx] = idx;
		array_decl_idx++;
		array_idx++;
		array_elem_num = 0;
	}
  ;

literal_list
  : literal
	{
		array_elem_num++;
		array_decl_vars[array_decl_cnt] = $1;
		array_decl_cnt++;
	}
  | literal_list _COMMA literal
	{
		array_elem_num++;
		array_decl_vars[array_decl_cnt] = $3;
		array_decl_cnt++;
	}
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement
  | for_each
  | callback_statement
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($3))
            err("incompatible types in assignment");
	if (get_atr1(idx) > 1 && array_idx > 0) {
		int var_pos = get_variable_stack_position(var_num, idx);
		gen_mov($3, -var_pos);
	}else 
        	gen_mov($3, idx);
	type_check = 0;
	type_check_arrays = 0;
      }
  | _ID _SLBRACKET literal _SRBRACKET _ASSIGN num_exp _SEMICOLON
	{
		int idx = lookup_symbol($1, ARRAY);
		if(idx == NO_INDEX)
			err("array %s not declared", $1);
		else
			if (get_type(idx) != get_type($6))
				err("incompatibile types in assignment");
		if (atoi(get_name($3)) >= get_atr2(idx))
			err("index out of range");
		int index_on_stack = get_stack_position_of_array_element(var_num, idx, $3);
		gen_mov($6, -index_on_stack);
		type_check = 0;
		type_check_arrays = 0;
	}
  ;

num_exp
  : exp

  | num_exp _AROP exp
      {
        int t1;   
	if (type_check_arrays == 0) {
		if(get_type($1) != get_type($3))
          		err("invalid operands: arithmetic operation");
		t1 = get_type($1);
	}else {
		int i, j;
		for (i = 0; i < type_check - 1; i++) {
			for (j = i + 1; j < type_check; j++) {
				if (get_type(type_check_numexp[i]) != get_type(type_check_numexp[j])) {
					err("types not compatibile");
					
				}
			}	
		}
		t1 = get_type(type_check_numexp[0]);
	}        
        code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
      }
  ;

exp
  : literal
	{
		type_check_numexp[type_check] = $1;
		type_check++;
	}
  | _ID
      {
	if (cb_param == 1) {
		int idx = lookup_symbol($1, FUN);
		if (idx == NO_INDEX)
			err("function undeclared: %s", $1);
		if (get_type(idx) != VOID)
			err("callback function must be void type: %s", $1);
		int i;
		for (i = 0; i < callback_idx; i++) {
			if (primary_func_idx[i] == fcall_idx) {
				cb_func_idx[i] = idx;
				gen_cb_idx = i;
				break;
			}
			
		}
		$$ = idx;
	}else {
		int idx = lookup_symbol($1, VAR|PAR);
		if(idx == NO_INDEX)
		  err("'%s' undeclared", $1);
		if (get_atr1(idx) > 1 && array_idx > 0) {
			int var_pos = get_variable_stack_position(var_num, idx);
			$$ = -var_pos;
			type_check_arrays++;
		}else {
			$$ = idx;
		}
		type_check_numexp[type_check] = idx;
		type_check++; 
	}      
      }

  | function_call
      {
        int taken_reg = take_reg();
        gen_mov(FUN_REG, taken_reg);
	if (cb_param == 1) generate_callback_call(cb_func_idx, arguments, gen_cb_idx);
	cb_param = 0;
	type_check_numexp[type_check] = taken_reg;
      	type_check++;
	$$ = taken_reg;
      }
  
  | _LPAREN num_exp _RPAREN
      { 
	type_check_numexp[type_check] = $2;
	type_check++;
	$$ = $2;
      }
  | _ID _SLBRACKET literal _SRBRACKET
	{
		int arr_idx = lookup_symbol($1, ARRAY);
		if (arr_idx == NO_INDEX)
			err("array not defined: %s", $1);
		if (atoi(get_name($3)) >= get_atr2(arr_idx))
			err("index out of range");
		int index_on_stack = get_stack_position_of_array_element(var_num, arr_idx, $3);
		$$ = -index_on_stack;
		type_check_numexp[type_check] = arr_idx;
		type_check++;
		type_check_arrays++;
	}
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
	if(get_atr2(fcall_idx) == VOID) {
		cb_param = 1;
	}
      }
    _LPAREN argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of arguments");
        code("\n\t\tCALL\t%s", get_name(fcall_idx));
        if($4 > 0 && cb_param == 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
	if (is_callback == 1) {
		int idx = $1;
		if ($1 < 0 || $1 > 13) {
			int reg = take_reg();
			gen_mov(idx, reg);
			idx = reg;
		}
		arguments[callback_idx] = idx;	
		$$ = 1;
	}else {
		if ($1 < 0) {
			int idx = get_index_from_stack_index(var_num, $1);
			if(get_atr2(fcall_idx) != get_type(idx))
				err("incompatible type for argument");
		}
		else {
			if(get_atr2(fcall_idx) != get_type($1))
				err("incompatible type for argument");
		}
		if (cb_param == 1) {
			$$ = 1;
		}else {
			free_if_reg($1);
		      	code("\n\t\tPUSH\t");
		      	gen_sym_name($1);
			$$ = 1;
		}
	}
    }
  ;

if_statement
  : if_part %prec ONLY_IF
      { code("\n@exit%d:", $1); }

  | if_part _ELSE statement
      { code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN
      {
        $<i>$ = ++lab_num;
        code("\n@if%d:", lab_num);
      }
    rel_exp
      {
        code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3);
        code("\n@true%d:", $<i>3);
      }
    _RPAREN statement
      {
        code("\n\t\tJMP \t@exit%d", $<i>3);
        code("\n@false%d:", $<i>3);
        $$ = $<i>3;
      }
  ;

rel_exp
  : num_exp 
	{
		type_check = 0;
		type_check_arrays = 0;
	}
   _RELOP num_exp
      {
	int idx1, idx2;
	if ($1 < 0)	
		idx1 = get_index_from_stack_index(var_num, $1);
	else
		idx1 = $1;
	if ($4 < 0)
		idx2 = get_index_from_stack_index(var_num, $4);
	else
		idx2 = $4;
        if(get_type(idx1) != get_type(idx2))
          err("invalid operands: relational operator");
        $$ = $3 + ((get_type(idx1) - 1) * RELOP_NUMBER);
        gen_cmp($1, $4);
	type_check = 0;
	type_check_arrays = 0;
      }
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
      {
	if ($2 < 0) {
		int idx = get_index_from_stack_index(var_num, $2);
		if (get_type(idx) != get_type(fun_idx))
			err("incompatibile types in return");
		gen_mov($2, FUN_REG);			
		code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
	} else {
		unsigned kind = get_kind($2);
		if (kind == VAR) {
			int index_on_stack = 0;
			if (get_atr1($2) > 1 && array_idx > 0) {
				index_on_stack = get_variable_stack_position(var_num, $2);
			}else {
				index_on_stack += 1;
			}
			if(get_type(fun_idx) != get_type($2))
		  		err("incompatible types in return");
			gen_mov(-index_on_stack, FUN_REG);
			code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));	
		}
		else {
			if(get_type(fun_idx) != get_type($2))
		 	 	err("incompatible types in return");
			gen_mov($2, FUN_REG);
			code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));
		}	  
	}
	type_check = 0;
	type_check_arrays = 0;    
      }
  ;

for_each
  : _ID _DOT _FOREACH _LPAREN _ID _RPAREN _SEMICOLON
	{
		int arr_idx = lookup_symbol($1, ARRAY);
		if (arr_idx == NO_INDEX)
			err("Array not defined: %s", $1);
		int func_idx = lookup_symbol($5, FUN);
		if (func_idx == NO_INDEX)
			err("Function not declared: %s", $5);
		else {
			if (get_type(func_idx) != get_type(arr_idx) || get_atr2(func_idx) != get_type(arr_idx))
				err("Types not compatibile");
			else {
				int array_pos = 1;
				if (get_atr1(arr_idx) > 1) {
					array_pos = get_variable_stack_position(var_num, arr_idx);
				}
				int i;
				for (i = 0; i < get_atr2(arr_idx); i++) {
					code("\n\t\t\tPUSH\t-%d(%%14)", (array_pos + i) * 4);
					code("\n\t\t\tCALL\t%s", get_name(func_idx));
          				code("\n\t\t\tADDS\t%%15,$4,%%15");
        				set_type(FUN_REG, get_type(func_idx));
					code("\n\t\t\tMOV\t%%13,-%d(%%14)", (array_pos + i) * 4);
				}
			}
		}
		
	}
  ;

callback_statement
  : _CALLBACK 
   	{
		is_callback = 1;
	}
   _LPAREN argument _RPAREN _SEMICOLON
	{
		is_callback = 0;
		type_check = 0;
		type_check_arrays = 0;
	}
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

