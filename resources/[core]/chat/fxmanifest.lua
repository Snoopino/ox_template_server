fx_version 'adamant'
games { 'gta5' }

lua54 'yes'

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'
shared_script '@oxmysql/lib/MySQL.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.css',
    'html/config.default.js',
    'html/config.js',
    'html/App.js',
    'html/Message.js',
    'html/Suggestions.js',
    'html/vendor/vue.2.3.3.min.js',
    'html/vendor/flexboxgrid.6.3.1.min.css',
    'html/vendor/animate.3.5.2.min.css',
    'html/vendor/latofonts.css',
  }