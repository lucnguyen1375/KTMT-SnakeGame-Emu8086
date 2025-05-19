org 100h
include emu8086.inc
          
    mov ah, 0    ; Chon h�m 0 cua INT 10h (dat che do hien thi)
    mov al, 3    ; Che do 3: Van ban 80x25, 16 mau
    int 10h      ; Goi ngat 10 cua BIOS de thuc thi    
    
start :  
    xor ax, ax        ; X�a AX
    int 1ah           ; lay so tick he thong vao cx:dx
    mov ax, dx        ; su dung dx lam gia tri ngau nhien
    
    ; sinh gia tri ngau nhien cho dl (cot) tu 1 den 79
    mov ah, 0         ; Xoa AH de tr�nh loi chia
    mov al, dl        ; lay phan thap cua dx
    mov bl, 78        ; gioi han cua gia tri toi da la 78
    div bl            ; AX / 78, du (AH) l� gi� tr? ng?u nhi�n   
    mov dl, ah        ; Luu k?t qu? v�o DL (t?a d? c?t)
    inc dl            ; �?m b?o gi� tr? t? 1 d?n 78
    
    ; Sinh gi� tr? ng?u nhi�n cho DH (h�ng), t? 1 d?n 23
    mov ah, 0         ; X�a AH d? tr�nh l?i chia
    mov al, dh        ; L?y ph?n cao c?a DX
    mov bl, 23        ; Gi?i h?n gi� tr? t?i da l� 23
    div bl            ; AX / 23, du (AH) l� gi� tr? ng?u nhi�n     
    mov dh, ah        ; Luu k?t qu? v�o DH (t?a d? h�ng)
    inc dh            ; �?m b?o gi� tr? t? 1 d?n 23
    
    ; �ua con tr? d?n v? tr� (DL, DH)
    mov bh, 0         ; Ch?n trang m�n h�nh 0
    mov ah, 02h       ; �?t con tr? t?i (DL, DH)
    int 10h
    
    ; In k� t? '@' t?i v? tr� ng?u nhi�n
    mov ah, 09h       ; L?nh in k� t?
    mov al, '@'       ; K� t? c?n in
    mov bl, 0eh       ; M�u s�ng
    mov cx, 1         ; In 1 k� t?
    int 10h  
        
     
    jmp start   
    
    ret
    
END main