#include "./lib/queue.h"
#include "./lib/dtable.h"
#define MAILBOX_END 0x1FFFF474
#define SYSTEM_TIMER_BASE 0x7E003000
#define SYSTEM_TIMER_CL_OFFSET 0x4
#define SYSTEM_TIMER_C0_OFFSET 0xc
#define RR_QUANTOM_TIME 200

extern void restore_context(PCB_t *context);
extern void save_context(ubyte_t id);

volatile PCB_t *pcb_dtable = 0x1FFFFF24;
volatile PCB_t **created_tasks_queue = 0x1FFFF922;
volatile PCB_t **ready_tasks_queue = 0x1FFFF7F7;
volatile PCB_t **waiting_tasks_queue = 0x1FFFF6CB;
volatile PCB_t **terminated_tasks_queue = 0x1FFFF59F;

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
volatile ubyte_t *cur_running_task_id = 0x1FFFF473;

void timer_set(unsigned int value);
void terminate_task(ubyte_t id);
void schaduler();

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

void schaduler()
{
    __asm__("stmfd r13!,{r0-r3,lr}");
    save_context(*cur_running_task_id);

    *created_tasks_queue_len = 0;
    *ready_tasks_queue_len = 0;
    *waiting_tasks_queue_len = 0;
    *terminated_tasks_queue_len = 0;

    PCB_t *cur_running_task;
    for (unsigned int i = *pcb_dtable_len; i != -1; i--)
    {
        if (pcb_dtable[i].id == *cur_running_task_id)
        {
            cur_running_task = &pcb_dtable[i];
            break;
        }
    }
    cur_running_task->status = 2;

    for (unsigned int i = *pcb_dtable_len; i != -1; i--)
    {
        switch (pcb_dtable[i].status)
        {
        case 0:
            created_tasks_queue[*created_tasks_queue_len] = &pcb_dtable[i];
            *created_tasks_queue_len++;
            break;
        case 1:
            ready_tasks_queue[*ready_tasks_queue_len] = &pcb_dtable[i];
            (*ready_tasks_queue_len)++;
            break;
        case 2:
            *cur_running_task_id = pcb_dtable[i].id;
            break;
        default:
            terminated_tasks_queue[*terminated_tasks_queue_len] = pcb_dtable[i].id;
            *terminated_tasks_queue_len++;
            break;
        }
    }

    if (*created_tasks_queue_len)
    {
        push_back(*created_tasks_queue[0], ready_tasks_queue, *ready_tasks_queue_len);
        remove_task_idx(0, created_tasks_queue, *created_tasks_queue_len);
        *created_tasks_queue_len--;
        *ready_tasks_queue_len++;
    }

    if (*ready_tasks_queue_len)
    {
        *cur_running_task_id = ready_tasks_queue[0]->id;
        cur_running_task = ready_tasks_queue[0];
        remove_task_idx(0, ready_tasks_queue, *ready_tasks_queue_len);
        *ready_tasks_queue_len--;
    }

    if (*terminated_tasks_queue_len)
    {
        terminate_task(terminated_tasks_queue[0]->id);
        remove_task_idx(0, terminated_tasks_queue, *terminated_tasks_queue_len);
        *terminated_tasks_queue_len--;
    }

    timer_set(RR_QUANTOM_TIME);
    restore_context(cur_running_task);
}

void terminate_task(ubyte_t id)
{
    int idx = -1;
    for (unsigned int i = *pcb_dtable_len; i != -1; i--)
    {
        if (pcb_dtable[i].id == id)
        {
            idx = i;
            break;
        }
    }
    if (idx == -1)
        return;

    for (unsigned int i = *mailboxes_len; i != -1; i--)
    {
        if (mailboxes_dtable[i].owner_id == id)
        {
            mailboxes_dtable_remove_idx(mailboxes_dtable, *mailboxes_len, i);
            *mailboxes_len--;
        }
    }

    dtable_remove_idx(pcb_dtable, *pcb_dtable_len, idx);
}

void timer_set(unsigned int value)
{
    volatile unsigned int *system_timer_cl = SYSTEM_TIMER_BASE + SYSTEM_TIMER_CL_OFFSET;
    volatile unsigned int *system_timer_c0 = SYSTEM_TIMER_BASE + SYSTEM_TIMER_C0_OFFSET;
    *system_timer_c0 = (*system_timer_cl + value);
}