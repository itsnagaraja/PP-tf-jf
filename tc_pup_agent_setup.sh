tc_server_pri_dns=`sed -n '1p' < tc_pri_dns.txt`
echo $tc_server_pri_dns
tc_server_pri_ip=`sed -n '1p' < tc_pri_ip.txt`
echo $tc_server_pri_ip
pupmaster_pri_ip=`sed -n '1p' < pup_master_pri_ip.txt`
echo $pupmaster_pri_ip
pupmaster_pri_dns=`sed -n '1p' < pup_master_pri_dns.txt`
echo $pupmaster_pri_dns
sleep 20
#ssh -i tomcat_ec2_key -tt ubuntu@$tc_server_pri_dns -oStrictHostKeyChecking=no <<EOF
ssh -t ubuntu@$tc_server_pri_dns -i "tomcat_ec2_key" -oStrictHostKeyChecking=no "/usr/bin/sudo bash -c 'hostname tomcatpuppetagent.ec2.internal; \
echo tomcatpuppetagent.ec2.internal > /etc/hostname; \
echo $pupmaster_pri_ip puppetmaster.ec2.internal ${pupmaster_pri_dns} >> /etc/hosts; \
echo ${tc_server_pri_ip} tomcatpuppetagent.ec2.internal ${tc_server_pri_dns} >> /etc/hosts; \
wget https://apt.puppetlabs.com/puppet-release-bionic.deb; \
dpkg -i puppet-release-bionic.deb; \
apt-get update -y; \
apt-get install puppet -y; \
exit;'"
#EOF


echo "Configuring puppet agent on Tomcat"
#ssh -i tomcat_ec2_key -tt ubuntu@$tc_server_pri_dns -oStrictHostKeyChecking=no <<EOF
ssh -t ubuntu@$tc_server_pri_dns -i "tomcat_ec2_key" -oStrictHostKeyChecking=no "/usr/bin/sudo bash -c 'mv /etc/puppetlabs/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf.orig; \
echo [main] > /etc/puppetlabs/puppet/puppet.conf; \
echo ssldir = /var/lib/puppet/ssl >> /etc/puppetlabs/puppet/puppet.conf; \
echo certname = tomcatpuppetagent.ec2.internal >> /etc/puppetlabs/puppet/puppet.conf; \
echo server = puppetmaster.ec2.internal >> /etc/puppetlabs/puppet/puppet.conf; \
echo environment = production >> /etc/puppetlabs/puppet/puppet.conf; \
export PATH=$PATH:/opt/puppetlabs/puppet/bin; \
systemctl restart puppet; \
systemctl enable puppet; \
exit;'"
#EOF

echo "Signing puppet certs from Puppet master"
ssh -i /opt/puppet/puppet_ec2_key -t ubuntu@$pupmaster_pri_ip -oStrictHostKeyChecking=no "/usr/bin/sudo bash -c 'echo ${tc_server_pri_ip} tomcatpuppetagent.ec2.internal ${tc_server_pri_dns} >> /etc/hosts; \
puppet cert list; \
puppet cert sign tomcatpuppetagent.ec2.internal; \
exit;'"
#EOF

echo "Test puppet agent (Tomcat server) connection"
ssh -i tomcat_ec2_key -t ubuntu@$tc_server_pri_dns -oStrictHostKeyChecking=no "/usr/bin/sudo bash -c 'puppet agent --test; \
exit;'"
#EOF

