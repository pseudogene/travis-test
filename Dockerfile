FROM ubuntu:16.04
MAINTAINER Michael Bekaert <michael.bekaert@stir.ac.uk>

ENV DOCKERVERSION 1.0

USER root

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget ca-certificates
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make bioperl primer3 ncbi-blast+ clustalw

RUN perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'
RUN perl -MCPAN -e 'force install Bio::DB::EUtilities'

RUN mkdir -p /usr/local/share/qdd && \
    wget http://net.imbe.fr/~emeglecz/QDDweb/QDD-3.1.2/QDD-3.1.2.tar.gz -O /usr/local/share/qdd/QDD-3.1.2.tar.gz && \
    cd /usr/local/share/qdd && \
    tar xfz QDD-3.1.2.tar.gz && \
    ln -s /usr/local/share/qdd/subprogramQDD.pm /etc/perl/subprogramQDD.pm && \
    ln -s /usr/local/share/qdd/ncbi_taxonomy.pm /etc/perl/ncbi_taxonomy.pm && \
    mkdir /etc/qdd/ && \
    mv /etc/primer3_config /usr/bin && \
    sed -i 's/blast_path=/blast_path= \/usr\/bin\//' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/clust_path =/clust_path = \/usr\/bin\//' /usr/local/share/qdd/set_qdd_default.ini && \
#    sed -i 's/primer3_path = \/usr\/bin\//primer3_path = \/usr\/bin\//' /usr/local/share/qdd/set_qdd_default.ini && \
#    sed -i 's/primer3_version = 2/primer3_version = 2/' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/qdd_folder = \/home\/qdd\/galaxy-dist\/tools\/qdd\//qdd_folder = \/usr\/local\/share\/qdd\//' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/out_folder = \/home\/qdd\/galaxy-dist\/tools\/qdd\/qdd_output\//out_folder = \/tmp\//' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/num_threads = 1/num_threads = 15/' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/blastdb = \/usr\/local\/nt\/nt\//blastdb = \/blast_databases\//' /usr/local/share/qdd/set_qdd_default.ini && \
    sed -i 's/local_blast = 0/local_blast = 1/' /usr/local/share/qdd/set_qdd_default.ini && \
    ln -s /usr/local/share/qdd/set_qdd_default.ini /etc/qdd/set_qdd_default.ini && \
    rm -rf QDD-3.1.2.tar.gz

RUN mkdir /qdd && mkdir /blast_databases
WORKDIR /qdd
