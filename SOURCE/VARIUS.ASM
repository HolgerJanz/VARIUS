*************************************
* VARIUS by Holger Janz
*
* ABBUC Software Contest 2021
*
* use Fast Assembler to compile:
* github.com/HolgerJanz/FastAssembler
*

*         system and OS equs
          icl "INCOSEQU.ASM"

*************************************
* Main block
          blk DOS $2480

*   main program loop
          icl "INCMAIN.ASM"

*   utility subroutines 
          icl "INCSUBUT.ASM"

*   subroutines for moving
          icl "INCSUBMV.ASM"

*   subroutines for sound
          icl "INCSND.ASM"

*   data and subroutines for IRQ
          icl "INCIRQ.ASM"

*   DL and screen memory
          icl "INCSCR.ASM"

*************************************
* Run Address block
          blk DOS RUNAD
          dta a(start)

*************************************
          end
