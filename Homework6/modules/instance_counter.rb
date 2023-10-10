# frozen_string_literal: true

# 5. Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы,
#     которые подключаются автоматически при вызове include в классе:
#         Методы класса:
#            - instances, который возвращает кол-во экземпляров данного класса
#         Инстанс-методы:
#            - register_instance, который увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из
#            конструктора. При этом данный метод не должен быть публичным.
#         Подключить этот модуль в классы поезда, маршрута и станции.

#     Примечание: инстансы подклассов могут считаться по отдельности, не увеличивая счетчик инстансов базового класса.

module InstanceCounter
  def self.included(base)
    base.class_variable_set :@@instances, 0
    base.extend ClassMethods
    # base.send :include, InstanceMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      class_variable_get :@@instances
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.class_variable_set :@@instances, (self.class.instances + 1)
    end
  end
end
