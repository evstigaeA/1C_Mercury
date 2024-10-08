﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ПродукцияПредприятия(ПараметрыПодбора, Текст) Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 50
		|	Продукция.Ссылка КАК Ссылка,
		|	Продукция.Представление КАК Представление,
		|	Продукция.Код КАК Код
		|ИЗ
		|	Справочник.Продукция КАК Продукция
		|ГДЕ
		|	Продукция.Наименование ПОДОБНО &Текст
		|	И НЕ Продукция.ПометкаУдаления
		|	И НЕ Продукция.НеИспользуется";
	
	Запрос = Новый Запрос;
	
	Если ПараметрыПодбора.Свойство("ВидПродукции") Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	И Продукция.Владелец.Владелец = &ВидПродукции";
		Запрос.УстановитьПараметр("ВидПродукции", ПараметрыПодбора.ВидПродукции);
	КонецЕсли;
	
	Если ПараметрыПодбора.Свойство("Контрагент") Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	И Продукция.Контрагент = &Контрагент";
		Запрос.УстановитьПараметр("Контрагент", ПараметрыПодбора.Контрагент);
	КонецЕсли;
	
	Если ПараметрыПодбора.Свойство("Предприятие") Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	И Продукция.ПроизводителиПродукции.Предприятие = &Предприятие";
		Запрос.УстановитьПараметр("Предприятие", ПараметрыПодбора.Предприятие);
	КонецЕсли;
	
	Если ПараметрыПодбора.Свойство("ЗарегистрированнаяПродукция") Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	И НЕ Продукция.GUID_Меркурий = """"";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Текст", "%" + Текст + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокЗначений = Новый СписокЗначений;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокЗначений.Добавить(Выборка.Ссылка, Выборка.Представление + " (" + Выборка.Код + ")");
	КонецЦикла;
	
	Возврат СписокЗначений;
КонецФункции

Функция ПродукцияПолучателя(ПараметрыПодбора, Текст) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 50
		|	ПродукцияСобственнаяПродукция.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Продукция.СобственнаяПродукция КАК ПродукцияСобственнаяПродукция
		|ГДЕ
		|	ПродукцияСобственнаяПродукция.Продукция = &Продукция
		|	И ПродукцияСобственнаяПродукция.Ссылка.КонтрагентПолучатель = &КонтрагентПолучатель
		|	И НЕ ПродукцияСобственнаяПродукция.Ссылка.НеИспользуется
		|	И ПродукцияСобственнаяПродукция.Ссылка.Наименование ПОДОБНО &Текст";
	
	Запрос.УстановитьПараметр("КонтрагентПолучатель", ПараметрыПодбора.КонтрагентПолучатель);
	Запрос.УстановитьПараметр("Продукция"           , ПараметрыПодбора.Продукция);
	Запрос.УстановитьПараметр("Текст"               , "%" + Текст + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокЗначений = Новый СписокЗначений;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокЗначений.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокЗначений;

КонецФункции

#КонецОбласти

#КонецЕсли