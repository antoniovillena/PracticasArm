
.SUFFIXES:
.SUFFIXES: .fig .eps .dvi .tex .ps .pdf .bbl .log .bib .aux
LATEX	= latex
DVIPS	= dvips
BIBTEX 	= bibtex
PSPDF	= ps2pdf
EPSTOPDF=epstopdf
PDFLATEX= pdflatex
RM 	= /bin/rm -rf
RERUN	= "(Rerun to get cross-references right|Citation.*undefined)"
.tex.pdf:
	$(PDFLATEX) $<
	if grep "bibdata" $*.aux ; then $(BIBTEX) $* ; fi
	if grep -E $(RERUN) $*.log ; then $(PDFLATEX) $< ; fi
	if grep -E $(RERUN) $*.log ; then $(PDFLATEX) $< ; fi

.tex.dvi:
	$(LATEX) $<
	if grep "bibdata" $*.aux ; then $(BIBTEX) $* ; fi
	if grep -E $(RERUN) $*.log ; then $(LATEX) $< ; fi
	if grep -E $(RERUN) $*.log ; then $(LATEX) $< ; fi


.dvi.ps:
	$(DVIPS) -t letter -o $@ $<

.eps.pdf:
	$(EPSTOPDF) $<


.fig.eps:
	fig2dev -L eps $< > $@

.fig.pdf:
	fig2dev -L pdf $< > $@

TARGET		= A0.PFC
TEXFILES	= A0.PFC.tex Capitulo01.tex \
			  Capitulo02.tex Capitulo03.tex \
		      Capitulo04.tex Capitulo05.tex D0.Conclusiones.tex
BIBFILES	= 
FIGFILES	= 
GRAPHS_EPS	= 
GRAPHS		= 

all: $(TARGET).pdf

$(TARGET).ps: $(TARGET).dvi $(GRAPHS_EPS)
	$(DVIPS) -t letter -o $@ $<

$(TARGET).dvi: $(TEXFILES) $(FIGFILES) $(BIBFILES) $(GRAPHS)

$(TARGET).pdf: $(TEXFILES) $(FIGFILES) $(BIBFILES) $(GRAPHS)
	$(PDFLATEX) $<
	if grep "bibdata" $*.aux ; then $(BIBTEX) $* ; fi
	if grep -E $(RERUN) $*.log ; then $(PDFLATEX) $< ; fi
	if grep -E $(RERUN) $*.log ; then $(PDFLATEX) $< ; fi
	if grep -E $(RERUN) $*.log ; then $(PDFLATEX) $< ; fi

clean:
	-$(RM)  $(TARGET).ps $(TARGET).pdf ${FIGFILES}
	-$(RM) *.bbl *.aux *.dvi *.blg *.log
	-$(RM) *~

purge: clean
	-$(RM) figures/*.eps

print:
	pdpr $(TARGET).ps 
