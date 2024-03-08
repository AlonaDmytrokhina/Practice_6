.model small
.stack 100h

.data
array dw 10*20 dup(?)

.code
main proc

mov ax, @data
mov ds, ax


mov ah, 4Ch
int 21h
main endp

end main