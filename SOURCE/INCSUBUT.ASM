*** varius, victus, exitus **********

varius dta b($36,$21,$32,$29,$35,$33)
victus dta b($76,$69,$63,$74,$75,$73)
exitus dta b($e5,$f8,$e9,$f4,$f5,$f3)

*** wait routines *******************

waitLong  lda #$10
          jmp _wait
wait      lda #$06
_wait     clc
          adc RTCLK1
          cmp RTCLK1
          bne *-2
          rts

*** check game over *****************

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

*** set score/high in head **********

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

*** set high score ******************

scoreVar dta b($00,$00,$00)

highVar  dta b($00,$00,$00)

setHigh   lda scoreVar   compare high
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

_setHigh  lda scoreVar  save new high
          sta highVar
          lda scoreVar+1
          sta highVar+1
          lda scoreVar+2
          sta highVar+2

          ldx #$0f index of high
          jsr setHeadSH  set new high

          rts

*** add score (X) *******************

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

          sed calc new score
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

          ldx #$00 set score head
          jsr setHeadSH

          rts

*** set right and left scale ********

setScale  sta _setScl+1
          txa
          pha
          tya
          pha

_setScl   lda #$00
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

          jsr addScore changes X

          pla
          tay
          pla
          tax
          lda _setScl+1

          rts

*** calc and set new tile ***********

setNew    ldx #$0f
          ldy #$ff
setNewLp  lda plyFld,X
          bne *+7
          iny
          txa
          sta _setNew,Y
          dex
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

_setNew   dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)

*** START/S key *********************

startKey  lda #$00    reset game over
          sta gameOver

          ldx #$05    set VARIUS
          lda varius,X
          sta colHT,X
          dex
          bpl *-7

          lda #$00    clear field
          ldx #$0f
          sta plyFld,x
          dex
          bpl *-4

          ldx #$04    clear score
          lda colHL,X
          and #$f0
          sta colHL,X
          dex
          bpl *-9

          lda #$00    clear ScoreVar
          ldx #$02
          sta scoreVar,X
          dex
          bpl *-4

          ldx #$0a    set left scale
          txa
          sta fldSc1-1,X
          dex
          bne *-5

          lda #$00    set right scale
          ldx #$09
          sta fldSc2,X
          dex
          bpl *-4

          jsr setNew  new first tile

          ldx #$00    update scales
          stx fldSc1
          inx
          stx fldSc2

          jmp chkKey
