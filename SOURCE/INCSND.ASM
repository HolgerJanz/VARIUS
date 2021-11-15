**************************************
* subroutines for sound

sndDst1 dta b(%10000000)
sndDst2 dta b(%10100000)

sndDstr dta b(0)

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

sndCur  dta b(0)

initSnd   lda #$00
          ldx #$07
          sta AUDF1,X
          dex
          bpl *-4
          lda #03
          sta SKCTL
          lda #$00
          sta AUDCTL
          rts

* joyn to new tile
playSndJN lda sndDst1
          sta sndDstr
          lda #sndFre1-sndFstr
          sta sndCur
          rts

* joyn to old tile
playSndJO lda sndDst2
          sta sndDstr
          lda #sndFre1-sndFstr
          sta sndCur
          rts

* new tile
playSndNT lda sndDst2
          sta sndDstr
          lda #sndFre2-sndFstr
          sta sndCur
          rts

* title sound
playSndTI lda sndDst1
          sta sndDstr
          lda #sndFTit-sndFstr
          sta sndCur
          rts

* victus sound
playSndVI lda sndDst1
          sta sndDstr
          lda #sndFTit-sndFstr
          sta sndCur
          rts

* exitus sound
playSndEx lda sndDst1
          sta sndDstr
          lda #sndFExi-sndFstr
          sta sndCur
          rts
