.section .text
.eq PCB_DTABLE #0x1FFFFF24

restore_context:
    add r0,r0,#66
    ldmfd r0,{r3,r2,r1,lr,r2,r4}
    sub r0,r0,#66

    sub r13,r13,#4
    stmfd r13!,{r4,r1,r2,r3}

    mov r2,r0
    ldmfd r2,{r0,r1,r3-r11}
    ldmfd r13!,{r12}
    mrs r12,spsr_svc
    ldmfd r13!,{r13,r12,pc}^

save_context_loop:
    add r2,r2,#80
    ldr r3,[r2]
    cmp r3,r0
    subeq r0,r3,#76
    moveq pc,lr
    bne save_context_loop

save_context:
    msr spsr_svc,r1
    mov r2,=PCB_DTABLE
    bl save_context_loop
    stmfd r13!,{lr}
    str r1,[r0,#72]
    ldmfd r13!,{r1}
    str lr,[r0,#60]
    str r12,[r0,#68]
    stmfd r0,{r0-r11}
    ldmfd r13!,{lr}
    mov pc,lr