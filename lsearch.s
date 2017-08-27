
#	VARIABLE MAP			                            
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

 # if (n < 0)
	testl	%esi, %esi		
	
 # return -1
	jle	change_result		        

  # returnValue = n
	movslq	%esi, %rax		    
	
  # returnValue = A[n-1]
	leaq	-4(%rdi,%rax,4), %rax   
	
  # temp = returnValue
	movl	(%rax), %r8d	
	
  # returnValue = target
	movl	%edx, (%rax)
	
  # if (target == A[x=1])
	cmpl	(%rdi), %edx	
	
  # determine_result()
	je	zero_i	
  # A[x=1] = A[x=2] 
	addq	$4, %rdi		           
  # i = 0
	xorl	%ecx, %ecx	
	
loop:
  
  # A[x=2] = A[x=3] .. A[x=n-1]
	addq	$4, %rdi		              
   
  # i++
	addl	$1, %ecx		
	
  # while (A[x=1..n-1] != i)
	cmpl	-4(%rdi), %edx		        
	
  # int determineResult()
	jne	loop	
	
determine_result:			

  # returnValue = tmp
	movl	%r8d, (%rax)	
	
  # returnValue = n-1
	leal	-1(%rsi), %eax	
	
  # if (returnValue > i)
	cmpl	%ecx, %eax		
	
  # return i
	jg	i_is_result		          
	
  # if (temp != target)
	cmpl	%edx, %r8d
	
  # return -1
	jne	change_result		            
	rep ret
	
# int returnI()
i_is_result:		

	movl	%ecx, %eax
	ret
	
change_result:

   # int return-1()
	movl	$-1, %eax		           
	ret
	
zero_i:	

	xorl	%ecx, %ecx
	jmp	determine_result
