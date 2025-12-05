#ifndef TYPE_H
#define TYPE_H
typedef unsigned char ubyte_t; // a byte
typedef struct                 // 48 bytes
{
    int r11;
    int r10;
    int r9;
    int r8;
    int r7;
    int r6;
    int r5;
    int r4;
    int r3;
    int r2;
    int r1;
    int r0;
} registers_t;

typedef struct // 2 bytes
{
    ubyte_t id;
    ubyte_t access;
} member_t;

typedef struct // 22 bytes
{
    member_t *members;
    int members_len;
    int start_point;
    int end_point;
    int free_size;
    ubyte_t id;
    ubyte_t owner_id;
} mailbox_t;

typedef struct // 30 bytes
{
    registers_t data;
    int stack_start;
    int stack_end;
    int pc;
    int veneer;
    int *mailboxes;
    int mailboxes_len;
    ubyte_t status;
    ubyte_t id;
} PCB_t;
#endif