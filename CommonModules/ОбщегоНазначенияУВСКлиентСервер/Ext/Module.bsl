﻿#Область СервисныеПроцедуры

// Устаналивает свойство "ТолькоПросмотр" для запрещенных статусов записанных документов.
//
// Параметры:
//  Форма  - Форма - форма документа, которую необходимо заблокировать или разблокировать.
//
Процедура БлокировкаФормыПоСтатусуДокумента(Форма, ДополнительныеПараметры = Неопределено) Экспорт 

	Если Форма.Параметры.Ключ.Пустая() Тогда
		Возврат
	КонецЕсли; 	                        

	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ТекущийСтатусДокумента") Тогда
		ТекущийСтатусДокумента 		= ДополнительныеПараметры.ТекущийСтатусДокумента;
	Иначе	
		ТекущийСтатусДокумента 		= ОбщегоНазначенияУВСВызовСервера.ТекущийСтатусДокумента(Форма.Объект.Ссылка);
	КонецЕсли; 
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("МассивЗапрещенныхСтатусов") Тогда
	 	МассивЗапрещенныхСтатусов 	= ДополнительныеПараметры.МассивЗапрещенныхСтатусов;
	Иначе	
		МассивЗапрещенныхСтатусов 	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовСЗапретомРедактированияФормы();
	КонецЕсли;
	
	Если МассивЗапрещенныхСтатусов.Найти(ТекущийСтатусДокумента) = Неопределено Тогда
		Форма.ТолькоПросмотр = Ложь;
	Иначе	
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
КонецПроцедуры

// Заполняет реквизит формы "Статус" текущим статусом документа.
//
// Параметры:
//  Форма  - Форма - форма документа, в которой необходимо установить статус.
//
Процедура ПоказатьТекущийСтатусДокумента(Форма, ДополнительныеПараметры = Неопределено) Экспорт

	Если Форма.Параметры.Ключ.Пустая() Тогда
		Форма.Статус = Новый ФорматированнаяСтрока("отсутствует", , WebЦвета.Синий); 
		Возврат
	КонецЕсли; 	                        

	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ТекущийСтатусДокумента") Тогда
		ТекущийСтатусДокумента 		= ДополнительныеПараметры.ТекущийСтатусДокумента;
	Иначе	
		ТекущийСтатусДокумента 		= ОбщегоНазначенияУВСВызовСервера.ТекущийСтатусДокумента(Форма.Объект.Ссылка);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущийСтатусДокумента) Тогда
		Форма.Статус = Новый ФорматированнаяСтрока("отсутствует", , WebЦвета.Синий); 
		Возврат
	КонецЕсли;	
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("МассивСтатусовУспешноОбработано") Тогда
	 	МассивСтатусовУспешноОбработано 	= ДополнительныеПараметры.МассивСтатусовУспешноОбработано;
	Иначе	
		МассивСтатусовУспешноОбработано 	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовУспешноОбработано();
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("МассивСтатусовВПроцессеОбработки") Тогда
	 	МассивСтатусовВПроцессеОбработки 	= ДополнительныеПараметры.МассивСтатусовВПроцессеОбработки;
	Иначе	
		МассивСтатусовВПроцессеОбработки 	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовВПроцессеОбработки();
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("МассивСтатусовОшибок") Тогда
	 	МассивСтатусовОшибок 	= ДополнительныеПараметры.МассивСтатусовОшибок;
	Иначе	
		МассивСтатусовОшибок 	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовОшибок();
	КонецЕсли;
	
	
	Если Не МассивСтатусовУспешноОбработано.Найти(ТекущийСтатусДокумента) = Неопределено Тогда
		Форма.Статус = Новый ФорматированнаяСтрока("" + ТекущийСтатусДокумента, , WebЦвета.Зеленый);
	ИначеЕсли Не МассивСтатусовВПроцессеОбработки.Найти(ТекущийСтатусДокумента) = Неопределено Тогда
		Форма.Статус = Новый ФорматированнаяСтрока("" + ТекущийСтатусДокумента, , WebЦвета.ЦианТемный);
	ИначеЕсли Не МассивСтатусовОшибок.Найти(ТекущийСтатусДокумента) = Неопределено Тогда
		Форма.Статус = Новый ФорматированнаяСтрока("" + ТекущийСтатусДокумента, , WebЦвета.Красный);
	Иначе	
		Форма.Статус = Новый ФорматированнаяСтрока("" + ТекущийСтатусДокумента, , WebЦвета.Синий);
	КонецЕсли;	

КонецПроцедуры

// Производит дополнительные действия с формой на сервере.
//
// Параметры:
//  Форма  - Форма - форма документа.
//
Процедура ДополнительныеДействияСФормой(Форма) Экспорт 

	ТекущийСтатусДокумента 				= ОбщегоНазначенияУВСВызовСервера.ТекущийСтатусДокумента(Форма.Объект.Ссылка);
	МассивЗапрещенныхСтатусов 			= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовСЗапретомРедактированияФормы();
	МассивСтатусовУспешноОбработано 	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовУспешноОбработано();
	МассивСтатусовВПроцессеОбработки	= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовВПроцессеОбработки();
	МассивСтатусовОшибок 				= ОбщегоНазначенияУВСВызовСервера.МассивСтатусовОшибок();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТекущийСтатусДокумента"			, ТекущийСтатусДокумента);
	ДополнительныеПараметры.Вставить("МассивЗапрещенныхСтатусов"		, МассивЗапрещенныхСтатусов);
	ДополнительныеПараметры.Вставить("МассивСтатусовУспешноОбработано"	, МассивСтатусовУспешноОбработано);
	ДополнительныеПараметры.Вставить("МассивСтатусовВПроцессеОбработки"	, МассивСтатусовВПроцессеОбработки);
	ДополнительныеПараметры.Вставить("МассивСтатусовОшибок"				, МассивСтатусовОшибок);
	
	БлокировкаФормыПоСтатусуДокумента(Форма, ДополнительныеПараметры);	
	ПоказатьТекущийСтатусДокумента(Форма);
	
	ДополнительныеПараметры = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область МетодыРаботыСРеквизитамиОбъектов

// Проверяет наличие у произвольного объекта реквизита с указанным именем.
//
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоЮрЛицо(ТипПредприятия) Экспорт
	
	Если ТипПредприятия = ПредопределенноеЗначение("Справочник.ТипыПредприятий.ЮридическоеЛицо") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция СформироватьПредставлениеСпискаУпаковок(Объект, ИдентификаторСтроки = "", ТабЧасть = "СписокФизическихУпаковок") Экспорт
	
	ЕстьУпаковки = Ложь;
	Если ЗначениеЗаполнено(ИдентификаторСтроки) Тогда
		ЕстьУпаковки = Объект[ТабЧасть].НайтиСтроки(Новый Структура("GUIDСтроки", ИдентификаторСтроки)).Количество() > 0;
	Иначе
		ЕстьУпаковки = Объект[ТабЧасть].Количество() > 0;
	КонецЕсли;
	
	Если ЕстьУпаковки Тогда
		ТекстУпаковок = НСтр("ru = 'Введены данные по упаковкам'");
	Иначе
		ТекстУпаковок = НСтр("ru = 'Без упаковок'");
	КонецЕсли;

	Возврат Новый ФорматированнаяСтрока(ТекстУпаковок,,,,"СвойстваЗаписейСкладскогоЖурнала");
КонецФункции

Процедура УстановитьСвойстваЭлементовФормыДанныхТТН(Форма) Экспорт
	
	ЭлементыФормы = Форма.Элементы;
	Объект        = Форма.Объект;
	
	ЭлементыФормы.ДатаТТН.АвтоОтметкаНезаполненного  = ЗначениеЗаполнено(Объект.ТипТТН);
	ЭлементыФормы.ДатаТТН.ОтметкаНезаполненного      = ЗначениеЗаполнено(Объект.ТипТТН);
	ЭлементыФормы.НомерТТН.АвтоОтметкаНезаполненного = ЗначениеЗаполнено(Объект.ТипТТН);
	ЭлементыФормы.НомерТТН.ОтметкаНезаполненного     = ЗначениеЗаполнено(Объект.ТипТТН);
	ЭлементыФормы.ТипТТН.АвтоОтметкаНезаполненного   = ЗначениеЗаполнено(Объект.ДатаТТН) ИЛИ ЗначениеЗаполнено(Объект.НомерТТН);
	ЭлементыФормы.ТипТТН.ОтметкаНезаполненного       = ЗначениеЗаполнено(Объект.ДатаТТН) ИЛИ ЗначениеЗаполнено(Объект.НомерТТН);
	
КонецПроцедуры

#КонецОбласти
