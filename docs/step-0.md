# Домашка нулевой недели

## Общий вид

- таск трекер
- авторизация
- система ролей (менеджер, попуг, админ, бухгалтер)
- рандомное распределение задач
- аккаунтинг (счета, аудит лог, общий баланс)
- нотификации
- аналитика

## Сервисы

* ТаskTracker
* Auth (roles)
* Accounting
* Analitics

Связи:
* TaskTracker -> Auth
* Accounting -> TaskTracker, Auth
* Analitics -> Accounting
* Auth -> Analitics

## Модели

- users (role)
- tasks (price, desc, user)
- bills (sum, user)
- auditlog (task, price, user, event)
