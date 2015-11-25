Facter.add("php_fact_version") do
    setcode do
        if Facter::Util::Resolution.which('php')
            Facter::Core::Execution.execute('php -v|awk \'{ print $2 }\'|head -n1')    || nil
        end
    end
end
