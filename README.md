# Скрипты для анализа списка зарегистрированных на конкурс в МГТУ
## Использование
Вывести статистику по ИУ9 (01.03.02)

``` sh
./bmstu-stats.sh
```

Вывести статистику по [номеру направления]

``` sh
./bmstu-stats.sh [номер направления]
```

Вывести статистику по [номеру направления] без ASCCII названия программы

``` sh
./bmstu-stats.sh -q [номер направления]
```

## Зависимости

wget
awk
grep
sed
pdftotext(poppler)
dc
