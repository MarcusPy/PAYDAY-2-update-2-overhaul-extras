import os

for root, dirs, files in os.walk(".", topdown=False):
    for name in files:
        temp = os.path.join(root, name)
        if temp.endswith('.lua_source') and not temp.startswith('.\mods'):
            name, ext = os.path.splitext(temp)
            os.rename(temp, temp[:-7])