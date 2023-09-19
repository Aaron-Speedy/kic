	.file	"main.c"
	.text
.Ltext0:
	.file 0 "/home/aaron/Code/swir-editor" "main.c"
	.p2align 4
	.globl	sst_kill_tui
	.type	sst_kill_tui, @function
sst_kill_tui:
.LFB10:
	.file 1 "sstui.h"
	.loc 1 65 21 view -0
	.cfi_startproc
	.loc 1 66 3 view .LVU1
	.loc 1 65 21 is_stmt 0 view .LVU2
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	.loc 1 66 3 view .LVU3
	movl	$1, %edi
	call	exit@PLT
.LVL0:
	.cfi_endproc
.LFE10:
	.size	sst_kill_tui, .-sst_kill_tui
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\033[?1049h"
.LC1:
	.string	"\033[2J"
.LC2:
	.string	"\033[?1049l"
	.text
	.p2align 4
	.globl	sst_cleanup_tui
	.type	sst_cleanup_tui, @function
sst_cleanup_tui:
.LFB9:
	.loc 1 58 28 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 59 3 view .LVU5
	.loc 1 58 28 is_stmt 0 view .LVU6
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	.loc 1 59 3 view .LVU7
	leaq	.LC0(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL1:
	.loc 1 60 3 is_stmt 1 view .LVU8
	leaq	.LC1(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL2:
	.loc 1 61 3 view .LVU9
	leaq	.LC2(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL3:
	.loc 1 62 3 view .LVU10
	xorl	%esi, %esi
	movl	$1, %edi
	.loc 1 63 1 is_stmt 0 view .LVU11
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	.loc 1 62 3 view .LVU12
	leaq	sst_initial_termios(%rip), %rdx
	jmp	tcsetattr@PLT
.LVL4:
	.cfi_endproc
.LFE9:
	.size	sst_cleanup_tui, .-sst_cleanup_tui
	.section	.rodata.str1.1
.LC3:
	.string	"\033[%zu;%zuH"
.LC4:
	.string	"tcgetattr"
.LC6:
	.string	"tcsetattr"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB7:
	.text
.LHOTB7:
	.p2align 4
	.section	.text.unlikely
.Ltext_cold0:
	.text
	.globl	sst_init_tui
	.type	sst_init_tui, @function
sst_init_tui:
.LFB8:
	.loc 1 26 25 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 27 3 view .LVU14
	.loc 1 26 25 is_stmt 0 view .LVU15
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	.loc 1 27 3 view .LVU16
	movq	stdout(%rip), %rdi
	xorl	%ecx, %ecx
	xorl	%esi, %esi
	movl	$2, %edx
	.loc 1 33 7 view .LVU17
	leaq	sst_current_termios(%rip), %rbx
	.loc 1 27 3 view .LVU18
	call	setvbuf@PLT
.LVL5:
	.loc 1 29 3 is_stmt 1 view .LVU19
	leaq	.LC0(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL6:
	.loc 1 30 3 view .LVU20
	leaq	.LC1(%rip), %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL7:
	.loc 1 31 3 view .LVU21
	movl	$1, %esi
	movl	$1, %edx
	xorl	%eax, %eax
	leaq	.LC3(%rip), %rdi
	call	printf@PLT
.LVL8:
	.loc 1 31 3 discriminator 1 view .LVU22
	movq	stdout(%rip), %rdi
	call	fflush@PLT
.LVL9:
	.loc 1 31 40 discriminator 2 view .LVU23
	.loc 1 33 3 view .LVU24
	.loc 1 33 7 is_stmt 0 view .LVU25
	movq	%rbx, %rsi
	movl	$1, %edi
	call	tcgetattr@PLT
.LVL10:
	.loc 1 33 6 discriminator 1 view .LVU26
	testl	%eax, %eax
	jne	.L9
	.loc 1 38 3 is_stmt 1 view .LVU27
	.loc 1 38 23 is_stmt 0 view .LVU28
	movdqa	sst_current_termios(%rip), %xmm0
	.loc 1 44 35 view .LVU29
	movl	$256, %eax
	.loc 1 46 7 view .LVU30
	xorl	%esi, %esi
	.loc 1 38 23 view .LVU31
	movdqa	16+sst_current_termios(%rip), %xmm1
	movdqa	32+sst_current_termios(%rip), %xmm2
	movdqu	44+sst_current_termios(%rip), %xmm3
	.loc 1 46 7 view .LVU32
	movq	%rbx, %rdx
	movl	$1, %edi
	.loc 1 39 31 view .LVU33
	andl	$-1299, sst_current_termios(%rip)
	.loc 1 41 31 view .LVU34
	orl	$48, 8+sst_current_termios(%rip)
	.loc 1 42 31 view .LVU35
	andl	$-32796, 12+sst_current_termios(%rip)
	.loc 1 38 23 view .LVU36
	movaps	%xmm2, 32+sst_initial_termios(%rip)
	.loc 1 44 35 view .LVU37
	movw	%ax, 22+sst_current_termios(%rip)
	.loc 1 38 23 view .LVU38
	movaps	%xmm0, sst_initial_termios(%rip)
	movaps	%xmm1, 16+sst_initial_termios(%rip)
	movups	%xmm3, 44+sst_initial_termios(%rip)
	.loc 1 39 3 is_stmt 1 view .LVU39
	.loc 1 41 3 view .LVU40
	.loc 1 42 3 view .LVU41
	.loc 1 43 3 view .LVU42
	.loc 1 44 3 view .LVU43
	.loc 1 46 3 view .LVU44
	.loc 1 46 7 is_stmt 0 view .LVU45
	call	tcsetattr@PLT
.LVL11:
	.loc 1 46 6 discriminator 1 view .LVU46
	testl	%eax, %eax
	jne	.L10
	.loc 1 51 3 is_stmt 1 view .LVU47
	.loc 1 52 3 is_stmt 0 view .LVU48
	leaq	sst_kill_tui(%rip), %rbx
	.loc 1 51 3 view .LVU49
	leaq	sst_cleanup_tui(%rip), %rdi
	call	atexit@PLT
.LVL12:
	.loc 1 52 3 is_stmt 1 view .LVU50
	movq	%rbx, %rsi
	movl	$15, %edi
	call	__sysv_signal@PLT
.LVL13:
	.loc 1 53 3 view .LVU51
	movq	%rbx, %rsi
	movl	$2, %edi
	call	__sysv_signal@PLT
.LVL14:
	.loc 1 55 3 view .LVU52
	leaq	sst_winsize(%rip), %rdx
	xorl	%eax, %eax
	.loc 1 56 1 is_stmt 0 view .LVU53
	popq	%rbx
	.cfi_def_cfa_offset 8
	.loc 1 55 3 view .LVU54
	movl	$21523, %esi
	movl	$1, %edi
	jmp	ioctl@PLT
.LVL15:
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.type	sst_init_tui.cold, @function
sst_init_tui.cold:
.LFSB8:
.L9:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	.loc 1 34 5 is_stmt 1 view -0
	leaq	.LC4(%rip), %rdi
	call	perror@PLT
.LVL16:
	.loc 1 35 5 view .LVU56
	movl	$1, %edi
	call	exit@PLT
.LVL17:
.L10:
	.loc 1 47 5 view .LVU57
	leaq	.LC6(%rip), %rdi
	call	perror@PLT
.LVL18:
	.loc 1 48 5 view .LVU58
	movl	$1, %edi
	call	exit@PLT
.LVL19:
	.cfi_endproc
.LFE8:
	.text
	.size	sst_init_tui, .-sst_init_tui
	.section	.text.unlikely
	.size	sst_init_tui.cold, .-sst_init_tui.cold
.LCOLDE7:
	.text
.LHOTE7:
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC8:
	.string	"Something went wrong while reading user input"
	.section	.rodata
.LC9:
	.string	"OP"
	.string	""
.LC10:
	.string	"OQ"
	.string	""
.LC11:
	.string	"OR"
	.string	""
.LC12:
	.string	"OS"
	.string	""
	.section	.rodata.str1.1
.LC13:
	.string	"\033["
	.section	.rodata
.LC14:
	.string	"15~"
	.string	""
.LC15:
	.string	"17~"
	.string	""
.LC16:
	.string	"18~"
	.string	""
.LC17:
	.string	"19~"
	.string	""
.LC18:
	.string	"20~"
	.string	""
.LC19:
	.string	"21~"
	.string	""
.LC20:
	.string	"23~"
	.string	""
.LC21:
	.string	"24~"
	.string	""
	.section	.rodata.str1.1
.LC22:
	.string	"F%d : %d\n"
.LC23:
	.string	"%c : %d\n"
	.section	.text.unlikely
.LCOLDB24:
	.section	.text.startup,"ax",@progbits
.LHOTB24:
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB11:
	.file 2 "main.c"
	.loc 2 40 16 view -0
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
.LBB2:
	.loc 2 81 43 is_stmt 0 discriminator 2 view .LVU60
	leaq	.LC23(%rip), %r13
.LBE2:
	.loc 2 40 16 view .LVU61
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
.LBB3:
	.loc 2 82 46 discriminator 2 view .LVU62
	leaq	.LC22(%rip), %r12
.LBE3:
	.loc 2 40 16 view .LVU63
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$56, %rsp
	.cfi_def_cfa_offset 96
	.loc 2 40 16 view .LVU64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	.loc 2 41 3 is_stmt 1 view .LVU65
	movq	%rsp, %rbp
	call	sst_init_tui
.LVL20:
	.p2align 4,,10
	.p2align 3
.L28:
	.loc 2 43 3 view .LVU66
.LBB4:
	.loc 2 44 5 view .LVU67
	.loc 2 44 10 is_stmt 0 view .LVU68
	pxor	%xmm0, %xmm0
	.loc 2 45 15 view .LVU69
	xorl	%edi, %edi
	movl	$33, %edx
	movq	%rbp, %rsi
	.loc 2 44 10 view .LVU70
	movb	$0, 32(%rsp)
	.loc 2 45 5 is_stmt 1 view .LVU71
	.loc 2 44 10 is_stmt 0 view .LVU72
	movaps	%xmm0, (%rsp)
	movaps	%xmm0, 16(%rsp)
	.loc 2 45 15 view .LVU73
	call	read@PLT
.LVL21:
	.loc 2 46 5 is_stmt 1 view .LVU74
	.loc 2 46 8 is_stmt 0 view .LVU75
	testl	%eax, %eax
	js	.L90
	.loc 2 51 5 is_stmt 1 view .LVU76
.LVL22:
	.loc 2 52 5 view .LVU77
	.loc 2 53 5 view .LVU78
	.loc 2 54 5 view .LVU79
	.loc 2 55 7 view .LVU80
	.loc 2 56 7 view .LVU81
	.loc 2 56 7 discriminator 1 view .LVU82
	.loc 2 56 7 discriminator 1 view .LVU83
	movzbl	(%rsp), %ebx
.LVL23:
	.loc 2 56 7 is_stmt 0 discriminator 1 view .LVU84
	movzbl	1(%rsp), %edx
	leal	-97(%rbx), %ecx
	testb	%dl, %dl
	movl	%ebx, %esi
.LVL24:
	.loc 2 56 7 is_stmt 1 discriminator 1 view .LVU85
	sete	%al
.LVL25:
	.loc 2 56 7 discriminator 3 view .LVU86
	cmpb	$25, %cl
	ja	.L45
	.loc 2 51 13 is_stmt 0 view .LVU87
	xorl	%ecx, %ecx
	.loc 2 56 7 discriminator 3 view .LVU88
	testb	%al, %al
	je	.L45
.LVL26:
.L14:
	.loc 2 81 43 is_stmt 1 discriminator 2 view .LVU89
	movsbl	%bl, %esi
	movl	%ecx, %edx
	movq	%r13, %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL27:
	.loc 2 82 5 view .LVU90
.L25:
	.loc 2 83 5 view .LVU91
	.loc 2 83 8 is_stmt 0 view .LVU92
	cmpb	$113, %bl
	jne	.L28
.LVL28:
	.loc 2 83 8 view .LVU93
.LBE4:
	.loc 2 86 3 is_stmt 1 view .LVU94
	.loc 2 87 1 is_stmt 0 view .LVU95
	movq	40(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L92
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.LVL29:
	.p2align 4,,10
	.p2align 3
.L45:
	.cfi_restore_state
.LBB5:
	.loc 2 56 7 is_stmt 1 discriminator 4 view .LVU96
	.loc 2 56 7 discriminator 4 view .LVU97
	.loc 2 56 101 discriminator 4 view .LVU98
	.loc 2 57 7 view .LVU99
	.loc 2 57 7 discriminator 1 view .LVU100
	.loc 2 57 7 discriminator 1 view .LVU101
	.loc 2 57 7 discriminator 1 view .LVU102
	.loc 2 57 7 discriminator 3 view .LVU103
	.loc 2 57 7 is_stmt 0 discriminator 1 view .LVU104
	leal	-65(%rbx), %ecx
	.loc 2 57 7 discriminator 3 view .LVU105
	cmpb	$25, %cl
	ja	.L16
	testb	%al, %al
	je	.L16
	.loc 2 57 7 discriminator 1 view .LVU106
	addl	$32, %ebx
.LVL30:
	.loc 2 57 7 discriminator 1 view .LVU107
	movl	$1, %ecx
	jmp	.L14
.LVL31:
	.p2align 4,,10
	.p2align 3
.L16:
	.loc 2 57 7 is_stmt 1 discriminator 4 view .LVU108
	.loc 2 57 7 discriminator 4 view .LVU109
	.loc 2 57 127 discriminator 4 view .LVU110
	.loc 2 58 7 view .LVU111
	.loc 2 58 7 discriminator 1 view .LVU112
	.loc 2 58 7 discriminator 1 view .LVU113
	leal	-1(%rsi), %ecx
	addl	$96, %ebx
.LVL32:
	.loc 2 58 7 discriminator 1 view .LVU114
	.loc 2 58 7 discriminator 3 view .LVU115
	cmpb	$25, %cl
	ja	.L46
	.loc 2 58 7 is_stmt 0 discriminator 1 view .LVU116
	movl	$4, %ecx
	.loc 2 58 7 discriminator 3 view .LVU117
	testb	%al, %al
	jne	.L14
.L46:
	.loc 2 58 7 is_stmt 1 discriminator 4 view .LVU118
.LVL33:
	.loc 2 58 7 discriminator 4 view .LVU119
	.loc 2 58 129 discriminator 4 view .LVU120
	.loc 2 59 7 view .LVU121
	.loc 2 59 7 is_stmt 0 view .LVU122
	cmpb	$27, %sil
	je	.L93
.LVL34:
	.loc 2 68 7 is_stmt 1 discriminator 4 view .LVU123
	.loc 2 68 7 discriminator 4 view .LVU124
	.loc 2 68 46 discriminator 4 view .LVU125
	.loc 2 69 7 view .LVU126
	movl	$2, %edx
	movq	%rbp, %rsi
	leaq	.LC13(%rip), %rdi
	call	strncmp@PLT
.LVL35:
	.loc 2 69 7 is_stmt 0 discriminator 1 view .LVU127
	testl	%eax, %eax
	jne	.L25
.LVL36:
.L23:
	.loc 2 69 7 is_stmt 1 discriminator 1 view .LVU128
	.loc 2 69 7 discriminator 1 view .LVU129
	.loc 2 69 7 discriminator 1 view .LVU130
	leaq	2(%rsp), %rbx
	leaq	.LC14(%rip), %rdi
	movq	%rbx, %rsi
	call	strcmp@PLT
.LVL37:
	.loc 2 69 7 discriminator 3 view .LVU131
	movl	$5, %esi
	testl	%eax, %eax
	je	.L22
.LVL38:
	.loc 2 69 7 discriminator 4 view .LVU132
	.loc 2 69 7 discriminator 4 view .LVU133
	.loc 2 69 48 discriminator 4 view .LVU134
	.loc 2 70 7 view .LVU135
	.loc 2 70 7 discriminator 1 view .LVU136
	.loc 2 70 7 discriminator 1 view .LVU137
	.loc 2 70 7 discriminator 1 view .LVU138
	movq	%rbx, %rsi
	leaq	.LC15(%rip), %rdi
	call	strcmp@PLT
.LVL39:
	.loc 2 70 7 discriminator 3 view .LVU139
	movl	$6, %esi
	testl	%eax, %eax
	je	.L22
.LVL40:
	.loc 2 70 7 discriminator 4 view .LVU140
	.loc 2 70 7 discriminator 4 view .LVU141
	.loc 2 70 48 discriminator 4 view .LVU142
	.loc 2 71 7 view .LVU143
	.loc 2 71 7 discriminator 1 view .LVU144
	.loc 2 71 7 discriminator 1 view .LVU145
	.loc 2 71 7 discriminator 1 view .LVU146
	movq	%rbx, %rsi
	leaq	.LC16(%rip), %rdi
	call	strcmp@PLT
.LVL41:
	.loc 2 71 7 discriminator 3 view .LVU147
	movl	$7, %esi
	testl	%eax, %eax
	je	.L22
.LVL42:
	.loc 2 71 7 discriminator 4 view .LVU148
	.loc 2 71 7 discriminator 4 view .LVU149
	.loc 2 71 48 discriminator 4 view .LVU150
	.loc 2 72 7 view .LVU151
	.loc 2 72 7 discriminator 1 view .LVU152
	.loc 2 72 7 discriminator 1 view .LVU153
	.loc 2 72 7 discriminator 1 view .LVU154
	movq	%rbx, %rsi
	leaq	.LC17(%rip), %rdi
	call	strcmp@PLT
.LVL43:
	.loc 2 72 7 discriminator 3 view .LVU155
	movl	$8, %esi
	testl	%eax, %eax
	je	.L22
.LVL44:
	.loc 2 72 7 discriminator 4 view .LVU156
	.loc 2 72 7 discriminator 4 view .LVU157
	.loc 2 72 48 discriminator 4 view .LVU158
	.loc 2 73 7 view .LVU159
	.loc 2 73 7 discriminator 1 view .LVU160
	.loc 2 73 7 discriminator 1 view .LVU161
	.loc 2 73 7 discriminator 1 view .LVU162
	movq	%rbx, %rsi
	leaq	.LC18(%rip), %rdi
	call	strcmp@PLT
.LVL45:
	.loc 2 73 7 discriminator 3 view .LVU163
	movl	$9, %esi
	testl	%eax, %eax
	je	.L22
.LVL46:
	.loc 2 73 7 discriminator 4 view .LVU164
	.loc 2 73 7 discriminator 4 view .LVU165
	.loc 2 73 48 discriminator 4 view .LVU166
	.loc 2 74 7 view .LVU167
	.loc 2 74 7 discriminator 1 view .LVU168
	.loc 2 74 7 discriminator 1 view .LVU169
	.loc 2 74 7 discriminator 1 view .LVU170
	movq	%rbx, %rsi
	leaq	.LC19(%rip), %rdi
	call	strcmp@PLT
.LVL47:
	.loc 2 74 7 discriminator 3 view .LVU171
	movl	$10, %esi
	testl	%eax, %eax
	je	.L22
.LVL48:
	.loc 2 74 7 discriminator 4 view .LVU172
	.loc 2 74 7 discriminator 4 view .LVU173
	.loc 2 74 49 discriminator 4 view .LVU174
	.loc 2 75 7 view .LVU175
	.loc 2 75 7 discriminator 1 view .LVU176
	.loc 2 75 7 discriminator 1 view .LVU177
	.loc 2 75 7 discriminator 1 view .LVU178
	movq	%rbx, %rsi
	leaq	.LC20(%rip), %rdi
	call	strcmp@PLT
.LVL49:
	.loc 2 75 7 discriminator 3 view .LVU179
	movl	$11, %esi
	testl	%eax, %eax
	je	.L22
.LVL50:
	.loc 2 75 7 discriminator 4 view .LVU180
	.loc 2 75 7 discriminator 4 view .LVU181
	.loc 2 75 49 discriminator 4 view .LVU182
	.loc 2 76 7 view .LVU183
	.loc 2 76 7 discriminator 1 view .LVU184
	.loc 2 76 7 discriminator 1 view .LVU185
	.loc 2 76 7 discriminator 1 view .LVU186
	movq	%rbx, %rsi
	leaq	.LC21(%rip), %rdi
	call	strcmp@PLT
.LVL51:
	.loc 2 76 7 discriminator 3 view .LVU187
	.loc 2 76 7 is_stmt 0 discriminator 1 view .LVU188
	movl	$12, %esi
	.loc 2 76 7 discriminator 3 view .LVU189
	testl	%eax, %eax
	je	.L22
	jmp	.L28
.LVL52:
.L93:
	.loc 2 59 7 is_stmt 1 discriminator 1 view .LVU190
	.loc 2 59 7 discriminator 1 view .LVU191
	cmpb	$0, 2(%rsp)
	leal	-97(%rdx), %ecx
	movl	%edx, %ebx
.LVL53:
	.loc 2 59 7 discriminator 1 view .LVU192
	sete	%al
.LVL54:
	.loc 2 59 7 discriminator 3 view .LVU193
	cmpb	$25, %cl
	ja	.L47
.LVL55:
	.loc 2 59 7 is_stmt 0 discriminator 1 view .LVU194
	movl	$2, %ecx
	.loc 2 59 7 discriminator 3 view .LVU195
	testb	%al, %al
	jne	.L14
.L47:
.LVL56:
	.loc 2 60 7 is_stmt 1 discriminator 1 view .LVU196
	.loc 2 60 7 discriminator 1 view .LVU197
	.loc 2 60 7 discriminator 1 view .LVU198
	.loc 2 60 7 discriminator 3 view .LVU199
	.loc 2 60 7 is_stmt 0 discriminator 1 view .LVU200
	leal	-65(%rdx), %ecx
	.loc 2 60 7 discriminator 3 view .LVU201
	cmpb	$25, %cl
	ja	.L20
	testb	%al, %al
	je	.L20
	.loc 2 60 7 discriminator 1 view .LVU202
	leal	32(%rdx), %ebx
	movl	$3, %ecx
	jmp	.L14
.L20:
	.loc 2 60 7 is_stmt 1 discriminator 4 view .LVU203
.LVL57:
	.loc 2 60 7 discriminator 4 view .LVU204
	.loc 2 60 141 discriminator 4 view .LVU205
	.loc 2 61 7 view .LVU206
	.loc 2 61 7 discriminator 1 view .LVU207
	.loc 2 61 7 discriminator 1 view .LVU208
	.loc 2 61 7 discriminator 1 view .LVU209
	.loc 2 61 7 discriminator 3 view .LVU210
	.loc 2 61 7 is_stmt 0 discriminator 1 view .LVU211
	leal	-1(%rdx), %ecx
	.loc 2 61 7 discriminator 3 view .LVU212
	cmpb	$25, %cl
	ja	.L21
	testb	%al, %al
	je	.L21
	.loc 2 61 7 discriminator 1 view .LVU213
	leal	96(%rdx), %ebx
	movl	$6, %ecx
	jmp	.L14
.L21:
.LVL58:
	.loc 2 65 7 is_stmt 1 discriminator 1 view .LVU214
	.loc 2 65 7 discriminator 1 view .LVU215
	.loc 2 65 7 discriminator 1 view .LVU216
	leaq	1(%rsp), %rbx
	leaq	.LC9(%rip), %rdi
	movq	%rbx, %rsi
.LVL59:
	.loc 2 65 7 is_stmt 0 discriminator 1 view .LVU217
	call	strcmp@PLT
.LVL60:
	.loc 2 65 7 is_stmt 1 discriminator 3 view .LVU218
	movl	$1, %esi
	testl	%eax, %eax
	jne	.L94
.LVL61:
.L22:
	.loc 2 82 5 view .LVU219
	.loc 2 82 46 discriminator 2 view .LVU220
	xorl	%edx, %edx
	movq	%r12, %rdi
	xorl	%eax, %eax
	call	printf@PLT
.LVL62:
	.loc 2 83 5 view .LVU221
	jmp	.L28
.LVL63:
.L94:
	.loc 2 65 7 discriminator 4 view .LVU222
	.loc 2 65 7 discriminator 4 view .LVU223
	.loc 2 65 46 discriminator 4 view .LVU224
	.loc 2 66 7 view .LVU225
	.loc 2 66 7 discriminator 1 view .LVU226
	.loc 2 66 7 discriminator 1 view .LVU227
	.loc 2 66 7 discriminator 1 view .LVU228
	movq	%rbx, %rsi
	leaq	.LC10(%rip), %rdi
	call	strcmp@PLT
.LVL64:
	.loc 2 66 7 discriminator 3 view .LVU229
	movl	$2, %esi
	testl	%eax, %eax
	je	.L22
.LVL65:
	.loc 2 66 7 discriminator 4 view .LVU230
	.loc 2 66 7 discriminator 4 view .LVU231
	.loc 2 66 46 discriminator 4 view .LVU232
	.loc 2 67 7 view .LVU233
	.loc 2 67 7 discriminator 1 view .LVU234
	.loc 2 67 7 discriminator 1 view .LVU235
	.loc 2 67 7 discriminator 1 view .LVU236
	movq	%rbx, %rsi
	leaq	.LC11(%rip), %rdi
	call	strcmp@PLT
.LVL66:
	.loc 2 67 7 discriminator 3 view .LVU237
	movl	$3, %esi
	testl	%eax, %eax
	je	.L22
.LVL67:
	.loc 2 67 7 discriminator 4 view .LVU238
	.loc 2 67 7 discriminator 4 view .LVU239
	.loc 2 67 46 discriminator 4 view .LVU240
	.loc 2 68 7 view .LVU241
	.loc 2 68 7 discriminator 1 view .LVU242
	.loc 2 68 7 discriminator 1 view .LVU243
	.loc 2 68 7 discriminator 1 view .LVU244
	movq	%rbx, %rsi
	leaq	.LC12(%rip), %rdi
	call	strcmp@PLT
.LVL68:
	.loc 2 68 7 discriminator 3 view .LVU245
	movl	$4, %esi
	testl	%eax, %eax
	je	.L22
.LVL69:
	.loc 2 68 7 discriminator 4 view .LVU246
	.loc 2 68 7 discriminator 4 view .LVU247
	.loc 2 68 46 discriminator 4 view .LVU248
	.loc 2 69 7 view .LVU249
	movl	$2, %edx
	movq	%rbp, %rsi
	leaq	.LC13(%rip), %rdi
	call	strncmp@PLT
.LVL70:
	.loc 2 69 7 is_stmt 0 discriminator 1 view .LVU250
	testl	%eax, %eax
	je	.L23
	jmp	.L28
.LVL71:
.L92:
	.loc 2 69 7 discriminator 1 view .LVU251
.LBE5:
	.loc 2 87 1 view .LVU252
	call	__stack_chk_fail@PLT
.LVL72:
	.loc 2 87 1 view .LVU253
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.type	main.cold, @function
main.cold:
.LFSB11:
.L90:
	.cfi_def_cfa_offset 96
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
.LBB6:
	.loc 2 47 7 is_stmt 1 view .LVU59
	leaq	.LC8(%rip), %rdi
	call	perror@PLT
.LVL73:
	.loc 2 48 7 view .LVU255
	movl	$1, %edi
	call	exit@PLT
.LVL74:
.LBE6:
	.cfi_endproc
.LFE11:
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold, .-main.cold
.LCOLDE24:
	.section	.text.startup
.LHOTE24:
	.globl	sst_winsize
	.bss
	.align 8
	.type	sst_winsize, @object
	.size	sst_winsize, 8
sst_winsize:
	.zero	8
	.globl	sst_current_termios
	.align 32
	.type	sst_current_termios, @object
	.size	sst_current_termios, 60
sst_current_termios:
	.zero	60
	.globl	sst_initial_termios
	.align 32
	.type	sst_initial_termios, @object
	.size	sst_initial_termios, 60
sst_initial_termios:
	.zero	60
	.text
.Letext0:
	.section	.text.unlikely
.Letext_cold0:
	.file 3 "/usr/include/bits/types.h"
	.file 4 "/usr/include/unistd.h"
	.file 5 "/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/include/stddef.h"
	.file 6 "/usr/include/bits/ioctl-types.h"
	.file 7 "/usr/include/signal.h"
	.file 8 "/usr/include/bits/termios.h"
	.file 9 "/usr/include/bits/termios-struct.h"
	.file 10 "/usr/include/bits/types/struct_FILE.h"
	.file 11 "/usr/include/bits/types/FILE.h"
	.file 12 "/usr/include/stdio.h"
	.file 13 "/usr/include/string.h"
	.file 14 "/usr/include/sys/ioctl.h"
	.file 15 "/usr/include/stdlib.h"
	.file 16 "/usr/include/termios.h"
	.file 17 "<built-in>"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0xbe3
	.value	0x5
	.byte	0x1
	.byte	0x8
	.long	.Ldebug_abbrev0
	.uleb128 0x19
	.long	.LASF99
	.byte	0xc
	.long	.LASF0
	.long	.LASF1
	.long	.LLRL7
	.quad	0
	.long	.Ldebug_line0
	.uleb128 0x7
	.byte	0x1
	.byte	0x8
	.long	.LASF2
	.uleb128 0x7
	.byte	0x2
	.byte	0x7
	.long	.LASF3
	.uleb128 0x7
	.byte	0x4
	.byte	0x7
	.long	.LASF4
	.uleb128 0x7
	.byte	0x8
	.byte	0x7
	.long	.LASF5
	.uleb128 0x7
	.byte	0x1
	.byte	0x6
	.long	.LASF6
	.uleb128 0x7
	.byte	0x2
	.byte	0x5
	.long	.LASF7
	.uleb128 0x1a
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x7
	.byte	0x8
	.byte	0x5
	.long	.LASF8
	.uleb128 0x5
	.long	.LASF9
	.byte	0x3
	.byte	0x98
	.byte	0x19
	.long	0x5b
	.uleb128 0x5
	.long	.LASF10
	.byte	0x3
	.byte	0x99
	.byte	0x1b
	.long	0x5b
	.uleb128 0x1b
	.byte	0x8
	.uleb128 0x5
	.long	.LASF11
	.byte	0x3
	.byte	0xc2
	.byte	0x1b
	.long	0x5b
	.uleb128 0x6
	.long	0x92
	.uleb128 0x12
	.long	0x88
	.uleb128 0x7
	.byte	0x1
	.byte	0x6
	.long	.LASF12
	.uleb128 0x13
	.long	0x92
	.uleb128 0x5
	.long	.LASF13
	.byte	0x4
	.byte	0xdc
	.byte	0x13
	.long	0x7c
	.uleb128 0x5
	.long	.LASF14
	.byte	0x5
	.byte	0xd6
	.byte	0x17
	.long	0x3f
	.uleb128 0xd
	.long	.LASF23
	.byte	0x8
	.byte	0x6
	.byte	0x1b
	.long	0xf7
	.uleb128 0x2
	.long	.LASF15
	.byte	0x6
	.byte	0x1d
	.byte	0x18
	.long	0x31
	.byte	0
	.uleb128 0x2
	.long	.LASF16
	.byte	0x6
	.byte	0x1e
	.byte	0x18
	.long	0x31
	.byte	0x2
	.uleb128 0x2
	.long	.LASF17
	.byte	0x6
	.byte	0x1f
	.byte	0x18
	.long	0x31
	.byte	0x4
	.uleb128 0x2
	.long	.LASF18
	.byte	0x6
	.byte	0x20
	.byte	0x18
	.long	0x31
	.byte	0x6
	.byte	0
	.uleb128 0x5
	.long	.LASF19
	.byte	0x7
	.byte	0x48
	.byte	0x10
	.long	0x103
	.uleb128 0x6
	.long	0x108
	.uleb128 0x1c
	.long	0x113
	.uleb128 0x4
	.long	0x54
	.byte	0
	.uleb128 0x5
	.long	.LASF20
	.byte	0x8
	.byte	0x17
	.byte	0x17
	.long	0x2a
	.uleb128 0x5
	.long	.LASF21
	.byte	0x8
	.byte	0x18
	.byte	0x16
	.long	0x38
	.uleb128 0x5
	.long	.LASF22
	.byte	0x8
	.byte	0x19
	.byte	0x16
	.long	0x38
	.uleb128 0xd
	.long	.LASF24
	.byte	0x3c
	.byte	0x9
	.byte	0x18
	.long	0x1ac
	.uleb128 0x2
	.long	.LASF25
	.byte	0x9
	.byte	0x1a
	.byte	0xe
	.long	0x12b
	.byte	0
	.uleb128 0x2
	.long	.LASF26
	.byte	0x9
	.byte	0x1b
	.byte	0xe
	.long	0x12b
	.byte	0x4
	.uleb128 0x2
	.long	.LASF27
	.byte	0x9
	.byte	0x1c
	.byte	0xe
	.long	0x12b
	.byte	0x8
	.uleb128 0x2
	.long	.LASF28
	.byte	0x9
	.byte	0x1d
	.byte	0xe
	.long	0x12b
	.byte	0xc
	.uleb128 0x2
	.long	.LASF29
	.byte	0x9
	.byte	0x1e
	.byte	0xa
	.long	0x113
	.byte	0x10
	.uleb128 0x2
	.long	.LASF30
	.byte	0x9
	.byte	0x1f
	.byte	0xa
	.long	0x1b1
	.byte	0x11
	.uleb128 0x2
	.long	.LASF31
	.byte	0x9
	.byte	0x20
	.byte	0xd
	.long	0x11f
	.byte	0x34
	.uleb128 0x2
	.long	.LASF32
	.byte	0x9
	.byte	0x21
	.byte	0xd
	.long	0x11f
	.byte	0x38
	.byte	0
	.uleb128 0x13
	.long	0x137
	.uleb128 0xa
	.long	0x113
	.long	0x1c1
	.uleb128 0xb
	.long	0x3f
	.byte	0x1f
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.byte	0x5
	.long	.LASF33
	.uleb128 0xd
	.long	.LASF34
	.byte	0xd8
	.byte	0xa
	.byte	0x31
	.long	0x34e
	.uleb128 0x2
	.long	.LASF35
	.byte	0xa
	.byte	0x33
	.byte	0x7
	.long	0x54
	.byte	0
	.uleb128 0x2
	.long	.LASF36
	.byte	0xa
	.byte	0x36
	.byte	0x9
	.long	0x88
	.byte	0x8
	.uleb128 0x2
	.long	.LASF37
	.byte	0xa
	.byte	0x37
	.byte	0x9
	.long	0x88
	.byte	0x10
	.uleb128 0x2
	.long	.LASF38
	.byte	0xa
	.byte	0x38
	.byte	0x9
	.long	0x88
	.byte	0x18
	.uleb128 0x2
	.long	.LASF39
	.byte	0xa
	.byte	0x39
	.byte	0x9
	.long	0x88
	.byte	0x20
	.uleb128 0x2
	.long	.LASF40
	.byte	0xa
	.byte	0x3a
	.byte	0x9
	.long	0x88
	.byte	0x28
	.uleb128 0x2
	.long	.LASF41
	.byte	0xa
	.byte	0x3b
	.byte	0x9
	.long	0x88
	.byte	0x30
	.uleb128 0x2
	.long	.LASF42
	.byte	0xa
	.byte	0x3c
	.byte	0x9
	.long	0x88
	.byte	0x38
	.uleb128 0x2
	.long	.LASF43
	.byte	0xa
	.byte	0x3d
	.byte	0x9
	.long	0x88
	.byte	0x40
	.uleb128 0x2
	.long	.LASF44
	.byte	0xa
	.byte	0x40
	.byte	0x9
	.long	0x88
	.byte	0x48
	.uleb128 0x2
	.long	.LASF45
	.byte	0xa
	.byte	0x41
	.byte	0x9
	.long	0x88
	.byte	0x50
	.uleb128 0x2
	.long	.LASF46
	.byte	0xa
	.byte	0x42
	.byte	0x9
	.long	0x88
	.byte	0x58
	.uleb128 0x2
	.long	.LASF47
	.byte	0xa
	.byte	0x44
	.byte	0x16
	.long	0x367
	.byte	0x60
	.uleb128 0x2
	.long	.LASF48
	.byte	0xa
	.byte	0x46
	.byte	0x14
	.long	0x36c
	.byte	0x68
	.uleb128 0x2
	.long	.LASF49
	.byte	0xa
	.byte	0x48
	.byte	0x7
	.long	0x54
	.byte	0x70
	.uleb128 0x2
	.long	.LASF50
	.byte	0xa
	.byte	0x49
	.byte	0x7
	.long	0x54
	.byte	0x74
	.uleb128 0x2
	.long	.LASF51
	.byte	0xa
	.byte	0x4a
	.byte	0xb
	.long	0x62
	.byte	0x78
	.uleb128 0x2
	.long	.LASF52
	.byte	0xa
	.byte	0x4d
	.byte	0x12
	.long	0x31
	.byte	0x80
	.uleb128 0x2
	.long	.LASF53
	.byte	0xa
	.byte	0x4e
	.byte	0xf
	.long	0x46
	.byte	0x82
	.uleb128 0x2
	.long	.LASF54
	.byte	0xa
	.byte	0x4f
	.byte	0x8
	.long	0x371
	.byte	0x83
	.uleb128 0x2
	.long	.LASF55
	.byte	0xa
	.byte	0x51
	.byte	0xf
	.long	0x381
	.byte	0x88
	.uleb128 0x2
	.long	.LASF56
	.byte	0xa
	.byte	0x59
	.byte	0xd
	.long	0x6e
	.byte	0x90
	.uleb128 0x2
	.long	.LASF57
	.byte	0xa
	.byte	0x5b
	.byte	0x17
	.long	0x38b
	.byte	0x98
	.uleb128 0x2
	.long	.LASF58
	.byte	0xa
	.byte	0x5c
	.byte	0x19
	.long	0x395
	.byte	0xa0
	.uleb128 0x2
	.long	.LASF59
	.byte	0xa
	.byte	0x5d
	.byte	0x14
	.long	0x36c
	.byte	0xa8
	.uleb128 0x2
	.long	.LASF60
	.byte	0xa
	.byte	0x5e
	.byte	0x9
	.long	0x7a
	.byte	0xb0
	.uleb128 0x2
	.long	.LASF61
	.byte	0xa
	.byte	0x5f
	.byte	0xa
	.long	0xaa
	.byte	0xb8
	.uleb128 0x2
	.long	.LASF62
	.byte	0xa
	.byte	0x60
	.byte	0x7
	.long	0x54
	.byte	0xc0
	.uleb128 0x2
	.long	.LASF63
	.byte	0xa
	.byte	0x62
	.byte	0x8
	.long	0x39a
	.byte	0xc4
	.byte	0
	.uleb128 0x5
	.long	.LASF64
	.byte	0xb
	.byte	0x7
	.byte	0x19
	.long	0x1c8
	.uleb128 0x1d
	.long	.LASF100
	.byte	0xa
	.byte	0x2b
	.byte	0xe
	.uleb128 0xe
	.long	.LASF65
	.uleb128 0x6
	.long	0x362
	.uleb128 0x6
	.long	0x1c8
	.uleb128 0xa
	.long	0x92
	.long	0x381
	.uleb128 0xb
	.long	0x3f
	.byte	0
	.byte	0
	.uleb128 0x6
	.long	0x35a
	.uleb128 0xe
	.long	.LASF66
	.uleb128 0x6
	.long	0x386
	.uleb128 0xe
	.long	.LASF67
	.uleb128 0x6
	.long	0x390
	.uleb128 0xa
	.long	0x92
	.long	0x3aa
	.uleb128 0xb
	.long	0x3f
	.byte	0x13
	.byte	0
	.uleb128 0x6
	.long	0x34e
	.uleb128 0x12
	.long	0x3aa
	.uleb128 0x1e
	.long	.LASF68
	.byte	0xc
	.byte	0x95
	.byte	0xe
	.long	0x3aa
	.uleb128 0xf
	.long	.LASF69
	.byte	0x12
	.long	0x137
	.uleb128 0x9
	.byte	0x3
	.quad	sst_initial_termios
	.uleb128 0xf
	.long	.LASF70
	.byte	0x13
	.long	0x137
	.uleb128 0x9
	.byte	0x3
	.quad	sst_current_termios
	.uleb128 0xf
	.long	.LASF71
	.byte	0x14
	.long	0xb6
	.uleb128 0x9
	.byte	0x3
	.quad	sst_winsize
	.uleb128 0x14
	.long	0x38
	.byte	0x9
	.long	0x419
	.uleb128 0x8
	.long	.LASF72
	.byte	0
	.uleb128 0x8
	.long	.LASF73
	.byte	0x1
	.uleb128 0x8
	.long	.LASF74
	.byte	0x2
	.byte	0
	.uleb128 0x5
	.long	.LASF75
	.byte	0x2
	.byte	0xd
	.byte	0x3
	.long	0x3fc
	.uleb128 0x14
	.long	0x38
	.byte	0xf
	.long	0x442
	.uleb128 0x8
	.long	.LASF76
	.byte	0x1
	.uleb128 0x8
	.long	.LASF77
	.byte	0x2
	.uleb128 0x8
	.long	.LASF78
	.byte	0x4
	.byte	0
	.uleb128 0x5
	.long	.LASF79
	.byte	0x2
	.byte	0x13
	.byte	0x3
	.long	0x425
	.uleb128 0x1f
	.byte	0xc
	.byte	0x2
	.byte	0x15
	.byte	0x9
	.long	0x47d
	.uleb128 0x2
	.long	.LASF80
	.byte	0x2
	.byte	0x16
	.byte	0xf
	.long	0x419
	.byte	0
	.uleb128 0x15
	.string	"key"
	.byte	0x17
	.byte	0x8
	.long	0x92
	.byte	0x4
	.uleb128 0x15
	.string	"mod"
	.byte	0x18
	.byte	0xb
	.long	0x442
	.byte	0x8
	.byte	0
	.uleb128 0x5
	.long	.LASF81
	.byte	0x2
	.byte	0x19
	.byte	0x3
	.long	0x44e
	.uleb128 0x9
	.long	.LASF82
	.byte	0xd
	.byte	0x9f
	.long	0x54
	.long	0x4a8
	.uleb128 0x4
	.long	0x4a8
	.uleb128 0x4
	.long	0x4a8
	.uleb128 0x4
	.long	0xaa
	.byte	0
	.uleb128 0x6
	.long	0x99
	.uleb128 0xc
	.long	.LASF83
	.byte	0x4
	.value	0x173
	.byte	0x10
	.long	0x9e
	.long	0x4ce
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0x7a
	.uleb128 0x4
	.long	0xaa
	.byte	0
	.uleb128 0x9
	.long	.LASF84
	.byte	0xe
	.byte	0x2a
	.long	0x54
	.long	0x4e9
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0x3f
	.uleb128 0x16
	.byte	0
	.uleb128 0x20
	.long	.LASF94
	.byte	0x7
	.byte	0x5d
	.byte	0x17
	.long	.LASF101
	.long	0xf7
	.long	0x508
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0xf7
	.byte	0
	.uleb128 0xc
	.long	.LASF85
	.byte	0xf
	.value	0x2de
	.byte	0xc
	.long	0x54
	.long	0x51f
	.uleb128 0x4
	.long	0x51f
	.byte	0
	.uleb128 0x6
	.long	0x524
	.uleb128 0x21
	.uleb128 0x9
	.long	.LASF86
	.byte	0x10
	.byte	0x46
	.long	0x54
	.long	0x544
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0x544
	.byte	0
	.uleb128 0x6
	.long	0x1ac
	.uleb128 0x22
	.long	.LASF87
	.byte	0xf
	.value	0x2f4
	.byte	0xd
	.long	0x55c
	.uleb128 0x4
	.long	0x54
	.byte	0
	.uleb128 0x23
	.long	.LASF102
	.byte	0xc
	.value	0x35e
	.byte	0xd
	.long	0x56f
	.uleb128 0x4
	.long	0x4a8
	.byte	0
	.uleb128 0x9
	.long	.LASF88
	.byte	0x10
	.byte	0x42
	.long	0x54
	.long	0x589
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0x589
	.byte	0
	.uleb128 0x6
	.long	0x137
	.uleb128 0x9
	.long	.LASF89
	.byte	0xc
	.byte	0xeb
	.long	0x54
	.long	0x5a3
	.uleb128 0x4
	.long	0x3aa
	.byte	0
	.uleb128 0xc
	.long	.LASF90
	.byte	0xc
	.value	0x169
	.byte	0xc
	.long	0x54
	.long	0x5bb
	.uleb128 0x4
	.long	0x4a8
	.uleb128 0x16
	.byte	0
	.uleb128 0xc
	.long	.LASF91
	.byte	0xc
	.value	0x151
	.byte	0xc
	.long	0x54
	.long	0x5e1
	.uleb128 0x4
	.long	0x3af
	.uleb128 0x4
	.long	0x8d
	.uleb128 0x4
	.long	0x54
	.uleb128 0x4
	.long	0xaa
	.byte	0
	.uleb128 0x24
	.long	.LASF96
	.byte	0x2
	.byte	0x28
	.byte	0x5
	.long	0x54
	.long	.LLRL1
	.uleb128 0x1
	.byte	0x9c
	.long	0x91c
	.uleb128 0x25
	.long	.LLRL2
	.long	0x901
	.uleb128 0x26
	.string	"seq"
	.byte	0x2
	.byte	0x2c
	.byte	0xa
	.long	0x91c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0x17
	.string	"ret"
	.byte	0x2d
	.byte	0x9
	.long	0x54
	.long	.LLST3
	.long	.LVUS3
	.uleb128 0x17
	.string	"key"
	.byte	0x33
	.byte	0xd
	.long	0x47d
	.long	.LLST4
	.long	.LVUS4
	.uleb128 0x18
	.long	.LASF92
	.byte	0x34
	.long	0x54
	.long	.LLST5
	.long	.LVUS5
	.uleb128 0x18
	.long	.LASF93
	.byte	0x35
	.long	0x54
	.long	.LLST6
	.long	.LVUS6
	.uleb128 0x3
	.quad	.LVL21
	.long	0x4ad
	.long	0x67d
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x8
	.byte	0x21
	.byte	0
	.uleb128 0x3
	.quad	.LVL27
	.long	0x5a3
	.long	0x6a1
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x8
	.byte	0x73
	.sleb128 0
	.byte	0x8
	.byte	0x38
	.byte	0x24
	.byte	0x8
	.byte	0x38
	.byte	0x26
	.byte	0
	.uleb128 0x3
	.quad	.LVL35
	.long	0x489
	.long	0x6cb
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC13
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x3
	.quad	.LVL37
	.long	0xbd2
	.long	0x6f0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC14
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL39
	.long	0xbd2
	.long	0x715
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC15
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL41
	.long	0xbd2
	.long	0x73a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC16
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL43
	.long	0xbd2
	.long	0x75f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC17
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL45
	.long	0xbd2
	.long	0x784
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC18
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL47
	.long	0xbd2
	.long	0x7a9
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC19
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL49
	.long	0xbd2
	.long	0x7ce
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC20
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL51
	.long	0xbd2
	.long	0x7f3
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC21
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL60
	.long	0xbd2
	.long	0x818
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC9
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL62
	.long	0x5a3
	.long	0x835
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x3
	.quad	.LVL64
	.long	0xbd2
	.long	0x85a
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC10
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL66
	.long	0xbd2
	.long	0x87f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC11
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL68
	.long	0xbd2
	.long	0x8a4
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC12
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL70
	.long	0x489
	.long	0x8ce
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC13
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x3
	.quad	.LVL73
	.long	0x55c
	.long	0x8ed
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC8
	.byte	0
	.uleb128 0x10
	.quad	.LVL74
	.long	0x549
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x11
	.quad	.LVL20
	.long	0x9ff
	.uleb128 0x11
	.quad	.LVL72
	.long	0xbdd
	.byte	0
	.uleb128 0xa
	.long	0x92
	.long	0x92c
	.uleb128 0xb
	.long	0x3f
	.byte	0x20
	.byte	0
	.uleb128 0x27
	.long	.LASF95
	.byte	0x1
	.byte	0x41
	.byte	0x6
	.quad	.LFB10
	.quad	.LFE10-.LFB10
	.uleb128 0x1
	.byte	0x9c
	.long	0x95e
	.uleb128 0x10
	.quad	.LVL0
	.long	0x549
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x28
	.long	.LASF97
	.byte	0x1
	.byte	0x3a
	.byte	0x6
	.quad	.LFB9
	.quad	.LFE9-.LFB9
	.uleb128 0x1
	.byte	0x9c
	.long	0x9ff
	.uleb128 0x3
	.quad	.LVL1
	.long	0x5a3
	.long	0x99b
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC0
	.byte	0
	.uleb128 0x3
	.quad	.LVL2
	.long	0x5a3
	.long	0x9ba
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC1
	.byte	0
	.uleb128 0x3
	.quad	.LVL3
	.long	0x5a3
	.long	0x9d9
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC2
	.byte	0
	.uleb128 0x29
	.quad	.LVL4
	.long	0x525
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.quad	sst_initial_termios
	.byte	0
	.byte	0
	.uleb128 0x2a
	.long	.LASF98
	.byte	0x1
	.byte	0x1a
	.byte	0x6
	.long	.LLRL0
	.uleb128 0x1
	.byte	0x9c
	.long	0xbd2
	.uleb128 0x3
	.quad	.LVL5
	.long	0x5bb
	.long	0xa32
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x32
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x3
	.quad	.LVL6
	.long	0x5a3
	.long	0xa51
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC0
	.byte	0
	.uleb128 0x3
	.quad	.LVL7
	.long	0x5a3
	.long	0xa70
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC1
	.byte	0
	.uleb128 0x3
	.quad	.LVL8
	.long	0x5a3
	.long	0xa99
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC3
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x11
	.quad	.LVL9
	.long	0x58e
	.uleb128 0x3
	.quad	.LVL10
	.long	0x56f
	.long	0xac3
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL11
	.long	0x525
	.long	0xae5
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL12
	.long	0x508
	.long	0xb04
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	sst_cleanup_tui
	.byte	0
	.uleb128 0x3
	.quad	.LVL13
	.long	0x4e9
	.long	0xb21
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x3f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x3
	.quad	.LVL14
	.long	0x4e9
	.long	0xb3e
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x32
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0x2b
	.quad	.LVL15
	.long	0x4ce
	.long	0xb69
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x3
	.byte	0xa
	.value	0x5413
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.quad	sst_winsize
	.byte	0
	.uleb128 0x3
	.quad	.LVL16
	.long	0x55c
	.long	0xb88
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC4
	.byte	0
	.uleb128 0x3
	.quad	.LVL17
	.long	0x549
	.long	0xb9f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.uleb128 0x3
	.quad	.LVL18
	.long	0x55c
	.long	0xbbe
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x9
	.byte	0x3
	.quad	.LC6
	.byte	0
	.uleb128 0x10
	.quad	.LVL19
	.long	0x549
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x1
	.byte	0x31
	.byte	0
	.byte	0
	.uleb128 0x2c
	.long	.LASF103
	.long	.LASF104
	.byte	0x11
	.byte	0
	.uleb128 0x2d
	.long	.LASF105
	.long	.LASF105
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 12
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x37
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3e
	.uleb128 0x21
	.sleb128 7
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 14
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x15
	.byte	0
	.uleb128 0x27
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x87
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"",@progbits
	.long	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.value	0x5
	.byte	0x8
	.byte	0
	.long	0
.Ldebug_loc0:
.LVUS3:
	.uleb128 .LVU74
	.uleb128 .LVU86
	.uleb128 .LVU253
	.uleb128 0
	.uleb128 0
	.uleb128 .LVU255
.LLST3:
	.byte	0x6
	.quad	.LVL21
	.byte	0x4
	.uleb128 .LVL21-.LVL21
	.uleb128 .LVL25-.LVL21
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL72-.LVL21
	.uleb128 .LHOTE24-.LVL21
	.uleb128 0x1
	.byte	0x50
	.byte	0x8
	.quad	.LFSB11
	.uleb128 .LVL73-1-.LFSB11
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS4:
	.uleb128 .LVU77
	.uleb128 .LVU81
	.uleb128 .LVU81
	.uleb128 .LVU84
	.uleb128 .LVU84
	.uleb128 .LVU89
	.uleb128 .LVU91
	.uleb128 .LVU93
	.uleb128 .LVU96
	.uleb128 .LVU102
	.uleb128 .LVU102
	.uleb128 .LVU107
	.uleb128 .LVU107
	.uleb128 .LVU108
	.uleb128 .LVU108
	.uleb128 .LVU114
	.uleb128 .LVU114
	.uleb128 .LVU123
	.uleb128 .LVU130
	.uleb128 .LVU132
	.uleb128 .LVU138
	.uleb128 .LVU140
	.uleb128 .LVU146
	.uleb128 .LVU148
	.uleb128 .LVU154
	.uleb128 .LVU156
	.uleb128 .LVU162
	.uleb128 .LVU164
	.uleb128 .LVU170
	.uleb128 .LVU172
	.uleb128 .LVU178
	.uleb128 .LVU180
	.uleb128 .LVU186
	.uleb128 .LVU190
	.uleb128 .LVU190
	.uleb128 .LVU192
	.uleb128 .LVU192
	.uleb128 .LVU194
	.uleb128 .LVU194
	.uleb128 .LVU198
	.uleb128 .LVU198
	.uleb128 .LVU209
	.uleb128 .LVU209
	.uleb128 .LVU214
	.uleb128 .LVU214
	.uleb128 .LVU216
	.uleb128 .LVU216
	.uleb128 .LVU219
	.uleb128 .LVU222
	.uleb128 .LVU228
	.uleb128 .LVU228
	.uleb128 .LVU230
	.uleb128 .LVU230
	.uleb128 .LVU236
	.uleb128 .LVU236
	.uleb128 .LVU238
	.uleb128 .LVU238
	.uleb128 .LVU244
	.uleb128 .LVU244
	.uleb128 .LVU246
.LLST4:
	.byte	0x6
	.quad	.LVL22
	.byte	0x4
	.uleb128 .LVL22-.LVL22
	.uleb128 .LVL22-.LVL22
	.uleb128 0xe
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL22-.LVL22
	.uleb128 .LVL23-.LVL22
	.uleb128 0xe
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL23-.LVL22
	.uleb128 .LVL26-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL27-.LVL22
	.uleb128 .LVL28-.LVL22
	.uleb128 0x7
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL30-.LVL22
	.uleb128 0xf
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x73
	.sleb128 32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL30-.LVL22
	.uleb128 .LVL31-.LVL22
	.uleb128 0xf
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x74
	.sleb128 32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL31-.LVL22
	.uleb128 .LVL32-.LVL22
	.uleb128 0xf
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x73
	.sleb128 32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL32-.LVL22
	.uleb128 .LVL34-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x34
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL36-.LVL22
	.uleb128 .LVL38-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x35
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL38-.LVL22
	.uleb128 .LVL40-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x36
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL40-.LVL22
	.uleb128 .LVL42-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x37
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL42-.LVL22
	.uleb128 .LVL44-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x38
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL44-.LVL22
	.uleb128 .LVL46-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x39
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL46-.LVL22
	.uleb128 .LVL48-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x3a
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL48-.LVL22
	.uleb128 .LVL50-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x3b
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL50-.LVL22
	.uleb128 .LVL52-.LVL22
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x4
	.byte	0x3c
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x7
	.byte	0x4
	.uleb128 .LVL52-.LVL22
	.uleb128 .LVL53-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x34
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL53-.LVL22
	.uleb128 .LVL55-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x53
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL55-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0xd
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x51
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL56-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0xf
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x71
	.sleb128 32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x33
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL58-.LVL22
	.uleb128 0x10
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x71
	.sleb128 96
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x36
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL58-.LVL22
	.uleb128 .LVL58-.LVL22
	.uleb128 0x10
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x71
	.sleb128 96
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL58-.LVL22
	.uleb128 .LVL61-.LVL22
	.uleb128 0xe
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x31
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL63-.LVL22
	.uleb128 0xa
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x93
	.uleb128 0x4
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0xe
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL65-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0xa
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x93
	.uleb128 0x4
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL65-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0xe
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x33
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL67-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0xa
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x93
	.uleb128 0x4
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL67-.LVL22
	.uleb128 .LVL69-.LVL22
	.uleb128 0xe
	.byte	0x32
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0x34
	.byte	0x9f
	.byte	0x93
	.uleb128 0x1
	.byte	0x93
	.uleb128 0x3
	.byte	0x30
	.byte	0x9f
	.byte	0x93
	.uleb128 0x4
	.byte	0
.LVUS5:
	.uleb128 .LVU78
	.uleb128 .LVU85
	.uleb128 .LVU85
	.uleb128 .LVU89
	.uleb128 .LVU96
	.uleb128 .LVU97
	.uleb128 .LVU97
	.uleb128 .LVU102
	.uleb128 .LVU102
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 .LVU114
	.uleb128 .LVU114
	.uleb128 .LVU119
	.uleb128 .LVU119
	.uleb128 .LVU123
	.uleb128 .LVU124
	.uleb128 .LVU129
	.uleb128 .LVU129
	.uleb128 .LVU133
	.uleb128 .LVU133
	.uleb128 .LVU137
	.uleb128 .LVU137
	.uleb128 .LVU141
	.uleb128 .LVU141
	.uleb128 .LVU145
	.uleb128 .LVU145
	.uleb128 .LVU149
	.uleb128 .LVU149
	.uleb128 .LVU153
	.uleb128 .LVU153
	.uleb128 .LVU157
	.uleb128 .LVU157
	.uleb128 .LVU161
	.uleb128 .LVU161
	.uleb128 .LVU165
	.uleb128 .LVU165
	.uleb128 .LVU169
	.uleb128 .LVU169
	.uleb128 .LVU173
	.uleb128 .LVU173
	.uleb128 .LVU177
	.uleb128 .LVU177
	.uleb128 .LVU181
	.uleb128 .LVU181
	.uleb128 .LVU185
	.uleb128 .LVU185
	.uleb128 .LVU190
	.uleb128 .LVU190
	.uleb128 .LVU191
	.uleb128 .LVU191
	.uleb128 .LVU192
	.uleb128 .LVU192
	.uleb128 .LVU196
	.uleb128 .LVU197
	.uleb128 .LVU198
	.uleb128 .LVU198
	.uleb128 .LVU199
	.uleb128 .LVU204
	.uleb128 .LVU208
	.uleb128 .LVU208
	.uleb128 .LVU209
	.uleb128 .LVU209
	.uleb128 .LVU210
	.uleb128 .LVU215
	.uleb128 .LVU219
	.uleb128 .LVU222
	.uleb128 .LVU223
	.uleb128 .LVU223
	.uleb128 .LVU227
	.uleb128 .LVU227
	.uleb128 .LVU231
	.uleb128 .LVU231
	.uleb128 .LVU235
	.uleb128 .LVU235
	.uleb128 .LVU239
	.uleb128 .LVU239
	.uleb128 .LVU243
	.uleb128 .LVU243
	.uleb128 .LVU246
	.uleb128 .LVU247
	.uleb128 .LVU251
.LLST5:
	.byte	0x6
	.quad	.LVL22
	.byte	0x4
	.uleb128 .LVL22-.LVL22
	.uleb128 .LVL24-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL24-.LVL22
	.uleb128 .LVL26-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL31-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL31-.LVL22
	.uleb128 .LVL32-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL32-.LVL22
	.uleb128 .LVL33-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.LVL22
	.uleb128 .LVL34-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL34-.LVL22
	.uleb128 .LVL36-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL36-.LVL22
	.uleb128 .LVL38-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL22
	.uleb128 .LVL38-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL22
	.uleb128 .LVL40-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL40-.LVL22
	.uleb128 .LVL40-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL40-.LVL22
	.uleb128 .LVL42-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL42-.LVL22
	.uleb128 .LVL42-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL42-.LVL22
	.uleb128 .LVL44-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL44-.LVL22
	.uleb128 .LVL44-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL44-.LVL22
	.uleb128 .LVL46-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL46-.LVL22
	.uleb128 .LVL46-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL46-.LVL22
	.uleb128 .LVL48-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL48-.LVL22
	.uleb128 .LVL48-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL48-.LVL22
	.uleb128 .LVL50-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL22
	.uleb128 .LVL50-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL22
	.uleb128 .LVL52-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL22
	.uleb128 .LVL52-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL22
	.uleb128 .LVL53-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL53-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL56-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL56-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0x2
	.byte	0x32
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL58-.LVL22
	.uleb128 .LVL61-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL63-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL63-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL65-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL65-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL67-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL67-.LVL22
	.uleb128 .LVL69-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL69-.LVL22
	.uleb128 .LVL71-.LVL22
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS6:
	.uleb128 .LVU79
	.uleb128 .LVU85
	.uleb128 .LVU85
	.uleb128 .LVU86
	.uleb128 .LVU86
	.uleb128 .LVU89
	.uleb128 .LVU96
	.uleb128 .LVU98
	.uleb128 .LVU98
	.uleb128 .LVU102
	.uleb128 .LVU102
	.uleb128 .LVU103
	.uleb128 .LVU103
	.uleb128 .LVU107
	.uleb128 .LVU107
	.uleb128 .LVU108
	.uleb128 .LVU108
	.uleb128 .LVU110
	.uleb128 .LVU110
	.uleb128 .LVU114
	.uleb128 .LVU114
	.uleb128 .LVU115
	.uleb128 .LVU115
	.uleb128 .LVU120
	.uleb128 .LVU120
	.uleb128 .LVU122
	.uleb128 .LVU122
	.uleb128 .LVU123
	.uleb128 .LVU125
	.uleb128 .LVU127
	.uleb128 .LVU127
	.uleb128 .LVU128
	.uleb128 .LVU131
	.uleb128 .LVU132
	.uleb128 .LVU134
	.uleb128 .LVU136
	.uleb128 .LVU139
	.uleb128 .LVU140
	.uleb128 .LVU142
	.uleb128 .LVU144
	.uleb128 .LVU147
	.uleb128 .LVU148
	.uleb128 .LVU150
	.uleb128 .LVU152
	.uleb128 .LVU155
	.uleb128 .LVU156
	.uleb128 .LVU158
	.uleb128 .LVU160
	.uleb128 .LVU163
	.uleb128 .LVU164
	.uleb128 .LVU166
	.uleb128 .LVU168
	.uleb128 .LVU171
	.uleb128 .LVU172
	.uleb128 .LVU174
	.uleb128 .LVU176
	.uleb128 .LVU179
	.uleb128 .LVU180
	.uleb128 .LVU182
	.uleb128 .LVU184
	.uleb128 .LVU187
	.uleb128 .LVU190
	.uleb128 .LVU190
	.uleb128 .LVU192
	.uleb128 .LVU192
	.uleb128 .LVU193
	.uleb128 .LVU193
	.uleb128 .LVU194
	.uleb128 .LVU194
	.uleb128 .LVU196
	.uleb128 .LVU198
	.uleb128 .LVU199
	.uleb128 .LVU199
	.uleb128 .LVU205
	.uleb128 .LVU205
	.uleb128 .LVU207
	.uleb128 .LVU207
	.uleb128 .LVU209
	.uleb128 .LVU209
	.uleb128 .LVU210
	.uleb128 .LVU210
	.uleb128 .LVU214
	.uleb128 .LVU214
	.uleb128 .LVU217
	.uleb128 .LVU217
	.uleb128 .LVU218
	.uleb128 .LVU218
	.uleb128 .LVU219
	.uleb128 .LVU224
	.uleb128 .LVU226
	.uleb128 .LVU229
	.uleb128 .LVU230
	.uleb128 .LVU232
	.uleb128 .LVU234
	.uleb128 .LVU237
	.uleb128 .LVU238
	.uleb128 .LVU240
	.uleb128 .LVU242
	.uleb128 .LVU245
	.uleb128 .LVU246
	.uleb128 .LVU248
	.uleb128 .LVU250
	.uleb128 .LVU250
	.uleb128 .LVU251
.LLST6:
	.byte	0x6
	.quad	.LVL22
	.byte	0x4
	.uleb128 .LVL22-.LVL22
	.uleb128 .LVL24-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL24-.LVL22
	.uleb128 .LVL25-.LVL22
	.uleb128 0xc
	.byte	0x73
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL25-.LVL22
	.uleb128 .LVL26-.LVL22
	.uleb128 0xf
	.byte	0x73
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0xf
	.byte	0x73
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL29-.LVL22
	.uleb128 0xc
	.byte	0x73
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL29-.LVL22
	.uleb128 .LVL30-.LVL22
	.uleb128 0xf
	.byte	0x73
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL30-.LVL22
	.uleb128 .LVL31-.LVL22
	.uleb128 0xf
	.byte	0x74
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL31-.LVL22
	.uleb128 .LVL31-.LVL22
	.uleb128 0xf
	.byte	0x73
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL31-.LVL22
	.uleb128 .LVL32-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL32-.LVL22
	.uleb128 .LVL32-.LVL22
	.uleb128 0xb
	.byte	0x74
	.sleb128 -1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL32-.LVL22
	.uleb128 .LVL33-.LVL22
	.uleb128 0xe
	.byte	0x74
	.sleb128 -1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.LVL22
	.uleb128 .LVL33-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.LVL22
	.uleb128 .LVL34-.LVL22
	.uleb128 0xb
	.byte	0x74
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x4b
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL34-.LVL22
	.uleb128 .LVL35-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL35-.LVL22
	.uleb128 .LVL36-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL37-.LVL22
	.uleb128 .LVL38-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL38-.LVL22
	.uleb128 .LVL38-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL39-.LVL22
	.uleb128 .LVL40-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL40-.LVL22
	.uleb128 .LVL40-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL41-.LVL22
	.uleb128 .LVL42-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL42-.LVL22
	.uleb128 .LVL42-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL43-.LVL22
	.uleb128 .LVL44-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL44-.LVL22
	.uleb128 .LVL44-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL45-.LVL22
	.uleb128 .LVL46-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL46-.LVL22
	.uleb128 .LVL46-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL47-.LVL22
	.uleb128 .LVL48-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL48-.LVL22
	.uleb128 .LVL48-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL49-.LVL22
	.uleb128 .LVL50-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL50-.LVL22
	.uleb128 .LVL50-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL51-.LVL22
	.uleb128 .LVL52-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL52-.LVL22
	.uleb128 .LVL53-.LVL22
	.uleb128 0xb
	.byte	0x74
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x4b
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL53-.LVL22
	.uleb128 .LVL54-.LVL22
	.uleb128 0xc
	.byte	0x73
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL54-.LVL22
	.uleb128 .LVL55-.LVL22
	.uleb128 0xf
	.byte	0x73
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL55-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0xf
	.byte	0x71
	.sleb128 -97
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL56-.LVL22
	.uleb128 .LVL56-.LVL22
	.uleb128 0xc
	.byte	0x71
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL56-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0xf
	.byte	0x71
	.sleb128 -65
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0xb
	.byte	0x74
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x4b
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL57-.LVL22
	.uleb128 0xb
	.byte	0x71
	.sleb128 -1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL57-.LVL22
	.uleb128 .LVL58-.LVL22
	.uleb128 0xe
	.byte	0x71
	.sleb128 -1
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x49
	.byte	0x2c
	.byte	0x70
	.sleb128 0
	.byte	0x1a
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL58-.LVL22
	.uleb128 .LVL59-.LVL22
	.uleb128 0xb
	.byte	0x74
	.sleb128 0
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x4b
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL59-.LVL22
	.uleb128 .LVL60-1-.LVL22
	.uleb128 0xa
	.byte	0x76
	.sleb128 0
	.byte	0x94
	.byte	0x1
	.byte	0x4b
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL60-.LVL22
	.uleb128 .LVL61-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL63-.LVL22
	.uleb128 .LVL63-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL64-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL65-.LVL22
	.uleb128 .LVL65-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL66-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL67-.LVL22
	.uleb128 .LVL67-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL68-.LVL22
	.uleb128 .LVL69-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL69-.LVL22
	.uleb128 .LVL70-.LVL22
	.uleb128 0x2
	.byte	0x31
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL70-.LVL22
	.uleb128 .LVL71-.LVL22
	.uleb128 0xb
	.byte	0x70
	.sleb128 0
	.byte	0x8
	.byte	0x20
	.byte	0x24
	.byte	0x30
	.byte	0x29
	.byte	0x8
	.byte	0xff
	.byte	0x1a
	.byte	0x9f
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",@progbits
	.long	0x4c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	.Ltext_cold0
	.quad	.Letext_cold0-.Ltext_cold0
	.quad	.LFB11
	.quad	.LHOTE24-.LFB11
	.quad	0
	.quad	0
	.section	.debug_rnglists,"",@progbits
.Ldebug_ranges0:
	.long	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.value	0x5
	.byte	0x8
	.byte	0
	.long	0
.LLRL0:
	.byte	0x7
	.quad	.LFB8
	.uleb128 .LHOTE7-.LFB8
	.byte	0x7
	.quad	.LFSB8
	.uleb128 .LCOLDE7-.LFSB8
	.byte	0
.LLRL1:
	.byte	0x7
	.quad	.LFB11
	.uleb128 .LHOTE24-.LFB11
	.byte	0x7
	.quad	.LFSB11
	.uleb128 .LCOLDE24-.LFSB11
	.byte	0
.LLRL2:
	.byte	0x5
	.quad	.LBB2
	.byte	0x4
	.uleb128 .LBB2-.LBB2
	.uleb128 .LBE2-.LBB2
	.byte	0x4
	.uleb128 .LBB3-.LBB2
	.uleb128 .LBE3-.LBB2
	.byte	0x4
	.uleb128 .LBB4-.LBB2
	.uleb128 .LBE4-.LBB2
	.byte	0x4
	.uleb128 .LBB5-.LBB2
	.uleb128 .LBE5-.LBB2
	.byte	0x7
	.quad	.LBB6
	.uleb128 .LBE6-.LBB6
	.byte	0
.LLRL7:
	.byte	0x7
	.quad	.Ltext0
	.uleb128 .Letext0-.Ltext0
	.byte	0x7
	.quad	.Ltext_cold0
	.uleb128 .Letext_cold0-.Ltext_cold0
	.byte	0x7
	.quad	.LFB11
	.uleb128 .LHOTE24-.LFB11
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF32:
	.string	"c_ospeed"
.LASF58:
	.string	"_wide_data"
.LASF31:
	.string	"c_ispeed"
.LASF34:
	.string	"_IO_FILE"
.LASF29:
	.string	"c_line"
.LASF46:
	.string	"_IO_save_end"
.LASF30:
	.string	"c_cc"
.LASF7:
	.string	"short int"
.LASF14:
	.string	"size_t"
.LASF85:
	.string	"atexit"
.LASF56:
	.string	"_offset"
.LASF18:
	.string	"ws_ypixel"
.LASF96:
	.string	"main"
.LASF40:
	.string	"_IO_write_ptr"
.LASF35:
	.string	"_flags"
.LASF42:
	.string	"_IO_buf_base"
.LASF82:
	.string	"strncmp"
.LASF98:
	.string	"sst_init_tui"
.LASF47:
	.string	"_markers"
.LASF37:
	.string	"_IO_read_end"
.LASF60:
	.string	"_freeres_buf"
.LASF73:
	.string	"SST_ALPHA"
.LASF91:
	.string	"setvbuf"
.LASF22:
	.string	"tcflag_t"
.LASF28:
	.string	"c_lflag"
.LASF81:
	.string	"SST_Key"
.LASF93:
	.string	"matches"
.LASF83:
	.string	"read"
.LASF33:
	.string	"long long int"
.LASF95:
	.string	"sst_kill_tui"
.LASF11:
	.string	"__ssize_t"
.LASF55:
	.string	"_lock"
.LASF90:
	.string	"printf"
.LASF69:
	.string	"sst_initial_termios"
.LASF52:
	.string	"_cur_column"
.LASF102:
	.string	"perror"
.LASF24:
	.string	"termios"
.LASF61:
	.string	"__pad5"
.LASF39:
	.string	"_IO_write_base"
.LASF87:
	.string	"exit"
.LASF89:
	.string	"fflush"
.LASF51:
	.string	"_old_offset"
.LASF21:
	.string	"speed_t"
.LASF2:
	.string	"unsigned char"
.LASF19:
	.string	"__sighandler_t"
.LASF6:
	.string	"signed char"
.LASF57:
	.string	"_codecvt"
.LASF13:
	.string	"ssize_t"
.LASF27:
	.string	"c_cflag"
.LASF80:
	.string	"type"
.LASF23:
	.string	"winsize"
.LASF4:
	.string	"unsigned int"
.LASF65:
	.string	"_IO_marker"
.LASF54:
	.string	"_shortbuf"
.LASF70:
	.string	"sst_current_termios"
.LASF79:
	.string	"SST_Mod"
.LASF16:
	.string	"ws_col"
.LASF48:
	.string	"_chain"
.LASF63:
	.string	"_unused2"
.LASF105:
	.string	"__stack_chk_fail"
.LASF36:
	.string	"_IO_read_ptr"
.LASF72:
	.string	"SST_NONE"
.LASF43:
	.string	"_IO_buf_end"
.LASF74:
	.string	"SST_FUNCTION"
.LASF17:
	.string	"ws_xpixel"
.LASF12:
	.string	"char"
.LASF94:
	.string	"signal"
.LASF75:
	.string	"SST_KeyType"
.LASF77:
	.string	"SST_ALT"
.LASF25:
	.string	"c_iflag"
.LASF59:
	.string	"_freeres_list"
.LASF20:
	.string	"cc_t"
.LASF99:
	.string	"GNU C99 13.2.1 20230801 -mtune=generic -march=x86-64 -ggdb -O3 -std=c99"
.LASF104:
	.string	"__builtin_strcmp"
.LASF64:
	.string	"FILE"
.LASF3:
	.string	"short unsigned int"
.LASF26:
	.string	"c_oflag"
.LASF5:
	.string	"long unsigned int"
.LASF41:
	.string	"_IO_write_end"
.LASF10:
	.string	"__off64_t"
.LASF49:
	.string	"_fileno"
.LASF92:
	.string	"seq_index"
.LASF88:
	.string	"tcgetattr"
.LASF62:
	.string	"_mode"
.LASF86:
	.string	"tcsetattr"
.LASF9:
	.string	"__off_t"
.LASF45:
	.string	"_IO_backup_base"
.LASF103:
	.string	"strcmp"
.LASF97:
	.string	"sst_cleanup_tui"
.LASF50:
	.string	"_flags2"
.LASF66:
	.string	"_IO_codecvt"
.LASF38:
	.string	"_IO_read_base"
.LASF15:
	.string	"ws_row"
.LASF101:
	.string	"__sysv_signal"
.LASF71:
	.string	"sst_winsize"
.LASF53:
	.string	"_vtable_offset"
.LASF76:
	.string	"SST_SHIFT"
.LASF44:
	.string	"_IO_save_base"
.LASF8:
	.string	"long int"
.LASF84:
	.string	"ioctl"
.LASF67:
	.string	"_IO_wide_data"
.LASF78:
	.string	"SST_CONTROL"
.LASF68:
	.string	"stdout"
.LASF100:
	.string	"_IO_lock_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/aaron/Code/swir-editor"
.LASF0:
	.string	"main.c"
	.ident	"GCC: (GNU) 13.2.1 20230801"
	.section	.note.GNU-stack,"",@progbits
