# Terraform And Ansible Setup

## Описание

С помощью терраформа нужно поднять 5 серверов и настроить их. На HAproxy настроить балансировку что б при обращении на статический адрес в браузере открывался сайт с одного из 3-х серверов с приветствием Welcome to ```<hostname>``` при обновление страницы сайт должен открыться с другого сервера.

**Пример**: Открываем сайт по статическому адресу, открывается страница с сервера VM1 с инфой Welcome to VM1, обновляем страницу инфа должна взяться с сервера VM2 и инфа Welcome to VM2 и так далее.

### Что нужно сделать

1.Terraform:

- Создать 5 VM (ОС centos  (4 VM пустые, 1 VM control с нее будет запускаться роли Ansible)).
- На VM с HAproxy повесить floating ip.
- На VM control поставить нужные пакеты.
- Фиксируемы локальные (серые) ip адреса.
- Запуск Ansible Role.

2.Ansible:

- Настроить 1 Haproxy и 3 Apache.
- На Apache /opt/html/index.html со строчкой "Welcome to ```<hostname>```".
- Отключать SElinux нельзя.
- Role Ansible должны лежать в S3.

### Запуск и выполнение

1. Выполним команду terraform init в папке "terraform_project", чтобы инициализировать Terraform.
2. Запустим terraform apply и введим yes для создания инфраструктуры.
3. После создания VM выполним настройку Ansible. Создадим файл inventory.ini:

```
[haproxy]
vm1 ansible_ssh_host=<floating_ip>

[apache_servers]
vm2 ansible_ssh_host=<private_ip_vm2>
vm3 ansible_ssh_host=<private_ip_vm3>
vm4 ansible_ssh_host=<private_ip_vm4>
```

4. Запустим Ansible с помощью команды:

```
ansible-playbook -i inventory.ini ansible_roles/haproxy_role/tasks/main.yml
ansible-playbook -i inventory.ini ansible_roles/apache_role/tasks/main.yml --limit apache_servers
```

### Теперь должно быть настроено 5 серверов, включая HAProxy для балансировки
