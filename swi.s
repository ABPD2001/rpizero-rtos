.section .swi_table
.org 0x00 ldr pc, =swi_uart_enable
.org 0x04 ldr pc, =swi_uart_status
.org 0x08 ldr pc, =swi_write_uart
.org 0x0C ldr pc, =swi_read_uart
.org 0x10 ldr pc, =swi_read_uart_buffer
.org 0x14 ldr pc, =swi_flush_uart_buffer
.org 0x18 ldr pc, =swi_uart_settings
.org 0x1C ldr pc, =swi_terminate_task
.org 0x20 ldr pc, =swi_mailbox_creation
.org 0x24 ldr pc, =swi_mailbox_settings
.org 0x28 ldr pc, =swi_void

.section .swi_routines
.eq UART_BUFFER #0x1FFFFB24
.eq UART_BUFFER_LEN #0x1FFFF46E
.eq UART_ALLOC #0x1FFFF924

.eq UART_BASE #0x7E21
.eq UART_AUX_MO_OFFSET #0x5040
.eq UART_MU_BAUD_OFFSET #0x5068
.eq UART_LCR_OFFSET #0x504C
.eq UART_CNTL_OFFSET #0x5060
.eq UART_IIR_OFFSET #0x5044

swi_uart_enable:
    ldrb r0,[=UART_ALLOC]
    and r2,r0,#0x03
    cmp r2,#0x03

    movne r1,#1
    movne pc,lr

    mov r1,#0
    mov r2,#0x0
    strb r2,[=UART_ALLOC]
    ldr r2,[=UART_BASE,=UART_LCR_OFFSET]
    and r2,r2,#0xFFF7
    str r2,[=UART_BASE,=UART_LCR_OFFSET]

    ldr r0,[=UART_BASE,#0x7E21]
    orr r0,r0,#0x0001
    str r0,[=UART_BASE,#0x7E21]

    mov r2,#0x03
    strb r2,[=UART_ALLOC]

    mov pc,lr

swi_uart_status:
    # nothing...

swi_read_uart:
    ldrb r0,[=UART_ALLOC]
    and r2,r0,#0x01
    cmp r0,#0x01

    movle r1,#1
    movle pc,lr
    mov r1,#0

    mov r2,r0
    and r2,r2,#0xFE
    strb r2,[=UART_ALLOC]     

    ldr r0,[=UART_BASE,=UART_AUX_MO_OFFSET]
    and r0,r0,#0x000F

    orr r2,r2,#0x01
    strb r2,[=UART_ALLOC]
    
    mov pc,lr

swi_write_uart:
    mov r0,r3
    ldrb r0,[=UART_ALLOC]
    and r2,r0,#0x02
    cmp r2,#0x02

    movne r1,#1
    movne pc,lr
    mov r1,#0
    and r2,r0,#0xFD

    strb r2,[=UART_ALLOC]
    and r3,r3,#0x000F
    str r3,[=UART_BASE,=UART_AUX_MO_OFFSET]

    ldrb r2,[=UART_ALLOC]
    orr r2,r2,#0x02
    strb r2,[=UART_ALLOC]

    mov pc,lr

swi_read_uart_buffer:
    ldrb r0,[=UART_ALLOC]
    and r2,r0,#0x01
    cmp r2,#0x01

    movne r2,#1
    movne pc,lr

    ldrb r2,[=UART_ALLOC]
    and r2,#0x0E
    strb r2,[=UART_ALLOC]

    mov r0,=UART_BUFFER
    mov r1,=UART_BUFFER_LEN

    orr r2,#0x01
    strb r2,[=UART_ALLOC]
    mov r2,#0

    mov pc,lr

swi_flush_uart_buffer:
    ldrb r0,[=UART_ALLOC]
    and r2,r0,#0x03
    cmp r2,#0x03

    movne r2,#0
    movne pc,lr

    mov r2,#0x00
    strb r2,[=UART_ALLOC]
    strb r2,[=UART_BUFFER]

    mov r2,#0x03
    strb r2,[=UART_ALLOC]

    mov pc,lr

swi_uart_settings:
    ldrb r1,[=UART_ALLOC]
    and r2,r1,#0x03
    cmp r2,#0x03
    mov r1,#0x00
    strb r1,[=UART_ALLOC]

    movne r1,#1
    movne pc,lr

    mov r1,#0

    ldrh r2,[r0]
    cmp r2,#0
    ldreq r2,[=UART_BASE,=UART_MU_BAUD_OFFSET]
    str r2,[=UART_BASE,=UART_MU_BAUD_OFFSET]

    ldrb r2,[r0,#2]
    and r2,r2,#0x01
    ldr r3,[=UART_BASE,=UART_LCR_OFFSET]
    and r3,r3,#0xFFFE
    orr r2,r3,r2
    str r2,[=UART_LCR_OFFSET]

    ldrb r2,[r0,#3]
    and r2,r2,#0x03
    ldr r3,[=UART_BASE,=UART_CNTL_OFFSET]
    and r3,r3,#0xFFFC
    orr r2,r3,r2
    str r2,[=UART_BASE,=UART_CNTL_OFFSET]

    ldrb r2,[r0,#4]
    and r2,r2,#0x03
    ldr r3,[=UART_BASE,=UART_IIR_OFFSET]
    and r3,r3,#0xFFFC
    orr r2,r3,r2
    str r2,[=UART_BASE,=UART_IIR_OFFSET]

    mov r2,#0x03
    strb r2,[=UART_ALLOC]
    mov pc,lr

swi_void:
    mov pc,lr