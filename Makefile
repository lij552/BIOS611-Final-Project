.PHONY: clean
.PHONY: init

init:
	mkdir -p derived_data
	mkdir -p figures
	mkdir -p logs

clean:
	rm -rf derived_data
	rm -rf figures
	rm -rf logs

data_cleaning:\
	flavors_of_cacao.csv\
	clean.R
	Rscript clean.R

plot:\
	data_cleaning visulization.R
	Rscript visulization.R
model:\
	data_cleaning model.R
	Rscript model.R
report:\
	plot model
	report.Rmd figures/corr.png
	Rscript -e "rmarkdown::render('report.Rmd')"
