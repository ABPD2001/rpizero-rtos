.section .swi_table
.org 0x00 ldr pc, =swi_uart_enable
.org 0x04 ldr pc, =swi_status
.org 0x08 ldr pc, =swi_write_uart
.org 0x0C ldr pc, =swi_read_uart
.org 0x10 ldr pc, =swi_read_uart_buffer
.org 0x14 ldr pc, =swi_flush_uart_buffer
.org 0x18 ldr pc, =swi_terminate_task
.org 0x1C ldr pc, =swi_mailbox_creation
.org 0x20 ldr pc, =swi_mailbox_settings
.org 0x24 ldr pc, =swi_void

.section .swi_routines