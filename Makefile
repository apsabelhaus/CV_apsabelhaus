all: paper

paper: 
	#rm img/*eps-converted-to.pdf
	xelatex CV_apsabelhaus.tex
	xelatex CV_apsabelhaus.tex

clean:
	rm *.aux
	rm *.log
	rm *.bbl
	rm CV_apsabelhaus.pdf
	rm CV_apsabelhaus.dvi
	rm CV_apsabelhaus.ps
	rm *.blg
	rm img/*eps-converted-to.pdf
	rm *~
