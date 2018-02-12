
OUT_FR_PERSO = CV_AdrienChardon.pdf
OUT_FR_WEB = CV_AdrienChardon_web.pdf
OUT_EN_PERSO = Resume_AdrienChardon.pdf
OUT_EN_WEB = Resume_AdrienChardon_web.pdf

OUT_FR = $(OUT_FR_PERSO) $(OUT_FR_WEB)
OUT_EN = $(OUT_EN_PERSO) $(OUT_EN_WEB)
OUT_ALL = $(OUT_FR) $(OUT_EN)

.PHONY: all re clean patch_apply patch_revert pdflatex_fr pdflatex_en

# By default (target "all") this works by compiling four times (two languages
# and two flavors: with private infos or without)
# It applies the patch to add the personal info, compile and save and then
# reverts the patch

all: fr.pdf en.pdf
	@echo "== Compilation finished, now upload to diamant =="
	@echo "scp CV_AdrienChardon_web.pdf diamant:/var/www/cv/cv/fr.pdf"
	@echo "scp Resume_AdrienChardon_web.pdf diamant:/var/www/cv/cv/en.pdf"

re: clean all

clean:
	rm -f *.aux *.log *.out
	rm -f $(OUT_ALL) fr.pdf en.pdf


patch_apply:
	git apply add_personal_info.patch

patch_revert:
	git apply -R add_personal_info.patch

pdflatex_fr:
	pdflatex --shell-escape fr.tex

pdflatex_en:
	pdflatex --shell-escape en.tex

fr.pdf: fr.tex add_personal_info.patch
	make patch_apply
	make pdflatex_fr
	cp fr.pdf $(OUT_FR_PERSO)
	make patch_revert

	make pdflatex_fr
	cp fr.pdf $(OUT_FR_WEB)

en.pdf: en.tex add_personal_info.patch
	make patch_apply
	make pdflatex_en
	cp en.pdf $(OUT_EN_PERSO)
	make patch_revert

	make pdflatex_en
	cp en.pdf $(OUT_EN_WEB)

