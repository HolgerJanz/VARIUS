; VARIUS for Atari 5200

; equates for Atari 5200
          icl 'INCEQU52.ASM'

; Variables
ztemp1    equ $80
ztemp2    equ $81
ztemp3    equ $82

; variables page 3, init with 0
CH        equ $302 ;1 byte
sndCur    equ $303 ;1 byte
sndDstr   equ $304 ;1 byte
scoreVar  equ $305 ;3 bytes
highVar   equ $308 ;3 bytes
gameOver  equ $30B ;1 byte
_setNew   equ $30C ;16 bytes
_setScl   equ $31C ;1 byte
colIdx    equ $31D ;1 byte
sclIdx    equ $31E ;1 byte

colAry    equ $320 ;16 bytes
colSc1    equ $330 ;12 bytes
colSc2    equ $340 ;12 bytes

; variables page 4, init with pg4bgn-pg4end
; Right Scale
fldSc1    equ $400 ;10 bytes
; Play Field
plyFld    equ $40A ;16 bytes
; Left Scale
fldSc2    equ $41A ;10 bytes
; Header Line
; 00000
colHL     equ $424 ;7 bytes
; VARIUS
colHT     equ $42B ;8 bytes
; 00000
colHH     equ $433 ;5 bytes


; Cartridge
; 8k cartridge, one block without header 

; for MADS comment next line and uncomment following lines
         blk none $a000
;         opt f+ h-
;         org $A000

start    cli        ;on 5200 it is on at start
         lda #0
         sta CRITIC ;we use deferred

         lda #0     ;init page 3 variables
         tax
startl11 sta $300,X
         inx
         bne startl11

         ldx #0 ;init page 4 variables
startl12 lda pg4bgn,X
         sta $400,X
         inx
         cpx <pg4end-pg4bgn
         bne startl12

         lda #$00 ;default color
         ldx #$04
startl2  sta PCOLR0,x
         dex
         bpl startl2
         lda #$28
         sta COLOR0
         lda #$ca
         sta COLOR1
         lda #$94
         sta COLOR2
         lda #$46
         sta COLOR3

         lda <kybdfIrq ;keyboard IRQ
         sta VKYBDF
         lda >kybdfIrq
         sta VKYBDF+1
         lda #$02      ;enable
         sta SKCTL
         lda #$04
         sta CONSOL    ;switch on analog sticks
         lda #$40
         sta POKMSK
         sta IRQEN

         jsr initSnd   ;init sound

         ldx <colVblki ;set deferred VBI
         ldy >colVblki
         lda #1
         jsr _wait
         stx VVBLKD
         sty VVBLKD+1

         jsr playSndTI  ;start sound

         lda <titDspLst ;set title DL
         sta SDLSTL
         lda >titDspLst
         sta SDLSTH

chkstart lda CH       ;check START
         cmp #$0C
         bne chkstart

         lda <colDspLst ;set game DL
         sta SDLSTL
         lda >colDspLst
         sta SDLSTH

         lda <colDli    ;set game DLI
         sta VDSLST
         lda >colDli
         sta VDSLST+1
         lda #$c0
         sta NMIEN

         jsr setNew

chkKey   lda #6
         jsr _wait
         lda #$ff
         sta CH

chkKey1  lda PADDL0   ;check Joystick
         cmp #20      ;left
         bcs *+7
         ldx #$04
         stx CH

         cmp #208     ;right
         bcc *+7
         ldx #$06
         stx CH

         lda PADDL1
         cmp #20      ;up
         bcs *+7
         ldx #$02
         stx CH

         cmp #208     ;down
         bcc *+7
         ldx #$08
         stx CH

         lda #$ff     ;key check
         cmp CH
         beq chkKey1
         lda CH

         cmp #$0e     ;reset key
         bne *+5
         jmp start

         cmp #$0c     ;start key
         bne *+5
         jmp startKey

         ldx gameOver ;check
         bne chkKey

         cmp #$04     ;left key
         bne *+5
         jmp leftKey

         cmp #$06     ;right key
         bne *+5
         jmp rightKey

         cmp #$02     ;up key
         bne *+5
         jmp upKey

         cmp #$08     ;down key
         bne *+5
         jmp downKey

         jmp chkKey

; varius, victus, exitus

varius dta b($36,$21,$32,$29,$35,$33)
victus dta b($76,$69,$63,$74,$75,$73)
exitus dta b($e5,$f8,$e9,$f4,$f5,$f3)

; wait routines

waitLong  lda #$10
          bne _wait
wait      lda #$06
_wait     clc
          adc RTCLOK1
_waitl1   cmp RTCLOK1
          bne _waitl1
          rts

; check game over

chkOver   lda gameOver
          bmi gameExi
          bne gameVic
          rts

gameExi   ldx #$05
          lda exitus,X
          sta colHT,X
          dex
          bpl *-7
          jsr setHigh
          jsr playSndEX
          rts

gameVic   ldx #$05
          lda victus,X
          sta colHT,X
          dex
          bpl *-7
          jsr setHigh
          jsr playSndVI
          rts

; set score/high in head

setHeadSH lda colHL+4,X
          and #$f0
          sta colHL+4,X
          lda scoreVar+2
          and #$0f
          ora colHL+4,X
          sta colHL+4,X

          lda colHL+3,X
          and #$f0
          sta colHL+3,X
          lda scoreVar+2
          lsr @
          lsr @
          lsr @
          lsr @
          ora colHL+3,X
          sta colHL+3,X

          lda colHL+2,X
          and #$f0
          sta colHL+2,X
          lda scoreVar+1
          and #$0f
          ora colHL+2,X
          sta colHL+2,X

          lda colHL+1,X
          and #$f0
          sta colHL+1,X
          lda scoreVar+1
          lsr @
          lsr @
          lsr @
          lsr @
          ora colHL+1,X
          sta colHL+1,X

          lda colHL,X
          and #$f0
          sta colHL,X
          lda scoreVar
          and #$0f
          ora colHL,X
          sta colHL,X

          rts

; set high score

setHigh   lda scoreVar   ;compare high
          cmp highVar
          bcs *+3
          rts
          bne _setHigh
          lda scoreVar+1
          cmp highVar+1
          bcs *+3
          rts
          bne _setHigh
          lda scoreVar+2
          cmp highVar+2
          bcs *+3
          rts

_setHigh  lda scoreVar  ;save new high
          sta highVar
          lda scoreVar+1
          sta highVar+1
          lda scoreVar+2
          sta highVar+2

          ldx #$0f ;index of high
          jsr setHeadSH  ;set new high

          rts

; add score (X)

scoreTab dta b($00,$01)
         dta b($00,$02)
         dta b($00,$04)
         dta b($00,$08)
         dta b($00,$16)
         dta b($00,$32)
         dta b($00,$64)
         dta b($01,$28)
         dta b($02,$56)
         dta b($05,$12)

addScore  txa
          asl @
          tax

          sed ;calc new score
          clc
          lda scoreVar+2
          adc scoreTab+1,X
          sta scoreVar+2
          lda scoreVar+1
          adc scoreTab,X
          sta scoreVar+1
          lda scoreVar
          adc #$00
          sta scoreVar
          cld

          ldx #$00 ;set score head
          jsr setHeadSH

          rts

; set right and left scale

setScale  sta _setScl
          txa
          pha
          tya
          pha

          lda _setScl
          tax
          dex
          cmp fldSc2,X
          sta fldSc2,X
          bne *+8
          jsr playSndJN
          clc
          bcc *+5
          jsr playSndJO
          lda #$00
          sta fldSc1,X
          cpx #$09
          bne *+7
          lda #$01
          sta gameOver

          jsr addScore ;changes X

          pla
          tay
          pla
          tax
          lda _setScl

          rts

; calc and set new tile

setNew    ldx #$0f
          ldy #$ff
setNewLp  lda plyFld,X
          bne setNew1
          iny
          txa
          sta _setNew,Y
setNew1   dex
          bpl setNewLp
          cpy #$ff
          beq setNewEnd
          jsr waitLong
          jsr playSndNT
          tya
          lsr @
          adc #$00
          tay
          ldx _setNew,Y
          lda #$01
          sta plyFld,X
          rts
setNewEnd lda #$ff
          sta gameOver
          rts

; START key

startKey  lda #$00    ;reset game over
          sta gameOver

          ldx #$05    ;set VARIUS
          lda varius,X
          sta colHT,X
          dex
          bpl *-7

          lda #$00    ;clear field
          ldx #$0f
          sta plyFld,x
          dex
          bpl *-4

          ldx #$04   ; clear score
          lda colHL,X
          and #$f0
          sta colHL,X
          dex
          bpl *-9

          lda #$00    ;clear ScoreVar
          ldx #$02
          sta scoreVar,X
          dex
          bpl *-4

          ldx #$0a    ;set left scale
          txa
          sta fldSc1-1,X
          dex
          bne *-5

          lda #$00    ;set right scale
          ldx #$09
          sta fldSc2,X
          dex
          bpl *-4

          jsr setNew  ;new first tile

          ldx #$00    ;update scales
          stx fldSc1
          inx
          stx fldSc2

          jmp chkKey


; left key

moveLeft  lda #$04
          sta ztemp2
          lda #$00
          sta ztemp1
moveLeft1 lda ztemp1
          tax
          tay
mvLeft    lda plyFld,X
          beq moveLeft3
          sty ztemp3
          cpx ztemp3
          beq moveLeft2
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
moveLeft2 iny
moveLeft3 inx
          cpx ztemp2
          bne mvLeft
          lda ztemp2
          sta ztemp1
          clc
          adc #$04
          sta ztemp2
          cmp #$14
          bne moveLeft1
          rts

joynLeft  lda #$04
          sta ztemp2
          lda #$00
          sta ztemp1
joynLeft1 lda ztemp1
          tax
          tay
          iny
jnLeft    lda plyFld,X
          beq joynLeft2
          cmp plyFld,Y
          bne joynLeft2
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
joynLeft2 inx
          iny
          cpy ztemp2
          bne jnLeft
          lda ztemp2
          sta ztemp1
          clc
          adc #$04
          sta ztemp2
          cmp #$14
          bne joynLeft1
          rts

leftKey   jsr moveLeft
          jsr joynLeft
          jsr moveLeft
          jsr setNew
          jsr chkOver
          jmp chkKey

; right key

moveRight lda #$03
          sta ztemp1
          lda #$ff
          sta ztemp2
moveRght1 lda ztemp1
          tax
          tay
mvRght    lda plyFld,X
          beq moveRght3
          sty ztemp3
          cpx ztemp3
          beq moveRght2
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
moveRght2 dey
moveRght3 dex
          cpx ztemp2
          bne mvRght
          lda ztemp1
          sta ztemp2
          clc
          adc #$04
          sta ztemp1
          cmp #$13
          bne moveRght1
          rts

joynRight lda #$ff
          sta ztemp2
          lda #$03
          sta ztemp1
joynRght1 lda ztemp1
          tax
          tay
          dey
jnRght    lda plyFld,X
          beq joynRght2
          cmp plyFld,Y
          bne joynRght2
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
joynRght2 dex
          dey
          cpy ztemp2
          bne jnRght
          lda ztemp1
          sta ztemp2
          clc
          adc #$04
          sta ztemp1
          cmp #$13
          bne joynRght1
          rts

rightKey  jsr moveRight
          jsr joynRight
          jsr moveRight
          jsr setNew
          jsr chkOver
          jmp chkKey

; up key
moveUp    lda #$10
          sta ztemp2
          lda #$00
          sta ztemp1
moveUp1   lda ztemp1
          tax
          tay
mvUp      lda plyFld,X
          beq moveUp3
          sty ztemp3
          cpx ztemp3
          beq moveUp2
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
moveUp2   iny
          iny
          iny
          iny
moveUp3   inx
          inx
          inx
          inx
          cpx ztemp2
          bne mvUp
          inc ztemp2
          ldx ztemp1
          inx
          stx ztemp1
          cpx #$04
          bne moveUp1
          rts

joynUp    lda #$00
          sta ztemp1
          lda #$10
          sta ztemp2
joynUp1   lda ztemp1
          tax
          tay
          iny
          iny
          iny
          iny
jnUp      lda plyFld,X
          beq joynUp2
          cmp plyFld,Y
          bne joynUp2
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
joynUp2   inx
          inx
          inx
          inx
          iny
          iny
          iny
          iny
          cpy ztemp2
          bne jnUp
          inc ztemp2
          ldx ztemp1
          inx
          stx ztemp1
          cpx #$04
          bne joynUp1
          rts

upKey     jsr moveUp
          jsr joynUp
          jsr moveUp
          jsr setNew
          jsr chkOver
          jmp chkKey

; down key

moveDown  lda #$0c
          sta ztemp1
          lda #$fc
          sta ztemp2
moveDown1 lda ztemp1
          tax
          tay
mvDown    lda plyFld,X
          beq moveDown3
          sty ztemp3
          cpx ztemp3
          beq moveDown2
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
moveDown2 dey
          dey
          dey
          dey
moveDown3 dex
          dex
          dex
          dex
          cpx ztemp2
          bne mvDown
          inc ztemp2
          ldx ztemp1
          inx
          stx ztemp1
          cpx #$10
          bne moveDown1
          rts

joynDown  lda #$0c
          sta ztemp1
          lda #$00
          sta ztemp2
joynDown1 lda ztemp1
          tax
          tay
          dey
          dey
          dey
          dey
jnDown    lda plyFld,X
          beq joynDown2
          cmp plyFld,Y
          bne joynDown2
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
joynDown2 dex
          dex
          dex
          dex
          dey
          dey
          dey
          dey
          cpx ztemp2
          bne jnDown
          inc ztemp1
          ldx ztemp2
          inx
          stx ztemp2
          cpx #$04
          bne joynDown1
          rts

downKey   jsr moveDown
          jsr joynDown
          jsr moveDown
          jsr setNew
          jsr chkOver
          jmp chkKey


; subroutines for sound

sndDst1 dta b(%10000000)
sndDst2 dta b(%10100000)

sndFstr dta b(0)
sndFre1 dta b(96,108,108,91,0)
sndFre2 dta b(190,239,213,179,0)
sndFTit dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(29,29,29,29,29,29,29,29)
        dta b(0)
sndFExi dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(243,243,243,243,243,243,243,243)
        dta b(0)

sndVstr dta b(0)
sndVol1 dta b(7,14,14,7,0)
sndVol2 dta b(4,8,8,4,0)
sndVTit dta b(02,06,12,15,15,15,15,15)
        dta b(15,15,15,15,15,15,15,15)
        dta b(15,12,12,12,09,09,09,06)
        dta b(06,06,04,04,04,04,04,04)
        dta b(03,03,03,03,03,03,03,03)
        dta b(02,02,02,02,02,02,02,02)
        dta b(01,01,01,01,01,01,01,01)
        dta b(00,00,00,00,00,00,00,00)
        dta b(0)
sndVExi dta b(02,06,12,15,15,15,15,15)
        dta b(15,15,15,15,15,15,15,15)
        dta b(15,12,12,12,09,09,09,06)
        dta b(06,06,04,04,04,04,04,04)
        dta b(03,03,03,03,03,03,03,03)
        dta b(02,02,02,02,02,02,02,02)
        dta b(01,01,01,01,01,01,01,01)
        dta b(00,00,00,00,00,00,00,00)
        dta b(0)

initSnd   lda #$00
          ldx #$07
initSnd2  sta AUDF1,X
          dex
          bpl initSnd2
          lda #02
          sta SKCTL
          lda #$00
          sta AUDCTL
          rts

; joyn to new tile
playSndJN lda sndDst1
          sta sndDstr
          lda #sndFre1-sndFstr
          sta sndCur
          rts

; joyn to old tile
playSndJO lda sndDst2
          sta sndDstr
          lda #sndFre1-sndFstr
          sta sndCur
          rts

; new tile
playSndNT lda sndDst2
          sta sndDstr
          lda #sndFre2-sndFstr
          sta sndCur
          rts

; title sound
playSndTI lda sndDst1
          sta sndDstr
          lda #sndFTit-sndFstr
          sta sndCur
          rts

; victus sound
playSndVI lda sndDst1
          sta sndDstr
          lda #sndFTit-sndFstr
          sta sndCur
          rts

; exitus sound
playSndEx lda sndDst1
          sta sndDstr
          lda #sndFExi-sndFstr
          sta sndCur
          rts


; Color Registers & Play Field

; Color Registers 10 + 1 for empty
colPot    dta b($02)    
          dta b($b2,$a8,$92,$86,$7a)
          dta b($6C,$58,$44,$38,$2C)

; VBLK & DLI

colBG     dta b($00)

colDliCtl dta b($00,$00,$01,$00)
          dta b($00,$01,$00,$00)
          dta b($01,$00,$00,$01)

; VBLK
colVblki  lda #$00  ;reset DLI counter
          sta colIdx
          lda #$0b
          sta sclIdx

          lda #$00     ;set GITA
          sta PRIOR

          ldx #$0F    ;set color array
colAryLp  ldy plyFld,X
          lda colPot,Y
          sta colAry,X
          dex
          bpl colAryLp

          ldx #$09    ;set color scales
colScLp   ldy fldSc1,X
          lda colPot,Y
          sta colSc1+1,X
          ldy fldSc2,X
          lda colPot,Y
          sta colSc2+1,X
          dex
          bpl colScLp

          lda #$00  ;reset attract mode
          sta ATRACT

          ldx sndCur ;play sound
          lda sndFstr,X
          beq *+5
          inc sndCur
          sta AUDF1
          lda sndVstr,X
          ora sndDstr
          sta AUDC1

          pla
          tay
          pla
          tax
          pla

          rti

; DLI
colDli    pha
          txa
          pha

          lda #$80     ;set GITA
          sta PRIOR

          lda colBG    ;set background
          sta COLPM0

          ldx sclIdx   ;set scales
          lda colSc1,X
          sta COLPF1
          lda colSc2,X
          sta COLPF2

          lda colDliCtl,X  ;check for
          beq colDliEnd    ;new field

          ldx colIdx ;set field colors
          lda colAry,X
          sta COLPM1

          inx
          lda colAry,X
          sta COLPM2

          inx
          lda colAry,X
          sta COLPM3

          inx
          lda colAry,X
          sta COLPF0

          inx
          stx colIdx

colDliEnd dec sclIdx
          pla
          tax
          pla
          rti

; Keyboard IRQ
kybdfIrq  sta CH

          pla
          tay
          pla
          tax
          pla
          rti

; for MADS comment next line and uncomment following line
          blk padding $b000 $ff
;          org $B000

; Screen Memory Title

;  V A R I U S
titScrH dta b($00,$00,$00,$00,$00)
        dta b($36,$00,$61,$00,$b2)
        dta b($00,$e9,$00,$75,$00)
        dta b($33,$00,$00,$00,$00)
; BY HOLGER JANZ
titScrC dta b($00,$00,$00,$a2,$b9)
        dta b($00,$a8,$af,$ac,$a7)
        dta b($a5,$b2,$00,$aa,$a1)
        dta b($ae,$ba,$00,$00,$00)
;    ABBUC
titScrA dta b($00,$00,$00,$00,$00)
        dta b($00,$00,$00,$a1,$a2)
        dta b($a2,$b5,$a3,$00,$00)
        dta b($00,$00,$00,$00,$00)
; SOFTWARE CONTEST
        dta b($00,$00,$b3,$af,$a6)
        dta b($b4,$b7,$a1,$b2,$a5)
        dta b($00,$a3,$af,$ae,$b4)
        dta b($a5,$b3,$b4,$00,$00)
; 2021
        dta b($00,$00,$00,$00,$00)
        dta b($00,$00,$00,$92,$90)
        dta b($92,$91,$00,$00,$00)
        dta b($00,$00,$00,$00,$00)
; MOVE ALL TILES
titScrE dta b($00,$00,$00,$ad,$af)
        dta b($b6,$a5,$00,$a1,$ac)
        dta b($ac,$00,$b4,$a9,$ac)
        dta b($a5,$b3,$00,$00,$00)
; JOYN SAME COLOR
        dta b($00,$00,$00,$aa,$af)
        dta b($b9,$ae,$00,$b3,$a1)
        dta b($ad,$a5,$00,$a3,$af)
        dta b($ac,$af,$b2,$00,$00)
; VICTUS HIGHEST COLOR
        dta b($b6,$a9,$a3,$b4,$b5)
        dta b($b3,$00,$a8,$a9,$a7)
        dta b($a8,$a5,$b3,$b4,$00)
        dta b($a3,$af,$ac,$af,$b2)
; EXITUS NO NEW TILE
        dta b($00,$a5,$b8,$a9,$b4)
        dta b($b5,$b3,$00,$ae,$af)
        dta b($00,$ae,$a5,$b7,$00)
        dta b($b4,$a9,$ac,$a5,$00)
; PRESS START
titScrP dta b($00,$00,$00,$00,$00)
        dta b($70,$72,$65,$73,$73)
        dta b($00,$73,$74,$61,$72)
        dta b($74,$00,$00,$00,$00)

; Display List Title

titDspLst dta b($70,$70,$70,$70,$70)
          dta b($70),b($47),a(titScrH)
          dta b($70),b($46),a(titScrC)
          dta b($70)
          dta b($70),b($46),a(titScrA)
          dta b($06,$06)
          dta b($70)
          dta b($70),b($46),a(titScrE)
          dta b($06,$06,$06)
          dta b($70,$70)
          dta b($70),b($46),a(titScrP)
; end jump
  dta b($41),a(titDspLst)

; Screen Memory Game

; Line with Scale
colS1 dta b($00,$00,$55,$55)
      dta b($00,$00,$00,$00)
      dta b($01,$11,$11,$11)
      dta b($11,$11,$02,$22)
      dta b($22,$22,$22,$22)
      dta b($03,$33,$33,$33)
      dta b($33,$33,$04,$44)
      dta b($44,$44,$44,$44)
      dta b($00,$00,$00,$00)
      dta b($06,$66,$60,$00)

; Line without Scale
colS2 dta b($00,$00,$00,$00)
      dta b($00,$00,$00,$00)
      dta b($01,$11,$11,$11)
      dta b($11,$11,$02,$22)
      dta b($22,$22,$22,$22)
      dta b($03,$33,$33,$33)
      dta b($33,$33,$04,$44)
      dta b($44,$44,$44,$44)
      dta b($00,$00,$00,$00)
      dta b($00,$00,$00,$00)

; Display List Game

colDspLst dta b($70,$70)
          dta b($46),a(colHL)
          dta b($30)

; Row 1
  dta b($b0)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

; Row 2
  dta b($b0)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

; Row 3
  dta b($b0)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

; Row 4
  dta b($b0)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

  dta b($cf),a(colS2),b($4f),a(colS2)
  dta b($4f),a(colS2),b($4f),a(colS2)

  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)
  dta b($4f),a(colS1),b($4f),a(colS1)

; end jump
  dta b($41),a(colDspLst)


; init data for page 4

pg4bgn equ *

; Right Scale
ifldSc1    dta b($00,$02,$03,$04)
           dta b($05,$06,$07,$08)
           dta b($09,$0a)
; Play Field
iplyFld    dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)
; Left Scale
ifldSc2    dta b($01,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00)

; Header Line
; 00000
icolHL dta b($90,$90,$90,$90,$90)
       dta b($00,$00)
; VARIUS
icolHT dta b($36,$21,$32,$29,$35,$33)
       dta b($00,$00)
; 00000
icolHH dta b($50,$50,$50,$50,$50)

pg4end equ *

; cartridge title, year, and start address
; for MADS comment next line and uncomment following line
         blk padding $bfe8 $ff
;         org $BFE8

         dta b(0,0,0)
         dta b($36,$21,$32,$29,$35,$33,0,$22,$39,0,$28,$2A,$38) ; VARIUS BY HJX
         dta b(0,0,0,0)
         dta b($57,$51) ; 71
         dta a(start)

         end
