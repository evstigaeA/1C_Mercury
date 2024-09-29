﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыриантыРазбивкиДокументовНаСтраницы = РегистрыСведений.НастройкиПечатиОбъектов.ВыриантыРазбивкиДокументовНаСтраницы();
	
	Для Каждого ТекВариант Из ВыриантыРазбивкиДокументовНаСтраницы Цикл
		Элементы.ВариантРазбивкиДокументовНаСтраницы.СписокВыбора.Добавить(ТекВариант.Значение, ТекВариант.Представление);
	КонецЦикла;
	
	ОбъектМетаданных = Параметры.Объекты[0].Метаданные();
	
	ТипОбъекта               = ОбъектМетаданных.ПолноеИмя();
	ПредставлениеТипаОбъекта = ОбъектМетаданных.Представление();
	
	ПараметрыПечатиОбъекта = РегистрыСведений.НастройкиПечатиОбъектов.ПараметрыПечатиОбъекта(ТипОбъекта, Пользователи.ТекущийПользователь());
	
	ВариантРазбивкиДокументовНаСтраницы = Элементы.ВариантРазбивкиДокументовНаСтраницы.СписокВыбора.НайтиПоЗначению(ПараметрыПечатиОбъекта.ВариантРазбивкиДокументовНаСтраницы).Значение;
	
	Если ВариантРазбивкиДокументовНаСтраницы = "Настраиваемый" Тогда
		
		НастройкиРеквизитов = ПараметрыПечатиОбъекта.Настройки.Получить();
		Для Каждого ТекЗначение Из НастройкиРеквизитов Цикл
			ЗаполнитьЗначенияСвойств(РеквизитыРазбивкиСтраниц.Добавить(), ТекЗначение);
		КонецЦикла;
		
	Иначе
		
		КоллекцияРеквизитовДокументаДляРазбивкиСтраниц = РегистрыСведений.НастройкиПечатиОбъектов.КоллекцияРеквизитовДокументаДляРазбивкиСтраниц();
		
		Для Каждого ТекРеквизит Из КоллекцияРеквизитовДокументаДляРазбивкиСтраниц Цикл
			РеквизитыРазбивкиСтраниц.Добавить(ТекРеквизит.Значение, ТекРеквизит.Представление);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ВыполняетсяЗакрытие Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ СохранитьПараметры И НЕ ЗавершениеРаботы Тогда
		
		ТекстВопроса = НСтр("ru = 'Изменены настройки печати документов. Выполнить сохранение настроек?'");
		Обработчик = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		СохранитьНастройкиНаСервере();
	КонецЕсли;

	ВыполняетсяЗакрытие = Истина;
	Закрыть();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантРазбивкиДокументовНаСтраницыПриИзменении(Элемент)
	
	РеквизитыРазбивкиСтраниц.ЗаполнитьПометки(Ложь);
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСпискаФормы

&НаКлиенте
Процедура РеквизитыРазбивкиСтраницПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыРазбивкиСтраницПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("ТипОбъекта", ТипОбъекта);
	СтруктураЗаписи.Вставить("Пользователь", Пользователи.ТекущийПользователь());
	СтруктураЗаписи.Вставить("ВариантРазбивкиДокументовНаСтраницы", ВариантРазбивкиДокументовНаСтраницы);
	СтруктураЗаписи.Вставить("Настройки", Новый ХранилищеЗначения(РеквизитыРазбивкиСтраниц));
	СтруктураЗаписи.Вставить("ПредставлениеТипаОбъекта", ПредставлениеТипаОбъекта);
	СтруктураЗаписи.Вставить("ПредставлениеВариантаРазбивкиДокументовНаСтраницы", Элементы.ВариантРазбивкиДокументовНаСтраницы.СписокВыбора.НайтиПоЗначению(ВариантРазбивкиДокументовНаСтраницы));
	
	РегистрыСведений.НастройкиПечатиОбъектов.ДобавитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		СохранитьНастройкиНаСервере();
		
		СохранитьПараметры = Истина;
		
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Элементы.РеквизитыРазбивкиСтраниц.ТолькоПросмотр = ВариантРазбивкиДокументовНаСтраницы <> "Настраиваемый";
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти