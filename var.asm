.model small
.stack 100h
.data
    Buffer db 255 dup(?), '$'
    SubStrg db 255 dup(?), 'aaa$'
    FileName db "test.in", 0
    FileHandle dw ?
    SubStrLength db 0
    FoundFlag db 0          ; Флаг для позначення знаходження підстрічки
    Counts db 255 dup(0)   ; Масив для зберігання кількості підстрічок у кожній строці
    FileOpenErrorMsg db 'Error opening file.', 0Dh, 0Ah, '$'
    FileOpenSuccessMsg db 'File opened successfully.', 0Dh, 0Ah, '$'
    SubstrNotFoundMsg db 'Substring not found in file.', 0Dh, 0Ah, '$'

.code
start:
    mov ax, @data
    mov ds, ax

    ; Отримання підстрічки від користувача
    lea dx, SubStrg
    mov ah, 0Ah
    int 21h
    mov SubStrLength, 4    ; Зберігаємо довжину підстрічки

    ; Відкриття файлу 
    mov ah, 3Dh 
    mov al, 0              ; Режим читання 
    lea dx, FileName 
    int 21h  
    jnc FileOpened         ; Перевірка на успішне відкриття файлу
    jmp FileOpenError      ; Якщо файл не відкрито, переходимо до обробки помилки

FileOpened:
    mov FileHandle, ax    ; Зберігаємо дескриптор файлу
    ; Виведення повідомлення про успішне відкриття файлу
    mov ah, 09h
    lea dx, FileOpenSuccessMsg
    int 21h
    jmp ContinueProgram

FileOpenError:
    ; Виведення повідомлення про помилку відкриття файлу
    mov ah, 09h
    lea dx, FileOpenErrorMsg
    int 21h

ContinueProgram:

    ; Пошук підстрічки у файлі
    mov FileHandle, 0    ; Очищення FileHandle
    call FindSubStrInFile

    ; Закриття файлу
    mov ah, 3Eh
    mov bx, FileHandle
    int 21h

    ; Виведення результату
    cmp FoundFlag, 1
    jnz PrintError        ; Вивести повідомлення про помилку, якщо підстрічка не знайдена

    mov cl, Counts[bx]   ; Завантаження кількості знайдених підстрічок у регістр cx
    ;call PrintIndexAndCount

ExitProgram:
    mov ax, 4C00h        ; Код завершення програми
    int 21h

PrintError:
    ; Виведення повідомлення про помилку
    mov ah, 09h
    lea dx, SubstrNotFoundMsg
    int 21h
    jmp ExitProgram

;==================================================================================================================
FindSubStrInFile proc
    mov bx, FileHandle
    mov cl, 0             ; Зануляємо лічильник строк

ReadNextLine:
    mov ah, 3Fh
    lea dx, Buffer
    mov cl, 255
    int 21h
    or ax, ax
    jz DoneReading
    call FindSubString
    call CountSubStrInLine
    call PrintIndexAndCount
    mov Counts[bx], cl    ; Зберігаємо кількість підстрічок у масив
    inc bx                ; Збільшуємо індекс масиву
    or ax,ax
    jnz ReadNextLine

DoneReading:
    ret

FindSubStrInFile endp

;==================================================================================================================
FindSubString proc
    mov si, 0          ; Індекс у Buffer
    mov di, 0          ; Індекс у SubStr

SearchLoop: 
    mov al, [Buffer+si] ; Взяти символ з Buffer
    cmp al, [SubStrg+di] ; Порівняти з символом у SubStr
    je CompareNext      ; Якщо символи однакові, продовжити порівняння
    jne NextChar        ; Якщо ні, перейти до наступного символу
    inc si
    jmp SearchLoop

CompareNext:
    inc si
    inc di
    cmp byte ptr [SubStrg+di], '$' ; Чи досягнуто кінця підстрічки?
    je FoundSubStr
    jmp SearchLoop

NextChar:
    inc si
    xor di, di        ; Скинути індекс у SubStr
    jmp SearchLoop

FoundSubStr:
    mov FoundFlag, 1
    ret

FindSubString endp

;==================================================================================================================
CountSubStrInLine PROC
    mov cl, 0             ; Зануляємо регістр для лічильника підстрічок у рядку
    mov si, 0             ; Ініціалізуємо індекс у Buffer
    mov di, 0             ; Ініціалізуємо індекс у SubStr

CountLoop:
    mov al, [Buffer+si]   ; Взяти символ з Buffer
    cmp al, [SubStrg+di]  ; Порівняти з символом у SubStr
    je CompareNextCount   ; Якщо символи однакові, продовжити порівняння
    jne NextCharCount     ; Якщо ні, перейти до наступного символу
    inc si
    jmp CheckEndOfLine

CompareNextCount:
    inc si
    inc di
    cmp byte ptr [SubStrg+di], '$' ; Чи досягнуто кінця підстрічки?
    je FoundSubStrCount
    jmp CheckEndOfLine

NextCharCount:
    inc si
    xor di, di          ; Скинути індекс у SubStr
    jmp CheckEndOfLine

FoundSubStrCount:
    inc cl               ; Якщо підстрічка знайдена, збільшити лічильник

CheckEndOfLine:
    mov al, [Buffer+si]   ; Перевірка кінця рядка
    cmp al, '$'
    jne CountLoop

EndOfLine:
    mov Counts[bx], cl  ; Збільшуємо кількість підстрічок у рядку в пам'яті
    ret

CountSubStrInLine ENDP

;==================================================================================================================
PrintIndexAndCount proc
    mov ah, 02h            ; Вивід номеру строки
    mov dl, '0'            ; Початок номера строки
    add dl, bl             ; Додавання номера строки
    int 21h

    mov ah, 02h            ; Вивід пробілу
    mov dl, ' '            
    int 21h

    mov ah, 02h            ; Вивід кількості підстрічок у строці
    mov dl, cl             ; Завантаження кількості підстрічок
    add dl, '0'            ; Перетворення у ASCII-код
    int 21h

    ret
PrintIndexAndCount endp

;==================================================================================================================

BubbleSort proc
    mov cx, 255   ; Завантаження кількості елементів у буфері (255 - максимальна довжина буфера)
    dec cx        ; Зменшення на 1
    mov si, 0     ; Початковий індекс

OuterLoop:
    mov di, si          ; Збереження початкового значення si
    mov bx, 255         ; Завантаження максимальної довжини масиву
    sub bx, si          ; Вирахування кількості порівнянь для поточного елементу
    dec bx              ; Зменшення на 1, бо ми порівнюємо з наступним елементом
    jz EndOuterLoop     ; Якщо bx=0, закінчити зовнішній цикл

    mov dx, di          ; Збереження значення di для використання його під час внутрішнього циклу

InnerLoop:
    mov al, [Buffer+si] ; Завантаження поточного елементу
    mov ah, [Buffer+si+1] ; Завантаження наступного елементу
    cmp al, ah          ; Порівняння поточного та наступного елементів
    jle SkipSwap        ; Якщо поточний елемент менший або рівний, пропустити обмін
    xchg al, ah         ; Обмін елементів
    mov [Buffer+si], al ; Збереження поточного елементу
    mov [Buffer+si+1], ah ; Збереження наступного елементу
SkipSwap:
    inc si              ; Збільшення індексу для наступного елементу
    loop InnerLoop      ; Повторення внутрішнього циклу

    inc di              ; Збільшення індексу для наступного елементу
    loop OuterLoop      ; Повторення зовнішнього циклу

EndOuterLoop:
    ret
BubbleSort endp

;==================================================================================================================
ErrorMsg db "Error: Unable to open or read file", '$'

end start
