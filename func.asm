section .text
global func
;arguments:
; RDI - input buffer pointer
; RSI - ouput buffer pointer
; RDX - frame size

; Variables:
; r8 - bitmap width
; r9 - bitmap heigth counter
; rbp - 8 bitmap heigth
; rbp-16 - padding
; rbp-24 - bytes to omit when jumping down
func:
        push    rbx
        push    r12
        push    r13
        push    r14
        push    r15
        push	rbp
        mov	rbp, rsp
        sub     rsp, 16
        add     rsi, 54             ; move pointer to the pixel array
; reading size

        mov     r8d, [rdi + 18] ; read width
        mov     r9d, [rdi + 22] ;  heigth
        mov     [rbp-8], r9
        add     rdi, 54


; count padding
        mov     r10, r8
        and     r10, 3
;count number of bytes in a row
        mov     r15, r8
        lea     r15, [r15 + r15*2]
        add     r15, r10

;count numbers of bytes to omit when jumping left
        mov     r13, rdx
        lea     r13, [r13, r13*2]

; count number of bytes to omit when jumping down

        mov     rcx, rdx    ; memorize rdx before mul

        mov     rax, r15
        mul     ecx
        mov     rdx, rcx
        mov     r14, rax
        mov     [rbp-16], r10 ;put padding on the stack


proceedRow:

; rbx - counter of pixels

        mov     rbx, r8        ; pixels in a row counter


proceedPixel:
; r11 - row counter
; r12 - column counter
; r13 - number of bytes to jump left
; r14 - bytes to omit when jumping down
; r15 - bytes in a row
; rax - max pixel
; rcx - current pixel

        push    rdi           ; memorize input pointer

        mov     r11, rdx    ; count number of pixels to proceed in a frame
        shl     r11, 1
        inc     r11
        mov     r12, r11


        mov     al, byte [rdi+2] ; read first pixel
        shl     eax, 16
        mov     ah, byte [rdi +1]
        mov     al, byte [rdi]


        sub     rdi, r13    ; move max left in the frame
        sub     rdi, r14    ; move max down

;check if the frame isn't out of range

        mov     eax, r9d
        add     eax, edx
        cmp     rax, [rbp-8]
        jle     checkRange1
                            ; frame is out of range - down
        sub     rax, [rbp-8]
        sub     r11d, eax

loop1: ; move up
        add     rdi, r15
        dec     eax
        jnz     loop1

checkRange1:
        mov     eax, edx
        inc     eax
        cmp     eax, r9d
        jle     checkRow  ; frame is out of range up
        sub     eax, r9d
        sub     r11d, eax



checkRow:
        mov     r12, rdx
        shl     r12, 1
        inc     r12

        mov     ecx, ebx ; frame is out of range left
        add     ecx, edx
        cmp     ecx, r8d
        jle     checkRange2

        sub     ecx, r8d
        sub     r12d, ecx
        lea     rcx, [rcx + rcx*2]
        add     rdi, rcx

checkRange2:
        mov     r10, r13

        cmp     ebx, edx
        jg      checkPixel ; frame is out of range right
        mov     ecx, edx
        sub     ecx, ebx
        inc     ecx
        sub     r12d, ecx
        lea     ecx, [ecx + ecx*2]
        sub     r10d, ecx


checkPixel:
        mov     cl, byte [rdi+2] ; read first pixel
        shl     ecx, 16
        mov     ch, byte [rdi +1]
        mov     cl, byte [rdi]
        add     rdi, 3
        cmp     al, cl              ; check B
        jae      G
        mov     al, cl
G:
        cmp     ah, ch
        jae      R
        mov     ah, ch
R:
        and     ecx, 0x00ff0000
        and     eax, 0x00ffffff
        cmp     eax, ecx
        jae     end
        and     eax, 0x0000ffff
        or      eax, ecx

end:
        dec     r12
        jnz     checkPixel

        add     rdi, r15                ; jump up
        sub     rdi, r10                ; jump left
        sub     rdi, 3
        sub     rdi, r13

        dec     r11
        jnz     checkRow

; save pixel
        mov     [rsi], al
        shr     eax, 8
        inc     rsi
        mov     [rsi], al
        shr     eax, 8
        inc     rsi
        mov     [rsi], al
        shr     eax, 8
        inc     rsi
        pop     rdi
        add     rdi, 3
        dec     rbx
        jnz     proceedPixel


        mov     eax, [rbp-16]
        test    eax, eax
        jz      endRow
padding:
        mov     [rsi], byte 0
        inc     rsi
        inc     rdi
        dec     eax
        jnz     padding
endRow:

        dec     r9
        jnz     proceedRow


        mov     rsp, rbp
        pop	rbp
        pop     r15
        pop     r14
        pop     r13
        pop     r12
        pop     rbx


        ret
