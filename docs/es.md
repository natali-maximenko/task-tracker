# Требования

## TaskTracker

1. Дашборд с тасками доступен всем сотрудникам
{actor: account, data: task, account_id, query: list_tasks} 
2. Авторизация в таск трекере по форме клюва
{actor: account, data: account.auth, command: login, event: Acc.authorized}
3. Переход в дашборд
{actor: account, data: tasks, query: get_tasks}
4. Создавать таски может кто угодно
{actor: account, data: task, command: add_task, event: Task.added}
5. Менеджер и админ могут реассайнить таски по кнопке.
{actor: account(role=manager|admin), data: task, account_id, command: reassign_all, event: Task.reassigned}

## Accounting

1. Доступ к дашборду
   - У сотрудников должен быть доступ к дашборду (аудитлог + текущий баланс)
   {actor: account, data: bill, log, query: show_balance}
   - У админов и бухов должен быть доступ к общей статистике по заработанным деньгам
   {actor: account(role=admin|buch), data: money_stat, query: get_money_stat}
2. Авторизация
{actor: account, data: account.auth, command: login, event: Acc.authorized}
3. У каждого сотрудника должен быть счёт с балансом и аудитлог прихода/расхода денег из задач
{actor: account, data: bill, log, query: show_balance}
4. У задач есть расценки
actor: Task.added, data: assign_price, submit_price, command: generate_prices, event: Task.priced
   - Списать деньги при assign
   {actor: task.assigned, data: sum,acc_id, command: change_balance, event: balance.changed}
   - Начислить при submit
   {actor: task.submited, data: sum.acc_id, command: change_balance, event: balance.changed}
5. Дашборд общий баланс по всем таскам
{actor: account, data: balance, query: calculate_balance}
6. В конце дня считать сколько попуг получил денег за день и отправлять на почту сумму выплаты
   - {actor: day.finished, data: positive balance, acc_id, command: calculate_account_balance, event: balanse.status(positive|negative)}
   - {actor: balance.positive, data: balance, acc_id, command: notify, event: acc.balance_notifed}
7. Checkout: баланс обнуляется, в аудитлог пишется сумма выплаты
{actor: acc.balance_notifed, data: bill, command: checkout}
8. Статистика по дням (сегодня)
query: stat_by_days 

## Analitics

1. Доступ у админов
2. Сколько заработано за сегодня
3. Самая дорогая задача за период
{actor: account(role=admin), data: task, query: get_hightest_priced_task}

# Модели данных

auth <-   Account   -> role
          |     |
         Bill  Task -> status
          |     |
       Balance  price

#  Домены

- Auth(пользователи, роли, авторизация)
- TaskTracker(создание, ассайн тасок)
- Billing(начисления, списания, формирование цен, отчёты)

# Сервисы

- Auth
- TaskTracker
- Billing
- Analitics

# Коммуникации

Синхронные:

* Бизнес-команды для сервиса авторизации
* Бизнес-команды для сервиса таск-трекер
* Бизнес-команды для биллинга и аналитики
* Сам процесс авторизации

Асинхронные

* CUD-события для аккаунтов
* BE для смены роли
* CUD для тасок
* BE для (ре)ассайна попуга(ов)
* BE для смены статуса таски
* BE внутри биллинга
