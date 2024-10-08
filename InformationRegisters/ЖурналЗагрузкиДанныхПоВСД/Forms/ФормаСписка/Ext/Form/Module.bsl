﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеОбмена(Идентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЖурналЗагрузкиДанныхПоВСД.ИдентификаторЗаявки КАК ИдентификаторЗаявки,
		|	ЖурналЗагрузкиДанныхПоВСД.ТекстЗапроса КАК ТекстЗапроса,
		|	ЖурналЗагрузкиДанныхПоВСД.ТекстОтвета КАК ТекстОтвета,
		|	ЖурналЗагрузкиДанныхПоВСД.Статус КАК Статус,
		|	ЖурналЗагрузкиДанныхПоВСД.ОшибкиВыполнения КАК ОшибкиВыполнения,
		|	ЖурналЗагрузкиДанныхПоВСД.КодСостоянияСервера КАК КодСостоянияСервера
		|ИЗ
		|	РегистрСведений.ЖурналЗагрузкиДанныхПоВСД КАК ЖурналЗагрузкиДанныхПоВСД
		|ГДЕ
		|	ЖурналЗагрузкиДанныхПоВСД.Идентификатор = &Идентификатор";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ТекстЗапроса = Выборка.ТекстЗапроса.Получить();
	ТекстОтвета  = Выборка.ТекстОтвета.Получить();
	
	ДанныеОбмена = Новый Структура;
	ДанныеОбмена.Вставить("ИдентификаторЗаявки", Выборка.ИдентификаторЗаявки);
	ДанныеОбмена.Вставить("СтатусЗаявки", Выборка.Статус);
	ДанныеОбмена.Вставить("ТекстОшибки", Выборка.ОшибкиВыполнения);
	ДанныеОбмена.Вставить("КодСостоянияСервера", Выборка.КодСостоянияСервера);
	ДанныеОбмена.Вставить("ТекстЗапросаФормированияЗаявки", ТекстЗапроса);
	ДанныеОбмена.Вставить("ТекстОтветаПолучениеРезультата", ТекстОтвета);
	
	Возврат ДанныеОбмена;
КонецФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбмена = ПолучитьДанныеОбмена(ТекущиеДанные.Идентификатор);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДанныеОбмена", ДанныеОбмена);
	
	ОткрытьФорму("Обработка.ИнформацияОбработкиЗапроса.Форма.Форма", ПараметрыФормы, Элемент, ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

#КонецОбласти