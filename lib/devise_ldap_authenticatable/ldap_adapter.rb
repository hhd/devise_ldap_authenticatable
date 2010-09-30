require 'net/ldap'

module Devise

  # simple adapter for ldap credential checking
  # ::Devise.ldap_host
  module LdapAdapter

    def self.valid_credentials?(login, password)
      login = "#{::Devise.ldap_domain}\\#{login}"
      @encryption = ::Devise.ldap_ssl ? :simple_tls : nil
      ldap = Net::LDAP.new(:encryption => @encryption)
      ldap.host = ::Devise.ldap_host
      ldap.port = ::Devise.ldap_port
      ldap.auth login, password

      ldap.bind
    end

  end

end
