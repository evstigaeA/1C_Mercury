﻿#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение, ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПроведениеДокументаОшибка");
		ОценкаПроизводительностиКлиент.УстановитьПризнакОшибкиЗамера(ИдентификаторЗамераПроведение, Истина);
				
		ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
		МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_Органиазация

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Контрагент = ОбщегоНазначенияУВСВызовСервера.КонтрагентПоОрганизации(Объект.Организация);
	Объект.ТаблицаЗаписейСкладскогоЖурнала.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_Предприятие

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)

	ОбщегоНазначенияУВСКлиент.ПредприятиеПриИзменении(Объект.Контрагент, Объект.Предприятие);
	Объект.ТаблицаЗаписейСкладскогоЖурнала.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияУВСКлиент.ПредприятиеНачалоВыбора(Элемент, СтандартнаяОбработка, Объект.Организация);

КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	ОбщегоНазначенияУВСКлиент.ПредприятиеАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);

КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	ОбщегоНазначенияУВСКлиент.ПредприятиеОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицаЗаписейСкладскогоЖурнала

&НаКлиенте
Процедура ТаблицаЗаписейСкладскогоЖурналаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаписейСкладскогоЖурналаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивСтрок = Объект.ТаблицаЗаписейСкладскогоЖурнала.НайтиСтроки(Новый Структура("ЗаписьСкладскогоЖурнала", ВыбранноеЗначение.ЗаписьСкладскогоЖурнала));
	
	Если МассивСтрок.Количество() = 0 Тогда
		
		НоваяСтрока = Объект.ТаблицаЗаписейСкладскогоЖурнала.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подбор(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрЗаголовок = НСтр("ru = 'Подбор продукции в %Документ%'");
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Объект.Ссылка);
	Иначе
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru = 'корректировку остатков записей складского журнала'"));
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация"       , Объект.Организация);
	ПараметрыФормы.Вставить("Предприятие"       , Объект.Предприятие);
	ПараметрыФормы.Вставить("Документ"          , Объект.Ссылка);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыФормы.Вставить("Заголовок"         , ПараметрЗаголовок);
	
	ОткрытьФорму("Справочник.СвойстваЗаписейСкладскогоЖурнала.Форма.ФормаВыбораСОстатками", ПараметрыФормы, Элементы.ТаблицаЗаписейСкладскогоЖурнала);
	
КонецПроцедуры

&НаКлиенте
Процедура Обнулить(Команда)
	МассивСтрок = Объект.ТаблицаЗаписейСкладскогоЖурнала;
	Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
		СтрокаТаблицы.Количество = 0;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти