"""
prep_for_lens.py — fix & prepare a 3D model for Snapchat Lens Studio (headless Blender, no GUI/MCP).
snap_blender_001 / blender pipeline.

Run:
  blender.exe --background --python prep_for_lens.py -- \
     --in model.glb --out model_lens.glb \
     --target-height 0.25 \
     --recolor "Cube=#1A2A6C,Tube=#FFD54A,Sphere=#FFD54A" \
     --separate-loose --decimate 0.5

Fixes the graduation-cap class of problems: bad origin, giant scale, white un-editable
material, fused parts. English-only (ASCII-safe for the editor); Blender reads it fine.
"""
import bpy, sys, argparse, math

def get_args():
    argv = sys.argv
    argv = argv[argv.index("--")+1:] if "--" in argv else []
    p = argparse.ArgumentParser()
    p.add_argument("--in", dest="inp", required=True)
    p.add_argument("--out", dest="out", required=True)
    p.add_argument("--target-height", type=float, default=0.0, help="normalize total height to this (LS units); 0 = skip")
    p.add_argument("--recolor", default="", help="comma list name_substr=#RRGGBB")
    p.add_argument("--separate-loose", action="store_true")
    p.add_argument("--decimate", type=float, default=0.0, help="ratio 0..1; 0 = skip")
    return p.parse_args(argv)

def hex_to_rgba(h):
    h = h.lstrip("#")
    return (int(h[0:2],16)/255.0, int(h[2:4],16)/255.0, int(h[4:6],16)/255.0, 1.0)

def clear_scene():
    bpy.ops.object.select_all(action='SELECT'); bpy.ops.object.delete()
    for blk in (bpy.data.meshes, bpy.data.materials, bpy.data.objects):
        for d in list(blk):
            try: blk.remove(d)
            except: pass

def main():
    a = get_args()
    clear_scene()
    bpy.ops.import_scene.gltf(filepath=a.inp)
    meshes = [o for o in bpy.data.objects if o.type=='MESH']
    print("Imported meshes:", [o.name for o in meshes])

    # 1) separate loose parts (so tassel/board are independent)
    if a.separate_loose:
        for o in list(meshes):
            bpy.ops.object.select_all(action='DESELECT')
            o.select_set(True); bpy.context.view_layer.objects.active=o
            bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.mesh.select_all(action='SELECT')
            bpy.ops.mesh.separate(type='LOOSE'); bpy.ops.object.mode_set(mode='OBJECT')
        meshes = [o for o in bpy.data.objects if o.type=='MESH']

    # 2) cleanup + origin to geometry + apply scale
    for o in meshes:
        bpy.ops.object.select_all(action='DESELECT')
        o.select_set(True); bpy.context.view_layer.objects.active=o
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.remove_doubles(); bpy.ops.mesh.normals_make_consistent(inside=False)
        bpy.ops.object.mode_set(mode='OBJECT')
        if a.decimate>0:
            m=o.modifiers.new("dec","DECIMATE"); m.ratio=a.decimate
            bpy.ops.object.modifier_apply(modifier=m.name)
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    for o in meshes:
        bpy.ops.object.select_all(action='DESELECT'); o.select_set(True)
        bpy.context.view_layer.objects.active=o
        bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY')

    # 3) normalize total height to target (so it fits the head in Lens Studio)
    if a.target_height>0 and meshes:
        zs=[(o.matrix_world @ v.co).z for o in meshes for v in o.data.vertices]
        cur=max(zs)-min(zs)
        if cur>0:
            f=a.target_height/cur
            for o in meshes: o.scale=(o.scale[0]*f,o.scale[1]*f,o.scale[2]*f)
            bpy.ops.object.select_all(action='SELECT')
            bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
            print("Normalized height %.4f -> %.4f (x%.4f)"%(cur,a.target_height,f))

    # 4) recolor: assign clean per-object material with explicit Base Color
    rules=[]
    for part in [x for x in a.recolor.split(",") if "=" in x]:
        name,hx=part.split("="); rules.append((name.strip().lower(), hex_to_rgba(hx.strip())))
    for o in meshes:
        for sub,rgba in rules:
            if sub in o.name.lower():
                mat=bpy.data.materials.new(o.name+"_mat"); mat.use_nodes=True
                bsdf=mat.node_tree.nodes.get("Principled BSDF")
                if bsdf: bsdf.inputs["Base Color"].default_value=rgba
                o.data.materials.clear(); o.data.materials.append(mat)
                print("Recolored",o.name,"->",rgba); break

    # 5) purge + export GLB
    bpy.ops.outliner.orphans_purge(do_recursive=True)
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.export_scene.gltf(filepath=a.out, export_format='GLB',
                              export_apply=True, export_yup=True)
    print("EXPORTED:", a.out)

main()
