﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ФайловыйРежим Тогда
		ПроверяемыеРеквизиты.Добавить("КаталогИнформационнойБазы");
	Иначе
		ПроверяемыеРеквизиты.Добавить("ИмяСервера");
		ПроверяемыеРеквизиты.Добавить("ИмяИнформационнойБазыНаСервере");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
