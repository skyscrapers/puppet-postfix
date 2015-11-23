Facter.add('realfqdn') do
  setcode do
    Facter::Util::Resolution.exec('/bin/hostname -f')
  end
end
