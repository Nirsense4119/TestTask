# TestTask
Репозиторий с архивом, с ответом на задание
## 11. Описание возможных способов защиты от ошибок переполнения разрядной сетки

Самый простой способ избежать переполнения при выполнении арифметических операций с переменными — это увеличение разрядности результата.  
- При **сложении** разрядность результата должна быть `N + 1`,  
- При **умножении** — до `2N`.

Если разрядность результата строго ограничена, можно использовать **механизмы детектирования переполнения**. Например:
- Если два положительных числа (`a > 0`, `b > 0`) дают отрицательный результат — произошло переполнение.
- В таком случае можно запрограммировать **детектор переполнения** и реализовать логику отмены операции и выдачи сигнала об ошибке.

---

## 12. Оценка аппаратных ресурсов (по Vivado)

На занятиях в университете мы работали с FPGA Artix-7, чипом **XC7A35T-1CPG236I**.  
Для оценки ресурсов использовалась встроенная команда Vivado: `report_utilization`.  

После синтеза дизайна был получен следующий отчет:

| Ref Name | Used | Functional Category   |
|----------|------|------------------------|
| FDCE     |   51 | Flop & Latch           |
| LUT2     |   35 | LUT                    |
| IBUF     |   34 | IO                     |
| LUT6     |   21 | LUT                    |
| CARRY4   |   15 | CarryLogic             |
| LUT4     |   13 | LUT                    |
| OBUF     |    9 | IO                     |
| LUT5     |    4 | LUT                    |
| LUT3     |    3 | LUT                    |
| LUT1     |    2 | LUT                    |
| BUFG     |    1 | Clock                  |

**Вывод:** используется 51 триггер и 35 логических элементов, что является **сотыми долями процента** от общего ресурса чипа.

---

## 13. Максимальная тактовая частота

Также в рамках лабораторной работы мы измеряли производительность схемы на загруженном Bitstream.  

По результатам симуляции testbenchа было определено, что:
- Модуль выполняется **33.3 миллиона раз в секунду**
- Что эквивалентно **частоте 33.3 МГц**

---
