.section .irq_table
.org 0x00 ldr pc, =irq_task_timer
.org 0x04 ldr pc, =irq_uart_overrun
.org 0x08 ldr pc, =irq_uart_buffer
.org 0x0C ldr pc, =irq_uart_tx_ready
.org 0x10 ldr pc, =irq_void_irq
.org 0x14 ldr pc, =irq_unknown
    
.section .irq_routines
.eq CREATED_TASKS_QUEUE #0x1FFFF922 
.eq READY_TASKS_QUEUE #0x1FFFF7F7
.eq WAITING_TASKS_QUEUE #0x1FFFF6CB
.eq TERMINATED_TASKS_QUEUE #0x1FFFF59F

.eq CREATED_TASKS_QUEUE_LEN #0x1FFFF46B
.eq READY_TASKS_QUEUE_LEN #0x1FFFF467
.eq WAITING_TASKS_QUEUE_LEN #0x1FFFF463
.eq TERMINATED_TASKS_QUEUE_LEN #0x1FFFF45F

.eq PCB_DTABLE_LEN #0x1FFFF473

irq_task_timer:
    ldmfd r0!,{lr}
    stmfd r13!,{lr}
    bl schaduler
    ldmfd r13!,{lr}
    mov pc,lr
