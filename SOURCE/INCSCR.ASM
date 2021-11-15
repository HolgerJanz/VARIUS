*************************************
* Screen Memory Title

*  V A R I U S
titScrH dta b($00,$00,$00,$00,$00)
        dta b($36,$00,$61,$00,$b2)
        dta b($00,$e9,$00,$75,$00)
        dta b($33,$00,$00,$00,$00)
* BY HOLGER JANZ
titScrC dta b($00,$00,$00,$a2,$b9)
        dta b($00,$a8,$af,$ac,$a7)
        dta b($a5,$b2,$00,$aa,$a1)
        dta b($ae,$ba,$00,$00,$00)
*    ABBUC
titScrA dta b($00,$00,$00,$00,$00)
        dta b($00,$00,$00,$a1,$a2)
        dta b($a2,$b5,$a3,$00,$00)
        dta b($00,$00,$00,$00,$00)
* SOFTWARE CONTEST
        dta b($00,$00,$b3,$af,$a6)
        dta b($b4,$b7,$a1,$b2,$a5)
        dta b($00,$a3,$af,$ae,$b4)
        dta b($a5,$b3,$b4,$00,$00)
* 2021
        dta b($00,$00,$00,$00,$00)
        dta b($00,$00,$00,$92,$90)
        dta b($92,$91,$00,$00,$00)
        dta b($00,$00,$00,$00,$00)
* MOVE ALL TILES
titScrE dta b($00,$00,$00,$ad,$af)
        dta b($b6,$a5,$00,$a1,$ac)
        dta b($ac,$00,$b4,$a9,$ac)
        dta b($a5,$b3,$00,$00,$00)
* JOYN SAME COLOR
        dta b($00,$00,$00,$aa,$af)
        dta b($b9,$ae,$00,$b3,$a1)
        dta b($ad,$a5,$00,$a3,$af)
        dta b($ac,$af,$b2,$00,$00)
* VICTUS HIGHEST COLOR
        dta b($b6,$a9,$a3,$b4,$b5)
        dta b($b3,$00,$a8,$a9,$a7)
        dta b($a8,$a5,$b3,$b4,$00)
        dta b($a3,$af,$ac,$af,$b2)
* EXITUS NO NEW TILE
        dta b($00,$a5,$b8,$a9,$b4)
        dta b($b5,$b3,$00,$ae,$af)
        dta b($00,$ae,$a5,$b7,$00)
        dta b($b4,$a9,$ac,$a5,$00)
* PRESS START
titScrP dta b($00,$00,$00,$00,$00)
        dta b($70,$72,$65,$73,$73)
        dta b($00,$73,$74,$61,$72)
        dta b($74,$00,$00,$00,$00)

*************************************
* Display List Title

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
* end jump
  dta b($41),a(titDspLst)

*************************************
* Screen Memory Game

* Header Line
* 00000
colHL dta b($90,$90,$90,$90,$90)
      dta b($00,$00)
* VARIUS
colHT dta b($36,$21,$32,$29,$35,$33)
      dta b($00,$00)
* 00000
colHH dta b($50,$50,$50,$50,$50)

* Line with Scale
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

* Line without Scale
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

*************************************
* Display List Game

colDspLst dta b($70,$70)
          dta b($46),a(colHL)
          dta b($30)

* Row 1
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

* Row 2
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

* Row 3
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

* Row 4
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

* end jump
  dta b($41),a(colDspLst)

