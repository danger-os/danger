
SECTIONS {
    /* Put init at 0x80000 */
    .init 0x80000 : {
        *(.init)
    }
    .text : {
        *(._start)
        *(.text)
    }
    .data : {
        *(.data)
    }
    /* Discard everything else */
    /DISCARD/ : {

    }
}

