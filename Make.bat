if 0==1 (
  makeindex "A0.Mi Proyecto fin de carrera.idx"
  bibtex    "A0.Mi Proyecto fin de carrera.aux"
  pdflatex  "A0.Mi Proyecto fin de carrera.tex"
  copy /y   "A0.Mi Proyecto fin de carrera.pdf" "c:\Users\Yo\Google Drive"
)
else (
  pdflatex  "Capitulo02.tex"
  copy /y   "Capitulo02.pdf" "c:\Users\Yo\Google Drive"
)
