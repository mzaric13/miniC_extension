
func1:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@func1_body:
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
@func1_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@func_body:
		MOV 	$1,-4(%14)
		MOV 	$5,-8(%14)
		MOV 	-4(%14),%0
		ADDS	-4(%14),-8(%14),%1
		MOV 	%1,%13
		JMP 	@func_exit
@func_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func2:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$8,%15
@func2_body:
		MOV 	$6,-4(%14)
		MOV 	$10,-8(%14)
		MOV 	-4(%14),%1
		MOV 	-4(%14),%13
		JMP 	@func2_exit
@func2_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$4,%15
@main_body:
		MOV 	$2,-4(%14)
		CALL	func2
		MOV 	%13,%2
		MOV 	%2,-4(%14)
		CALL	func
		MOV 	%13,%2
		ADDS	-4(%14),%2,%2
		MOV 	%2,%13
		PUSH	%0
		CALL	func1
		ADDS	%15,$4,%15
		PUSH	%1
		CALL	func1
		ADDS	%15,$4,%15
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET