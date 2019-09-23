name 'migration'

default_source :supermarket

run_list 'fingerprint::default'

cookbook 'fingerprint', path: '../cookbooks/fingerprint'