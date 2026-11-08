import bpy, os, sys, time
src, dst = sys.argv[sys.argv.index('--') + 1:][:2]
os.makedirs(dst, exist_ok=True)
for f in sorted(x for x in os.listdir(src) if x.endswith('.blend')):
    t = time.time()
    bpy.ops.wm.open_mainfile(filepath=os.path.join(src, f))
    sc = bpy.context.scene
    if sc.render.engine == 'CYCLES':   # the 4090 always: factory-startup would leave Cycles on the CPU
        cp = bpy.context.preferences.addons['cycles'].preferences
        cp.compute_device_type = 'OPTIX'; cp.get_devices()
        gpus = [d for d in cp.devices if d.type == 'OPTIX']
        if not gpus:
            sys.exit('NO GPU: refusing to render on the CPU')
        for d in cp.devices: d.use = d.type == 'OPTIX'
        sc.cycles.device = 'GPU'
        print('DEVICE', ', '.join(d.name for d in gpus), flush=True)
    sc.render.filepath = os.path.join(dst, f[:-6] + '.png')
    bpy.ops.render.render(write_still=True)
    print('RENDERED', f, round(time.time() - t, 1), 's', flush=True)
