#define _USE_MATH_DEFINES
#include <iostream>
#include <cmath>

// Arctan
double calcAtan(double x, int N_steps)
{
    double arctan = 0.0;
    for (int n = 0; n < N_steps; n++)
    {
        double vsota = pow(-1, n) * pow(x, 2 * n + 1) / (2 * n + 1);
        arctan += vsota;
    }
    return arctan;
}

// Trapezna metoda
double trapeznaMetoda(double (*f)(double, int), double a, double b, int n, int N_steps)
{
    double delta_x = (b - a) / n;
    double integral = 0.0;

    integral += f(a, N_steps) + f(b, N_steps);

    for (int i = 1; i < n; i++)
    {
        double x_i = a + i * delta_x;
        integral += 2 * f(x_i, N_steps);
    }

    integral *= delta_x / 2;
    return integral;
}
   
// Funkcija ki jo bomo racunali
double f(double x, int N_steps)
{
    return exp(3 * x) * calcAtan(x / 2, N_steps);
}

int main()
{
    double a = 0.0;
    double b = M_PI/ 4;
    int n = 100;
    int N_steps = 10;

    double ploscina = trapeznaMetoda(f, a, b, n, N_steps);

 
    printf("Ocenjena vrdnost integrala: %.15f\n", ploscina);

    return 0;
}

