using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2
script_name = "01_lotka"
mkpath(plotsdir(script_name))

function lv!(du, u, p, t)
    x, y = u
    du[1] = -0.56x + 0.057x * y
    du[2] = 0.57y - 0.056x * y
end

xs = 0.57 / 0.056
ys = 0.56 / 0.057
println("Стационарное состояние: x = ", round(xs; digits=3), ", y = ", round(ys; digits=3))

prob = ODEProblem(lv!, [11.0, 22.0], (0.0, 50.0))
sol = solve(prob, Tsit5(), saveat=0.1, reltol=1e-8, abstol=1e-8)
x = first.(sol.u)
y = last.(sol.u)

p1 = plot(sol.t, [x y], lw=2, label=["Хищники" "Жертвы"], xlabel="t", ylabel="Численность")
savefig(p1, plotsdir(script_name, "time.png"))
p1

p2 = plot(y, x, lw=2, label="Траектория", xlabel="Жертвы", ylabel="Хищники")
scatter!(p2, [ys], [xs], label="Стационарное состояние")
savefig(p2, plotsdir(script_name, "phase.png"))
p2
