Facter.add('realfqdn') do
  setcode do
    Facter::Core::Execution.exec('/bin/hostname -f')
  end
end
