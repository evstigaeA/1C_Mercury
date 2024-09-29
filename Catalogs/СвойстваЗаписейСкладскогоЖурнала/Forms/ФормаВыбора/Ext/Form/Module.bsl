﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализацияФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПродукции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(Элементы.СписокПродукции.ВыделенныеСтроки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияПродукции

&НаКлиенте
Процедура ИерархияПродукцииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИерархияПродукцииПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИерархияПродукцииПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ИерархияПродукции.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("ТипПродукции, ВидПродукции, ПодвидПродукции");
	
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, ТекущиеДанные);
	
	Для Каждого ТекЭлемент Из СтруктураОтбора Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПродукции, ТекЭлемент.Ключ,
				ТекЭлемент.Значение, ВидСравненияКомпоновкиДанных.Равно, Строка(ТипЗнч(ТекЭлемент.Значение)), ЗначениеЗаполнено(ТекЭлемент.Значение));
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ИерархияПродукцииПередРазворачиванием(Элемент, Строка, Отказ)
	
	Если Строка.ИмяГруппировки = "ПодвидПродукции" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияПродукцииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормы()
	
	Параметры.Свойство("Организация"     , Организация);
	Параметры.Свойство("Предприятие"     , Предприятие);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокПродукции,   "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокПродукции,   "Предприятие", Предприятие);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ИерархияПродукции, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ИерархияПродукции, "Предприятие", Предприятие);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеЗаписиСкладскогоЖурнала(Команда)
	
	ОповеститьОВыборе(Элементы.СписокПродукции.ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ИнтеграцияВетисAPIСервер.УстановитьУсловноеОформлениеФорматовДат(СписокПродукции);
	
КонецПроцедуры

#КонецОбласти