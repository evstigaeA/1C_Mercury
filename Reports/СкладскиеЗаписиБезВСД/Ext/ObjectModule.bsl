﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодВыгрузки");
	ПараметрДанных.Значение = ТекущаяДата() - Константы.ГлубинаОтчета.Получить();
	ПараметрДанных.Использование = Истина;
	
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПустойПериод");
	ПараметрДанных.Значение = Дата(1,1,1);
	ПараметрДанных.Использование = Истина;


КонецПроцедуры
#КонецОбласти

#КонецЕсли

