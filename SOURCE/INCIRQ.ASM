*************************************
* Color Registers & Play Field

* Color Registers 10 + 1 for empty
colPot    dta b($02)    
          dta b($b2,$a8,$92,$86,$7a)
          dta b($6C,$58,$44,$38,$2C)

* Right Scale
fldSc1     dta b($00,$02,$03,$04)
           dta b($05,$06,$07,$08)
           dta b($09,$0a)

* Play Field
plyFld     dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00,$00,$00)

* Left Scale
fldSc2     dta b($01,$00,$00,$00)
           dta b($00,$00,$00,$00)
           dta b($00,$00)

* VBLK & DLI

colIdx    dta b($00) ;inc counter
sclIdx    dta b($0B) ;dec counter

colBG     dta b($00)

colDliCtl dta b($00,$00,$01,$00)
          dta b($00,$01,$00,$00)
          dta b($01,$00,$00,$01)

colAry    dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)

colSc1    dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)

colSc2    dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)
          dta b($00,$00,$00,$00)

*** VBLK ****************************
colVblki  lda #$00  ;reset DLI counter
          sta colIdx
          lda #$0b
          sta sclIdx

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

          jmp SYSVB  ;jump back to sys

*** DLI *****************************
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

