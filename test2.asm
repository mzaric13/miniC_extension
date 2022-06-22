
func1:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$32,%15
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
		MOV 	$3,-12(%14)
		MOV 	$3,-16(%14)
		MOV 	$4,-20(%14)
		MOV 	$3,-28(%14)
		MOV 	$3,-32(%14)
@func1_body:
		ADDS	-4(%14),-8(%14),%0
		ADDS	%0,-28(%14),%0
		MOV 	%0,%13
		JMP 	@func1_exit
@func1_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
@main_body:
		CALL	func1
		MOV 	%13,%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET