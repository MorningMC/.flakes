-- Declare animations & curves
-- See https://wiki.hypr.land/configuring/core/animations

------------ Curves ------------
hl.curve("expressive_fast_spatial",    { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.90 } } })
hl.curve("expressive_slow_spatial",    { type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } })
hl.curve("expressive_default_spatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.00 } } })
hl.curve("emphasized_decel",           { type = "bezier", points = { { 0.05, 0.7  }, { 0.1,  1    } } })
hl.curve("emphasized_accel",           { type = "bezier", points = { { 0.3,  0    }, { 0.8,  0.15 } } })
hl.curve("standard_decel",             { type = "bezier", points = { { 0,    0    }, { 0,    1    } } })
hl.curve("menu_decel",                 { type = "bezier", points = { { 0.1,  1    }, { 0,    1    } } })
hl.curve("menu_accel",                 { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })

------------ Animatioms ------------
-- Windows
hl.animation({ leaf = "windowsIn",           enabled = true, speed = 3,   bezier = "emphasized_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",          enabled = true, speed = 2,   bezier = "emphasized_decel", style = "popin 90%" })
hl.animation({ leaf = "windowsMove",         enabled = true, speed = 3,   bezier = "emphasized_decel", style = "slide"     })
hl.animation({ leaf = "border",              enabled = true, speed = 10,  bezier = "emphasized_decel" })

-- Layers
hl.animation({ leaf = "layersIn",            enabled = true, speed = 2.7, bezier = "emphasized_decel", style = "popin 93%" })
hl.animation({ leaf = "layersOut",           enabled = true, speed = 2.4, bezier = "menu_accel",       style = "popin 94%" })

-- Fade
hl.animation({ leaf = "fadeLayersIn",        enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",       enabled = true, speed = 2.7, bezier = "menu_accel" })

-- Workspaces
hl.animation({ leaf = "workspaces",          enabled = true, speed = 7,   bezier = "menu_decel",       style = "slide"     })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasized_decel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasized_accel", style = "slidevert" })

