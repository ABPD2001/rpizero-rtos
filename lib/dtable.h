#ifndef DTABLE_H
#define DTABLE_H
#include "./types.h"

void dtable_remove_idx(PCB_t *tasks, unsigned int len, unsigned int idx);
int dtable_remove(PCB_t *tasks, PCB_t *tasks_dtable, unsigned int tasks_dtable_len, unsigned int len, ubyte_t id);

void mailboxes_dtable_remove_idx(mailbox_t *mailboxes, unsigned int len, unsigned int idx);
void mailboxes_dtable_remove(mailbox_t *mailboxes, unsigned int len, ubyte_t id);
#endif