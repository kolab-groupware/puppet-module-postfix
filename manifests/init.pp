class postfix {

    file { "/etc/postfix/main.cf":
        owner => "root",
        group => "root",
        mode => "644",
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
        mode => "644",
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

    package { [
            "sendmail",
            "sendmail-cf"
        ]:
        ensure => absent,
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

    class amavisd inherits postfix {
        file { "/etc/amavisd/amavisd.conf":
            owner => "root",
            group => "root",
            mode => "644",
            source => [
                    "puppet://$server/private/$environment/postfix/amavisd/amavisd.conf.$hostname",
                    "puppet://$server/private/$environment/postfix/amavisd/amavisd.conf",
                    "puppet://$server/files/postfix/amavisd/amavisd.conf.$hostname",
                    "puppet://$server/files/postfix/amavisd/amavisd.conf",
                    "puppet://$server/modules/postfix/amavisd/amavisd.conf.$hostname",
                    "puppet://$server/modules/postfix/amavisd/amavisd.conf"
                ],
            require => Package["amavisd-new"],
            notify => Service["amavisd"]
        }

        file { "/etc/clamd.d/amavisd.conf":
            owner => "root",
            group => "root",
            mode => "644",
            source => [
                    "puppet://$server/private/$environment/postfix/amavisd/clamd.conf.$hostname",
                    "puppet://$server/private/$environment/postfix/amavisd/clamd.conf",
                    "puppet://$server/files/postfix/amavisd/clamd.conf.$hostname",
                    "puppet://$server/files/postfix/amavisd/clamd.conf",
                    "puppet://$server/modules/postfix/amavisd/clamd.conf.$hostname",
                    "puppet://$server/modules/postfix/amavisd/clamd.conf"
                ],
            require => Package["clamd"],
            notify => Service["clamd.amavisd"]
        }

        file { "/etc/sysconfig/clamd":
            owner => "root",
            group => "root",
            mode => "644",
            source => [
                    "puppet://$server/private/$environment/postfix/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/private/$environment/postfix/amavisd/clamd.sysconfig",
                    "puppet://$server/files/postfix/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/files/postfix/amavisd/clamd.sysconfig",
                    "puppet://$server/modules/postfix/amavisd/clamd.sysconfig.$hostname",
                    "puppet://$server/modules/postfix/amavisd/clamd.sysconfig"
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
                    Package["amavisd-new"]
                ]
        }

        service { "clamd.amavisd":
            ensure => running,
            enable => true,
            require => [
                    File["/etc/clamd.d/amavisd.conf"],
                    File["/etc/sysconfig/clamd"],
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

    class mailman inherits postfix {

            file { "/etc/postfix/mailman/":
            owner => "root",
            group => "root",
            recurse => true,
            purge => false,
            force => true,
            require => Package["postfix"],
            notify => Service["postfix"],
            source => [
                    "puppet://$server/private/$environment/postfix/mailman.$hostname/",
                    "puppet://$server/private/$environment/postfix/mailman/",
                    "puppet://$server/files/postfix/mailman.$hostname/",
                    "puppet://$server/files/postfix/mailman/",
                    "puppet://$server/modules/postfix/mailman.$hostname/",
                    "puppet://$server/modules/postfix/mailman/"
                ]   
        }

    }

    class template($template = "postfix/main.cf.erb") inherits postfix {
        File["/etc/postfix/main.cf"] {
            source => undef,
            content => template("$template")
        }
    }
}
