class postfix {

    file { "/etc/postfix/main.cf":
        owner => "root",
        group => "root",
        mode => 644,
        source => [
                "puppet://$server/private/$environment/postfix/main.cf.$hostname",
                "puppet://$server/private/$environment/postfix/main.cf",
                "puppet://$server/files/postfix/main.cf.$hostname",
                "puppet://$server/files/postfix/main.cf",
                "puppet://$server/modules/postfix/main.cf.$hostname",
                "puppet://$server/modules/postfix/main.cf"
            ],
        require => Package["postfix"],
        notify => Service["postfix"]
    }

    file { "/etc/postfix/master.cf":
        owner => "root",
        group => "root",
        mode => 644,
        source => [
                "puppet://$server/private/$environment/postfix/master.cf.$hostname",
                "puppet://$server/private/$environment/postfix/master.cf",
                "puppet://$server/files/postfix/master.cf.$hostname",
                "puppet://$server/files/postfix/master.cf",
                "puppet://$server/modules/postfix/master.cf.$hostname",
                "puppet://$server/modules/postfix/master.cf"
            ],
        require => Package["postfix"],
        notify => Service["postfix"]
    }

    package { "postfix":
        ensure => installed
    }

    package { "sendmail":
        ensure => purged,
        require => Package["postfix"]
    }

    service { "postfix":
        ensure => running,
        enable => true,
        require => [
                File["/etc/postfix/main.cf"],
                File["/etc/postfix/master.cf"],
                Package["postfix"]
            ]
    }

    service { "amavisd":
        ensure => running,
        enable => true
    }

    class amavisd inherits postfix {
        file { "/etc/amavisd/amavisd.conf":
            owner => "root",
            group => "root",
            mode => 644,
            source => [
                    "puppet://$server/private/$environment/postfix/amavisd.conf.$hostname",
                    "puppet://$server/private/$environment/postfix/amavisd.conf",
                    "puppet://$server/files/postfix/amavisd.conf.$hostname",
                    "puppet://$server/files/postfix/amavisd.conf",
                    "puppet://$server/modules/postfix/amavisd.conf.$hostname",
                    "puppet://$server/modules/postfix/amavisd.conf"
                ],
            require => Package["amavisd-new"],
            notify => Service["amavisd"]
        }

        file { "/etc/clamd.d/amavisd.conf":
            owner => "root",
            group => "root",
            mode => 644,
            source => [
                    "puppet://$server/private/$environment/postfix/clamd.conf.$hostname",
                    "puppet://$server/private/$environment/postfix/clamd.conf",
                    "puppet://$server/files/postfix/clamd.conf.$hostname",
                    "puppet://$server/files/postfix/clamd.conf",
                    "puppet://$server/modules/postfix/clamd.conf.$hostname",
                    "puppet://$server/modules/postfix/clamd.conf"
                ],
            require => Package["clamd"],
            notify => Service["clamd.amavisd"]
        }

        package { [
                "amavisd-new",
                "clamd"
            ]:
            ensure => installed
        }

        service { "amavisd":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/amavisd/amavisd.conf"],
                    Package["amavisd"]
                ]
        }

        service { "clamd.amavisd":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/clamd.d/amavisd.conf"],
                    Package["clamd"]
                ]
        }
    }

    class ldap inherits postfix {

        file { "/etc/postfix/ldap/":
            owner => "root",
            group => "root",
            recurse => true,
            purge => true,
            force => true,
            require => Package["postfix"],
            notify => Service["postfix"],
            source => [
                    "puppet://$server/private/$environment/postfix/ldap.$hostname/",
                    "puppet://$server/private/$environment/postfix/ldap/",
                    "puppet://$server/files/postfix/ldap.$hostname/",
                    "puppet://$server/files/postfix/ldap/",
                    "puppet://$server/modules/postfix/ldap.$hostname/",
                    "puppet://$server/modules/postfix/ldap/"
                ]
        }

        Service["postfix"] {
            require +> [
                    File["/etc/postfix/ldap/"]
                ]
        }
    }
}