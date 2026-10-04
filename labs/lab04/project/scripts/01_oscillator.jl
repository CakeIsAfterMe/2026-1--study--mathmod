# # Модель гармонических колебаний
#
# Вариант 42: x0 = 1.3, y0 = -1.2, время от 0 до 47.
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2
script_name = "01_oscillator"
mkpath(plotsdir(script_name))

# ## Модель
#
# Уравнение: $\ddot{x} + a\dot{x} + bx = f(t)$

function osc!(du, u, p, t)
    a, b, f = p
    du[1] = u[2]
    du[2] = -a * u[2] - b * u[1] + f(t)
end

# ## Расчёт

function calc(p, name)
    prob = ODEProblem(osc!, [1.3, -1.2], (0.0, 47.0), p)
    sol = solve(prob, Tsit5(), saveat=0.05, reltol=1e-8, abstol=1e-8)
    x = first.(sol.u)
    y = last.(sol.u)
    p1 = plot(sol.t, [x y], label=["x", "y"], xlabel="t", title="Решение")
    p2 = plot(x, y, label="", xlabel="x", ylabel="y", title="Фазовый портрет")
    plt = plot(p1, p2, size=(900, 400))
    println(name, ": x = ", round(x[end]; digits=3), ", y = ", round(y[end]; digits=3))
    return plt
end

# ## Случай 1: без затухания

plt1 = calc((0.0, 14.0, t -> 0.0), "case1.png")

# ## Случай 2: с затуханием

plt2 = calc((2.0, 5.0, t -> 0.0), "case2.png")

# ## Случай 3: с затуханием и внешней силой

plt3 = calc((4.0, 5.0, t -> 0.5cos(2t)), "case3.png")
