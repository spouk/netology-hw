---
- name: Install Clickhouse # определяет имя play  
  hosts: clickhouse # определяет перечень машин, с которыми будет работать play
  handlers: # обработчики, отрабатывает при соответствующем вызове в процессе отработки tasks
    - name: Start clickhouse service # имя обработчика
      become: true  # использовать выполнение обработчика с привилегированными правами
      ansible.builtin.service: # модуль ansible, отвечающий за работу с systemd
      name: clickhouse-server # имя сервиса
      enabled: true # активация сервиса, сервис будет запущен при перезапуске сервера
      state: restarted # перезапустить сервис
    - name: Start vector service   # имя обработчика
      become: true # использовать выполнение обработчика с привилегированными правами
      ansible.builtin.service:  # модуль ansible, отвечающий за работу с systemd
      name: vector # имя сервиса
      enabled: true# активация сервиса, сервис будет запущен при перезапуске сервера
      daemon_reload: true # перезапустить systemd чтобы "увидеть" файл сервиса
      state: restarted # перезапустить сервис
      tasks: # список задач
    - name: Install clickhouse on remote host # имя задачи
      block: - группировка задач
        - name: Get clickhouse distrib# имя задачи
          ansible.builtin.get_url: - получает пакеты
          url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
          dest: "./{{ item }}-{{ clickhouse_version }}.rpm"  - куда скачивать пакеты
          mode: '0440' выставляется права на скаченные пакеты
          with_items: "{{ clickhouse_packages }}" - в цикл списочно подставляется из переменных соответствующее значение
          rescue: - действия при неудаче
        - name: Get clickhouse distrib# имя задачи
          ansible.builtin.get_url:
          url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
          dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
          mode: '0440'
    - name: Install clickhouse packages# имя задачи
      become: true
      ansible.builtin.yum: - установка скаченных пакетов пакетным менеджером yum (centos)
      name:
      - clickhouse-common-static-{{ clickhouse_version }}.rpm
      - clickhouse-client-{{ clickhouse_version }}.rpm
      - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service - запуск обработчика с соответствующим именем
    - name: Create database# имя задачи
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'" - создание бд
      register: create_db - сохранения результата команды
      failed_when: create_db.rc != 0 and create_db.rc != 82 - ошибка при не соответствии представленных условий
      changed_when: create_db.rc == 0 - внесение изменений при представленного условия

    - name: Vector installed or not# имя задачи
      ansible.builtin.command: vector --version
      register: is_installed
      ignore_errors: true - игнорирование ошибки при получении версии vector

    - name: Install and configure vector on remote host# имя задачи
      when: - выполнение блока task при соблюдении условий
        - is_installed is failed  - когда vector не установлен
        - ansible_distribution == "CentOS" - когда удаленная машина под управлением Centos
          block:
        - name: Get Vector distrib# имя задачи
          ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
          dest: "./vector-{{ vector_version }}-1.x86_64.rpm"
          mode: '0440'
        - name: Install vector package# имя задачи
          become: true
          ansible.builtin.yum:
          name:
          - vector-{{ vector_version }}-1.x86_64.rpm
        - name: Make vector config file remote host# имя задачи
          ansible.builtin.file: - модуль для манипуляций с файлами
          path: /etc/vector/vector.toml - где создавать
          state: touch - способ.вид создания
          mode: u=rw,g=r,o=r - права доступа

        - name: Build context vector config file from template# имя задачи
          ansible.builtin.template: - модуль для работы с шаблонами
          src: "file/vector.j2"  - источник шаблона
          dest: "/etc/vector/vector.toml" - место где размещать шаблон на удаленной машине
          backup: true - сохранить файл на удаленной машине при его наличии с таким же именем
          mode: '0640' - права доступа
          notify: Start vector service - запуск обработчика
