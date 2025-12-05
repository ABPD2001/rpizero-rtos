#include "./lib/queue.h"
#define MAILBOX_END 0x1FFFF474
#define SYSTEM_TIMER_BASE 0x7E003000
#define SYSTEM_TIMER_CL_OFFSET 0x4
#define SYSTEM_TIMER_C0_OFFSET 0xc
#define RR_QUANTOM_TIME 200

volatile PCB_t *pcb_dtable = 0x1FFFFF24;
volatile PCB_t *created_tasks_queue = 0x1FFFF922;
volatile PCB_t *ready_tasks_queue = 0x1FFFF7F7;
volatile PCB_t *waiting_tasks_queue = 0x1FFFF6CB;
volatile PCB_t *terminated_tasks_queue = 0x1FFFF59F;

volatile mailbox_t *mailboxes_dtable = 0x20000000;

volatile unsigned int *pcb_dtable_len = 0x1FFFF473;
volatile unsigned int *created_tasks_queue_len = 0x1FFFF46B;
volatile unsigned int *ready_tasks_queue_len = 0x1FFFF467;
volatile unsigned int *waiting_tasks_queue_len = 0x1FFFF463;
volatile unsigned int *terminated_tasks_queue_len = 0x1FFFF45F;

volatile unsigned int *mailboxes_len = 0x1FFFF45B;

volatile ubyte_t **mini_uart_buffer = 0x1FFFFB24;
volatile unsigned int *mini_uart_buffer_len = 0x1FFFF46E;
volatile ubyte_t *uart_allocation = 0x1FFFF924;
volatile ubyte_t *irq_void = 0x1FFFF293;
volatile ubyte_t cur_running_task_id = 0x1FFFF473;

void timer_set(unsigned int value);

void kernel()
{
    *mini_uart_buffer_len = 0;
    *pcb_dtable_len = 0;
    *created_tasks_queue_len = 0;
    *ready_tasks_queue_len = 0;
    *waiting_tasks_queue_len = 0;
    *terminated_tasks_queue_len = 0;
    *mailboxes_len = 0;

    timer_set(RR_QUANTOM_TIME);
}

void timer_set(unsigned int value)
{
    volatile unsigned int *system_timer_cl = SYSTEM_TIMER_BASE + SYSTEM_TIMER_CL_OFFSET;
    volatile unsigned int *system_timer_c0 = SYSTEM_TIMER_BASE + SYSTEM_TIMER_C0_OFFSET;
    *system_timer_c0 = (*system_timer_cl + value);
}