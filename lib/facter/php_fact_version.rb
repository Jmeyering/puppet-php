Facter.add("php_fact_version") do
  setcode do
    Facter::Util::Resolution.execute('php -v|awk \'{ print $2 }\'|head -n1')    || nil
  end
end
