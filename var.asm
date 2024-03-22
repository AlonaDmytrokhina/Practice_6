.model small
.stack 100h

.data
count dw 100 dup(?)
line dw 100 dup(?)
substring dw ?
enterMsg db 'Enter the substring: '

.code
main proc

mov ax, @data
mov ds, ax

lea dx, enterMsg
mov ah, 09h
int 21


mov ah, 4Ch
int 21h
main endp

end main