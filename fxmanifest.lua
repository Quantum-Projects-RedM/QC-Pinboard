fx_version 'adamant'
game 'rdr3'
lua54 'yes'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '1.0.0'
files {
  'config.lua'
}

client_scripts {
  'config.lua',
  'client.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'config.lua',
  'server.lua'
}
ui_page 'html/index.html'

files {
    'html/index.js',
    'html/index.css',
    'html/index.html',
    'html/crock.ttf',
    'html/images/*.png',
}

