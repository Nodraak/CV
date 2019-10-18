
OUT_FR_PRIVATE = CV_AdrienChardon.pdf
OUT_FR_PUBLIC = CV_AdrienChardon_web.pdf
OUT_EN_PRIVATE = Resume_AdrienChardon.pdf
OUT_EN_PUBLIC = Resume_AdrienChardon_web.pdf

OUT_FR = $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC)
OUT_EN = $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)
OUT_ALL = $(OUT_FR) $(OUT_EN)

.PHONY: all re clean fr en

# By default (target "all") this works by compiling four times (two languages
# and two flavors: with private infos or without)
# It applies the patch to add the personal info, compile and save and then
# reverts the patch

all: fr en
	@echo "== Compilation finished, now upload to diamant =="
	@echo "scp $(OUT_FR_PUBLIC) agate:/var/www/cv/fr.pdf"
	@echo "scp $(OUT_EN_PUBLIC) agate:/var/www/cv/en.pdf"


re: clean all

clean:
	rm -f *.aux *.log *.out $(OUT_ALL) fr.pdf en.pdf

fr: $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC)

en: $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)

$(OUT_FR_PRIVATE): fr.tex sed-script-file-private
	cat fr.tex | sed -f sed-script-file-private | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_FR_PRIVATE)
	rm -f texput.*

$(OUT_FR_PUBLIC): fr.tex sed-script-file-public
	cat fr.tex | sed -f sed-script-file-public | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_FR_PUBLIC)
	rm -f texput.*

$(OUT_EN_PRIVATE): en.tex sed-script-file-private
	cat en.tex | sed -f sed-script-file-private | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_EN_PRIVATE)
	rm -f texput.*

$(OUT_EN_PUBLIC): en.tex sed-script-file-public
	cat en.tex | sed -f sed-script-file-public | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_EN_PUBLIC)
	rm -f texput.*
