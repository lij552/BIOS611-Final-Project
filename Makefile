.PHONY: clean init report data_cleaning plot model

init:
	mkdir -p derived_data
	mkdir -p figures
	mkdir -p logs

clean:
	rm -rf derived_data
	rm -rf figures
	rm -rf logs
	rm -f report.html

data_cleaning: flavors_of_cacao.csv clean.R
	Rscript clean.R

plot: data_cleaning visulization.R
	Rscript visulization.R

model: data_cleaning model.R
	Rscript model.R

report: init plot model report.Rmd
	Rscript -e "rmarkdown::render('report.Rmd')"

