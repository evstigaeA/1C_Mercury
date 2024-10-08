﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВССервер.УстановитьУсловноеОформлениеНеИспользуемыхЭлементов(ЭтаФорма);
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПодобратьИзОКЕИ();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодобратьИзОКЕИ()
	
	ОткрытьФорму("Справочник.КлассификаторЕдиницИзмерения.Форма.КлассификаторЕдиницИзмерения",,,,,, Новый ОписаниеОповещения("ПодобратьИзОКЕИЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзОКЕИЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();

КонецПроцедуры	

#КонецОбласти