﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("УполномоченноеГашение") Тогда
		
		УполномоченноеГашение = Параметры.УполномоченноеГашение;
		
		Если УполномоченноеГашение Тогда
			
			Кнопка = ЭтотОбъект.КоманднаяПанель.ПодчиненныеЭлементы.Найти("ФормаДокументПриходныеОперацииСводноВыгрузитьВУчетнуюСистему");
			Если Кнопка <> Неопределено Тогда
				Кнопка.Видимость = Ложь;
			КонецЕсли;
			
			ЭтотОбъект.АвтоЗаголовок = Ложь;
			ЭтотОбъект.Заголовок = НСтр("ru = 'Уполномоченное гашение (сводно)'");
			
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "УполномоченноеГашение", УполномоченноеГашение);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ЗначенияЗаполнения = Новый Структура("УполномоченноеГашение", УполномоченноеГашение);
		ПараметрыФормы     = Новый Структура("ЗначенияЗаполнения"   , ЗначенияЗаполнения);
		
		ПараметрУникальности = ?(УполномоченноеГашение, "УполномоченноеГашениеСводно", "ПриходнаяОперацияСводно");
		
		ОткрытьФорму("Документ.ПриходныеОперацииСводно.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект, ПараметрУникальности);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

#КонецОбласти