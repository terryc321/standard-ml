
# Triangle

move mouse and click places a black triangle on screen 

reset button - clears the canvas

# endian-ness

workaround for old mlx code (grok slop) 

```
Xephyr :99 -sw-cursor -retro -screen 800x600 -ac +extension GLX &
sml
> CM.make("sources.cml");
> Main.doit ":99";
```


# typical run

```
 (main) ~/code/standard-ml/exene/examples/triangle$ sml
Standard ML of New Jersey [Version 110.99.9; 64-bit; November 4, 2025]
- CM.make("sources.cm");
[autoloading]
[library $smlnj/cm/cm.cm is stable]
[library $smlnj/internal/cm-sig-lib.cm is stable]
[library $/pgraph.cm is stable]
[library $smlnj/internal/srcpath-lib.cm is stable]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
[scanning sources.cm]
[library $cml/basis.cm is stable]
[library $cml/cml.cm is stable]
[library $cml-lib/smlnj-lib.cm is stable]
[library $/eXene.cm is stable]
[library $cml/cml-internal.cm is stable]
[library $cml/core-cml.cm is stable]
[library $cml-lib/trace-cml.cm is stable]
[loading (sources.cm):icon-bitmap.sml]
[loading (sources.cm):tri.sml]
[library $SMLNJ-LIB/Util/smlnj-lib.cm is stable]
[library $/unix-lib.cm is stable]
[New bindings added.]
val it = true : bool
- Main.doit ":1";
exception (XERROR connection refused: Prohibited client endianess, see the Xserver man page ) in triangle thread
  ** eXene/lib/misc/mlx-err.sml:10.26-10.36
val it = 1 : OS.Process.status
```
