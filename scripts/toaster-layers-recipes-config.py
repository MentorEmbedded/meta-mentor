#!/usr/bin/env python3

import sys
import os
import re
from collections import OrderedDict

bblayers, builddir, meldir = sys.argv[1], sys.argv[2], sys.argv[3]

OE_CORE_NAME = "openembedded-core"

configured_layers = [OE_CORE_NAME]

def get_layer_name(lpath):
    layerconf = lpath + "/conf/layer.conf"
    lc = open(layerconf, "r")
    for ln in lc:
        ln = ln.rstrip("\n")
        layer = re.match("BBFILE_COLLECTIONS *\+= *\"", ln)
        if layer:
            layer = ln.split("\"")[1]
            if layer == "core":
                layer = OE_CORE_NAME
            break
    lc.close()
    return layer

# Parse through layers from bblayers.conf and pick up layer names
for base_layer in bblayers.split():
    layer = get_layer_name(base_layer)
    if layer:
        if layer == OE_CORE_NAME:
            continue
        configured_layers.append(layer)

totalLayers = list(configured_layers)

layer_and_recipes = OrderedDict()

recipeListFile = builddir + "/conf/recipes-list.txt"
customXML = builddir + "/custom.xml"

layerabsPath = []

toStrip = None
layer = None

# Populate layer_and_recipes
with open(recipeListFile, 'r') as f:
    for line in f:
        line = line.rstrip("\n")
        # Check if it's a layer or a recipe
        if line.endswith("/"):
            toStrip = line
            line = line.rstrip("/")
            layer = get_layer_name(line)
            if layer:
                layer_and_recipes[layer] = [line]
        else:
            if line.endswith('.bb'):
                layer_and_recipes[layer].append(line.replace(toStrip, ""))

# Now we need to add all layers that are found in the MEL install dir
# to custom.xml, layers from bblayers.conf are already added
pk = len(configured_layers) + 1
fd = open(customXML, 'a')
for layername in layer_and_recipes:
    # Skip the layer entry if it's already configured
    if len(layer_and_recipes[layername]) == 0 or layername in configured_layers:
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

# Reset pk and populate recipes
pk = 1
fd.write('  <!-- Recipe entries -->\n')
for layername in layer_and_recipes:
    # Skip layers which don't have a .bb
    if len(layer_and_recipes[layername]) == 1:
        continue
    # For each .bb in the current layer add an orm.recipe type custom.xml entry
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
