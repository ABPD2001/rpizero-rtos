#include "./queue.h"

void push_forward(PCB_t *task, PCB_t **tasks, int queue_len)
{
    for (unsigned int i = queue_len; i != -1; i--)
    {
        tasks[i + 1] = tasks[i];
    }
    tasks[0] = task;
}

void push_back(PCB_t *task, PCB_t **tasks, int queue_len)
{
    tasks[queue_len] = task;
}

int remove_task(int idx, PCB_t **tasks, int queue_len)
{
    if (idx > queue_len - 1)
        return -1;
    for (unsigned int i = idx; i != queue_len - 1; i++)
    {
        tasks[i] = tasks[i + 1];
    }
    return 0;
}

int remove_task(PCB_t *task, PCB_t **tasks, int queue_len)
{
    int idx = -1;
    for (unsigned int i = queue_len; i != -1; i--)
    {
        if (tasks[i]->id == task->id)
        {
            idx = i;
            break;
        }
    }
    if (idx == -1)
        return -1;
    for (unsigned int i = idx; i != queue_len - 1; i++)
    {
        tasks[i] = tasks[i + 1];
    }

    return idx;
}