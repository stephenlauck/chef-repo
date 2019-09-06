# Chef upgrade and migration setup

## Register for Account

Go to https://manage.chef.io/signup

fullname: chef migration
email: lauck@chef.io
username: migration

create org:
migration full name
migration666 shortname

`download starter kit`

## Validate Connectivity

```
cd chef-repo
knife client list
```

## Add Node to migration

`curl https://raw.githubusercontent.com/stephenlauck/chef-repo/master/bootstrap.sh | sudo bash`


## Bug Notes

Key not found, needs to be on SAAS bldr?

`hab origin key upload lauck`

SSL issues when uplaoding key

`export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem`


## Build hab package

```
hab studio enter
build
hab pkg upload results/lauck-migration-0.1.0-20190906051354-x86_64-linux.hart
hab pkg promote lauck/migration/0.1.0/20190906051354 stable
```
