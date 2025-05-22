.model small
.stack 200h
.data           

msgMainScreen db "============================= SNAKE GAME PROJECT ==============================", 0dh,0ah
              db "======================= COMPUTER ARCHITECTURE PROJECT =========================", 0dh,0ah
              db "                                                           ", 0dh,0ah
              db "                                  TEAM 09                            ", 0dh,0ah
              db "                                                           ", 0dh,0ah
              db "================================ HOW TO PLAY ==================================", 0dh,0ah
              db "  Use arrow keys to control the snake:                     ", 0dh,0ah
              db "     [^] - Move Up                                        ", 0dh,0ah
              db "     [v] - Move Down                                      ", 0dh,0ah
              db "     [<] - Move Left                                      ", 0dh,0ah
              db "     [>] - Move Right                                     ", 0dh,0ah
              db "     [ESC] - Exit Game                                    ", 0dh,0ah
              db "                                                           ", 0dh,0ah
              db "================================ GAME RULES ====================================", 0dh,0ah
              db "  * Collect food (@) to grow longer and score points      ", 0dh,0ah
              db "  * Each food item gives you 1 point                      ", 0dh,0ah
              db "  * Don't hit the walls or yourself!                      ", 0dh,0ah
              db "  * Try to get the highest score possible                 ", 0dh,0ah
              db "                                                           ", 0dh,0ah
              db "================================= START GAME ===================================", 0dh,0ah
              db "  Press any key to start your Snake adventure...          ", 0dh,0ah
              db "                                                           ", 0dh,0ah
              db " ==============================================================================$"

msgLevelSelect  db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "=========================== SELECT DIFFICULTY LEVEL ============================", 0dh, 0ah
                db "                               [1] EASY MODE                                ", 0dh, 0ah
                db "                       Only border walls, no barriers                       ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                               [2] MEDIUM MODE                              ", 0dh, 0ah
                db "                       Border walls + Simple barriers                       ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                               [3] HARD MODE                                ", 0dh, 0ah
                db "                       Border walls + Cross barriers                        ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                                                                            ", 0dh, 0ah
                db "                    Press 1, 2 or 3 to select your level...                 ", 0dh, 0ah
                db "================================================================================$"
    
    msgover db "Game Over! Your score is: $" 
    msgPlayAgain db "Do you want to play again?$"
    msgYN db "Press Y (Yes) or N (No)!$"
     
    s_max_size equ 2000
    s_size  dw  3    ; Dinh nghia kich thuoc mac dinh cua ran (7 doan)
    snake dw s_max_size dup(0) ; Cap phat bo nho cho 7 phan tu, moi phan tu la mot tu (word - 2 byte) 
                           ; Moi doan cua ran se co 2 byte luu tru vi tri hang va cot (toa do)
    tail dw ?      ; Bien luu tru vi tri cua duoi ran
    score dw 0     ; Bien luu diem so cua nguoi choi, khoi tao = 0     
    
    row_random db 0 ; bien luu hang ngau nhien
    col_random db 0 ; bien luu cot ngau nhien  
    
    ; Ma phim cho cac phim mui ten (dung de dieu khien ran)
    left    equ     4bh    ; Mui ten trai
    right   equ     4dh    ; Mui ten phai
    up      equ     48h    ; Mui ten len
    down    equ     50h    ; Mui ten xuong
    cur_dir db      right ; Bien luu huong di chuyen hien tai cua ran (mac dinh la sang phai)
    wait_time dw    0     ; Bien dung de dieu chinh toc do di chuyen cua ran
  
.code 
main proc
    push ax
    push bx
    push cx
    push dx 
    mov ax, @data
    mov ds, ax
        
    mov ah, 0    ; Chon ham 0 cua INT 10h (dat che do hien thi)
    mov al, 3    ; Che do 3: Van ban 80x25, 16 mau
    int 10h      ; Goi ngat 10 cua BIOS de thuc thi  
                    
            
                    
    ; in ra thong bao huong dan msgMainScreen
    mov dx, offset msgMainScreen      ; dua dia chi cua chuoi msgMainScreen vao thanh ghi DX
    mov ah, 9                ; Chon ham 9 cua INT 21h (hien thi chuoi ky tu)
    int 21h                  ; Goi ngat 21h cua DOS de in chuoi ra man hinh
           
    ; giu nguyen thong bao man hinh cho den khi nguoi dung nhan mot phim bat ky
    mov ah, 00h ; chon ham 00h cua INT 16h(cho nhan phim)
    int 16h     ; Goi ngat 16h de doi mot phim duoc nhan            
                 
    call clear_screen 

  ; Hiển thị menu chọn level
    mov dx, offset msgLevelSelect
    mov ah, 9
    int 21h
    
  select_level:
    mov ah, 00h     ; Đợi phím
    int 16h
  
    
    cmp al, '1'     ; Level 1 - Easy
    je level_1
    cmp al, '2'     ; Level 2 - Medium
    je level_2
    cmp al, '3'     ; Level 3 - Hard
    je level_3
    jmp select_level ; Nếu không phải 1,2,3 thì đợi tiếp
    
  level_1:
    call clear_screen
    call border
    jmp start_game
    
  level_2:
    call clear_screen
    call border
    call barrier_lv2
    jmp start_game
    
  level_3:
    call clear_screen
    call border
    call barrier_lv3
    jmp start_game

    ; Hien thi thong bao ve thuc an tren man hinh
    ;mov dx, offset msg1  ; Dua dia chi cua chuoi msg1 vao DX
    ;mov ah, 9            ; Chon ham 9 cua INT 21h (hien thi chuoi)
    ;int 21h              ; Goi ngat 21h de in ra msg1 ra man hinh         
               
    call border          ; Ve tuong xung quanh    
    call barrier_lv3
  start_game:
    call hide_cursor
    call draw_random_food 
    
    ; Cho den khi nguoi choi nhan mot phim bat ky de bat dau tro choi
    mov ah, 00h   ; chon ham 00h cua ngat 16h
    int 16h       ; ham nay cho den khi mot phim duoc nhan 
    
    mov ax, 2   ; Chon ham 2 de an con tro chuot
    int 33h     
    
    ; Khoi tao dau con ran o giua man hinh
    mov dh, 12  ; row 12
    mov dl, 40  ; column 40
    mov [snake], dx   ;Luu toa do dau ran vao bien snake  
    
  game_loop:
    
    mov al, 0  ; Chon trang 0
    mov ah, 05h   ; ham 05h cua ngat 10h dung de chon trang hien thi
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
    
    ; Lay toa do duoi ran
    mov bx, [s_size]     ; Lấy giá trị s_size hiện tại
    shl bx, 1           ; Nhân 2 (s_size * 2)
    sub bx, 2           ; Trừ 2 để lấy vị trí cuối
    mov ax, [snake + bx] ; Lấy giá trị tại vị trí cuối
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
    push ax
    push bx
    push cx
    push dx
    call clear_screen
    call border
    
    ; In Game Over và điểm số ở giữa màn hình
    mov dh, 10          ; Hàng 10
    mov dl, 25          ; Cột 25
    mov bh, 0           
    mov ah, 02h         
    int 10h
    
    mov dx, offset msgover
    mov ah, 09h
    int 21h
    
    mov ax, [score]
    call print_num
    
    ; In thông báo Play Again
    mov dh, 12          ; Hàng 12
    mov dl, 25
    mov ah, 02h
    int 10h
    
    mov dx, offset msgPlayAgain
    mov ah, 09h
    int 21h
    
    ; In thông báo Y/N
    mov dh, 14          ; Hàng 14
    mov dl, 25
    mov ah, 02h
    int 10h
    
    mov dx, offset msgYN
    mov ah, 09h
    int 21h


    wait_key:
    mov ah, 00h         ; Đợi phím
    int 16h
    
    cmp al, 'Y'         ; Kiểm tra Y
    je restart_game
    cmp al, 'y'         ; Kiểm tra y
    je restart_game
    cmp al, 'N'         ; Kiểm tra N
    je exit_game
    cmp al, 'n'         ; Kiểm tra n
    je exit_game
    jmp wait_key        ; Nếu không phải Y/N thì đợi tiếp
    
restart_game:
    ; Reset các biến
    mov word ptr [score], 0    ; Reset điểm
    mov word ptr [s_size], 3   ; Reset kích thước rắn
    mov word ptr [cur_dir], 0  ; Reset hướng
    call clear_screen
    jmp main                   ; Quay lại main để bắt đầu game mới
    
exit_game:
    mov ah, 4Ch
    mov al, 0
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret

  pop dx
  pop cx
  pop bx
  pop ax
main endp       

;----------------------------------------------------------------------------------------------
border proc
    push ax
    push bx
    push cx
    push dx
    ; Thiết lập chế độ văn bản
    mov ah, 0
    mov al, 3
    int 10h
    
    mov al, ' '
    ; Vẽ viền trên
    mov ah, 06h    ; Scroll up function
    mov al, 0      ; Clear
    mov bh, 7Fh    ; Thuộc tính màu (nền trắng)
    mov ch, 0      ; Hàng đầu
    mov cl, 0      ; Cột đầu
    mov dh, 0      ; Hàng cuối
    mov dl, 79     ; Cột cuối
    int 10h
    
    ; Vẽ viền dưới
    mov ch, 24     ; Hàng đầu
    mov dh, 24     ; Hàng cuối
    int 10h
    
    ; Vẽ viền trái
    mov ch, 0      ; Hàng đầu
    mov cl, 0      ; Cột đầu
    mov dh, 24     ; Hàng cuối
    mov dl, 0      ; Cột cuối
    int 10h
    
    ; Vẽ viền phải
    mov cl, 79     ; Cột đầu
    mov dl, 79     ; Cột cuối
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
border endp     
;----------------------------------------------------------------------------------------------

barrier_lv2 proc
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 06h        ; Scroll up function
    mov al, 0          ; Clear mode
    mov bh, 60h        ; Thuộc tính màu (nền đỏ)
    
    ; Vẽ rào dọc bên trái
    mov ch, 1          ; Hàng bắt đầu
    mov cl, 20         ; Cột bắt đầu
    mov dh, 16         ; Hàng kết thúc
    mov dl, 20         ; Cột kết thúc
    int 10h
    
    ; Vẽ rào dọc bên phải
    mov ch, 8          ; Hàng bắt đầu
    mov cl, 59         ; Cột bắt đầu
    mov dh, 23         ; Hàng kết thúc
    mov dl, 59         ; Cột kết thúc
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
barrier_lv2 endp

barrier_lv3 proc
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 06h        ; Scroll up function
    mov al, 0          ; Clear mode
    mov bh, 60h        ; Thuộc tính màu (nền đỏ)
    
    ; Vẽ rào ngang trên màn hình từ cột 25 đến 55
    mov ch, 5         ; Hàng bắt đầu
    mov cl, 25         ; Cột bắt đầu
    mov dh, 5         ; Hàng kết thúc
    mov dl, 55         ; Cột kết thúc
    int 10h
    
    ; Vẽ rào ngang dưới màn hình từ cột 20 đến 60
    mov ch, 20         ; Hàng bắt đầu
    mov cl, 25         ; Cột bắt đầu
    mov dh, 20         ; Hàng kết thúc
    mov dl, 55         ; Cột kết thúc
    int 10h
    
    ; Vẽ rào dọc bên trái
    mov ch, 5          ; Hàng bắt đầu
    mov cl, 15         ; Cột bắt đầu
    mov dh, 20         ; Hàng kết thúc
    mov dl, 15         ; Cột kết thúc
    int 10h
    
    ; Vẽ rào dọc bên phải
    mov ch, 5          ; Hàng bắt đầu
    mov cl, 65         ; Cột bắt đầu
    mov dh, 20         ; Hàng kết thúc
    mov dl, 65         ; Cột kết thúc
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
barrier_lv3 endp

move_snake proc

    ; Tính vị trí cuối của rắn
    mov bx, [s_size]     ; Lấy giá trị s_size hiện tại
    shl bx, 1           ; Nhân 2 (bx = s_size * 2)
    sub bx, 2           ; Trừ 2 để có offset cuối
    mov di, bx          ; Chuyển vào di
    
    ; Di chuyển thân rắn
    mov cx, [s_size]    
    dec cx              ; cx = số phần tử cần dịch chuyển
    
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
    
    move_left:    ; Di chuyen dau ran sang trai
      mov   ax, [snake]  ; Lay toa do hien tai cua dau ran
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
;----------------------------------------------------------------------------------------------
check_next_character proc 
    mov ax, [snake]      ; Lay toa do cua dau ran (cot - al, hang - ah)
    mov dh, ah           ; Luu hang vao dh de dat con tro
    mov dl, al           ; Luu cot vao dl de dat con tro
    mov bh, 0            ; Su dung trang man hinh 0
    mov ah, 02h          ; Goi interrupt de di chuyen con tro den vi tri (dl, dh)
    int 10h              ; Thuc hien interrupt 10h (hien thi man hinh)

    mov ah, 08h          ; Goi interrupt de doc ky tu tai vi tri con tro
    int 10h              ; Thuc hien interrupt 10h, ky tu doc duoc luu trong al
    
    and ah, 0F0h        
    cmp ah, 70h         
    je collision

    cmp ah, 60h
    je collision
    
    cmp al, '*'          ; Kiem tra xem ky tu co phai la mot phan cua than ran?
    je collision         ; Neu dung, goi ham fail (ran tu va cham chinh no)
    
    cmp al, '@'          ; Kiem tra xem ky tu co phai la thuc an?
    jne move_ok          ; Neu khong phai, tiep tuc di chuyen binh thuong       
    inc word ptr [score] ; Neu la thuc an, tang diem len 1 don vi      
      ; word dam bao 'score' duoc xu ly nhu mot bien 16 bit
    ; Thêm đoạn mới vào đuôi rắn
    mov bx, [s_size]
    mov di, bx               ; di = s_size hiện tại
    shl di, 1               ; di = di * 2 (vì mỗi phần tử 2 byte)
    mov ax, [snake + di - 2] ; Lấy tọa độ đoạn cuối hiện tại
    mov [snake + di], ax     ; Thêm vào cuối
    inc word ptr [s_size]    ; Tăng kích thước rắn
    call draw_random_food
            

move_ok:
    ret

collision:
    call fail      ; Goi ham fail de hien thi "Game Over" va dung chuong trinh
    ret
check_next_character endp     

;----------------------------------------------------------------------------------------------
draw_random_food proc
    push ax
    push bx
    push cx
    push dx

try_again:
    ; Tạo vị trí random như cũ
    mov ah, 00h
    int 1ah
    
    ; Random cột (1-78)
    mov ax, dx
    xor dx, dx
    mov cx, 78
    div cx
    inc dx
    mov col_random, dl
    
    ; Random hàng (1-23)
    mov ax, dx
    xor dx, dx
    mov cx, 23
    div cx
    inc dx
    mov row_random, dl
    
    ; Kiểm tra vị trí có trống không
    mov dh, row_random    ; Hàng
    mov dl, col_random    ; Cột
    mov bh, 0            ; Trang hiện tại
    mov ah, 02h          ; Đặt vị trí con trỏ
    int 10h
    
    mov ah, 08h          ; Đọc ký tự và thuộc tính
    int 10h              ; AL = ký tự, AH = thuộc tính
    
    cmp al, ' '          ; Kiểm tra có phải khoảng trống
    jne try_again        ; Nếu không phải space thì thử vị trí khác
    
    and ah, 0F0h         ; Lấy màu nền
    cmp ah, 00h          ; Kiểm tra màu nền đen (trống)
    jne try_again        ; Nếu không phải nền đen thì thử vị trí khác
    
    ; In thức ăn tại vị trí trống
    mov dh, row_random
    mov dl, col_random
    mov ah, 02h
    int 10h
    
    mov al, '@'          ; Ký tự thức ăn
    mov ah, 09h
    mov bl, 0Ch          ; Màu đỏ sáng
    mov cx, 1
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
draw_random_food endp


;---------------------------------------------------------------------------------------------
print_num proc
    push ax     ; Luu gia tri ax
    push bx     ; Luu gia tri bx
    push cx     ; Luu gia tri cx
    push dx     ; Luu gia tri dx
    
    mov bx, 10  ; Bx l� so chia (10)
    xor cx, cx  ; Cx = 0, d�ng de dem so chu so
    
    ; T�ch c�c chu so v� day v�o stack
divide:
    xor dx, dx  ; Dx = 0
    div bx      ; Chia ax cho 10, thuong trong ax, du trong dx
    push dx     ; �ay so du (chu so) v�o stack
    inc cx      ; Tang bo dem
    test ax, ax ; Kiem tra ax c�n > 0?
    jnz divide  ; Neu c�n th� tiep tuc chia
    
    ; In c�c ch? s? t? stack
print_digits:
    pop dx          ; Lay chu so tu stack
    add dl, '0'     ; Chuyen so th�nh k� tu ASCII
    mov ah, 2       ; H�m 2: in k� tu
    int 21h
    loop print_digits ; Lay cho den khi cx = 0
    
    pop dx      ; khoi phuc cac gi� tri
    pop cx
    pop bx
    pop ax
    ret
print_num endp
;---------------------------------------------------------------------------------------------
clear_screen proc
    mov ah, 06h    ; H�m cu?n c?a s? l�n (scroll up)
    mov al, 0      ; X�a to�n b? m�n h�nh
    mov bh, 07h    ; Thu?c t�nh: ch? tr?ng tr�n n?n den
    mov cx, 0      ; G�c tr�n b�n tr�i (0,0)
    mov dx, 184Fh  ; G�c du?i b�n ph?i (24,79)
    int 10h        ; G?i ng?t 10h
    
    ; Di chuyen con tro ve vi tr� (0,0)
    mov ah, 02h    ; Ham dat vi tr� con tri
    mov bh, 0      ; Trang 0
    mov dx, 0      ; DH=row=0, DL=column=0
    int 10h
    
    ret
clear_screen endp

hide_cursor proc
    mov ah, 01h     ; Hàm 01h - set cursor shape
    mov ch, 20h     ; Bit 5 = 1 để ẩn con trỏ
    mov cl, 00h     ; 
    int 10h         ; Gọi ngắt 10h
  
    ret
hide_cursor endp

; Để hiện lại con trỏ (nếu cần):
show_cursor proc
    push ax
    push cx
    
    mov ah, 01h     ; Hàm 01h - set cursor shape
    mov ch, 06h     ; Shape bình thường
    mov cl, 07h     
    int 10h
    
    pop cx
    pop ax
    ret
show_cursor endp

end main

