*** left key ************************

moveLeft  lda #$00
          tax
          tay
mvLeft    lda plyFld,X
          beq *+21
          sty _mvLeftCX+1
_mvLeftCX cpx #$00
          beq *+13
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
          iny
          inx
_mvLeftBX cpx #$04
          bne mvLeft
          lda _mvLeftBX+1
          sta moveLeft+1
          clc
          adc #$04
          sta _mvLeftBX+1
          cmp #$14
          bne moveLeft
          lda #$00
          sta moveLeft+1
          lda #$04
          sta _mvLeftBX+1
          rts

joynLeft  lda #$00
          tax
          tay
          iny
jnLeft    lda plyFld,X
          beq *+24
          cmp plyFld,Y
          bne *+19
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
          inx
          iny
_jnLeftBX cpy #$04
          bne jnLeft
          lda _jnLeftBX+1
          sta joynLeft+1
          clc
          adc #$04
          sta _jnLeftBX+1
          cmp #$14
          bne joynLeft
          lda #$00
          sta joynLeft+1
          lda #$04
          sta _jnLeftBX+1
          rts

leftKey   jsr moveLeft
          jsr joynLeft
          jsr moveLeft
          jsr setNew
          jsr chkOver
          jmp chkKey

*** right key ***********************

moveRight lda #$03
          tax
          tay
mvRght    lda plyFld,X
          beq *+21
          sty _mvRghtCX+1
_mvRghtCX cpx #$00
          beq *+13
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
          dey
          dex
_mvRghtBX cpx #$ff
          bne mvRght
          lda moveRight+1
          sta _mvRghtBX+1
          clc
          adc #$04
          sta moveRight+1
          cmp #$13
          bne moveRight
          lda #$03
          sta moveRight+1
          lda #$ff
          sta _mvRghtBX+1
          rts

joynRight lda #$03
          tax
          tay
          dey
jnRght    lda plyFld,X
          beq *+24
          cmp plyFld,Y
          bne *+19
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
          dex
          dey
_jnRghtBX cpy #$ff
          bne jnRght
          lda joynRight+1
          sta _jnRghtBX+1
          clc
          adc #$04
          sta joynRight+1
          cmp #$13
          bne joynRight
          lda #$03
          sta joynRight+1
          lda #$ff
          sta _jnRghtBX+1
          rts

rightKey  jsr moveRight
          jsr joynRight
          jsr moveRight
          jsr setNew
          jsr chkOver
          jmp chkKey

*** up key **************************

moveUp    lda #$00
          tax
          tay
mvUp      lda plyFld,X
          beq *+24
          sty _mvUpCX+1
_mvUpCX   cpx #$00
          beq *+13
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
          iny
          iny
          iny
          iny
          inx
          inx
          inx
          inx
_mvUpBX   cpx #$10
          bne mvUp
          inc _mvUpBx+1
          ldx moveUp+1
          inx
          stx moveUp+1
          cpx #$04
          bne moveUp
          lda #$00
          sta moveUp+1
          lda #$10
          sta _mvUpBX+1
          rts

joynUp    lda #$00
          tax
          tay
          iny
          iny
          iny
          iny
jnUp      lda plyFld,X
          beq *+24
          cmp plyFld,Y
          bne *+19
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
          inx
          inx
          inx
          inx
          iny
          iny
          iny
          iny
_jnUpBX   cpy #$10
          bne jnUp
          inc _jnUpBX+1
          ldx joynUp+1
          inx
          stx joynUp+1
          cpx #$04
          bne joynUp
          lda #$00
          sta joynUp+1
          lda #$10
          sta _jnUpBX+1
          rts

upKey     jsr moveUp
          jsr joynUp
          jsr moveUp
          jsr setNew
          jsr chkOver
          jmp chkKey

*** down key ************************

moveDown  lda #$0c
          tax
          tay
mvDown    lda plyFld,X
          beq *+24
          sty _mvDownCX+1
_mvDownCX cpx #$00
          beq *+13
          sta plyFld,Y
          lda #$00
          sta plyFld,X
          jsr wait
          dey
          dey
          dey
          dey
          dex
          dex
          dex
          dex
_mvDownBX cpx #$fc
          bne mvDown
          inc _mvDownBx+1
          ldx moveDown+1
          inx
          stx moveDown+1
          cpx #$10
          bne moveDown
          lda #$0c
          sta moveDown+1
          lda #$fc
          sta _mvDownBX+1
          rts

joynDown  lda #$0c
          tax
          tay
          dey
          dey
          dey
          dey
jnDown    lda plyFld,X
          beq *+24
          cmp plyFld,Y
          bne *+19
          inc plyFld,X
          lda plyFld,X
          jsr setScale
          lda #$00
          sta plyFld,Y
          jsr wait
          dex
          dex
          dex
          dex
          dey
          dey
          dey
          dey
_jnDownBX cpx #$00
          bne jnDown
          inc joynDown+1
          ldx _jnDownBX+1
          inx
          stx _jnDownBX+1
          cpx #$04
          bne joynDown
          lda #$0c
          sta joynDown+1
          lda #$00
          sta _jnDownBX+1
          rts

downKey   jsr moveDown
          jsr joynDown
          jsr moveDown
          jsr setNew
          jsr chkOver
          jmp chkKey
