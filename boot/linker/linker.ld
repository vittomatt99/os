ENTRY (_start)

SECTIONS
{
    . = 0x100000; /* Kernel base address */

    .text ALIGN(4) : {
        *(.multiboot) /* Multiboot header */
        *(.text)      /* Code */
    }

    .data ALIGN(4) : {
        *(.data) /* Data align */
    }

    .bss ALIGN(4) : {
        *(.bss)  /* Data no initialized */
    }

    . = ALIGN(4); /* Align */
}