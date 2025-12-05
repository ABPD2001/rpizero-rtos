SECTIONS {
    . = 0x00;
    .vectors:{
        *(.vectors*)
    }
    . = 0x20;
    .irq_table:{
        *(.irq_table)
    }
    . = 0x2C;
    .swi_table:{
        *(.swi_table*)
    }
    . = 0x9284;
    .vector_handlers:{
        *(.vector_handlers*)
    }
    . = 0x93CB;
    .irq_routines:{
        *(.irq_routines*)
    }
    .=swi;
    .swi_routines:{
        *(.swi_routines*)
    }
}