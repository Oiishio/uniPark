-- Generated automaticly by RB Generator.
fx_version('cerulean')
games({ 'gta5' })
author 'Oiishio'
lua54 'yes'

shared_script('@ox_lib/init.lua', 'config.lua');

dependencies {'oxmysql', 'ox_lib'}

server_scripts({
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/server.lua',
});

files({
    'locales/*.json'
});

client_scripts({
    'config.lua',
    '@PolyZone/client.lua',
    'client/client.lua',
    'client/functions.lua',
});
