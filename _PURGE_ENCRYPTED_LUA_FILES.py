import os

for root, dirs, files in os.walk(".", topdown=False):
    for name in files:
        temp = os.path.join(root, name)
        if name.endswith('.lua') and not temp.startswith('.\mods'):
            os.remove(temp)