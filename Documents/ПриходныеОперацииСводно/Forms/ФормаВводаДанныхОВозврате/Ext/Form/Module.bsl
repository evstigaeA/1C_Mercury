﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДанныеВозврата") Тогда
		
		ДанныеВозврата = Параметры.ДанныеВозврата;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеВозврата);
		
	КонецЕсли;
	
	Элементы.ГруппаАктНесоответствия.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Элементы.ГруппаДанныеТТН.ТолькоПросмотр         = Параметры.ТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗаполнитьЗначенияСвойств(ДанныеВозврата, ЭтотОбъект);
	
	Закрыть(ДанныеВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти