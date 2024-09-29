﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьДокументКорректировкиОстатковЗаписейСкладскогоЖурнала(Параметры, ТаблицаЗаписей) Экспорт
	
	ПараметрыПодключения = ИнтеграцияВетисAPIСлужебный.ПараметрыПодключенияКВетисAPI(Параметры.Организация, Параметры.Ответственный,, Справочники.ВидыОперацийОбменаAPI.ЗагрузкаДанныхПоЗаписямСкладскогоЖурнала);
	
	ИтоговаяТаблица = Новый ТаблицаЗначений;
	ИтоговаяТаблица.Колонки.Добавить("ЗаписьСкладскогоЖурнала", Новый ОписаниеТипов("СправочникСсылка.СвойстваЗаписейСкладскогоЖурнала"));
	ИтоговаяТаблица.Колонки.Добавить("Количество"             , ОбщегоНазначения.ОписаниеТипаЧисло(21, 6));
	ИтоговаяТаблица.Колонки.Добавить("КоличествоОстаток"      , ОбщегоНазначения.ОписаниеТипаЧисло(21, 6));
	
	Для Каждого ТекЗапись Из ТаблицаЗаписей Цикл
		
		// Если количество одинаковое, то нет смысла делать по данной записи корректировку
		Если ТекЗапись.Количество = ТекЗапись.КоличествоМеркурий Тогда
			Продолжить;
		КонецЕсли;
		
		МассивОшибокОбработки = Новый Массив;
		
		Если ПустаяСтрока(ТекЗапись.ОписаниеОбъекта) Тогда // Такой записи нет в Меркурии, либо она уже списана в ноль
			
			НоваяСтрока = ИтоговаяТаблица.Добавить();
			НоваяСтрока.ЗаписьСкладскогоЖурнала = ТекЗапись.ЗаписьСкладскогоЖурнала;
			НоваяСтрока.Количество 				= ТекЗапись.КоличествоМеркурий;
			НоваяСтрока.КоличествоОстаток 		= ТекЗапись.Количество;
			
		Иначе
			
			ЗаписьСкладскогоЖурналаXDTO = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ТекЗапись.ОписаниеОбъекта);
			ДанныеЗаписиСкладскогоЖурналаСтруктура = ИнтеграцияВетисAPIОбработкаПартий.ЗаписьСкладскогоЖурналаПоДаннымXDTO(ПараметрыПодключения, Параметры.Предприятие, ЗаписьСкладскогоЖурналаXDTO, Истина);
			
			НоваяСтрока = ИтоговаяТаблица.Добавить();
			НоваяСтрока.ЗаписьСкладскогоЖурнала = ДанныеЗаписиСкладскогоЖурналаСтруктура.ЗаписьСкладскогоЖурнала;
			НоваяСтрока.Количество              = ДанныеЗаписиСкладскогоЖурналаСтруктура.КоличествоПродукции;
			НоваяСтрока.КоличествоОстаток 		= ТекЗапись.Количество;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИтоговаяТаблица.Количество() > 0 Тогда
		
		ДокументКорректировки = Документы.КорректировкаОстатковЗаписейСкладскогоЖурнала.СоздатьДокумент();
		ДокументКорректировки.Дата = ТекущаяДата();
		ДокументКорректировки.УстановитьНовыйНомер();
		
		ДокументКорректировки.Организация   = Параметры.Организация;
		ДокументКорректировки.Контрагент    = Параметры.Контрагент;
		ДокументКорректировки.Предприятие   = Параметры.Предприятие;
		ДокументКорректировки.Ответственный = Параметры.Ответственный;
		
		ДокументКорректировки.ТаблицаЗаписейСкладскогоЖурнала.Загрузить(ИтоговаяТаблица);
		
		ДокументКорректировки.Записать();
		
		Если Не Параметры.Свойство("СсылкаНаДокумент") = Неопределено Тогда
			Параметры.СсылкаНаДокумент = ДокументКорректировки.Ссылка;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Создан документ: '") + ДокументКорректировки, ДокументКорректировки.Ссылка);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ не создан. Нет записей складского журнала различных по количеству.'"));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли