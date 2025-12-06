#include "./dtable.h"

void dtable_remove_idx(PCB_t *tasks, unsigned int len, unsigned int idx)
{
    for (unsigned int i = idx; i != len - 2; i++)
    {
        tasks[i] = tasks[i + 1];
    }
}
int dtable_remove(PCB_t *tasks, PCB_t *tasks_dtable, unsigned int tasks_dtable_len, unsigned int len, ubyte_t id)
{
    int idx = -1;
    for (unsigned int i = tasks_dtable_len - 1; i != -1; i--)
    {
        if (tasks_dtable[i].id == id)
        {
            idx = i;
            break;
        }
    }

    if (idx == -1)
        return idx;
    for (unsigned int i = idx; i != len - 2; i++)
    {
        tasks[i] = tasks[i + 1];
    }

    return idx;
}

void mailboxes_dtable_remove_idx(mailbox_t *mailboxes, unsigned int len, unsigned int idx)
{
    for (unsigned int i = idx; i != len - 2; i++)
    {
        mailboxes[i] = mailboxes[i + 1];
    }
}
int mailboxes_dtable_remove(mailbox_t *mailboxes, unsigned int len, ubyte_t id)
{
    int idx = -1;
    for (unsigned int i = len - 1; i != -1; i--)
    {
        if (mailboxes[i].id == id)
        {
            idx = i;
            break;
        }
    }

    if (idx == -1)
        return idx;
    for (unsigned int i = idx; i != len - 2; i++)
    {
        mailboxes[i] = mailboxes[i + 1];
    }

    return idx;
}