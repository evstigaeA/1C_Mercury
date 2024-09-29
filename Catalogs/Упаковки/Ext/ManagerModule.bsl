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
	
	Результат.Добавить("GUID_Меркурий");
	
	Возврат Результат;
	
КонецФункции

// Заполнение справочника Упаковки на основании макета справочника
//
Процедура ЗагрузитьЭлементы() Экспорт
	
	ДанныеИзМакета = Справочники.Упаковки.ПолучитьДанныеИзМакета();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеИзМакета.GUID_Меркурий,
		|	ДанныеИзМакета.Наименование,
		|	ДанныеИзМакета.КодЕЭК,
		|	ДанныеИзМакета.СтароеНаименование,
		|	ДанныеИзМакета.НеИспользуется
		|ПОМЕСТИТЬ ВТ_Упаковки
		|ИЗ
		|	&ДанныеИзМакета КАК ДанныеИзМакета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Упаковки.GUID_Меркурий,
		|	ВТ_Упаковки.Наименование,
		|	ВТ_Упаковки.КодЕЭК,
		|	ВТ_Упаковки.СтароеНаименование,
		|	ВТ_Упаковки.НеИспользуется,
		|	Упаковки.Ссылка КАК Ссылка
		|ИЗ
		|	ВТ_Упаковки КАК ВТ_Упаковки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Упаковки КАК Упаковки
		|		ПО ВТ_Упаковки.GUID_Меркурий = Упаковки.GUID_Меркурий";
	
	Запрос.УстановитьПараметр("ДанныеИзМакета", ДанныеИзМакета);	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		УпаковкаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ЗаполнитьЗначенияСвойств(УпаковкаОбъект, ВыборкаДетальныеЗаписи);
		УпаковкаОбъект.ОбменДанными.Загрузка = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(УпаковкаОбъект);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает ссылку по параметру из макета
//
// Параметры:
//  GUID	 - Строка	 - Уникальный идентификатор объекта в системе "Меркурий"
//  КодЕЭК	 - Строка	 - 
// 
// Возвращаемое значение:
//   СправочникСсылка.Упаковки - ссылка.
//
Функция ПолучитьДанныеИзМакетаПоПараметру(GUID = "", КодЕЭК = "") Экспорт
	
	ДанныеИзМакета = Справочники.Упаковки.ПолучитьДанныеИзМакета();
	
	Отбор = Новый Структура();
	Если ЗначениеЗаполнено(GUID) Тогда
		Отбор.Вставить("GUID_Меркурий", GUID);
	ИначеЕсли ЗначениеЗаполнено(КодЕЭК) Тогда
		Отбор.Вставить("КодЕЭК", КодЕЭК);
	КонецЕсли;
	НайденныеСтроки = ДанныеИзМакета.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Упаковка = НайденныеСтроки[0];
	Иначе
		Упаковка = Неопределено;
	КонецЕсли;
		
	Возврат Упаковка;
	
КонецФункции

// Возвращает данные из макета
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьДанныеИзМакета() Экспорт

	Текст = Новый ТекстовыйДокумент;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Макет = Справочники.Упаковки.ПолучитьМакет("Упаковки");
	Макет.Записать(ИмяВременногоФайла);
	Текст.Прочитать(ИмяВременногоФайла);
	ТекстМакета = Текст.ПолучитьТекст();
	
	Возврат ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстМакета);

КонецФункции

#КонецОбласти

#КонецЕсли