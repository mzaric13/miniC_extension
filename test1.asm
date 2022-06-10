
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
		SUBS	%15,$16,%15
@func_body:
		MOV 	$1,-4(%14)
		MOV 	$2,-8(%14)
		MOV 	$3,-12(%14)
			PUSH	-4(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-4(%14)
			PUSH	-8(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-8(%14)
			PUSH	-12(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-12(%14)
		ADDS	-4(%14),-8(%14),%0
		ADDS	%0,-12(%14),%0
		MOV 	%0,-16(%14)
		MOV 	-16(%14),%13
		JMP 	@func_exit
@func_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func2:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@func2_body:
		MOV 	$10,-4(%14)
		MOV 	$100,-8(%14)
			PUSH	-4(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-4(%14)
			PUSH	-8(%14)
			CALL	func1
			ADDS	%15,$4,%15
			MOV	%13,-8(%14)
		MOV 	-4(%14),%13
		JMP 	@func2_exit
@func2_exit:
		MOV 	%14,%15
		POP 	%14
		RET
func3:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$24,%15
@func3_body:
		MOV 	$10,-4(%14)
		MOV 	$12,-24(%14)
		MOV 	$5,-16(%14)
		ADDS	-4(%14),-24(%14),%0
		ADDS	%0,-16(%14),%0
		ADDS	%0,8(%14),%0
		MOV 	%0,%13
		JMP 	@func3_exit
@func3_exit:
		MOV 	%14,%15
		POP 	%14
		RET
main:
		PUSH	%14
		MOV 	%15,%14
		SUBS	%15,$12,%15
@main_body:
		CALL	func
		MOV 	%13,%0
		MOV 	%0,-4(%14)
		CALL	func2
		MOV 	%13,%0
		MOV 	%0,-8(%14)
			PUSH	$3
		CALL	func3
			ADDS	%15,$4,%15
		MOV 	%13,%0
		MOV 	%0,-12(%14)
		ADDS	-4(%14),-8(%14),%0
		ADDS	%0,-12(%14),%0
		MOV 	%0,%13
		JMP 	@main_exit
@main_exit:
		MOV 	%14,%15
		POP 	%14
		RET