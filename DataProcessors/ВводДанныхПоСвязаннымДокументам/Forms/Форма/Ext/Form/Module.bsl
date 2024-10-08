﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресХранения") Тогда
		АдресХранения = Параметры.АдресХранения;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоПросмотр") Тогда
		ЭтаФорма.ТолькоПросмотр = Параметры.ТолькоПросмотр;
		Элементы.ДанныеОСвязанныхДокументах.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	КонецЕсли;
	
	Элементы.ДанныеОСвязанныхДокументахТипСвязанногоДокумента.РежимВыбораИзСписка = Истина;
	Элементы.ДанныеОСвязанныхДокументахТипСвязанногоДокумента.СписокВыбора.ЗагрузитьЗначения(Справочники.ТипыТТН.СписокРазрешенныхДокументовОтгрузки());
	
	ИнициализацияФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыДанныеОСвязанныхДокументах

&НаКлиенте
Процедура ДанныеОСвязанныхДокументахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.ДанныеОСвязанныхДокументах.Количество() >= 5 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
								НСтр("ru = 'Можно указать не более 5 связанных документов'"),
								,
								,
								,
								Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Закрыть(Объект.ДанныеОСвязанныхДокументах);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормы()
	
	ТаблицаСвязанныхДокументов = ПолучитьИзВременногоХранилища(АдресХранения);
	
	Для Каждого ТекСтрока Из ТаблицаСвязанныхДокументов Цикл
		
		НоваяСтрока = Объект.ДанныеОСвязанныхДокументах.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти