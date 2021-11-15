start     lda #$00       default color
          ldx #$04
          sta PCOLR0,x
          dex
          bpl *-4
          lda #$28
          sta COLOR0
          lda #$ca
          sta COLOR1
          lda #$94
          sta COLOR2
          lda #$46
          sta COLOR3

          jsr initSnd    init sound

          ldy <colVblki  set VBI
          ldx >colVblki
          lda #$06
          jsr SETVBV

          jsr playSndTI  start sound

          lda <titDspLst set title DL
          sta SDLST
          lda >titDspLst
          sta SDLST+1

          lda #$08
          sta CONSOL
          lda #$01       check START
          bit CONSOL
          beq *+7
          lda STRIG0     check trigger
          bne *-10

          lda <colDspLst set game DL
          sta SDLST
          lda >colDspLst
          sta SDLST+1

          lda <colDli    set game DLI
          sta VSDLST
          lda >colDli
          sta VSDLST+1
          lda #$c0
          sta NMIEN

          jsr setNew

chkKey    lda #$01     check START
          bit CONSOL
          bne *+7      and
          lda #$3e     set S key
          sta CH

          lda STRIG0   check trigger
          eor #$01     only at game
          and gameOver over
          beq *+7
          lda #$3e     set S key
          sta CH

          lda #$04     check Joystick
          bit STICK0   left
          bne *+7
          ldx #$06
          stx CH
          lda #$08
          bit STICK0   right
          bne *+7
          ldx #$07
          stx CH
          lda #$01
          bit STICK0   up
          bne *+7
          ldx #$0e
          stx CH
          lda #$02
          bit STICK0   down
          bne *+7
          ldx #$0f
          stx CH

          lda #$ff     key check
          tax
          cmp CH
          beq chkKey
          lda CH
          stx CH

          cmp #$3e     S key
          bne *+5
          jmp startKey

          ldx gameOver check
          bne chkKey

          cmp #$06     left key
          bne *+5
          jmp leftKey

          cmp #$07     right key
          bne *+5
          jmp rightKey

          cmp #$0e     up key
          bne *+5
          jmp upKey

          cmp #$0f     down key
          bne *+5
          jmp downKey

          jmp chkKey

gameOver  dta b($00)
