﻿
&НаКлиенте
Процедура ЗаполнитьПоКонтрагенту(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыНаСервере()
	
	Если Объект.ОчиститьНаборыФильтров Тогда
		НЗ = РегистрыСведений.ДМ_НаборыФильтровДляЗагрузкиПродукции.СоздатьНаборЗаписей();
		НЗ.Прочитать();
		НЗ.Очистить();
		НЗ.Записать();
	КонецЕсли;	
	
	КвоНФ=0;
	Для Каждого ТекП из Объект.Предприятия Цикл
		Для Каждого ТекТ из Объект.ТипыПродукции Цикл
			НЗ = РегистрыСведений.ДМ_НаборыФильтровДляЗагрузкиПродукции.СоздатьНаборЗаписей();
			НЗ.Отбор.Предприятие.Установить(ТекП.Предприятие);
			НЗ.Отбор.ТипПродукции.Установить(ТекТ.ТипПродукции);
			НЗ.Прочитать();
			Если НЗ.Количество() = 0 Тогда
				НовЗапись = НЗ.Добавить();
				НовЗапись.Предприятие = ТекП.Предприятие;
				НовЗапись.ТипПродукции = ТекТ.ТипПродукции;
				НЗ.Записать();	
				КвоНФ = КвоНФ + 1;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Добавлено "  + КвоНФ + " наборов фильтров для загрузки продукции");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПараметры(Команда)
	
	Если Объект.Предприятия.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет предприятий");
		Возврат;	
	КонецЕсли;	
	
	Если Объект.ТипыПродукции.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нет типов продукции");
		Возврат;	
	КонецЕсли;	
	
	СохранитьПараметрыНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ДобавитьПредприятияПоХСНаСервере()
	
	Запр = Новый Запрос;
	Запр.Текст = "ВЫБРАТЬ
	             |	СвязиМеждуКонтрагентамиИПредприятиями.Контрагент КАК Контрагент,
	             |	СвязиМеждуКонтрагентамиИПредприятиями.Предприятие КАК Предприятие,
	             |	СвязиМеждуКонтрагентамиИПредприятиями.GLN КАК GLN
	             |ИЗ
	             |	РегистрСведений.СвязиМеждуКонтрагентамиИПредприятиями КАК СвязиМеждуКонтрагентамиИПредприятиями
	             |ГДЕ
	             |	СвязиМеждуКонтрагентамиИПредприятиями.Контрагент = &Контрагент";
	
	Запр.Параметры.Вставить("Контрагент",Контрагент);
	
	Возврат Запр.Выполнить().Выгрузить().ВыгрузитьКолонку("Предприятие");
	
КонецФункции

&НаКлиенте
Процедура ДобавитьПредприятияПоХС(Команда)
	
	КвоПр = 0;
	мПредприятий = ДобавитьПредприятияПоХСНаСервере();
	Если мПредприятий.Количество() > 0 Тогда
		Для мм=0 по мПредприятий.Количество()-1 Цикл 
			СтрОтб = Новый Структура("Предприятие",мПредприятий.Получить(мм));
			мСтр = Объект.Предприятия.НайтиСтроки(СтрОтб);
			Если мСтр.Количество() = 0 Тогда
				НовСтр = Объект.Предприятия.Добавить();
				НовСтр.Предприятие = мПредприятий.Получить(мм);
				КвоПр = КвоПр + 1;	
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если КвоПр > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Добавлено " + КвоПр + " предприятий");
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	СтрОтб = Новый Структура("Предприятие",Элемент.ТекущиеДанные.Предприятие);
	мСтр = Объект.Предприятия.НайтиСтроки(СтрОтб);
	Если мСтр.Количество() > 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Дубль предприятия");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыПродукцииПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	СтрОтб = Новый Структура("ТипПродукции",Элемент.ТекущиеДанные.ТипПродукции);
	мСтр = Объект.ТипыПродукции.НайтиСтроки(СтрОтб);
	Если мСтр.Количество() > 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Дубль типа продукции");
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры
