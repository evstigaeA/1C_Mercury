﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУВССервер.ДобавитьЭлементАдресНаФормуСпискаВыбора(ЭтаФорма, "Адрес пункта перегрузки");
	
КонецПроцедуры

#КонецОбласти