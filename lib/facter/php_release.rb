Facter.add("php_release") do
    setcode do
        Facter::Util::Resolution.exec('php -v|awk \'{ print $2 }\'|head -n1|cut -c1-3')    || nil
    end
end
