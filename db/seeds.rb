# frozen_string_literal: true

%w[Личные вещи Транспорт Работа «Для дома и дачи» Недвижимость
   Хобби и отдых Электроника Животные].each { |name| Category.find_or_create_by!(name:) }
