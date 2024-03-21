.model small
.stack 100h

.data 
                                      
   dispMsg db 'Substring: $'
   lenDispMsg equ $-dispMsg                 
   buffer db 255 dup(?)  

.code          
start:
   mov ax, @data
   mov ds, ax  

   mov si, offset buffer  
   mov cx, 255            

read_loop:
   mov ah, 01h            
   int 21h 
   cmp al, 0Dh            
   je end_input           
   mov [si], al           
   inc si                 
   loop read_loop         

end_input:
   mov byte ptr [si], '$' 
   lea dx, dispMsg
   mov ah, 09h
   int 21h

   lea dx, buffer         
   int 21h
    
   ; Exit code
exit_program:
    mov ah, 4Ch          
    int 21h              

end start