﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура  ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат
	КонецЕсли; 
	
	Для каждого СтрокаДвижения Из ЭтотОбъект Цикл
		Если СтрокаДвижения.Количество = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Указана строка с нулевым количеством", СтрокаДвижения.Регистратор, , , Отказ);
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли