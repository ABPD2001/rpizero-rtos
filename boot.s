.section .vectors
.org 0x00 ldr pc, =reset_handler
.org 0x08 ldr pc, =swi_handler
.org 0x18 ldr pc, =irq_handler

.section .vector_handlers
.eq SVC_STACK #0x2044
.eq IRQ_STACK #0x9284

.eq SVC_STACK_OVERFLOW #0x76
.eq IRQ_STACK_OVERFLOW #0x2044

.eq PROCESSOR_CLR_MASK #0xE0
.eq PROCESSOR_IRQ_MASK #0x12
.eq PROCESSOR_SVC_MASK #0x13
.eq PROCESSOR_USR_MASK #0x1F

.eq PROCESSOR_ENABLE_IRQ #0x8F

.eq SWI_TABLE #0x2C
.eq IRQ_TABLE #0x20

.eq SYSTEM_TIMER_BASE #0x7E003000
.eq SYSTEM_TIMER_CS_OFFSET #0x0
.eq MINI_UART_BASE #0x7E21
.eq MINI_UART_ENABLE_OFFSET #0x5004
.eq MINI_UART_STAT_OFFSET #0x5064
.eq MINI_UART_IER_OFFSET #0x5048

.eq UART_BUFFER #0x1FFFFB24
.eq UART_BUFFER_LEN #0x1FFFF46E

reset_handler: 
    @ 44 bytes
    msr cpsr_c, r0
    and r0,r0,=PROCESSOR_CLR_MASK
    orr r0,r0,=PROCESSOR_IRQ_MASK
    mrs r0,cpsr_c

    mov r13,=IRQ_STACK
    msr cpsr_c,r0
    and r0,r0,=PROCESSOR_CLR_MASK
    orr r0,r0,=PROCESSOR_SVC_MASK
    mrs r0,cpsr_c
    mov r13,=SVC_STACK
    
    b kernel

irq_source_search:
    @ 126 bytes
    stmfd r13!, {lr}

    ldr lr, [=SYSTEM_TIMER_BASE,=SYSTEM_TIMER_CS_OFFSET] @ task timer
    and lr,lr,#0x0001
    cmp lr,#1
    moveq r1,#0
    ldreq pc,[r13]

    ldr lr,[=MINI_UART_BASE,=MINI_UART_STAT_OFFSET] @ mini uart overrun
    and lr,lr,0x0010
    cmp lr,#0x0010
    moveq r1,#1 
    ldreq pc,[r13]

    ldr lr,[=UART_BUFFER_LEN] @ mini uart buffer full
    cmp lr,#2040
    movge r1,#2
    ldrge pc,[r13]

    ldr lr,[=MINI_UART_BASE,=MINI_UART_IER_OFFSET] @ mini uart receive
    and lr,lr,#0x0006
    cmp lr,#0x0004
    moveq r1,#3
    ldreq pc,[r13]

    cmp lr,#0x0002 @ mini uart tx ready
    moveq r1,#4
    ldreq pc,[r13]
    
    ldrb lr,[=VOID_IRQ] @ void irq
    cmp lr,#0
    movge r1,#5
    ldrge pc,[r13]

    mov r1,#6 @ unknown irq
    ldr pc,[r13]

irq_handler:
    @ 56 bytes
    subs lr,lr,#4
    stmfd r13!,{lr}
    msr spsr_irq, lr
    stmfd r13!,{lr,r0,r1}
    mov r0,r13
    msr cpsr_c, lr

    and lr,lr,=PROCESSOR_CLR_MASK
    and lr,lr,=PROCESSOR_ENABLE_IRQ
    orr lr,lr,=PROCESSOR_SVC_MASK
    mrs lr,cpsr_c
    
    bl irq_source_search
    
    str r1,[r13,#4]
    ldmfd r0,[r1,r0]
    ldr pc,[=IRQ_TABLE,lr]
    
swi_handler:
    @ 28 bytes
    str r0,[r13]
    
    and r0,lr,#0x000F
    mul r0,r0,#4
    add r0,r0,=SWI_TABLE

    str r0,[r13,#4]
    ldr r0,[r13]
    ldr pc,[r13,#4]