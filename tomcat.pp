class { 'tomcat': }

tomcat::instance { 'Tomcat1_puppet':
        source_url => 'https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.24/src/apache-tomcat-9.0.24-src.tar.gz'
}->
exec { 'chown -R tomcat:tomcat /opt/apache-tomcat':
  path => ['/bin'],
}
tomcat::service { 'default': }


file {'/opt/apache-tomcat/webapps/mvn-hello-world.war':
  ensure => 'directory',
  owner  => 'tomcat',
  source => "puppet:///modules/tomcat/mvn-hello-world.war",
}

