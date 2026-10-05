# # Модель конкуренции двух фирм
#
# Вариант 42: p_cr = 24, N = 54, q = 1, tau1 = 24, tau2 = 20, p1 = 7.4, p2 = 11.4, M1(0) = 4.5, M2(0) = 6.5.

using DrWatson
@quickactivate "project"
using DifferentialEquations
using Plots
script_name = "01_firms"
mkpath(plotsdir(script_name))

# ## Параметры

p_cr = 24.0
N = 54.0
q = 1.0
tau1 = 24.0
tau2 = 20
p1 = 7.4
p2 = 11.4
u0 = [4.5, 6.5]

# ## Коэффициенты

a1 = p_cr / (tau1^2 * p1^2 * N * q)
a2 = p_cr / (tau2^2 * p2^2 * N * q)
b = p_cr / (tau1^2 * p1^2 * tau2^2 * p2^2 * N * q)
c1 = (p_cr - p1) / (tau1 * p1)
c2 = (p_cr - p2) / (tau2 * p2)
println("a1 = ", a1, ", a2 = ", a2)
println("b = ", b)
println("c1 = ", c1, ", c2 = ", c2)

# ## Модель
# Параметр d - добавка к коэф. при M1*M2 во втором уравнении.
function firms!(du, u, d, t)
    M1, M2 = u
    du[1] = M1 - b / c1 * M1 * M2 - a1 / c1 * M1^2
    du[2] = c2 / c1 * M2 - (b / c1 + d) * M1 * M2 - a2 / c1 * M2^2
end

# ## Расчёт
function calc(d, name)
    prob = ODEProblem(firms!, u0, (0.0, 30.0), d)
    sol = solve(prob, Tsit5(), saveat=0.01, reltol=1e-8, abstol=1e-8)
    M1 = sol[1, :]
    M2 = sol[2, :]
    plt = plot(sol.t, [M1 M2], lw=2, label=["M1" "M2"], xlabel="theta", ylabel="M")
    savefig(plt, plotsdir(script_name, name))
    println(name, ": M1 = ", round(M1[end], digits=2), ", M2 = ", round(M2[end], digits=2))
    println("max M2 = ", round(maximum(M2), digits=2))
    return plt
end

# ## Случай 1

plt1 = calc(0.0, "case1.png")

# ## Случай 2

plt2 = calc(0.00022, "case2.png")

# ## Случай 2 с крупным планом

plt3 = deepcopy(plt2)
ylims!(plt3, 0, 200)
savefig(plt3, plotsdir(script_name, "case2_zoom.png"))

# ## Стационарное состояние для случая 1
# `a1*M1 + b*M2 = c1`, `b*M1 + a2*M2 = c2`
A = [a1 b; b a2]
st = A \ [c1, c2]
println("stationary: M1 = ", round(st[1], digits=2), ", M2 = ", round(st[2], digits=2))
