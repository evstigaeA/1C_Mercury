﻿////////////////////////////////////////////////////////////////////////////////
// Менеджер защиты: Система лицензирования отраслевых и специализированных решений. 
// Область выполнения: Сервер (повторное использование)
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ОбъектКомпоненты() Экспорт
	// Подключаем компоненту только в случае необходимости (см. блок Исключение)
	Попытка
		// Считаем, что компонента уже подключена
		Возврат Новый("AddIn.Licence.LicenceExtension");
	Исключение
		// Исключение возможно только если компонента еще не подключена
	КонецПопытки;
	слкМенеджерЗащитыСервер.ПодключитьКомпонентуСЛК();
	Возврат Новый("AddIn.Licence.LicenceExtension");
КонецФункции

// Возвращает менеджер серии защиты. Структура, содержащая МенеджерОбъектов СЛК и 
// описывающая  параметры подключения серии защиты.
//
// Параметры:
//	Серия - Строка - Уникальная серия ключей защиты СЛК
//
// Возвращаемое значение:
//   Структурв   - Менеджер серии защиты
//
Функция МенеджерОбъектовСерииЗащиты(Знач Серия)	Экспорт
	
	МенеджерСерииЗащиты = ПолучитьМенеджерСерииЗащиты(Серия);
	ПараметрыПодключения = МенеджерСерииЗащиты.ПараметрыПодключения;
	ПараметрыСвязи = слкМенеджерЗащитыСервер.ПараметрыСвязи(ПараметрыПодключения.Host, ПараметрыПодключения.Port);
	
	// Создание объекта 
	МенеджерЛицензии = слкМенеджерЗащитыСервер.ОбъектКомпоненты();
	
	// Запуск
	Если ЗначениеЗаполнено(ПараметрыСвязи) Тогда
		МенеджерЛицензии.ПараметрыСвязи = ПараметрыСвязи;
	КонецЕсли;
	Если НЕ МенеджерЛицензии.Запуск(Серия, МенеджерСерииЗащиты.ТолькоНаличиеКлюча) Тогда
		слкМенеджерЗащиты.ВызватьИсключениеСЛК(МенеджерЛицензии.ПолучитьОписаниеОшибки(), Серия);
	КонецЕсли;
	
	// Получаем имя менеджера объектов
	Имя = МенеджерЛицензии.ПолучитьМенеджерОбъектов();
	Если Имя = Неопределено Тогда
		ВызватьИсключение МенеджерЛицензии.ПолучитьОписаниеОшибки();
	КонецЕсли;
	
	Защита = Неопределено;
	// Обход ошибки обычного приложения
	Если ТекущийРежимЗапуска() <> РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		Попытка
			Защита = Новый ("ОписаниеЗащитыОтОпасныхДействий");
			Защита.ПредупреждатьОбОпасныхДействиях = Ложь;
		Исключение
			// Исключение возможно на предыдущих версиях платформы без механизма
			// защиты от опасных действий
		КонецПопытки;
	КонецЕсли;
	
	// Создание менеджера объектов
	Попытка
		Если Защита = Неопределено Тогда
			// Предыдущие версии платформы без механизма защиты
			МенеджерОбъектов = ВнешниеОбработки.Создать(МенеджерЛицензии.МенеджерОбъектов, БезопасныйРежим());
		Иначе
			МенеджерОбъектов = ВнешниеОбработки.Создать(
				ВнешниеОбработки.Подключить(
					ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Имя)), , БезопасныйРежим(), Защита));
		КонецЕсли;
		     
	Исключение
		слкМенеджерЗащиты.ВызватьИсключениеСЛК(НСтр("ru = 'Ошибка создания менеджера объектов СЛК: '") + ОписаниеОшибки(), Серия);
	КонецПопытки;
	
	// Настраиваем менеджер объектов, дополнительно передаем объект для отключения
	// предупреждений об опасных действиях
	МенеджерОбъектов.УстановитьОбъектКомпоненты(МенеджерЛицензии, Защита);
		
	Если МенеджерОбъектов.ПопыткаПолучитьЛицензию() = Неопределено Тогда
		
		слкМенеджерЗащиты.ВызватьИсключениеСЛК(МенеджерОбъектов.ПолучитьОписаниеОшибки(), Серия);
		
	Иначе
		
		слкМенеджерЗащитыСервер.ЗагрузитьФайлыДанных(Серия, МенеджерСерииЗащиты, МенеджерОбъектов, Истина);
		
		слкМенеджерЗащитыСервер.ИнициализироватьСериюЗащиты(Серия, МенеджерСерииЗащиты.ТолькоНаличиеКлюча);
		
	КонецЕсли;
	
	Возврат МенеджерОбъектов;

КонецФункции // МенеджерОбъектовСерииЗащиты()

// Возвращает менеджер защиты. Соответствие, описывающее инициализированные сеансом
// серии защиты. Каждой серии защиты соответствует элемент соответствия.
//
// Параметры:
//  Активные - Булево - только доступные по установленным пользователю сеанса ролям
//                 
// Возвращаемое значение:
//   Соответствие   - Менеджер защиты
//
Функция ПолучитьМенеджерЗащиты(Знач Активные = Ложь) Экспорт
	
	Возврат слкМенеджерЗащитыСервер.ПолучитьМенеджерЗащиты(Активные);

КонецФункции // ПолучитьМенеджерЗащиты()

// Возвращает менеджер серии защиты. Структура, содержащая МенеджерОбъектов СЛК и 
// описывающая  параметры подключения серии защиты.
//
// Параметры:
//	Серия - Строка - Уникальная серия ключей защиты СЛК
//  ОписаниеОшибки  - Строка - Информация об ошибке полученная вызовом функции 
//						СЛК ПолучитьОписаниеОшибки (описание последней ошибки)
// Возвращаемое значение:
//   Структурв   - Менеджер серии защиты
//
Функция ПолучитьМенеджерСерииЗащиты(Знач Серия)	Экспорт
	
	Возврат слкМенеджерЗащитыСервер.ПолучитьМенеджерСерииЗащиты(Серия);

КонецФункции // ПолучитьМенеджерСерииЗащиты()

// Преобразует список ключей защиты, полученный функцией
// ПолучитьСписокКлючей() компоненты защиты СЛК в таблицу значений
//
// Параметры:
//  СписокКлючей  - Строка - список регистрационных номеров ключей  используемой серии 
//					установленных на сервере СЛК. 
//					Где:
// 					СН – серийный номер ключа
//					Тип – тип ключа (3 – основной, 4 – дополнительный)
//					Лицензии – количество лицензий
//					ТипУстройства – 0 – аппаратный, 1 – программный
//					РегНомер – регистрационный номер, связанный с С/Н (0, если не связан)
//
// Возвращаемое значение:
//   ТаблицаЗначений   - таблица ключей защиты, состав колонок соответствует
//							формату строки СписокКлючей
//
Функция ТаблицаИзСпискаКлючейЗащиты(СписокКлючей) Экспорт
	
	// Описание таблицы
	ТаблицаКлючей = Новый ТаблицаЗначений();
	ТаблицаКлючей.Колонки.Добавить("СН", Новый  ОписаниеТипов("Число"));
	ТаблицаКлючей.Колонки.Добавить("Тип", Новый  ОписаниеТипов("Число"));
	ТаблицаКлючей.Колонки.Добавить("ТипКлюча", Новый  ОписаниеТипов("Число"));
	ТаблицаКлючей.Колонки.Добавить("Лицензии", Новый  ОписаниеТипов("Число"));
	ТаблицаКлючей.Колонки.Добавить("ТипУстройства", Новый  ОписаниеТипов("Строка"));
	ТаблицаКлючей.Колонки.Добавить("РегНомер", Новый  ОписаниеТипов("Число"));
	ТаблицаКлючей.Колонки.Добавить("ТипПредставление", Новый  ОписаниеТипов("Строка"));
	ТаблицаКлючей.Колонки.Добавить("ТипУстройстваПредставление", Новый  ОписаниеТипов("Строка"));
	
	Если НЕ ЗначениеЗаполнено(СписокКлючей) Тогда
		Возврат ТаблицаКлючей; 
	КонецЕсли;
	
	// Описание разделителей
	РазделительСтрокиКлюч = ";";
	РазделительСтрокиПоле = ",";

	// Описание представлений
	ТипыКлючей = Новый Соответствие;
	ТипыКлючей.Вставить(3, "основной");
	ТипыКлючей.Вставить(4, "дополнительный");
	ТипыКлючей.Вставить(5, "демонстрационный");
	
	ТипыУстройства = Новый Соответствие;
	ТипыУстройства.Вставить("USB", "USB");
	ТипыУстройства.Вставить("Virtual", "программный");
	
	МассивОписанийКлючей = СтрРазделить(СписокКлючей, РазделительСтрокиКлюч);
	Для каждого КлючЗащиты Из МассивОписанийКлючей Цикл
		
		ОписаниеКлюча = СтрРазделить(КлючЗащиты, РазделительСтрокиПоле);
		
		СтрокаКлюча = ТаблицаКлючей.Добавить();
		СтрокаКлюча.СН = ОписаниеКлюча[0];
		СтрокаКлюча.Тип = ОписаниеКлюча[1];
		СтрокаКлюча.Лицензии = ОписаниеКлюча[2];
		СтрокаКлюча.ТипУстройства = ОписаниеКлюча[3];
		СтрокаКлюча.РегНомер = ОписаниеКлюча[4];

		СтрокаКлюча.ТипПредставление = ТипыКлючей[СтрокаКлюча.Тип];
		СтрокаКлюча.ТипУстройстваПредставление = ТипыУстройства[СтрокаКлюча.ТипУстройства];
	
	КонецЦикла;
	
	ТаблицаКлючей.Индексы.Добавить("Тип");
	
	Возврат ТаблицаКлючей;

КонецФункции // ТаблицаИзСпискаКлючейЗащиты()

// Функция создания защищенного объекта
// 
Функция СоздатьОбъект(Серия, Имя) Экспорт
	
	Возврат слкМенеджерЗащитыСервер.ПолучитьМенеджерОбъектовСерииЗащиты(Серия).СоздатьОбъект(Имя);
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

Функция ЭтоКлиентСервернаяБаза() Экспорт

	Возврат Не Найти(ВРег(СтрокаСоединенияИнформационнойБазы()), "FILE=");

КонецФункции // ЭтоКлиентСервернаяБаза()

#КонецОбласти

#КонецОбласти
