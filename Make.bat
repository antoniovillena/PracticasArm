if 0==1 (
  makeindex "A0.Mi Proyecto fin de carrera.idx"
  bibtex    "A0.Mi Proyecto fin de carrera.aux"
  pdflatex  "A0.Mi Proyecto fin de carrera.tex"
  copy /y   "A0.Mi Proyecto fin de carrera.pdf" "c:\Users\Yo\Google Drive\PFC-AntonioJoseVillena"
) else (
  pdflatex  "Capitulo05.tex"
  copy /y   "Capitulo05.pdf" "c:\Users\Yo\Google Drive\PFC-AntonioJoseVillena"
)
