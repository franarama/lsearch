
#		      VARIABLE MAP			                            
#							                                          
#	%esi - int n					                                
#	%rax - int result				                              
#	%rdi - int *A					                                
#	%rcx - int i					                                
# 	%edx - int target				                             
#	%r8d - temporary register, int tmp		                
#							                                          


	.globl	lsearch_2

lsearch_2:
	testl	%esi, %esi		            # if (n < 0)
	jle	change_result		            # return -1
	movslq	%esi, %rax		          # returnValue = n
	leaq	-4(%rdi,%rax,4), %rax     # returnValue = A[n-1]
	movl	(%rax), %r8d		          # temp = returnValue
	movl	%edx, (%rax)		          # returnValue = target
	cmpl	(%rdi), %edx		          # if (target == A[x=1])
	je	zero_i			                # determine_result()
	addq	$4, %rdi		              # A[x=1] = A[x=2] 
	xorl	%ecx, %ecx		            # i = 0
loop:
	addq	$4, %rdi		              # A[x=2] = A[x=3] .. A[x=n-1]
	addl	$1, %ecx		              # i++
	cmpl	-4(%rdi), %edx		        # while (A[x=1..n-1] != i)
	jne	loop			    
determine_result:			            # int determineResult()
	movl	%r8d, (%rax)		          # returnValue = tmp
	leal	-1(%rsi), %eax		        # returnValue = n-1
	cmpl	%ecx, %eax		            # if (returnValue > i)
	jg	i_is_result		              # return i
	cmpl	%edx, %r8d		            # if (temp != target)
	jne	change_result		            # return -1
	rep ret
i_is_result:				              # int returnI()
	movl	%ecx, %eax
	ret
change_result:
	movl	$-1, %eax		              # int return-1()
	ret
zero_i:			
	xorl	%ecx, %ecx
	jmp	determine_result
