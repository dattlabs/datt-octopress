FROM datt/datt-ruby:latest
MAINTAINER John Albietz <inthecloud247@gmail.com>

# make sure we're working in UTF8
ENV LC_ALL en_US.utf8

# add the current blog source
ADD . /o
WORKDIR /o

# install octopress dependencies
RUN gem install bundler
RUN bundle install

# set up user so that host files have correct ownership
RUN addgroup --gid 1000 blog
RUN adduser --uid 1000 --gid 1000 blog
RUN chown -R blog.blog /o
USER blog

# rake is the default command.
CMD if [ $RUN_DEBUG -gt 0 ]                                         ; \
      then                                                            \
        echo [DEBUG]; env | grep "._" >> /etc/environment           ; \
        env | grep "._" >> /etc/environment                         ; \
        /usr/bin/supervisord && /bin/bash                           ; \
      else                                                            \
        env | grep "._" >> /etc/environment                         ; \
        /usr/bin/supervisord --nodaemon && rake                     ; \
    fi
