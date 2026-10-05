# # Задача об эпидемии
#
# Вариант 42: N = 5500, I0 = 70, R0 = 2.
using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
using JLD2
script_name = "01_epidemic"
mkpath(plotsdir(script_name))

# ## Параметры

a = 0.01
b = 0.02
u0 = [5428.0, 70.0, 2.0]

# ## Случай 1: больные изолированы

function sir1!(du, u, p, t)
    du[1] = 0
    du[2] = -b * u[2]
    du[3] = b * u[2]
end

# ## Случай 2: больные заражают здоровых

function sir2!(du, u, p, t)
    du[1] = -a * u[1]
    du[2] = a * u[1] - b * u[2]
    du[3] = b * u[2]
end

# ## Расчёт

function calc(model, name)
    prob = ODEProblem(model, u0, (0.0, 200.0))
    sol = solve(prob, Tsit5(), saveat=0.5, reltol=1e-8, abstol=1e-8)
    s = sol[1, :]
    i = sol[2, :]
    r = sol[3, :]
    p1 = plot(sol.t, [s i r], lw=2, label=["S" "I" "R"], xlabel="t", title="Все группы")
    p2 = plot(sol.t, [i r], lw=2, label=["I" "R"], xlabel="t", title="Больные и выздоровевшие")
    plt = plot(p1, p2, size=(900, 400))
    savefig(plt, plotsdir(script_name, name))
    println(name, ": S = ", round(s[end]; digits=1), ", I = ", round(i[end]; digits=1), ", R = ", round(r[end]; digits=1))
    return plt
end

# ## Расчёт для первого случая

plt1 = calc(sir1!, "case1.png")

# ## Расчёт для второго случая

plt2 = calc(sir2!, "case2.png")
