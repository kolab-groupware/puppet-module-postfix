class postfix {
    @service { "postfix":
        ensure => running,
        enable => true,
        require => Package["postfix"]
    }

    @package { "postfix":
        ensure => installed,
        notify => Service["postfix"]
    }

    @service { "amavisd":
        ensure => running,
        enable => true
    }

    @package { "amavisd-new":
        ensure => installed,
        notify => Service["amavisd"]
    }

    class amavisd inherits postfix {
        realize(Package["postfix"],Service["postfix"])
        realize(Package["amavisd-new"],Service["amavisd"])
    }
}