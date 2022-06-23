
func2:
		PUSH	%14
		MOV 	%15,%14
@func2_body:
		ADDS	8(%14),$2,%0
		MOV 	%0,%13
		JMP 	@func2_exit
@func2_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func1:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$36,%15
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
		MOV 	$3,-12(%14)
		MOV 	$3,-16(%14)
		MOV 	$4,-20(%14)
		MOV 	$3,-32(%14)
		MOV 	$3,-36(%14)
@func1_body:
		MOV 	$5,-28(%14)
@if0:
		CMPU 	-32(%14),$4
		JLES	@false0
@true0:
		MOV 	$10,-28(%14)
		JMP 	@exit0
@false0:
@exit0:
			PUSH	-28(%14)
		CALL	func2
			ADDS	%15,$4,%15
		MOV 	%13,%0
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