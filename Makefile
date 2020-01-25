# The default target compiles four times:
# * Two languages: fr, en
# * Two flavors: with private infos or without
# It applies the patch to add the personal info and compile

OUT_FR_PRIVATE = AdrienChardon-CV.pdf
OUT_FR_PUBLIC = AdrienChardon-CV-web.pdf
OUT_EN_PRIVATE = AdrienChardon-Resume.pdf
OUT_EN_PUBLIC = AdrienChardon-Resume-web.pdf

.PHONY: all re clean fr en upload

all: fr en
	echo "Compilation done. Upload with 'Make upload'"

re: clean all

clean:
	rm -f *.aux *.log *.out fr.pdf en.pdf $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC) $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)

fr: $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC)

en: $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)

upload:
	scp $(OUT_FR_PUBLIC) agate:/var/www/cv/AdrienChardon-CV.pdf
	scp $(OUT_EN_PUBLIC) agate:/var/www/cv/AdrienChardon-Resume.pdf
	scp index.html agate:/var/www/cv/index.html

$(OUT_FR_PRIVATE): common.tex fr.tex personal-data-fr-private
	cat fr.tex | sed -f personal-data-fr-private | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_FR_PRIVATE)
	rm -f texput.*

$(OUT_FR_PUBLIC): common.tex fr.tex personal-data-fr-public
	cat fr.tex | sed -f personal-data-fr-public | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_FR_PUBLIC)
	rm -f texput.*

$(OUT_EN_PRIVATE): common.tex en.tex personal-data-en-private
	cat en.tex | sed -f personal-data-en-private | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_EN_PRIVATE)
	rm -f texput.*

$(OUT_EN_PUBLIC): common.tex en.tex personal-data-en-public
	cat en.tex | sed -f personal-data-en-public | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT_EN_PUBLIC)
	rm -f texput.*
