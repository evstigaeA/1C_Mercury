﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив разрешенных статусов версий записей для объединения
// 
// Возвращаемое значение:
//  Массив - 
//
Функция РазрешенныеСтатусыЗаписейСкладскогоЖурналаДляВыполненияОпераций() Экспорт
	
	МассивРазрешенныхСтатусов = Новый Массив;
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED);                            // 100 - создан
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED_WHEN_QUENCH_VETCERTIFICATE); // 101 - Запись создана путем гашения ВС (импорт)
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED_WHEN_QUENCH_VETDOCUMENT);    // 102 - Запись создана путем гашения ВСД
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED_BY_OPERATION);               // 103 - Запись создана в результате производственной операции
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED_WHEN_MERGE);                 // 110 - Запись создана в результате объединения двух или более других
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.CREATED_WHEN_SPLIT);                 // 120 - Запись создана в результате разделения другой
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.UPDATED);                            // 200 - В запись были внесены изменения
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.UPDATED_WHEN_WRITINGOFF);            // 202 - Запись продукции изменена путём списания. Необязательно, чтобы продукция была списана полностью, может быть списана и часть объёма
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.UPDATED_WHEN_ATTACH);                // 230 - Запись была обновлена в результате присоединения другой
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.UPDATED_WHEN_ATTACH_AUTOMATIC);      // 231 - Запись была обновлена в результате присоединения другой
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.UPDATED_WHEN_FORK);                  // 240 - Запись была обновлена в результате отделения от неё другой
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.RESTORED_AFTER_DELETE);              // 250 - Запись была восстановлена после удаления
	МассивРазрешенныхСтатусов.Добавить(Справочники.СтатусыВерсийЗаписейСкладскогоЖурнала.MOVED);                              // 300 - Запись была перемещена в другую группу (для иерархических справочников)
	
	Возврат МассивРазрешенныхСтатусов;
КонецФункции

#КонецОбласти

#КонецЕсли