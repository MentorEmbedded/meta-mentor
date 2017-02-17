#!/usr/bin/env python3

import sys
import os
import re
from collections import OrderedDict

builddir, meldir, cmdline = sys.argv[1], sys.argv[2], sys.argv[3]

OE_CORE_NAME = "openembedded-core"

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

bblayers = []
bblayerconf = builddir + "/conf/bblayers.conf"
start_found = False
blc = open(bblayerconf, "r")
for ln in blc:
    if start_found:
        if ln.startswith("\""):
            break
        bblayers.append(ln.strip().split()[0])
    elif ln.startswith("BBLAYERS = \""):
        start_found = True
blc.close()

localconf = builddir + "/conf/local.conf"
lc = open(localconf, "r")
distro_found, machine_found = False, False
for ln in lc:
    dist = re.match("DISTRO *\= *\'", ln)
    if dist:
        distro = ln.split("\'")[1]
        distro_found = True
    mch = re.match("MACHINE *\?\?\= *\"", ln)
    if mch:
        machine = ln.split("\"")[1]
        machine_found = True
    if distro_found and machine_found:
        break
lc.close()

customXML = builddir + "/custom.xml"
fd = open(customXML, 'w')
fd.write('<?xml version="1.0" encoding="utf-8"?>\n')
fd.write('<django-objects version="1.0">\n\n')
fd.write('  <!-- Reset to MEL -->\n\n')
fd.write('  <object model="orm.release" pk="2">\n')
fd.write('    <field type="CharField" name="name">local</field>\n')
fd.write('    <field type="CharField" name="description">Mentor Embedded Linux</field>\n')
fd.write('    <field rel="ManyToOneRel" to="orm.bitbakeversion" name="bitbake_version">2</field>\n')
fd.write('    <field type="CharField" name="branch_name">HEAD</field>\n')
fd.write('    <field type="TextField" name="helptext">Toaster will run your builds with the version of the Yocto Project you have cloned or downloaded to your computer.</field>\n')
fd.write('  </object>\n\n')
fd.write('  <!-- Default project settings -->\n')
fd.write('  <object model="orm.toastersetting" pk="1">\n')
fd.write('    <field type="CharField" name="name">DEFAULT_RELEASE</field>\n')
fd.write('    <field type="CharField" name="value">local</field>\n')
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="2">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_PACKAGE_CLASSES</field>\n')
fd.write('    <field type="CharField" name="value">package_ipk</field>\n')
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="3">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_MACHINE</field>\n')
fd.write('    <field type="CharField" name="value">%s</field>\n' % (machine))
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="4">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_DISTRO</field>\n')
fd.write('    <field type="CharField" name="value">%s</field>\n' % (distro))
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="5">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_ACCEPT_FSL_EULA</field>\n')
fd.write('    <field type="CharField" name="value"></field>\n')
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="6">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_SSTATE_DIR</field>\n')
fd.write('    <field type="CharField" name="value">%s/../sstate-cache</field>\n' % (builddir))
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="7">\n')
fd.write('    <field type="CharField" name="name">DEFCONF_DL_DIR</field>\n')
fd.write('    <field type="CharField" name="value">%s/downloads</field>\n' % (meldir))
fd.write('  </object>\n')
fd.write('  <object model="orm.toastersetting" pk="8">\n')
fd.write('    <field type="CharField" name="name">CUSTOM_BUILD_INIT_SCRIPT</field>\n')
fd.write('    <field type="CharField" name="value">%s</field>\n' % (cmdline))
fd.write('  </object>\n\n\n')

# Now fill up the default layers section
# i.e. layers found in bblayers.conf
fd.write('  <!-- Default layers for each release -->\n\n')
# oe-core the special case
fd.write('  <object model="orm.releasedefaultlayer" pk="1">\n')
fd.write('    <field rel="ManyToOneRel" to="orm.release" name="release">2</field>\n')
fd.write('    <field type="CharField" name="layer_name">%s</field>\n' % (OE_CORE_NAME))
fd.write('  </object>\n\n')
# Now populate the rest from bblayers.conf
pk=4
for base_layer in bblayers:
    layername = get_layer_name(base_layer)
    if layername:
        if layername == OE_CORE_NAME:
            oe_core_path = base_layer
            continue
        fd.write('  <object model="orm.releasedefaultlayer" pk="%s">\n' % str(pk))
        fd.write('    <field rel="ManyToOneRel" to="orm.release" name="release">2</field>\n')
        fd.write('    <field type="CharField" name="layer_name">%s</field>\n' % (layername))
        fd.write('  </object>\n\n')
        pk += 1

# Now we populate all the local layers (including everything added already) so
# recipes can be tied up to these
fd.write('\n  <!-- Layers for the Local release\n')
fd.write('       layersource TYPE_LOCAL = 0\n')
fd.write('  -->\n\n')
# Openembedded-core is poky's meta layer.
# We need to preconfigure this as it is a special case.
pk=1
fd.write('  <object model="orm.layer" pk="%s">\n' % str(pk))
fd.write('    <field type="CharField" name="name">%s</field>\n' % (OE_CORE_NAME))
fd.write('    <field type="CharField" name="local_source_dir">%s</field>\n' % (oe_core_path))
fd.write('  </object>\n')
fd.write('  <object model="orm.layer_version" pk="%s">\n' % str(pk))
fd.write('    <field rel="ManyToOneRel" to="orm.layer" name="layer">%s</field>\n' % str(pk))
fd.write('    <field type="IntegerField" name="layer_source">0</field>\n')
fd.write('    <field rel="ManyToOneRel" to="orm.release" name="release">2</field>\n')
fd.write('    <field type="CharField" name="dirpath"></field>\n')
fd.write('  </object>\n\n')
fd.close()

# Populate a dictionary of local layers/recipes available through
# the recipe-list file.
layer_and_recipes = OrderedDict()
toStrip = None
layer = None
recipeListFile = builddir + "/conf/recipes-list.txt"
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
# to custom.xml, oe-core should be added on the top manually
totalLayers = [OE_CORE_NAME]
pk = len(totalLayers) + 1
fd = open(customXML, 'a')
for layername in layer_and_recipes:
    # Skip the layer entry if it's already configured
    if len(layer_and_recipes[layername]) == 0 or layername in totalLayers:
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
fd.write('</django-objects>\n')
fd.close()
