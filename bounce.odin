package dvd_bounce

import "core:fmt"
import rl "vendor:raylib"

Window :: struct { 
    name:          cstring,
    width:         i32, 
    height:        i32,
    fps:           i32,
    control_flags: rl.ConfigFlags,
}



Sprite :: struct {
    tex: rl.Texture2D,
    rect: rl.Rectangle,
    pos: rl.Vector2,
    dir: rl.Vector2
}


UpdateStyle :: enum {
    fixed,
    deltaTimeUnlocked,
    deltaTimeLocked,
}

main :: proc() {
    window := Window{
        name = "linear test",
        width = 1024,
        height = 768,
        fps = 60,
        control_flags = rl.ConfigFlags{ }
    }

    rl.ChangeDirectory(rl.GetApplicationDirectory())
    rl.InitWindow(window.width, window.height, window.name)
    rl.SetWindowState( window.control_flags )
    // rl.SetTargetFPS(window.fps)


    dvd_texture := rl.LoadTexture("./dvd2.png")
    sprite: Sprite = {
        dvd_texture,
        {0,0,f32(dvd_texture.width),f32(dvd_texture.height)},
        {0,0},
        {1,1}
    }

    style := UpdateStyle.deltaTimeUnlocked
    speed : f32 = 4 //pixels per second

    for !rl.WindowShouldClose() {


        rl.BeginDrawing()
            rl.ClearBackground({})

            //input
            {
                if rl.IsKeyPressed(.SPACE) {
                    style = UpdateStyle((int(style) + 1) % len(UpdateStyle))
                    switch style {
                        case .deltaTimeUnlocked: 
                            rl.SetTargetFPS(0)
                        case .fixed, .deltaTimeLocked:
                            rl.SetTargetFPS(window.fps)
                    }
                }
            }

            //draw text
            rl.DrawFPS(5, 5)
            rl.DrawText(fmt.ctprintf("update style: %v", style), 5, window.height - 25, 20, rl.GRAY)

            //draw sprite
            {

                using sprite

                if pos.x > f32(window.width) - rect.width {
                    dir.x = -1
                } else if pos.x < 0 {
                    dir.x = 1
                }
                if pos.y > f32(window.height) - rect.height {
                    dir.y = -1
                } else if pos.y < 0 {
                    dir.y = 1
                }

                switch style {
                    case .fixed:
                        vel := dir * speed * (60 / f32(window.fps))
                        pos += vel
                    case .deltaTimeUnlocked, .deltaTimeLocked:
                        vel := dir * rl.GetFrameTime() * speed * 60
                        pos += vel
                }

                rl.DrawTextureV(tex, pos, rl.WHITE)
            }

        rl.EndDrawing()
            
    }
}