fx_version 'cerulean'

game 'gta5'

author 'Fleevo' -- https://github.com/fleevo32

lua54 'yes'

version '1.0.1'

client_scripts {
  'client/*.lua'
}

shared_scripts {
  '@es_extended/imports.lua',
  '@oxmysql/lib/MySQL.lua',
  'config.lua'
}

server_scripts {
  'server/*.lua'
}

dependencies { 
  'qtarget',
  'nh-context',
  'es_extended',
  'esx_ambulancejob'
}
