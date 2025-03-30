include emu8086.inc
org     100h
    
    mov ah, 0    ; Chon hàm 0 cua INT 10h (dat che do hien thi)
    mov al, 3    ; Che do 3: Van ban 80x25, 16 mau
    int 10h      ; Goi ngat 10 cua BIOS de thuc thi
    
    ; in ra thong bao huong dan msg0
    mov dx, offset msg0      ; dua dia chi cua chuoi msg0 vao thanh ghi DX
    mov ah, 9                ; Chon ham 9 cua INT 21h (hien thi chuoi ky tu)
    int 21h                  ; Goi ngat 21h cua DOS de in chuoi ra man hinh
    
    ; giu nguyen thong bao man hinh cho den khi nguoi dung nhan mot phim bat ky
    mov ah, 00h ; chon ham 00h cua INT 16h(cho nhan phim)
    int 16h     ; Goi ngat 16h de doi mot phim duoc nhan   
    
    call CLEAR_SCREEN ; xoa man hinh
    
 
    ; Hien thi thong bao ve thuc an tren man hinh
    mov dx, offset msg1  ; Dua dia chi cua chuoi msg1 vao DX
    mov ah, 9            ; Chon ham 9 cua INT 21h (hien thi chuoi)
    int 21h              ; Goi ngat 21h de in ra msg1 ra man hinh

    call border ; ve tuong bao quanh

    ; astept sa inceapa jocul cand primesc orice tasta in buffer
    mov ah, 00h   ; chon ham 00h cua ngat 16h
    int 16h       ; ham nay cho den khi mot phim duoc nhan
    
    ; An con tro chuot
    CURSOROFF         
    
    ; Khoi tao dau con ran o giua man hinh
    mov dh, 12  ; row 12
    mov dl, 40  ; column 40
    mov [snake], dx   ;Luu toa do dau ran vao bien snake

game_loop:
    
    mov al, 0  ; Chon trang 0
    mov ah, 05h
    int 10h    ; Goi ngat 10h de chon trang hien thi
    
    ; Hien thi dau ran
    mov dx, [snake]  ; Lay toa do cua dau ran
    
    ; Dat con tro den vi tri dl, dh
    mov ah, 02h
    int 10h
    
    ; In ky tu '*' tai vi tri dau ran
    mov al, '*'
    mov ah, 09h
    mov bl, 0ah ; Mau ky tu
    mov cx, 1   ; In mot ky tu
    int 10h
    
    ; Lay toa do cuoi ran
    mov ax, [snake + s_size * 2 - 2]
    mov [tail], ax
    
    call move_snake   ; Di chuyen ran
    
    ; Xoa phan cuoi ran cu
    mov dx, [tail]
    
    ; Dat con tro den vi tri cuoi ran
    mov ah, 02h
    int 10h
    
    ; Xoa dau ran cu bang ky tu rong ' '
    mov al, ' '
    mov ah, 09h
    mov bl, 0ah ; Mau ky tu
    mov cx, 1   ; In mot ky tu
    int 10h
    
    check_for_key:
    ; Kiem tra xem co phim nao duoc nhan khong
    mov ah, 01h
    int 16h
    jz no_key    ; Neu khong co phim nao duoc nhan, bo qua
    
    mov ah, 00h   ; Doc phim nhan
    int 16h
    
    cmp al, 1bh    ; Kiem tra phim ESC
    je fail  ; Neu ESC duoc nhan, dung tro choi va hien thi diem
    
    mov [cur_dir], ah     ; Luu lai phim dieu huong vua nhan
    
    no_key:
    ; Cho doi mot khoang thoi gian nho truoc khi tiep tuc
    mov ah, 00h
    int 1ah
    cmp dx, [wait_time]
    jb check_for_key     ; Neu chua het thoi gian cho, tiep tuc kiem tra phim
    add dx, 4
    mov [wait_time], dx
    
     ; Vong lap chinh cua tro choi
jmp game_loop
 
 
fail:
    mov dx, offset msgover  ; Hien thi thong bao "Game Over"
    mov ah, 9
    int 21h    ; Goi ngat 21h de in chuoi ky tu
    
    mov ax, [score]  ; Lay gia tri diem hien tai
    
    call print_num ; Goi ham in diem so tu ax
    
     ; Thoat chuong trinh
    mov ah, 4Ch
    mov al, 0
    int 21h       ; Goi ngat 21h de thoat chuong trinh
 
stop_game:
    ; Hien thi lai con tro chuot
    CURSORON
 
ret     ; Tro ve chuong trinh goi no

; ------ functions ------   
; ------ functions ------
; ------ functions ------



border proc ; Ham ve khung bao quanh tro choi      
    ; Thiet lap che do van ban 
    mov ah, 0  ; Ham 0h cua ngat 10h - Chuyen doi che do man hinh  
    mov al, 3  ; Che do van ban 80x25 (Text mode 80x25) 
    int 10h    ; Goi ngat 10h de chuyen sang che do van ban   

    ; Ve duong bien tren     
    mov cx, 80   ; Chieu dai duong bien  
    mov dl, 0    ; Cot bat dau 
    mov dh, 0    ; Hang bat dau  
draw_top:
    mov ah, 02h  ; Ham 02h cua ngat 10h - Dat vi tri con tro tai (dl, dh)   
    int 10h
    mov ah, 09h  ; In ky tu tai vi tri hien tai   
    mov al, '#'  ; Ky tu ve bien 
    mov bl, 0Eh  ; Mau vang 
    mov cx, 80   ; In 80 ky tu    
    int 10h

    ; Ve duong bien duoi    
    mov cx, 80
    mov dl, 0
    mov dh, 24    ; Hang cuoi cung  
draw_bottom:
    mov ah, 02h
    int 10h
    mov ah, 09h
    mov al, '#'
    mov bl, 0Eh
    mov cx, 80
    int 10h

    ; Ve bien ben trai   
    mov dh, 1     ; Bat dau tu hang 1  
    mov dl, 0     ; Cot 0  
draw_left:
    cmp dh, 24    ; Neu da ve den hang 24 thi dung       
    jge cont1
    mov ah, 02h   ; Dat con tro tai (dl, dh) 
    int 10h
    mov ah, 09h
    mov al, '#'   ; In ky tu '#'    
    mov bl, 0Eh
    mov cx, 1     ; In 1 ky tu tai vi tri hien tai  
    int 10h
    inc dh        ; Tang hang de ve tiep duoi  
    jmp draw_left
    
    cont1:            
    ; Ve bien ben phai   
    mov dh, 1        ; Hang bat dau         
    mov dl, 79       ; Cot ben phai cuoi cung   
draw_right:
    cmp dh, 24       ; Neu da ve den hang 24 (bien duoi) thi dung ve 
    jge cont2
    mov ah, 02h      ; Dat vi tri con tro tai (dl, dh)   
    int 10h
    mov ah, 09h      ; In ky tu '#' 
    mov al, '#'     
    mov bl, 0Eh      ; Mau vang 
    mov cx, 1        ; In 1 ky tu '#' tai vi tri hien tai  
    int 10h
    inc dh           ; Tang hang len de ve tiep  
    jmp draw_right
    
    cont2:    
    ret   ; Tro ve chuong trinh goi ham   
border endp

move_snake proc

      mov   di, s_size * 2 - 2    ; di tro den vi tri cua phan cuoi cung cua ran (co dau)

      mov   cx, s_size-1    ; cx la bien dem cho vong lap, so phan tu tru cap cua ran
                            ; excludem capul 
      ; Di chuyen toan bo than ran len vi tri moi (tru cap ran)
      
      move_array:
      mov   ax, [snake + di - 2] ; Lay toa do cua phan than truoc do (phan sau dich chuyen theo)
      mov   [snake + di], ax     ; Gan gia tri nay cho vi tri hien tai
      sub   di, 2   ; Di chuyen lui 2 byte (x, y) de den phan than tiep theo
      loop  move_array   ; Lap lai cho den khi tat ca cac phan cua ran (tru cap) duoc di chuyen
      
    ; Xac dinh huong di chuyen dua tren gia tri [cur_dir] (huong hien tai cua ran)
    cmp [cur_dir], left
      je move_left
    cmp [cur_dir], right
      je move_right
    cmp [cur_dir], up
      je move_up
    cmp [cur_dir], down
      je move_down
    
    jmp stop_move       ; Neu nhan phim khac cac phim dieu huong, tro choi dung lai
                        ; con tro xuat hien cho den khi nhan lai phim dieu huong hoac ESC
    
    move_left:    ; Di chuyen cap ran sang trai
      mov   ax, [snake]  ; Lay toa do hien tai cua cap ran
      dec   al           ; Giam gia tri cot de di chuyen sang trai
      mov   [snake], ax  ; Cap nhat vi tri moi
      call check_next_character ; Kiem tra xem co an duoc moi hoac va cham tuong khong
      jmp   stop_move
    
    move_right:
      mov   ax, [snake]
      inc   al  ; Tang gia tri cot de di chuyen sang phai
      mov   [snake], ax 
      call check_next_character
      jmp   stop_move
    
    move_up:
      mov   ax, [snake]
      dec   ah  ; Giam gia tri hang de di chuyen len tren
      mov   [snake], ax 
      call check_next_character
      jmp   stop_move
    
    move_down:
      mov   ax, [snake]
      inc   ah   ; Tang gia tri hang de di chuyen xuong duoi
      mov   [snake], ax 
      call check_next_character
      jmp   stop_move
    
    stop_move:
      ret
move_snake endp

;-----------------------------------------
 
check_next_character proc 
    mov ax, [snake]      ; Lay toa do cua cap ran (cot - al, hang - ah)
    mov dh, ah           ; Luu hang vao dh de dat con tro
    mov dl, al           ; Luu cot vao dl de dat con tro
    mov bh, 0            ; Su dung trang man hinh 0
    mov ah, 02h          ; Goi interrupt de di chuyen con tro den vi tri (dl, dh)
    int 10h              ; Thuc hien interrupt 10h (hien thi man hinh)

    mov ah, 08h          ; Goi interrupt de doc ky tu tai vi tri con tro
    int 10h              ; Thuc hien interrupt 10h, ky tu doc duoc luu trong al

    cmp al, ' '          ; Kiem tra xem ky tu co phai la dau cach (ran co the di tiep)?
    je move_ok           ; Neu dung, cho phep di chuyen

    cmp al, '#'          ; Kiem tra xem ky tu co phai la tuong?
    je collision         ; Neu dung, goi ham fail (tro choi ket thuc)

    cmp al, '*'          ; Kiem tra xem ky tu co phai la mot phan cua than ran?
    je collision         ; Neu dung, goi ham fail (ran tu va cham chinh no)
    
    cmp al, '@'          ; Kiem tra xem ky tu co phai la thuc an?
    jne move_ok          ; Neu khong phai, tiep tuc di chuyen binh thuong       
    inc word ptr [score] ; Neu la thuc an, tang diem len 1 don vi 
    

move_ok:
    ret

collision:
    call fail      ; Goi ham fail de hien thi "Game Over" va dung chuong trinh
    ret
check_next_character endp



; ------ data section ------
; ------ data section ------
; ------ data section ------

    s_size  equ     7    ; Dinh nghia kich thuoc mac dinh cua ran (7 doan)
    snake dw s_size dup(0) ; Cap phat bo nho cho 7 phan tu, moi phan tu la mot tu (word - 2 byte) 
                           ; Moi doan cua ran se co 2 byte luu tru vi tri hang va cot (toa do)
    tail dw ?      ; Bien luu tru vi tri cua duoi ran
    score dw 0     ; Bien luu diem so cua nguoi choi, khoi tao = 0
    ; Ma phim cho cac phim mui ten (dung de dieu khien ran)
    left    equ     4bh    ; Mui ten trai
    right   equ     4dh    ; Mui ten phai
    up      equ     48h    ; Mui ten len
    down    equ     50h    ; Mui ten xuong
    cur_dir db      right ; Bien luu huong di chuyen hien tai cua ran (mac dinh la sang phai)
    wait_time dw    0     ; Bien dung de dieu chinh toc do di chuyen cua ran
    
    msg1 db "                                                                  ", 0dh, 0ah
      db "             @         #     @             @         #                ", 0dh, 0ah
      db "                   @                   @                   @       ", 0dh, 0ah
      db "      @     @                 @                                    ", 0dh, 0ah
      db "   @                                         @       @              ", 0dh, 0ah
      db "                @          @                                       ", 0dh, 0ah
      db "                                      @                         ", 0dh, 0ah
      db "         @                        @           @                  ", 0dh, 0ah
      db "      @                  #                                  @      ", 0dh, 0ah
      db "                                                              ", 0dh, 0ah
      db "       #        @                           @      #     @         ", 0dh, 0ah
      db "                         @                                     ", 0dh, 0ah
      db "   @                              @                             ", 0dh, 0ah
      db "             #                                          @       ", 0dh, 0ah
      db "                                           @                   ", 0dh, 0ah
      db "         @             @          @                            ", 0dh, 0ah
      db "    @                        @                        @         ", 0dh, 0ah
      db "                @                       #         @              ", 0dh, 0ah
      db "                                                              ", 0dh, 0ah
      db "         @             @         @                     @        @   ", 0dh, 0ah
      db "   @             @                       @                   @   ", 0dh, 0ah
      db "            #                                #                 ", 0dh, 0ah
      db "       @                                  @          @         @  ", 0dh, 0ah
      db "   @             @       @          @                              ", 0dh, 0ah
      db "                                                                   $"

         
     msgover db "Game Over! Your score is: $" 
     
     msg0 db "                                                         ", 0dh,0ah    
        db "  ================== @GAME CONTROLS ====================   ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  Use the arrow keys to control the snake's direction.     ", 0dh,0ah
        db "  @UP    - Move the snake upwards                          ", 0dh,0ah
        db "  @DOWN  - Move the snake downwards                        ", 0dh,0ah
        db "  @LEFT  - Move the snake to the left                      ", 0dh,0ah
        db "  @RIGHT - Move the snake to the right                     ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  @Press ESC at any time to exit the game.                 ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  ================== @HOW TO WIN ======================    ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  Your goal is to collect as much food as possible.        ", 0dh,0ah
        db "  Each food item is represented by '@'.                    ", 0dh,0ah
        db "  Each '@' is 1 point for the final score.                 ", 0dh,0ah
        db "  DO NOT crash into the obstacles marked with '#'          ", 0dh,0ah
        db "  Be careful not to crash into the walls or yourself!      ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  =================== @START NOW =====================     ", 0dh,0ah
        db "                                                           ", 0dh,0ah
        db "  Press @ANY KEY to begin your Snake adventure...          ", 0dh,0ah
        db "  After the border are drawed, press any key to start      ", 0dh,0ah
        db "  =====================================================    $"

     
     DEFINE_PRINT_NUM 
     DEFINE_PRINT_NUM_UNS   
     DEFINE_CLEAR_SCREEN
     
     end  