Facter.add("php_release") do
    setcode do
        if Facter::Util::Resolution.which('php')
            Facter::Util::Resolution.exec('php -v|awk \'{ print $2 }\'|head -n1|cut -c1-3')    || nil
        end
    end
end
