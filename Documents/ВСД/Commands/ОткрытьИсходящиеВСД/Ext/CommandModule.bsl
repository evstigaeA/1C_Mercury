﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СписокВидовВСД  = Новый СписокЗначений;
	СписокВидовВСД.Добавить(ПредопределенноеЗначение("Перечисление.ВидыВСД.Исходящий"));
	СписокВидовВСД.Добавить(ПредопределенноеЗначение("Перечисление.ВидыВСД.НаПеремещение"));
	ПараметрыОтбора = Новый Структура("ВидВСД", СписокВидовВСД);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор"    , ПараметрыОтбора);
	ПараметрыФормы.Вставить("Заголовок", "Ветеринарно-сопроводительные документы (исходящие ВСД)");
	ПараметрыФормы.Вставить("ВидВСД"   , ПредопределенноеЗначение("Перечисление.ВидыВСД.Исходящий"));
	ОткрытьФорму("Документ.ВСД.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ИсходящиеВСД", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти