
%define BUFFER_SIZE 33 ;16 char max

org 0x7c00
bits 16
start:
	call clr_screen
 	mov cl,10 ;max loop 10 times
while:
	mov si,prompt
	call print
	call gets
	mov byte [si+BUFFER_SIZE-1],0
	mov si,input_buffer
	call print_newline
	pusha	
	call cmd_help
	call cmd_clr
	call cmd_echo
	popa
	call clear_input_buffer
	loop while

	mov si,press_any
	call print
	call getch
	mov si,bye
	call print
	hlt

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
	mov si,welcome
	call print
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

;to_bcd_print:
;	push dx
;	push ax
;	 mov ah,al
;	 shr ah,1
;;	 shr ah,1
;	 shr ah,1
;;	 shr ah,1
;	 and al,0fh  ; Mask off low digit.
;	 or ax,3030H; Convert binary digits to ASCII characters.
;       push ax
;       mov al,ah
;	call putchar
;	pop ax
;	call putchar
;	pop ax
;	pop dx
;	ret
	

;time:
;	pusha
;	mov ah,02h
;	int 1Ah
;	mov ax,0x00
;	mov al,ch; hour
;	call to_bcd_print
;	
;	mov al,'/'
;	call putchar
	
;	mov al,cl ;min
;	call to_bcd_print	
;	popa
;	ret

;exec_cmd:
;	pusha
;	call cmd_time
;	call cmd_clr
;	call cmd_echo
;	call cmd_help
;	popa
;	ret
cmd_help:
	cmp byte [si],'h'
	jne not_help
	inc si
	cmp byte [si],'e'
	jne not_help
	inc si
	cmp byte [si],'l' 
	jne not_help
	inc si
	cmp byte [si],'p'
	jne not_help
	mov si,help
	call print
;	jmp clr_executed
	not_help:
;		mov byte [invalid],1
;	clr_executed:
	ret

cmd_clr:
	cmp byte [si],'0'
	jne not_clr
	call clr_screen
	not_clr:
		ret
cmd_echo:
	cmp byte [si],'e'
	jne not_echo
	inc si
	cmp byte [si],'c'
	jne not_echo
	inc si
	cmp byte [si],'h'
	jne not_echo
	inc si
	cmp byte [si],'o'
	jne not_echo
	mov si,echo
	call print
;	jmp echo_executed

	not_echo :
;		mov byte [invalid],1
;	echo_executed:
		ret



welcome :  db '______________Welcome to boot shell_______________',10,13,0
prompt : db 'root@boot_shell >',0
press_any : db 'Press any key to continue',0
echo : db "Hello... how can i help you sir ? ",13,10,0
bye : db 10,13,"Thank you for using me...good bye",0
help : db "boot shell commands",13,10," echo",13,10," help",13,10,' ',49," : clear screen",13,10,0
input_buffer : times BUFFER_SIZE db 0; padd with 0 
;err : db "Invalid command",0
;invalid : db 1
times 510-($-$$) db 0

dw 0xAA55
