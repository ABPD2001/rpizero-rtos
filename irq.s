.section .irq_table
.org 0x00 ldr pc, =irq_task_timer_handler
.org 0x04 ldr pc, =irq_uart_overrun
.org 0x08 ldr pc, =irq_uart_buffer
.org 0x0C ldr pc, =irq_uart_tx_ready
.org 0x10 ldr pc, =irq_void_irq
.org 0x14 ldr pc, =irq_unknown
    
.section .irq_routines
