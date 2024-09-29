﻿Процедура ЗаполнитьДанные() Экспорт 
	Организация = ОбщегоНазначенияУВССервер.ОрганизацияТекущегоПользователя();
	Контрагент  = ОбщегоНазначенияУВССервер.КонтрагентПоОрганизации(Организация);
	СписокПредприятия = ОбщегоНазначенияУВСВызовСервера.ПредприятияПоКонтрагенту(Контрагент);
	
	Для Каждого Предприятия Из СписокПредприятия Цикл
		Если Не Предприятия.НеИспользуется Тогда
			НовыеЗаписи = РегистрыСведений.ПараметрыАктуальныхОстатков.СоздатьНаборЗаписей();
			НовыеЗаписи.Отбор.Предприятие.Установить(Предприятия);
			НовыеЗаписи.Отбор.Контрагент.Установить(Контрагент);
			НовыеЗаписи.Отбор.Организация.Установить(Организация);
			НовыеЗаписи.Прочитать();
			Если Не НовыеЗаписи.Количество() > 0 Тогда
				НоваяЗапись = НовыеЗаписи.Добавить();
				НоваяЗапись.Контрагент = Контрагент;
				НоваяЗапись.Организация = Организация;
				НоваяЗапись.Предприятие = Предприятия;
				НоваяЗапись.СмещениеВперед = 600;
				НоваяЗапись.СмещениеНазад  = 3600;
				НовыеЗаписи.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
