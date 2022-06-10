
func1:
		PUSH	%14
		MOV 	%15,%14
@func1_body:
		ADDS	8(%14),$3,%0
		MOV 	%0,%13
		JMP 	@func1_exit
@func1_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$24,%15
@func_body:
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
		MOV 	$3,-12(%14)
		@element0:
			PUSH	-4(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-4(%14)
		@element1:
			PUSH	-8(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-8(%14)
		@element2:
			PUSH	-12(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-12(%14)
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