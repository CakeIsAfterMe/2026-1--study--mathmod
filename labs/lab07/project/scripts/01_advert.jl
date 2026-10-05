# # Эффективность рекламы
#
# Вариант 42: N = 2200, n0 = 21

using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
script_name = "01_advert"
mkpath(plotsdir(script_name))

# ## Параметры

N = 2200
n0 = 21.0

# ## Модель

f1(n, t) = (0.605 + 0.000017n) * (N - n)
f2(n, t) = (0.000065 + 0.209n) * (N - n)
f3(n, t) = (0.51sin(t) + 0.31t * n) * (N - n)

# ## Расчёт

function calc(f, tmax, name)
    prob = ODEProblem((n, p, t) -> f(n, t), n0, (0.0, tmax))
    sol = solve(prob, Tsit5(), saveat=tmax/1000, reltol=1e-8, abstol=1e-8)
    v = f.(sol.u, sol.t)
    k = argmax(v)
    plt = plot(sol.t, sol.u, lw=2, label="n(t)", xlabel="t", ylabel="Число знающих о товаре")
    scatter!(plt, [sol.t[k]], [sol.u[k]], label="Максимальная скорость")
    savefig(plt, plotsdir(script_name, name))
    println(name, ": максимальная скорость при t = ", round(sol.t[k]; digits=4), ", n = ", round(sol.u[k]))
    return plt
end

# ## Случай 1

plt1 = calc(f1, 10.0, "case1.png")

# ## Случай 2

plt2 = calc(f2, 0.03, "case2.png")

# ## Случай 3

plt3 = calc(f3, 0.3, "case3.png")
