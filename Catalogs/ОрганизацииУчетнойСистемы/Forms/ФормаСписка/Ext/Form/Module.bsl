﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновлениеДанныхОрганизацииУчетнойСистемы" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ОбщегоНазначенияУВССервер.УстановитьУсловноеОформлениеСопоставленныхЭлементовЭлементов(ЭтаФорма);
	
КонецПроцедуры


#КонецОбласти