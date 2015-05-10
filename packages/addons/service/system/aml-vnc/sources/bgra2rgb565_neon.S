/*
 * BGRA2RGB565.s
 *
 * Created by Jake "Alquimista" Lee on 11. 11. 1..
 * Copyright 2011 Jake Lee. All rights reserved.
 *
 * Version 1.1
 * - bug fix
 *
 * Version 1.0
 * - initial release
 */


    .align 2
    .globl _bgra2rgb565_neon
//  .private_extern _bgra2rgb565_neon

// unsigned int * bgra2rgb565_neon(unsigned int * pDst, unsigned int * pSrc, unsigned int count);


//ARM
pDst        .req    r0
pSrc        .req    r1
count       .req    r2

//NEON
blu         .req    d16
grn         .req    d17
red         .req    d18
alp         .req    d19

gb          .req    grn
rg          .req    red

_bgra2rgb565_neon:
    pld     [pSrc]
    tst     count, #0x7
    movne   r0, #0
    bxne    lr

.loop:
    pld     [pSrc, #32]
    vld4.8  {blu, grn, red, alp}, [pSrc]!
    subs    count, count, #8

    vsri.8  red, grn, #5
    vshl.u8 gb, grn, #3
    vsri.8  gb, blu, #3

    vst2.8  {gb, rg}, [pDst]!
    bgt     .loop

    bx      lr
