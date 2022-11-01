# The default target compiles four times:
# * Two languages: fr, en
# * Two flavors: with private infos or without
# It applies the patch to add the personal info and compile

OUT_FR_PRIVATE = AdrienChardon-CV.pdf
OUT_FR_PUBLIC = AdrienChardon-CV-web.pdf
OUT_EN_PRIVATE = AdrienChardon-Resume.pdf
OUT_EN_PUBLIC = AdrienChardon-Resume-web.pdf

REMOTE_HOST = agate
REMOTE_FOLDER = /var/www/cv/


.PHONY: all re clean fr en upload

all: fr en
	echo "Compilation done. Upload with 'Make upload'"

re: clean all

clean:
	rm -f *.aux *.log *.out $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC) $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)

fr: $(OUT_FR_PRIVATE) $(OUT_FR_PUBLIC)

en: $(OUT_EN_PRIVATE) $(OUT_EN_PUBLIC)

upload:
	scp $(OUT_FR_PUBLIC)            $(REMOTE_HOST):$(REMOTE_FOLDER)/AdrienChardon-CV.pdf
	scp $(OUT_EN_PUBLIC)            $(REMOTE_HOST):$(REMOTE_FOLDER)/AdrienChardon-Resume.pdf
	scp static/index.html           $(REMOTE_HOST):$(REMOTE_FOLDER)/index.html
	scp static/gali-prototype.mp4   $(REMOTE_HOST):$(REMOTE_FOLDER)/gali-prototype.mp4

compile:
	cat $(IN) | sed -f $(PERSONAL_DATA) | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	cat $(IN) | sed -f $(PERSONAL_DATA) | SOURCE_DATE_EPOCH='' xelatex --halt-on-error --shell-escape
	mv texput.pdf $(OUT)
	rm -f texput.*

$(OUT_FR_PRIVATE): common.tex fr.tex personal-data-fr-private
	make compile IN=fr.tex PERSONAL_DATA=personal-data-fr-private OUT=$(OUT_FR_PRIVATE)

$(OUT_FR_PUBLIC): common.tex fr.tex personal-data-fr-public
	make compile IN=fr.tex PERSONAL_DATA=personal-data-fr-public OUT=$(OUT_FR_PUBLIC)

$(OUT_EN_PRIVATE): common.tex en.tex personal-data-en-private
	make compile IN=en.tex PERSONAL_DATA=personal-data-en-private OUT=$(OUT_EN_PRIVATE)

$(OUT_EN_PUBLIC): common.tex en.tex personal-data-en-public
	make compile IN=en.tex PERSONAL_DATA=personal-data-en-public OUT=$(OUT_EN_PUBLIC)
