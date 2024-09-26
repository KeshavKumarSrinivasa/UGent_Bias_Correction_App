# Use the Rocker Verse base image with R 4.4.0
FROM rocker/verse:4.4.0

# Install required dependencies
RUN apt-get update && apt-get install -y make zlib1g-dev && rm -rf /var/lib/apt/lists/*

# Set R options for CRAN and multithreading
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site

# Install necessary R packages
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("shiny", upgrade="never", version = "1.9.1")'
RUN Rscript -e 'remotes::install_version("config", upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("golem", upgrade="never", version = "0.5.1")'

# Create and set up the build directory
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone

# Install the app
RUN R -e 'remotes::install_local(upgrade="never")'

# Clean up the build zone
RUN rm -rf /build_zone

# Expose the port
EXPOSE 8080

# Run the app with dynamic port binding
CMD R -e "options('shiny.port' = as.numeric(Sys.getenv('PORT')), shiny.host = '0.0.0.0'); repurpose::run_app()"
