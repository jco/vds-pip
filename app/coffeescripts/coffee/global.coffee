# Files in app/coffeescripts are automatically compiled into JS in public/javascripts by Barista (gem)
# This file contains constants and useful global things for coffee files. Should be required first for coffee files.

# Preceding things with 'window' makes the variable global

# not working
# window.helper = new Helper() # available throughout coffee files

# path to images, so we can do things like <img src='#{IMAGE_PATH}/icons/folder.gif' />
window.IMAGE_PATH = '../images'