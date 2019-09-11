class { 'tomcat': }

tomcat::instance { 'Tomcat1_puppet':
        source_url => 'http://apache.cs.utah.edu/tomcat/tomcat-9/v9.0.24/bin/apache-tomcat-9.0.24.tar.gz'
}->
tomcat::service { 'default': }->

file { '/opt/apache-tomcat/webapps/mvn-hello-world.war':
    ensure => 'directory',
    owner  => 'tomcat',
    mode   => '0755',
    source => 'puppet:///modules/tomcat/mvn-hello-world.war';
  }
