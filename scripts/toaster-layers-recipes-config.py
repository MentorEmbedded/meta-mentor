#!/usr/bin/env python3

import sys
import os
from collections import OrderedDict

bblayers, builddir, meldir = sys.argv[1], sys.argv[2], sys.argv[3]

bblayers = bblayers.split(",")

totalLayers = bblayers

layer_and_recipes = OrderedDict()

recipeListFile = builddir + "/conf/recipes-list.txt"
customXML = builddir + "/custom.xml"

layerabsPath = []

toStrip = None
layer = None

#Populate layer_and_recipes 

with open(recipeListFile, 'r') as f:
    for line in f:
        line = line.rstrip("\n")
        if line.endswith("/"):
            line = line.rstrip("/")
            toStrip = line
            if len(line.split("/")) > 1:
                layer = line.split("/")[-1]
            else:
                layer = line
            layer_and_recipes[layer] = [line]
        else:
            if line.endswith('.bb'):
                layer_and_recipes[layer].append(line.replace(toStrip + "/", ""))


# Now time to populate custom.xml

for layername in list(layer_and_recipes):
    if len(layer_and_recipes[layername]) == 1:
        del layer_and_recipes[layername]

pk = len(bblayers) + 1

fd = open(customXML, 'a')

for layername in layer_and_recipes:
    if len(layer_and_recipes[layername]) == 0 or layername in bblayers:
        continue
    totalLayers.append(layername)
    fd.write('  <object model="orm.layer" pk="%s">\n' %(str(pk)))
    fd.write('    <field type="CharField" name="name">%s</field>\n' %(layername))
    fd.write('    <field type="CharField" name="local_source_dir">%s</field>\n' %( meldir + "/" + layer_and_recipes[layername][0]))
    fd.write('  </object>\n')
    fd.write('  <object model="orm.layer_version" pk="%s">\n' %(str(pk)))
    fd.write('    <field rel="ManyToOneRel" to="orm.layer" name="layer">%s</field>\n' %(str(pk)))
    fd.write('    <field type="IntegerField" name="layer_source">0</field>\n')
    fd.write('    <field rel="ManyToOneRel" to="orm.release" name="release">2</field>\n')
    fd.write('    <field type="CharField" name="dirpath"></field>\n')
    fd.write('  </object>\n\n')
    pk += 1

pk = 1

# Populate recipes

for layername in layer_and_recipes:
    if len(layer_and_recipes[layername]) == 1:
        continue
    for recipePath in layer_and_recipes[layername]:
        if '.bb' not in recipePath:
            continue
        fd.write('  <object model="orm.recipe" pk="%s">\n' %(str(pk)))
        pk += 1
        recipe = recipePath.split("/")[-1]
        recipeName = recipe.split("_")[0]
        recipeVersion = None
        image = None
        layerindex = None
        if '.bb' in recipeName:
            recipeName = recipeName.rstrip('.bb')
        if len(recipe.split("_")) > 1:
            recipeVersion = recipe.split("_")[-1].rstrip('.bb')
        fd.write('    <field name="name" type="CharField">%s</field>\n' %(recipeName))
        if recipeVersion is None:
            fd.write('    <field name="version" type="CharField"></field>\n')
        else:
            fd.write('    <field name="version" type="CharField">%s</field>\n' %(recipeVersion))
        fd.write('    <field rel="ManyToOneRel" name="layer_version" to="orm.layer_version">%s</field>\n' %(str(totalLayers.index(layername)+1)))
        fd.write('    <field name="file_path" type="FilePathField">%s</field>\n' %(recipePath))
        if '-image' in recipePath:
           image = "yes"
        if image == "yes":
           fd.write('    <field name="is_image" type="BooleanField">True</field>\n')
        else:
           fd.write('    <field name="is_image" type="BooleanField">False</field>\n')
        fd.write('  </object>\n')

fd.close()
