# # Задача о погоне
#
# Вариант 42: k = 16.1, n = 3.9
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2
script_name = "01_pursuit"
mkpath(plotsdir(script_name))

# ## Параметры
k = 16.1
n = 3.9
fi = 3pi / 4

# ## Модель
#
# Уравнение траектории катера: $dr/d\theta = r/\sqrt{n^2-1}$

f(r, p, t) = r / sqrt(n^2 - 1)

function pursuit(r0, t0, name)
    prob = ODEProblem(f, r0, (t0, t0 + 2pi))
    sol = solve(prob, Tsit5(), saveat=0.01)
    rx = sol(fi)

    plt = plot(sol.t, sol.u, proj=:polar, lw=2, label="Катер")
    plot!(plt, [fi, fi], [0, maximum(sol.u)], lw=2, label="Лодка")
    scatter!(plt, [fi], [rx], label="Пересечение")

    savefig(plt, plotsdir(script_name, name))
    println(name, ": r = ", round(rx; digits=3))
    return plt
end

# ## Случай 1

plt1 = pursuit(k / (n+1), 0.0, "case1.png")

# ## Случай 2

plt2 = pursuit(k / (n-1), -pi, "case2.png")


