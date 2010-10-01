Devise LDAP Authenticatable - Based on Devise-Imapable
=================

Devise LDAP Authenticatable is a LDAP based authentication strategy for the [Devise](http://github.com/plataformatec/devise) authentication framework.

This modification is tailored towards our own requirements, but should be useful to anyone who wants to:

- Allow LDAP auth to work along-side database authentication (and not replace it)
- Requires a timeout to prevent hung threads when/if the LDAP server is down
- Uses a simplified user format (probably a better term for this)
  - We use (u, p): DOMAIN/user, password
- Is still using Rails 2 (tested on 2.3.8)

Requirements
------------

- Rails 2.3.8
- Devise 1.0.6+
- Net-LDAP 0.1.1+

**_Please Note_**

You must use the net-ldap gem and _NOT_ the ruby-net-ldap gem.  

Your devise model (User, for example) should have a "full_name" field. If you don't want it, just remove the reference to it in ./lib/.../model.rb

Installation
------------

 Just install this as a plugin:

 ./script/plugin install git://github.com/hhd/devise_ldap_authenticatable.git

Setup
-----

Once devise\_ldap\_authenticatable is installed, all you need to do is setup the user model which includes a small addition to the model itself and to the schema.

First the schema :

    create_table :users do |t|
      t.ldap_authenticatable, :null => false
    end

and don’t forget to migrate :

    rake db:migrate.

then the model :

    class User < ActiveRecord::Base
      devise :ldap_authenticatable, :database_authenticatable, :rememberable, :trackable, :timeoutable

      # Setup accessible (or protected) attributes for your model
      attr_accessible :email, :password, :remember_me, :ldap
      ...
    end


Configuration
----------------------

In initializer  `config/initializers/devise.rb` :

    Devise.setup do |config|
      # Required
      config.ldap_host = 'ldap.mydomain.com'
      config.ldap_port = 389
	  config.ldap_domain = 'DOMAIN'
	
	  # Optional, these will default to false or nil if not set
	  config.ldap_ssl = true
	  config.ldap_create_user = true
    end

* ldap\_host
	* The host of your LDAP server
	
* ldap\_port
	* The port your LDAP service is listening on.
	
* ldap\_domain
	* The domain that is prepended to the username.
	
* ldap\_ssl
	* Enables SSL (ldaps) encryption.  START_TLS encryption will be added when the net-ldap gem adds support for it.

* ldap\_create\_user
	* If set to true, all valid LDAP users will be allowed to login and an appropriate user record will be created.
      If set to false, you will have to create the user record before they will be allowed to login.

      NOTE: A boolean field, 'ldap', will be set to true for all devise records created in this way. This way you can
            discern between database and LDAP users in other parts of your app.


References
----------

* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)
* [LDAP_authenticatable](http://github.com/cschiewek/devise_ldap_authenticatable)


Released under the MIT license

Copyright (c) 2010 Curtis Schiewek
