
func:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$24,%15
@func_body:
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
		MOV 	$0,%13
		JMP 	@func_exit
@func_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
@main_body:
		MOV 	$0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET