﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбновлениеИнформационнойБазы

// Монопольный обработчик обновления 2.0.6.1
Процедура ЗаполнитьТипыЗагружаемыхВСД() Экспорт
	
	МассивТиповВСД = Новый Массив;
	МассивТиповВСД.Добавить(Справочники.ТипыВСД.Транспортный);
	МассивТиповВСД.Добавить(Справочники.ТипыВСД.ПроизводственныйВСД);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатыПоследнихЗагрузокВСД.Организация КАК Организация,
		|	ДатыПоследнихЗагрузокВСД.Предприятие КАК Предприятие,
		|	МИНИМУМ(ДатыПоследнихЗагрузокВСД.Дата) КАК Дата
		|ИЗ
		|	РегистрСведений.ДатыПоследнихЗагрузокВСД КАК ДатыПоследнихЗагрузокВСД
		|
		|СГРУППИРОВАТЬ ПО
		|	ДатыПоследнихЗагрузокВСД.Предприятие,
		|	ДатыПоследнихЗагрузокВСД.Организация";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ДатыПоследнихЗагрузокВСД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.Предприятие.Установить(Выборка.Предприятие);
		
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		
		Для Каждого ТипВСД Из МассивТиповВСД Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			НоваяЗапись.ТипВСД = ТипВСД;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ДатыПоследнихЗагрузокВСД", Загрузка);
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "ДатыПоследнихЗагрузокВСД", Загрузка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли