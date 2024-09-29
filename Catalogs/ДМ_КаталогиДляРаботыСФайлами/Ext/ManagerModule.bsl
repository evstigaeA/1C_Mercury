﻿
// Выполняет проверку валидности заданного Каталога Архива Обработанных Файлов
//
// Параметры:
//  КаталогАрхиваОбработанныхФайлов  - Строка - Полное имя (полный путь с именем)
//                 Каталога Архива Обработанных Файлов
//  пТекстСообщения   - Строка - в этом параметре возвращается текст сообщения об ошибке
//
// Возвращаемое значение:
//  Булево  - Истина:	имя каталога задано верно
//			  Ложь:		каталог не существует или непригоден для использования
//
Функция КаталогАрхиваОбработанныхФайловДоступен( КаталогАрхиваОбработанныхФайлов, пТекстСообщения="" ) Экспорт

	ТекКаталог = Новый Файл(СокрЛП(КаталогАрхиваОбработанныхФайлов));
	Если НЕ ТекКаталог.Существует() Тогда
		пТекстСообщения = НСтр("ru = 'Каталог для архива обрабатываемых файлов %1 недоступен на сервере'");
		пТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( пТекстСообщения, СокрЛП(КаталогАрхиваОбработанныхФайлов) );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( пТекстСообщения );
		Возврат Ложь;
	ИначеЕсли Не ТекКаталог.ЭтоКаталог() Тогда
		пТекстСообщения = НСтр("ru = 'Файл %1 указан в качестве Каталога архива обрабатываемых файлов, а нужно указать имя существующего каталога'");
		пТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( пТекстСообщения, СокрЛП(КаталогАрхиваОбработанныхФайлов) );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( пТекстСообщения );
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ПроверитьКаталогАрхиваОбработанныхФайлов()

// Выполняет проверку валидности заданного Каталога обрабатываемых Файлов
//
// Параметры:
//  КаталогОбрабатываемыхФайлов  - Строка - Полное имя (полный путь с именем)
//                 Каталога Архива Обработанных Файлов
//  пТекстСообщения   - Строка - в этом параметре возвращается текст сообщения об ошибке
//
// Возвращаемое значение:
//  Булево  - Истина:	имя каталога задано верно
//			  Ложь:		каталог не существует или непригоден для использования
//
Функция КаталогОбрабатываемыхФайловДоступен( КаталогОбрабатываемыхФайлов, пТекстСообщения="" ) Экспорт

	ТекКаталог = Новый Файл(СокрЛП(КаталогОбрабатываемыхФайлов));
	Если НЕ ТекКаталог.Существует() Тогда
		пТекстСообщения = НСтр("ru = 'Каталог для обрабатываемых файлов %1 недоступен на сервере'");
		пТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( пТекстСообщения, СокрЛП(КаталогОбрабатываемыхФайлов) );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( пТекстСообщения );
		Возврат Ложь;
	ИначеЕсли Не ТекКаталог.ЭтоКаталог() Тогда
		пТекстСообщения = НСтр("ru = 'Файл %1 указан в качестве Каталога обрабатываемых файлов, а нужно указать имя существующего каталога'");
		пТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( пТекстСообщения, СокрЛП(КаталогОбрабатываемыхФайлов) );
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( пТекстСообщения );
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ПроверитьКаталогАрхиваОбработанныхФайлов()
