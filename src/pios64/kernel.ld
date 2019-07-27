
SECTIONS {
    /* Put init at 0x80000 */
    .init 0x80000 : {
        *(.init)
    }
    /* Could add .text and .data sections */
    /* Discard everything else */
    /DISCARD/ : {
        *(*)
    }
}

