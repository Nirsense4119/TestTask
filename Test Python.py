# Q - знаковое 8 бит, значит диапазон значений: [-128, 127]
def calculate_Q(a, b, c, d):
    # Проверка
    for param, name in [(a, 'a'), (b, 'b'), (c, 'c'), (d, 'd')]:
        if param < -128 or param > 127:
            raise ValueError(f"Параметр {name} = {param} вне диапазона [-128, 127]")
    diff = a - b
    term = 1 + 3 * c
    prod = diff * term
    sub = prod - 4 * d
    Q = sub // 2
test_cases = [
    {"a": 5, "b": 2, "c": 1, "d": 1},       # Q = 4
    {"a": -3, "b": 1, "c": 2, "d": -2},     # Q = -10
    {"a": 10, "b": 5, "c": -1, "d": 2},     # Q = -9
]
for i, test in enumerate(test_cases, 1):
    a, b, c, d = test["a"], test["b"], test["c"], test["d"]
    try:
        Q = calculate_Q(a, b, c, d)
        print(f"Тест {i}: a={a}, b={b}, c={c}, d={d}, Q={Q}")
    except ValueError as e:
        print(f"Ошибка в тесте {i}: {e}")