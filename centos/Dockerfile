FROM centos 

RUN dnf update -y  && dnf install openssh-server -y 

#RUN useradd centos && \
#      echo "1234" | passwd centos --stdin && \

#RUN useradd centos

RUN  mkdir -p /home/centos/.ssh && \
      chmod 700 /home/centos/.ssh

COPY centos.pub /home/centos/.ssh/authorized_keys

RUN chown centos:centos -R /home/centos/.ssh && \
      chmod 600 /home/centos/.ssh/authorized_keys

#RUN /usr/sbin/ssh-keygen

CMD ["/usr/sbin/sshd -D"]




 
 


