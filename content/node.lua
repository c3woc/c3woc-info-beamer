gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local interval = 30

function make_switcher(childs, interval)
    local next_switch = 0
    local child
    local function next_child()
        child = childs.next()
        next_switch = sys.now() + interval
    end
    local function draw()
        if sys.now() > next_switch then
            next_child()
        end
        util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)

        local remaining = next_switch - sys.now()
        if remaining < 0.2 or remaining > interval - 0.2 then
            util.post_effect(distort_shader, {
                effect = 5 + remaining * math.sin(sys.now() * 50);
            })
        end
    end
    return {
        draw = draw;
    }
end

local switcher = make_switcher(util.generator(function()
    local cycle = {}
    for child, updated in pairs(CHILDS) do
        table.insert(cycle, child)
    end
    return cycle
end), interval)


function node.render()
    gl.clear(0,0,0,1)
    switcher.draw()
end

