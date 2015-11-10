FROM phusion/passenger-ruby22
MAINTAINER Nilton Vasques "nilton.vasques@gmail.com" 

ENV HOME /root
ENV RAILS_ENV production

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y postgresql-client libpq-dev vim --no-install-recommends && rm -rf /var/lib/apt/lists/* 

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/micro-twit-ru.conf

# APP SETTINGS
RUN sudo bundle config --global frozen 1
# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
#RUN bundle install --deployment --verbose --retry 4
RUN bundle pack --verbose
RUN bundle install --path vendor/cache --deployment --verbose --retry 4
RUN ls -la
RUN ls -la vendor/
RUN pwd

ENV RAILS_ENV production

RUN mkdir /home/app/micro-twit-ru
ADD . /home/app/micro-twit-ru
RUN ln -s /tmp/vendor/bundle /home/app/micro-twit-ru/vendor/
RUN ln -s /tmp/vendor/cache /home/app/micro-twit-ru/vendor/
WORKDIR /home/app/micro-twit-ru
RUN chown -R app:app /home/app/micro-twit-ru
#ADD ./Gemfile Gemfile
#ADD ./Gemfile.lock Gemfile.lock
#RUN sudo -u app bundle install --deployment --verbose --retry 4
RUN ls -la vendor
#RUN ls -la vendor/bundle/
RUN pwd
RUN bundle exec rake assets:precompile

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#----------------------------------------------------------------------



#COPY . /home/app/webapp
#COPY Gemfile /home/app/webapp
#COPY Gemfile.lock /home/app/webapp
#
#ENV RAILS_ENV production
#
#RUN bundle install 
#
#RUN bundle exec rake assets:precompile --trace 
#
#RUN rm -f /etc/service/nginx/down
#
