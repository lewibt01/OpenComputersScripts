local math3d = {}

function math3d.deltas(p1,p2)
    return {
        p2[1] - p1[1],
        p2[2] - p1[2],
        p2[3] - p1[3]
    }
end

return math3d