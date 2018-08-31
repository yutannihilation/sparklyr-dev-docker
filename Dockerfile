FROM rocker/r-base:latest

# install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    scala \
    r-cran-assertthat \
    r-cran-base64enc \
    r-cran-broom \
    r-cran-dplyr \
    r-cran-dbplyr \
    r-cran-digest \
    r-cran-httr \
    r-cran-jsonlite \
    r-cran-lazyeval \
    r-cran-openssl \
    r-cran-rappdirs \
    r-cran-rlang \
    r-cran-rprojroot \
    r-cran-rstudioapi \
    r-cran-shiny \
    r-cran-withr \
    r-cran-xml2 \
    r-cran-tidyr \
    r-cran-purrr \
    r-cran-ggplot2 \
    r-cran-glmnet \
    r-cran-mlbench \
    r-cran-nnet \
    r-cran-rcurl \
    r-cran-reshape2 \
    r-cran-testthat \
    r-cran-tibble \
    # git2r is needed for remotes
    r-cran-git2r \
    # it seems spark won't work with Java 10 yet
    openjdk-8-jdk-headless \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

# remotes is needed inside installGithub.r
RUN install2.r --error --deps TRUE remotes

RUN installGithub.r --deps TRUE rstudio/sparklyr

# install scala 2.10 and 2.11, which is currently specified in spark_default_compilation_spec()
RUN mkdir /usr/local/scala/ \
  && wget -O - https://downloads.lightbend.com/scala/2.10.7/scala-2.10.7.tgz | tar -x -z -f - -C /usr/local/scala/ \
  && wget -O - https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.tgz | tar -x -z -f - -C /usr/local/scala/

# install spark
RUN r \
  -e 'specs <- sparklyr:::spark_default_compilation_spec("sparklyr"); \
      for (s in specs) sparklyr:::spark_install(s$spark_version, verbose = TRUE)'

WORKDIR /root/sparklyr
