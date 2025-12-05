#ifndef QUEUE_H
#define QUEUE_H
#include "./types.h"

void push_forward(PCB_t *task, PCB_t **tasks, int queue_len);
void push_back(PCB_t *task, PCB_t **tasks, int queue_len);
int remove_task(int idx, PCB_t **tasks, int queue_len);
int remove_task(PCB_t *task, PCB_t **tasks, int queue_len);
#endif