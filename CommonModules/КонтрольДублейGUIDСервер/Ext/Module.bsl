﻿
#Область ОбработчикиПодписокНаСобытия

Процедура КонтрольСправочниковДублейОбъектовПоGUIDПередЗаписью(Источник, Отказ) Экспорт	
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ИгнорироватьПроверкуДублейGUID") Тогда
		Возврат
	КонецЕсли; 
	
	ВыполнитьКонтрольДублейGUID(Источник, Отказ, "Справочник");
	
КонецПроцедуры

Процедура КонтрольДублейОбъектовПоGUID_ДокументыПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ИгнорироватьПроверкуДублейGUID") Тогда
		Возврат
	КонецЕсли; 
	
	ВыполнитьКонтрольДублейGUID(Источник, Отказ, "Документ");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Ищет даты запрета изменения/загрузки данных для объекта.
//
// Параметры:
//  Источник        - СправочникОбъект,
//                    ДокументОбъект  - объект данных.
//
//  Отказ           - Булево - (возвращаемое значение), будет установлено Истина,
//                    если объект не проходит проверки дублей GUID.
//
//  ТипТаблицы 		- Строка - Справочник или документ.
//
Процедура ВыполнитьКонтрольДублейGUID(Источник, Отказ, ТипТаблицы, СообщитьОЗапрете = Ложь)

	Если Не ЗначениеЗаполнено(Источник.GUID_Меркурий) Тогда
		Возврат	
	КонецЕсли;
	
	ОписаниеОшибки		= "";
	СообщитьОЗапрете	= Истина;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("GUID_Меркурий", Источник.GUID_Меркурий);
	Запрос.УстановитьПараметр("ТекущаяСсылка", Источник.Ссылка);
	Если ТипТаблицы = "Документ" Тогда
		Запрос.УстановитьПараметр("Организация", Источник.Организация);
	КонецЕсли;
	Запрос.Текст = ТекстЗапросаПоискаДублей(ТипТаблицы, Источник.Метаданные().Имя);
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		ОписаниеОшибки 	= НСтр("ru = 'Невозможно записать объект с GUID %1 (обнаружены дубли). Тип объекта: %2'");
		ОписаниеОшибки	= СтрЗаменить(ОписаниеОшибки, "%1", Источник.GUID_Меркурий);
		ОписаниеОшибки	= СтрЗаменить(ОписаниеОшибки, "%2", ТипЗнч(Источник));
		Отказ 			= Истина;
	КонецЕсли; 
	
	Если Не Отказ Или Не СообщитьОЗапрете Тогда
		Возврат
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки, Источник.Ссылка);
	
	ЗаписьЖурналаРегистрации(
		ОписаниеОшибки,
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		ОписаниеОшибки,
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	
КонецПроцедуры

// Возвращает текст запроса в зависимости от типа объекта
//
// Параметры:
//  ТипТаблицы - Строка - Справочник или документ,
//  ТипОбъекта - Строка - Имя типа объекта.
//
Функция ТекстЗапросаПоискаДублей(ТипТаблицы, ТипОбъекта)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	1 КАК Поле1
	|ИЗ
	|	"+ТипТаблицы+"."+ТипОбъекта+" КАК ТаблицаДублей
	|ГДЕ
	|	ТаблицаДублей.GUID_Меркурий = &GUID_Меркурий
	|	И ТаблицаДублей.Ссылка <> &ТекущаяСсылка";
	
	Если ТипТаблицы = "Документ" Тогда
		ТекстЗапроса = ТекстЗапроса + " И ТаблицаДублей.Организация = &Организация";
	КонецЕсли;
	
	Возврат ТекстЗапроса

КонецФункции
	
#КонецОбласти 

