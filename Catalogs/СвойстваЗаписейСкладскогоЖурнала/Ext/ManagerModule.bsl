﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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
	Результат.Добавить("Организация");
	Результат.Добавить("Предприятие");
	Результат.Добавить("НомерПартии");
	Результат.Добавить("GUID_Меркурий");
	Результат.Добавить("ТипПродукции");
	Результат.Добавить("ВидПродукции");
	Результат.Добавить("ПодвидПродукции");
	Результат.Добавить("НаименованиеПродукции");
	Результат.Добавить("Продукция");
	Результат.Добавить("ЕдиницаИзмерения");
	Результат.Добавить("СкоропортящаясяПродукция");
	Результат.Добавить("ФорматДатыВыработки");
	Результат.Добавить("ДатаВыработкиНачало");
	Результат.Добавить("ДатаВыработкиОкончание");
	Результат.Добавить("ДатаВыработкиСтрокой");
	Результат.Добавить("ФорматСрокаГодности");
	Результат.Добавить("ДатаОкончанияСрокаГодностиНачало");
	Результат.Добавить("ДатаОкончанияСрокаГодностиОкончание");
	Результат.Добавить("ДатаСрокаГодностиСтрокой");
	Результат.Добавить("НекачественныйГруз");
	Результат.Добавить("СтранаПроисхождения");
	Результат.Добавить("ПродукцияПроизводителя");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = "(" + Данные.НомерЗаписиЖурнала + ") " + Данные.Наименование;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("НомерЗаписиЖурнала");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Монопольный обработчик обновления 2.0.4.3
Процедура ЗаполнитьПредприятие() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеПродукцииОбороты.Предприятие КАК Предприятие,
		|	ДвижениеПродукцииОбороты.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
		|ИЗ
		|	РегистрНакопления.ДвижениеПродукции.Обороты КАК ДвижениеПродукцииОбороты";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.ЗаписьСкладскогоЖурнала.ПолучитьОбъект();
		Объект.Предприятие = Выборка.Предприятие;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
	КонецЦикла;
	
КонецПроцедуры

// Монопольный обработчик обновления 2.0.5.1
// Заполняет реквизит ""Формат срока годности"", а так же проверяет корректность заполнения реквизита ""Формат даты выработки""
Процедура ЗаполнитьФорматыДатПродукции() Экспорт
	
	ОбработаныВсеЗаписиСкладскогоЖурнала = Ложь;
	
	Пока Не ОбработаныВсеЗаписиСкладскогоЖурнала Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	СвойстваЗаписейСкладскогоЖурнала.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.СвойстваЗаписейСкладскогоЖурнала КАК СвойстваЗаписейСкладскогоЖурнала
			|ГДЕ
			|	СвойстваЗаписейСкладскогоЖурнала.ФорматСрокаГодности = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияДаты.ПустаяСсылка)";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СвойстваПараметровДат = ОбновлениеИнформационнойБазыУВС.СвойстваПараметровДат();
			ЗаполнитьЗначенияСвойств(СвойстваПараметровДат, Выборка.Ссылка);
			
			ЗаписьСкладскогоЖурналаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОбновлениеИнформационнойБазыУВС.УстановитьЗначенияФорматовДатОбъекта(ЗаписьСкладскогоЖурналаОбъект, СвойстваПараметровДат);
			
			Попытка
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЗаписьСкладскогоЖурналаОбъект);
			Исключение
				ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстИсключения = НСтр("ru = 'Не удалось выполнить обновление форматов дат по причине: %ПредставлениеОшибки%.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПредставлениеОшибки%", ПредставлениеОшибки);
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.СвойстваЗаписейСкладскогоЖурнала,
					Выборка.Ссылка,
					ТекстИсключения);
			КонецПопытки;
			
		КонецЦикла;
		
		КоличествоСсылок = Выборка.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОбработаныВсеЗаписиСкладскогоЖурнала = Истина;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли