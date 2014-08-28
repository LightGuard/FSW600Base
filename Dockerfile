#######################################################################
#                                                                     #
# Creates a base CentOS image with JBoss Data Virtualization 6.0.0.GA #
#                                                                     #
#######################################################################

# Use the centos base image
FROM centos

MAINTAINER kpeeples <kpeeples@redhat.com>

# Update the system
RUN yum -y update;yum clean all

# enabling sudo group for jboss
RUN echo '%jboss ALL=(ALL) ALL' >> /etc/sudoers

# Create jboss user
RUN useradd -m -d /home/jboss -p jboss jboss


##########################################################
# Install Java JDK, SSH and other useful cmdline utilities
##########################################################
RUN yum -y install java-1.7.0-openjdk which telnet unzip openssh-server sudo openssh-clients;yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre


############################################
# Install JBoss Fuse Service Works 6.0.0.GA
############################################
USER jboss
ENV INSTALLDIR /home/jboss/fsw
ENV HOME /home/jboss
RUN mkdir $INSTALLDIR && \
   mkdir $INSTALLDIR/software && \
   mkdir $INSTALLDIR/support && \
   mkdir $INSTALLDIR/demo && \
   mkdir $INSTALLDIR/jdbc

ADD software/jboss-fsw-installer-6.0.0.GA-redhat-4.jar $INSTALLDIR/software/jboss-fsw-installer-6.0.0.GA-redhat-4.jar 
#RUN curl https://www.jboss.org/download-manager/file/jboss-fsw-6.0.0.GA.zip > $INSTALLDIR/software/jboss-fsw-6.0.0.GA.zip
ADD support/InstallationScript.xml $INSTALLDIR/support/InstallationScript.xml
ADD support/InstallationScript.xml.variables $INSTALLDIR/support/InstallationScript.xml.variables
RUN java -jar $INSTALLDIR/software/jboss-fsw-installer-6.0.0.GA-redhat-4.jar $INSTALLDIR/support/InstallationScript.xml -variablefile $INSTALLDIR/support/InstallationScript.xml.variables
RUN rm -rf $INSTALLDIR/jboss-eap-6.1/standalone/configuration/standalone_xml_history/current

# Command line shortcuts
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre" >> $HOME/.bash_profile
RUN echo "alias ll='ls -l --color=auto'" >> $HOME/.bash_profile
RUN echo "alias grep='grep --color=auto'" >> $HOME/.bash_profile
RUN echo "alias c='clear'" >> $HOME/.bash_profile
RUN echo "alias sdv='$HOME/fsw/jboss-eap-6.1/bin/standalone.sh -c standalone.xml'" >> $HOME/.bash_profile
RUN echo "alias xdv='$HOME/fsw/jboss-eap-6.1/bin/jboss-cli.sh --commands=connect,:shutdown'" >> $HOME/.bash_profile

# Add for Homeloan ---------------------------------------------
ADD demo/standalone.xml $INSTALLDIR/demo/standalone.xml
RUN cp $INSTALLDIR/demo/standalone.xml /home/jboss/fsw/jboss-eap-6.1/standalone/configuration
ADD demo/lab1-1.0.0.jar $INSTALLDIR/demo/lab1-1.0.0.jar
RUN cp $INSTALLDIR/demo/lab1-1.0.0.jar /home/jboss/fsw/jboss-eap-6.1/standalone/deployments
RUN touch /home/jboss/fsw/jboss-eap-6.1/standalone/deployments/lab1-1.0.0.jar.dodeploy
ADD demo/customer.h2.db $INSTALLDIR/demo/customer.h2.db
RUN cp $INSTALLDIR/demo/customer.h2.db /home/jboss/fsw/jboss-eap-6.1/standalone/data/h2
ADD demo/customer.trace.db $INSTALLDIR/demo/customer.trace.db
RUN cp $INSTALLDIR/demo/customer.trace.db /home/jboss/fsw/jboss-eap-6.1/standalone/data/h2

# start.sh
USER root
RUN echo "#!/bin/sh"
RUN echo "echo JBoss Fuse Service Works Start script" >> $HOME/run.sh
RUN echo "runuser -l jboss -c '$HOME/fsw/jboss-eap-6.1/bin/standalone.sh -c standalone.xml -b 0.0.0.0 -bmanagement 0.0.0.0'" >> $HOME/run.sh
RUN chmod +x $HOME/run.sh

# Clean up
RUN rm -rf $INSTALLDIR/support
RUN rm -rf $INSTALLDIR/software

EXPOSE 22 3306 5432 8080 9990 27017 9999

CMD /home/jboss/run.sh

# Finished
