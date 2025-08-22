fx_version "cerulean"
lua54 "yes"

game "gta5"

author "Walterr399"
version "1.0.0"
description "A simple and secure newlife system built for esx."

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua",
    "data/*.lua"
}

shared_scripts {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua"
}

files {
    "locales/*.json"
}