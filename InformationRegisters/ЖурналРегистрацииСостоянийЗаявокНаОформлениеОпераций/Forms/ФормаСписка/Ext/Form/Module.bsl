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

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "Текст" Тогда
		ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Текст);
	ИначеЕсли Поле.Имя = "ОшибкиВыполнения" Тогда
		ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.ОшибкиВыполнения);
	Иначе	
		ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.ДокументСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти