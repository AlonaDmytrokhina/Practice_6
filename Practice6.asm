IDEAL
MODEL small
STACK 100h

DATASEG
    oneChar DB ?

CODESEG

start:
    mov ax, @data
    mov ds, ax

read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next

exit_program:
    mov ah, 4Ch           ; Функція для завершення програми
    int 21h               ; Виклик системного виклику

END start