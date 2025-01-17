# Домашнее задание к занятию "1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения" - `Мартыненко Алексей`

### Задача 1
Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

полная виртуализация - виртуализация при которой на "железо" устанавливается специализированный ОС (хостовой гипервизор) в рамках
которого происходит создание виртуальных машин

паравиртуализация - виртуализация, при которой приложение-гипервизор разворачивается в хостовой ОС (в linux на базе kvm libvirt для примера)
который позволяет создавать ВМ с разными гостевыми ОС (windows, unix*, linux etc...) в рамках которых приложения в обход хостовой ОС могут работать
непосредственно с железом (звуковая карта как пример)

виртуализация на основе ОС - подвид виртуализации, при которой эмулируется чистый namespace позволяющий в этой переменной среде 
запускать какой либо процесс, по сути это программная эмуляция виртуализации (docker контейнера как пример)


### Задача 2
Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:

физические сервера,
паравиртуализация,
виртуализация уровня ОС.

Условия использования:

Высоконагруженная база данных, чувствительная к отказу. = физический сервер, субд крайне придирчивы в части io и имеют весьма сложную алгоритмику по организации и работы напрямую с оперативной памятью и дисками
Различные web-приложения. = паравиртуализация, т.к. приложения могут быть скомпилированны под разные платформы  
Windows системы для использования бухгалтерским отделом = виртуализация на уровне ОС, "рабочее место" однотипно, изменение namespace под каждого пользователя будет достаточно  
Системы, выполняющие высокопроизводительные расчеты на GPU = физический сервер/паравиртуализация - в случае, если есть возможность выделить 95% можности видеокарт(ы) под перемалывания данных 


### Задача 3
Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.

    VMware vSphere, учитывая, что будут использоваться linux/windows, также vmware поддерживает механизм репликации ВМ

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
   kvm - бесплатное opensource решение, нативное практические для любого дистрибутива linux 

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
   Microsoft® Hyper-V™ Server 

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
    docker- контейнеров будет достаточно, т.к. как предполагается, что программный продукт будет работать в linux + 
   "чистый" userspace для каждого контейнера


### Задача 4
Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

наличие нескольких систем управления виртуализацией изначально предполагает разные механизмы работы с виртуальными машинами, разную
алгоритмику, разные механизмы репликаций, миграции ВМ, что влечет за собой двукратное (минимум) увеличение временных затрат на поддержку+аналогичное увеличение сложности взаимоинтеграции 2 систем, проблему с оперативным перемещением больших массивов данных между ними

по возможности я бы старался избегать создание подобных гетерогенных сред, единообразие дает преимущества в сопровождении,
обслуживании, финансовых затратах 

