FROM public.ecr.aws/q3h7b4o8/helio-notebook-py:v0.13_7

USER root

ADD apt.txt apt.txt
# Install apt packages specified in a apt.txt file if it exists.
# Unlike repo2docker, blank lines nor comments are supported here.
RUN echo "Checking for 'apt.txt'..." \
        ; if test -f "apt.txt" ; then \
        apt-get update --fix-missing > /dev/null \
        # Read apt.txt line by line, and execute apt-get install -y for each line in apt.txt
        && xargs -a apt.txt apt-get install -y > /dev/null\
        && apt-get clean > /dev/null \
        && rm -rf /var/lib/apt/lists/* \
        ; fi

USER ${NB_USER}

ADD environment.yml environment.yml

RUN mamba env update --prefix /srv/conda/envs/notebook --file environment.yml
