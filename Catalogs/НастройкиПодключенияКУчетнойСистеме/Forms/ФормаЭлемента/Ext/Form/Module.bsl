﻿
#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_ФайловыйРежим

&НаКлиенте
Процедура ФайловыйРежимПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	                                         
	ФайловыйРежим = Объект.ФайловыйРежим;
	
	Элементы.ИмяСервера.Видимость = Не ФайловыйРежим;
	Элементы.ИмяИнформационнойБазыНаСервере.Видимость = Не ФайловыйРежим;
	Элементы.КаталогИнформационнойБазы.Видимость = ФайловыйРежим;
	
КонецПроцедуры

#КонецОбласти