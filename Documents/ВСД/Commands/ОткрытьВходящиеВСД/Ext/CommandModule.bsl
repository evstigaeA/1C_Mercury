﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СписокВидовВСД  = Новый СписокЗначений;
	СписокВидовВСД.Добавить(ПредопределенноеЗначение("Перечисление.ВидыВСД.Входящий"));
	СписокВидовВСД.Добавить(ПредопределенноеЗначение("Перечисление.ВидыВСД.НаПеремещение"));
	ПараметрыОтбора = Новый Структура("ВидВСД", СписокВидовВСД);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор",     ПараметрыОтбора);
	ПараметрыФормы.Вставить("Заголовок", "Ветеринарно-сопроводительные документы (входящие ВСД)");
	ПараметрыФормы.Вставить("ВидВСД",    ПредопределенноеЗначение("Перечисление.ВидыВСД.Входящий"));
	ОткрытьФорму("Документ.ВСД.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ВходящиеВСД", ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти