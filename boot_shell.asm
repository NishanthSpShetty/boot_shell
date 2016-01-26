
%define BUFFER_SIZE 33 ;16 char max

org 0x7c00
bits 16
start:
	call clr_screen
	mov si,welcome
	call print
	
 	mov cl,9
 while:
	call print_newline

	mov si,prompt
	call print
	call gets
	call print_newline
	mov si,you_entered
	call print
	mov si,input_buffer
	mov byte [si+BUFFER_SIZE-1],0
	call print
	
	call clear_input_buffer
	
	call print_newline
	loop while

	mov si,press_any
	call print
	call getch
	call print_newline
	call print_newline
	call print_newline
	call print_newline
	call print_newline
	mov si,bye
	call print
	call getch
	call clr_screen
	;halt the system
	hlt
	cli
	mov al,01h
	mov ah,42h
	int 15h

gets:
	mov si,input_buffer
	next_input:
		call echo_getch
		cmp al,13
		je done
		mov [si],al
		inc si
	        jmp next_input
	done:
		ret

getch:
	mov ah,0x00
	int 16h
	ret
echo_getch:
	mov ah,0x00
	int 16h
	mov ah,0x0E
	int 10h
	ret

clr_screen:
	mov ah,0x00
	mov al,0x03
	int 10h
	ret
putchar:
	mov ah,0x0E
	mov bx,0
	int 10h
	ret

print:
	pusha
	mov bp,sp
	next_char:
		;loadsb
		mov al,[si]
		or al,al
		jz done_print
		call putchar
		inc si
		jmp next_char
	done_print:
		mov sp,bp
		popa
		ret

print_newline:
	mov al,0xA
	call putchar
	mov al,0x0D
	call putchar
	ret
clear_input_buffer:
	pusha
	mov cl,16
	mov si,input_buffer
	clear_all:
		mov byte [si] ,0x00
		inc si
		loop clear_all
	popa
	ret

; data section
you_entered : db "You entered  : ",0
input_buffer : times BUFFER_SIZE db 0; padd with 0 
welcome :  db '*************Welcome to boot shell*************',0;
prompt : db 'root@boot_shell >',0
press_any : db 'Press any key to continue',0;
bye : db "Thank you for using me...good bye",0
times 510-($-$$) db 0

dw 0xAA55
