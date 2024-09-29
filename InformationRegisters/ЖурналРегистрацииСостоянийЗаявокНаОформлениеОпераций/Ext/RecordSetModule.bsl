﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура  ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат
	КонецЕсли; 	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат
	КонецЕсли;
	
	// постановка и снатие с резерва в зависимости от сосотояния заявки
	Если ЭтотОбъект.Количество() > 0 Тогда
		
		//Проверяем статус заявки и при необходимости ставим продукцию в резерв или снимаем с резерва
	
		//Список состояний заявок при которых продукция снимается с резерва
		СписокСостоянийДляСнятияРезерва = Новый СписокЗначений();
		СписокСостоянийДляСнятияРезерва.Добавить(Справочники.СтатусыЗаявок.Закрыта);
		СписокСостоянийДляСнятияРезерва.Добавить(Справочники.СтатусыЗаявок.ЗаявкаОтмененаАдминистратором);
		СписокСостоянийДляСнятияРезерва.Добавить(Справочники.СтатусыЗаявок.Отклонена);
		СписокСостоянийДляСнятияРезерва.Добавить(Справочники.СтатусыЗаявок.ОшибкаОтправкиЗапроса);
		
		// Структура документов с ошибками записи движений
		ДокументыСОшибками = Новый Структура;
		
		Для каждого СтрокаДвижения Из ЭтотОбъект Цикл
			// Если по состоянию заявки нужно снять резерв (отменить проведение документа)
			Если СписокСостоянийДляСнятияРезерва.НайтиПоЗначению(СтрокаДвижения.Статус) <> Неопределено Тогда
				ДокументОбъект = СтрокаДвижения.ДокументСсылка.ПолучитьОбъект();
				Попытка
					ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				Исключение
					ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ТекстИсключения = НСтр("ru = 'Не удалось отменить проведение заявки по причине: %ПредставлениеОшибки%.'");
					ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПредставлениеОшибки%", ПредставлениеОшибки);
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Отмена проведения'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
											 УровеньЖурналаРегистрации.Ошибка,
											 СтрокаДвижения.ДокументСсылка.Метаданные(),
											 СтрокаДвижения.ДокументСсылка,
											 ТекстИсключения);
				КонецПопытки;
			КонецЕсли;
			
		КонецЦикла;
		
		Для каждого ДокументСОшибкой Из ДокументыСОшибками Цикл
			ИнтеграцияВетисAPIСлужебный.УстановитьТекущийСтатусСостоянийЗаявокНаОформлениеОпераций(ДокументСОшибкой.Ключ, Справочники.СтатусыЗаявок.ОшибкаОбработкиОтвета,,,ДокументСОшибкой.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли