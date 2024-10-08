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
	
	Результат.Добавить("Дата");
	Результат.Добавить("Номер");
	Результат.Добавить("GUID_Меркурий");
	Результат.Добавить("БлагополучиеМестности");
	Результат.Добавить("ВидПродукции");
	Результат.Добавить("ЕдиницаИзмерения");
	Результат.Добавить("КоличествоМесяцевНахожденияЖивотныхНаТерриторииТС");
	Результат.Добавить("МестоПроведенияКарантирования");
	Результат.Добавить("ОсобыеОтметки");
	Результат.Добавить("ПериодНахожденияЖивотныхНаТерриторииТС");
	Результат.Добавить("ПодвидПродукции");
	Результат.Добавить("Посредник");
	Результат.Добавить("ПредприятиеОтправитель");
	Результат.Добавить("ПредприятиеПолучатель");
	Результат.Добавить("Продукция");
	Результат.Добавить("Серия");
	Результат.Добавить("СпособХраненияПриПеревозке");
	Результат.Добавить("ТипВСД");
	Результат.Добавить("ТипДокумента");
	Результат.Добавить("ТипПродукции");
	Результат.Добавить("Транспорт");
	Результат.Добавить("ФормаВСД");
	Результат.Добавить("ТаблицаМаршрутСледования");
	Результат.Добавить("КонтрагентОтправитель");
	Результат.Добавить("КонтрагентПолучатель");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СжатоеСИнформацией") Тогда
	    // Формируем табличный документ и добавляем его в коллекцию печатных форм.
	    УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	        "СжатоеСИнформацией", "Штрих-коды ВСД с дополнительной информацией", СформироватьПечатнуюФормуСжатогоВСДСИнформацией(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Сжатое") Тогда
	    // Формируем табличный документ и добавляем его в коллекцию печатных форм.
	    УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	        "Сжатое", "Штрих-коды ВСД", СформироватьПечатнуюФормуСжатогоВСД(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуВетеринарнойСправки(МассивДокументов) Экспорт
	
	ТипОбъекта = ОбщегоНазначения.ИмяТаблицыПоСсылке(МассивДокументов[0]);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТТаблицаДокументов(Запрос.МенеджерВременныхТаблиц, ТипОбъекта, МассивДокументов);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаДокументов.ВСД КАК ВСД,
		|	ТаблицаДокументов.ВСД.GUID_Меркурий КАК GUID_Меркурий,
		|	ТаблицаДокументов.ВСД.Представление КАК ПредставлениеДокумента
		|ИЗ
		|	ТаблицаДокументов КАК ТаблицаДокументов
		|ГДЕ
		|	ТаблицаДокументов.ВСД.ТипВСД <> ЗНАЧЕНИЕ(Справочник.ТипыВСД.ПроизводственныйВСД)
		|	И ТаблицаДокументов.ВСД.ТипДокумента <> ЗНАЧЕНИЕ(Справочник.ТипыДокументов.БумажныйДокумент)";
		
	РезультатЗапроса = Запрос.Выполнить();
	
	АдресаПечатныхФорм = Новый Соответствие;
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		АдресПечатнойФормы = ИнтеграцияВетисAPIОбработкаПартий.ПолучитьФайлВетСправки(Выборка.ВСД);
		СтрокаСообщенияОбОшибке = НСтр("ru = 'Ошибка получения файла для документа: %1. %2'");
		Если АдресПечатнойФормы = Неопределено Тогда
			СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщенияОбОшибке, Выборка.ПредставлениеДокумента);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщенияОбОшибке);
		ИначеЕсли АдресПечатнойФормы.Свойство("СообщениеОбОшибке") Тогда
			СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщенияОбОшибке, Выборка.ПредставлениеДокумента, АдресПечатнойФормы.СообщениеОбОшибке);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщенияОбОшибке);
		Иначе
			АдресаПечатныхФорм.Вставить("ВСД " + Выборка.GUID_Меркурий, АдресПечатнойФормы.Путь);
		КонецЕсли;
	КонецЦикла;
	
	Возврат АдресаПечатныхФорм;
КонецФункции

Функция СформироватьПечатнуюФормуСжатогоВСДСИнформацией(МассивДокументов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВСД_СжатоеСИнформацией";
	УстановитьПараметрыТабличногоДокумента(ТабличныйДокумент);
	
	ТипОбъекта = ОбщегоНазначения.ИмяТаблицыПоСсылке(МассивДокументов[0]);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТТаблицаДокументов(Запрос.МенеджерВременныхТаблиц, ТипОбъекта, МассивДокументов);
	
	// Имена полей в запросе должны совпадать с именами Коллекции реквизитов документа для разбивки страниц
	// см. модуль менеджера РегистрСведений.НастройкиПечатиОбъектов Функция КоллекцияРеквизитовДокументаДляРазбивкиСтраниц()
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаДокументов.Ссылка КАК Ссылка,
		|	ТаблицаДокументов.ВСД КАК ВСД,
		|	ТаблицаДокументов.ВСД.GUID_Меркурий КАК GUID_Меркурий,
		|	ТаблицаДокументов.ВСД.Организация КАК Организация,
		|	ТаблицаДокументов.ВСД.ФормаВСД КАК ФормаВСД,
		|	ТаблицаДокументов.ВСД.Номер КАК НомерВСД,
		|	ТаблицаДокументов.ВСД.Дата КАК Дата,
		|	ТаблицаДокументов.ВСД.КонтрагентОтправитель КАК КонтрагентОтправитель,
		|	ТаблицаДокументов.ВСД.КонтрагентОтправитель.ПолноеНаименование КАК КонтрагентОтправительНаименование,
		|	ТаблицаДокументов.ВСД.КонтрагентОтправитель.ИНН КАК КонтрагентОтправительИНН,
		|	ТаблицаДокументов.ВСД.КонтрагентПолучатель КАК КонтрагентПолучатель,
		|	ТаблицаДокументов.ВСД.КонтрагентПолучатель.ПолноеНаименование КАК КонтрагентПолучательНаименование,
		|	ТаблицаДокументов.ВСД.КонтрагентПолучатель.ИНН КАК КонтрагентПолучательИНН,
		|	ТаблицаДокументов.ВСД.ПредприятиеОтправитель КАК ПредприятиеОтправитель,
		|	ТаблицаДокументов.ВСД.ПредприятиеПолучатель КАК ПредприятиеПолучатель,
		|	ТаблицаДокументов.ВСД.ПредприятиеПолучатель.Наименование КАК ПредприятиеПолучательНаименование,
		|	ТаблицаДокументов.ВСД.Продукция.НаименованиеПолное КАК Продукция,
		|	ТаблицаДокументов.ВСД.СкоропортящаясяПродукция КАК СкоропортящаясяПродукция,
		|	ТаблицаДокументов.ВСД.ФорматДатыВыработки КАК ФорматДатыВыработки,
		|	ТаблицаДокументов.ВСД.ДатаВыработкиНачало КАК ДатаВыработкиНачало,
		|	ТаблицаДокументов.ВСД.ДатаВыработкиОкончание КАК ДатаВыработкиОкончание,
		|	ТаблицаДокументов.ВСД.ДатаВыработкиСтрокой КАК ДатаВыработкиСтрокой,
		|	ТаблицаДокументов.ВСД.ТипТТН КАК ТипТТН,
		|	ТаблицаДокументов.ВСД.ДатаТТН КАК ДатаТТН,
		|	ТаблицаДокументов.ВСД.НомерТТН КАК НомерТТН,
		|	ТаблицаДокументов.ВСД.Транспорт КАК Транспорт,
		|	ТаблицаДокументов.ВСД.Количество КАК Количество,
		|	ТаблицаДокументов.ВСД.ЕдиницаИзмерения.НаименованиеПолное КАК ЕдИзм,
		|	КонтактнаяИнформация.Адрес КАК Адрес,
		|	СтатусыВСДСрезПоследних.СтатусВСД.ИмяПредопределенныхДанных КАК СтатусВСД
		|ИЗ
		|	ТаблицаДокументов КАК ТаблицаДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыВСД.СрезПоследних КАК СтатусыВСДСрезПоследних
		|		ПО ТаблицаДокументов.ВСД = СтатусыВСДСрезПоследних.ВСД
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			КИПредприятия.Ссылка КАК Ссылка,
		|			МАКСИМУМ(КИПредприятия.Представление) КАК Адрес
		|		ИЗ
		|			Справочник.Предприятия.КонтактнаяИнформация КАК КИПредприятия
		|		ГДЕ
		|			КИПредприятия.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|			И КИПредприятия.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресПредприятия)
		|		
		|		СГРУППИРОВАТЬ ПО
		|			КИПредприятия.Ссылка) КАК КонтактнаяИнформация
		|		ПО ТаблицаДокументов.ВСД.ПредприятиеПолучатель = КонтактнаяИнформация.Ссылка
		|ГДЕ
		|	ТаблицаДокументов.ВСД.ТипВСД <> ЗНАЧЕНИЕ(Справочник.ТипыВСД.ПроизводственныйВСД)
		|	И ТаблицаДокументов.ВСД.ТипДокумента <> ЗНАЧЕНИЕ(Справочник.ТипыДокументов.БумажныйДокумент)";
	
	МаксимальныйУровеньДерева = УточнитьТекстЗапросаСУчетомНастроекПечати(ТекстЗапроса, ТипОбъекта);
	
	ТекстЗапроса = ТекстЗапроса + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВСДПроизводителиПродукции.Ссылка КАК ВСД,
		|	ВСДПроизводителиПродукции.Ссылка.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ВСДПроизводителиПродукции.Производитель) = ТИП(Справочник.Предприятия)
		|			ТОГДА ВСДПроизводителиПродукции.Производитель.Наименование
		|		ИНАЧЕ ВСДПроизводителиПродукции.Производитель
		|	КОНЕЦ КАК Производитель,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(ВСДПроизводителиПродукции.Производитель) = ТИП(Справочник.Предприятия)
		|			ТОГДА КонтактнаяИнформаци.Адрес
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК АдресПроизводителя
		|ИЗ
		|	Документ.ВСД.ПроизводителиПродукции КАК ВСДПроизводителиПродукции
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			КИПредприятия.Ссылка КАК Ссылка,
		|			МАКСИМУМ(КИПредприятия.Представление) КАК Адрес
		|		ИЗ
		|			Справочник.Предприятия.КонтактнаяИнформация КАК КИПредприятия
		|		ГДЕ
		|			КИПредприятия.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|			И КИПредприятия.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресПредприятия)
		|		
		|		СГРУППИРОВАТЬ ПО
		|			КИПредприятия.Ссылка) КАК КонтактнаяИнформаци
		|		ПО (КонтактнаяИнформаци.Ссылка = ВСДПроизводителиПродукции.Производитель)
		|ГДЕ
		|	ВСДПроизводителиПродукции.Ссылка В
		|			(ВЫБРАТЬ
		|				ТаблицаДокументов.ВСД КАК ВСД
		|			ИЗ
		|				ТаблицаДокументов КАК ТаблицаДокументов
		|			ГДЕ
		|				ТаблицаДокументов.ВСД.ТипВСД <> ЗНАЧЕНИЕ(Справочник.ТипыВСД.ПроизводственныйВСД)
		|				И ТаблицаДокументов.ВСД.ТипДокумента <> ЗНАЧЕНИЕ(Справочник.ТипыДокументов.БумажныйДокумент))";
	
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивРезультатов      = Запрос.ВыполнитьПакет();
	ДанныеПечати 		   = МассивРезультатов[0].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ДанныеПоПроизводителям = МассивРезультатов[1].Выбрать();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВСД.ПФ_MXL_СжатаяСИнформацией");
	
	ОбластьДанных = Макет.ПолучитьОбласть("ДанныеВСД");
	
	Если МаксимальныйУровеньДерева < 0 Тогда
		
		ВывестиДанныеВСД(ДанныеПечати.Строки, Ложь, ДанныеПоПроизводителям, ТабличныйДокумент, ОбластьДанных, Истина);
		
	Иначе
		
		ОбойтиДеревоДанныхПечати(ДанныеПечати.Строки, Ложь, ДанныеПоПроизводителям, МаксимальныйУровеньДерева, ТабличныйДокумент, ОбластьДанных, Истина);
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьПечатнуюФормуСжатогоВСД(МассивДокументов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВСД_Сжатое";
	УстановитьПараметрыТабличногоДокумента(ТабличныйДокумент);
	
	ТипОбъекта = ОбщегоНазначения.ИмяТаблицыПоСсылке(МассивДокументов[0]);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТТаблицаДокументов(Запрос.МенеджерВременныхТаблиц, ТипОбъекта, МассивДокументов);
	
	// Имена полей в запросе должны совпадать с именами Коллекции реквизитов документа для разбивки страниц
	// см. модуль менеджера РегистрСведений.НастройкиПечатиОбъектов Функция КоллекцияРеквизитовДокументаДляРазбивкиСтраниц()
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаДокументов.Ссылка КАК Ссылка,
		|	ТаблицаДокументов.ВСД КАК ВСД,
		|	ТаблицаДокументов.ВСД.GUID_Меркурий КАК GUID_Меркурий,
		|	ТаблицаДокументов.ВСД.Организация КАК Организация,
		|	ТаблицаДокументов.ВСД.КонтрагентОтправитель КАК КонтрагентОтправитель,
		|	ТаблицаДокументов.ВСД.ПредприятиеОтправитель КАК ПредприятиеОтправитель,
		|	ТаблицаДокументов.ВСД.КонтрагентПолучатель КАК КонтрагентПолучатель,
		|	ТаблицаДокументов.ВСД.ПредприятиеПолучатель КАК ПредприятиеПолучатель,
		|	ТаблицаДокументов.ВСД.ТипТТН КАК ТипТТН,
		|	ТаблицаДокументов.ВСД.НомерТТН КАК НомерТТН,
		|	ТаблицаДокументов.ВСД.ДатаТТН КАК ДатаТТН,
		|	ТаблицаДокументов.ВСД.Транспорт КАК Транспорт
		|ИЗ
		|	ТаблицаДокументов КАК ТаблицаДокументов
		|ГДЕ
		|	ТаблицаДокументов.ВСД.ТипВСД <> ЗНАЧЕНИЕ(Справочник.ТипыВСД.ПроизводственныйВСД)
		|	И ТаблицаДокументов.ВСД.ТипДокумента <> ЗНАЧЕНИЕ(Справочник.ТипыДокументов.БумажныйДокумент)";
	
	МаксимальныйУровеньДерева = УточнитьТекстЗапросаСУчетомНастроекПечати(ТекстЗапроса, ТипОбъекта);
	
	Запрос.Текст = ТекстЗапроса;
	
	ДанныеПечати = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВСД.ПФ_MXL_Сжатая");
	
	ОбластьДанных = Макет.ПолучитьОбласть("ДанныеВСД");
	
	Если МаксимальныйУровеньДерева < 0 Тогда
		
		ВывестиДанныеВСД(ДанныеПечати.Строки,,, ТабличныйДокумент, ОбластьДанных, Истина);
		
	Иначе
		
		ОбойтиДеревоДанныхПечати(ДанныеПечати.Строки,,, МаксимальныйУровеньДерева, ТабличныйДокумент, ОбластьДанных, Истина);
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
КонецФункции

Процедура УстановитьПараметрыТабличногоДокумента(ТабличныйДокумент)
	
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабличныйДокумент.ПолеСверху        	  = 3;
	ТабличныйДокумент.ПолеСнизу         	  = 3;
	ТабличныйДокумент.ПолеСправа        	  = 3;
	ТабличныйДокумент.ПолеСлева         	  = 3;
	ТабличныйДокумент.АвтоМасштаб       	  = Истина;
	
КонецПроцедуры

Функция ПолучтьМассивОбрабатываемыхДокументов(МассивДокументов)
	
	Если ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ТранспортныеОперации") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДТранспортнойОперации();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ПриходныеОперации") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДПриходныеОперации();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ПриходныеОперацииСводно") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДПриходныеОперацииСводно();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.АннулированиеВСД") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДАннулированиеВСД();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.АннулированиеВСДГрупповое") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДГрупповогоАннулированияВСД();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ВнесениеНомеровТранспортныхСредств") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредств();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	ИначеЕсли ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ВнесениеНомеровТранспортныхСредствГрупповое") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредствГрупповое();
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		МассивДокументовДляЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	Иначе
		МассивДокументовДляЗапроса = МассивДокументов;
	КонецЕсли;
	
	Возврат МассивДокументовДляЗапроса;
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДТранспортнойОперации()
	
	Возврат
	"ВЫБРАТЬ
	|	ТранспортныеОперацииТаблицаВСД.Ссылка КАК Ссылка,
	|	ТранспортныеОперацииТаблицаВСД.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.ТранспортныеОперации.ТаблицаВСД КАК ТранспортныеОперацииТаблицаВСД
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
	|		ПО ТранспортныеОперацииТаблицаВСД.Ссылка = ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка
	|ГДЕ
	|	ТранспортныеОперацииТаблицаВСД.Ссылка В(&МассивДокументов)
	|	И ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус = ЗНАЧЕНИЕ(Справочник.СтатусыЗаявок.УспешноОбработана)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДПриходныеОперации()
	
	Возврат
	"ВЫБРАТЬ
	|	ПриходныеОперации.Ссылка КАК Ссылка,
	|	ПриходныеОперации.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.ПриходныеОперации КАК ПриходныеОперации
	|ГДЕ
	|	ПриходныеОперации.Ссылка В(&МассивДокументов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриходныеОперации.Ссылка,
	|	ПриходныеОперации.ВСД_Возврат
	|ИЗ
	|	Документ.ПриходныеОперации КАК ПриходныеОперации
	|ГДЕ
	|	ПриходныеОперации.ВСД_Возврат <> ЗНАЧЕНИЕ(Документ.ВСД.ПустаяСсылка)
	|	И ПриходныеОперации.Ссылка В(&МассивДокументов)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДПриходныеОперацииСводно()
	
	Возврат
	"ВЫБРАТЬ
	|	ПриходныеОперацииСводноТаблицаДанных.Ссылка КАК Ссылка,
	|	ПриходныеОперацииСводноТаблицаДанных.ПриходнаяОперация КАК ПриходнаяОперация
	|ПОМЕСТИТЬ ПриходныеОперации
	|ИЗ
	|	Документ.ПриходныеОперацииСводно.ТаблицаДанных КАК ПриходныеОперацииСводноТаблицаДанных
	|ГДЕ
	|	ПриходныеОперацииСводноТаблицаДанных.Ссылка В(&МассивДокументов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриходныеОперации.ПриходнаяОперация.Ссылка КАК Ссылка,
	|	ПриходныеОперации.ПриходнаяОперация.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	ПриходныеОперации КАК ПриходныеОперации
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриходныеОперации.ПриходнаяОперация.Ссылка,
	|	ПриходныеОперации.ПриходнаяОперация.ВСД_Возврат
	|ИЗ
	|	ПриходныеОперации КАК ПриходныеОперации
	|ГДЕ
	|	ПриходныеОперации.ПриходнаяОперация.ВСД_Возврат <> ЗНАЧЕНИЕ(Документ.ВСД.ПустаяСсылка)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДАннулированиеВСД()
	
	Возврат
	"ВЫБРАТЬ
	|	АннулированиеВСД.Ссылка КАК Ссылка,
	|	АннулированиеВСД.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.АннулированиеВСД КАК АннулированиеВСД
	|ГДЕ
	|	АннулированиеВСД.Ссылка В(&МассивДокументов)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДГрупповогоАннулированияВСД()
	
	Возврат
	"ВЫБРАТЬ
	|	АннулированиеВСДГрупповоеСписокАннулируемыхВСД.Ссылка КАК Ссылка,
	|	АннулированиеВСДГрупповоеСписокАннулируемыхВСД.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.АннулированиеВСДГрупповое.СписокАннулируемыхВСД КАК АннулированиеВСДГрупповоеСписокАннулируемыхВСД
	|ГДЕ
	|	АннулированиеВСДГрупповоеСписокАннулируемыхВСД.Ссылка В(&МассивДокументов)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредств()
	
	Возврат
	"ВЫБРАТЬ
	|	ВнесениеНомеровТранспортныхСредств.Ссылка КАК Ссылка,
	|	ВнесениеНомеровТранспортныхСредств.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.ВнесениеНомеровТранспортныхСредств КАК ВнесениеНомеровТранспортныхСредств
	|ГДЕ
	|	ВнесениеНомеровТранспортныхСредств.Ссылка В(&МассивДокументов)";
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредствГрупповое()
	
	Возврат
	"ВЫБРАТЬ
	|	ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки.Ссылка КАК Ссылка,
	|	ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки.ВСД КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.ВнесениеНомеровТранспортныхСредствГрупповое.ТочкиПерегрузки КАК ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки
	|ГДЕ
	|	ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки.Ссылка В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки.Ссылка,
	|	ВнесениеНомеровТранспортныхСредствГрупповоеТочкиПерегрузки.ВСД";
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ВСД";
	КомандаПечати.Идентификатор = "ПолнаяИнформация";
	КомандаПечати.Представление = НСтр("ru = 'Ветеринарная справка (формат pdf)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматPDF;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюУВСКлиент.СформироватьПечатнуюФормуВетеринарнойСправки";
	КомандаПечати.Порядок = 1;
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"ТипВСД",Справочники.ТипыВСД.ПроизводственныйВСД,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюУВСКлиент.НастройкаПечатиДокументов";
	КомандаПечати.МенеджерПечати = "";
	КомандаПечати.Идентификатор = "НастройкаПечатиДокументов";
	КомандаПечати.Представление = НСтр("ru = 'Настройка печати документов'");
	КомандаПечати.СписокФорм = "ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 2;
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"ТипВСД",Справочники.ТипыВСД.ПроизводственныйВСД,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ВСД";
	КомандаПечати.Идентификатор = "СжатоеСИнформацией";
	КомандаПечати.Представление = НСтр("ru = 'Штрих-коды ВСД с дополнительной информацией'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматMXL;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 3;
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"ТипВСД",Справочники.ТипыВСД.ПроизводственныйВСД,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ВСД";
	КомандаПечати.Идентификатор = "Сжатое";
	КомандаПечати.Представление = НСтр("ru = 'Штрих-коды ВСД'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматMXL;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 4;
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"ТипВСД",Справочники.ТипыВСД.ПроизводственныйВСД,ВидСравнения.НеРавно);
	УправлениеПечатью.ДобавитьУсловиеВидимостиКоманды(КомандаПечати,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	
КонецПроцедуры

Функция УточнитьТекстЗапросаСУчетомНастроекПечати(ТекстЗапроса, ТипОбъекта)
	
	ПараметрыПечатиОбъекта = РегистрыСведений.НастройкиПечатиОбъектов.ПараметрыПечатиОбъекта(ТипОбъекта, Пользователи.ТекущийПользователь());
	
	РеквизитыРазбивкиСтраниц = Новый Массив;
	
	Если ПараметрыПечатиОбъекта.ВариантРазбивкиДокументовНаСтраницы = "КаждыйДокументОтдельно" Тогда
		РеквизитыРазбивкиСтраниц.Добавить("Ссылка");
	ИначеЕсли ПараметрыПечатиОбъекта.ВариантРазбивкиДокументовНаСтраницы = "Настраиваемый" Тогда
		НастройкиРазбивкиСтраниц = ПараметрыПечатиОбъекта.Настройки.Получить();
		Для Каждого РеквизитРазбивкиСтраниц Из НастройкиРазбивкиСтраниц Цикл
			Если РеквизитРазбивкиСтраниц.Пометка Тогда
				РеквизитыРазбивкиСтраниц.Добавить(РеквизитРазбивкиСтраниц.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МаксимальныйИндекс = РеквизитыРазбивкиСтраниц.Количество() - 1;
	
	Если МаксимальныйИндекс >= 0 Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
			|ИТОГИ ПО";
		
		Для Индекс = 0 По МаксимальныйИндекс Цикл
			
			ТекстЗапроса = ТекстЗапроса + "
				|	" + РеквизитыРазбивкиСтраниц[Индекс] + ?(Индекс = МаксимальныйИндекс, "", ",");
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МаксимальныйИндекс;
КонецФункции

Процедура ОбойтиДеревоДанныхПечати(СтрокиПечати,
									КраткийВСД = Истина,
									ДанныеПоПроизводителям = Неопределено,
									МаксимальныйУровеньДерева,
									ТабличныйДокумент,
									ОбластьДанных,
									ПервыйДокумент)
	
	Для Каждого СтрокаДерева Из СтрокиПечати Цикл
		
		Если СтрокаДерева.Уровень() = МаксимальныйУровеньДерева Тогда
			ВывестиДанныеВСД(СтрокаДерева.Строки, КраткийВСД, ДанныеПоПроизводителям, ТабличныйДокумент, ОбластьДанных, ПервыйДокумент);
		Иначе
			ОбойтиДеревоДанныхПечати(СтрокаДерева.Строки, КраткийВСД, ДанныеПоПроизводителям, МаксимальныйУровеньДерева, ТабличныйДокумент, ОбластьДанных, ПервыйДокумент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВывестиДанныеВСД(СтрокиВСД, КраткийВСД = Истина, ДанныеПоПроизводителям = Неопределено, ТабличныйДокумент, ОбластьДанных, ПервыйДокумент = Истина)
	
	Если Не ПервыйДокумент Тогда
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	ПервыйДокумент = Ложь;
	
	Если КраткийВСД Тогда
		
		Сч = 0;
		Для Каждого СтрокаВСД Из СтрокиВСД Цикл
			
			Сч = Сч + 1;
			
			ВывестиQRКодВСД(СтрокаВСД.GUID_Меркурий, ОбластьДанных);
			
			Если Сч = 1 Тогда
				Если Не ТабличныйДокумент.ПроверитьВывод(ОбластьДанных) Тогда
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				ТабличныйДокумент.Вывести(ОбластьДанных);
			Иначе
				ТабличныйДокумент.Присоединить(ОбластьДанных);
			КонецЕсли;
			
			Если Сч = 3 Тогда
				Сч = 0;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Для Каждого СтрокаВСД Из СтрокиВСД Цикл
			
			ВывестиQRКодВСД(СтрокаВСД.GUID_Меркурий, ОбластьДанных);
			
			ОбластьДанных.Параметры.Заполнить(СтрокаВСД);
			
			ОбластьДанных.Параметры.ДатаВСД = Формат(СтрокаВСД.Дата, "ДФ='dd.MM.yyyy ''г.'''");
			
			СтрокаТТН = "";
			Если ЗначениеЗаполнено(СтрокаВСД.НомерТТН) Тогда
				СтрокаТТН = ", ТТН: № " + СтрокаВСД.НомерТТН + " от " + Формат(СтрокаВСД.ДатаТТН, "ДФ='dd.MM.yy ''г'''");
			КонецЕсли;
			ОбластьДанных.Параметры.ТТН = СтрокаТТН;
			
			СтрокаПредприятие = СтрокаВСД.ПредприятиеПолучательНаименование;
			Если ЗначениеЗаполнено(СтрокаВСД.Адрес) Тогда
				СтрокаПредприятие = СтрокаПредприятие + " (" + СтрокаВСД.Адрес + ")";
			КонецЕсли;
			ОбластьДанных.Параметры.Предприятие = СтрокаПредприятие;
			
			СтруктураДанныхВыработки = Новый Структура("ФорматДатыВыработки, СкоропортящаясяПродукция,
				|ДатаВыработкиНачало, ДатаВыработкиОкончание, ДатаВыработкиСтрокой");
			ЗаполнитьЗначенияСвойств(СтруктураДанныхВыработки, СтрокаВСД);
			
			СтрокаДатВыработки = "";
			СтрокаДатВыработки = ИнтеграцияВетисAPIКлиентСервер.СформироватьПредставлениеДатыВыработки(СтруктураДанныхВыработки);
			ОбластьДанных.Параметры.ДатыВыработки = СтрокаДатВыработки;
			
			СтрокаПроизводители = "";
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ВСД", СтрокаВСД.ВСД);
			Пока ДанныеПоПроизводителям.НайтиСледующий(ПараметрыОтбора) Цикл
				СтрокаПроизводители = ", " + СтрокаПроизводители + ДанныеПоПроизводителям.Производитель;
				Если ЗначениеЗаполнено(ДанныеПоПроизводителям.АдресПроизводителя) Тогда
					СтрокаПроизводители = СтрокаПроизводители + " (" + ДанныеПоПроизводителям.АдресПроизводителя + ")";
				КонецЕсли;
			КонецЦикла;
			ОбластьДанных.Параметры.Производитель = СтрокаПроизводители;
			
			Если Не ТабличныйДокумент.ПроверитьВывод(ОбластьДанных) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьДанных);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьВТТаблицаДокументов(МенеджерВременныхТаблиц, ТипОбъекта, МассивДокументов)
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапросаПоТипуОбъекта(ТипОбъекта);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ТекстЗапросаПоТипуОбъекта(ТипОбъекта)
	
	Если ТипОбъекта = "Документ.ТранспортныеОперации" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДТранспортнойОперации();
		
	ИначеЕсли ТипОбъекта = "Документ.ПриходныеОперации" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДПриходныеОперации();
		
	ИначеЕсли ТипОбъекта = "Документ.ПриходныеОперацииСводно" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДПриходныеОперацииСводно();
		
	ИначеЕсли ТипОбъекта = "Документ.АннулированиеВСД" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДАннулированиеВСД();
		
	ИначеЕсли ТипОбъекта = "Документ.АннулированиеВСДГрупповое" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДГрупповогоАннулированияВСД();
		
	ИначеЕсли ТипОбъекта = "Документ.ВнесениеНомеровТранспортныхСредств" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредств();
		
	ИначеЕсли ТипОбъекта = "Документ.ВнесениеНомеровТранспортныхСредствГрупповое" Тогда
		
		Возврат ТекстЗапросаПолученияСпискаВСДВнесениеНомеровТранспортныхСредствГрупповое();
		
	Иначе
		
		Возврат ТекстЗапросаПолученияСпискаВСД();
		
	КонецЕсли;
	
КонецФункции

Функция ТекстЗапросаПолученияСпискаВСД()
	
	Возврат
	"ВЫБРАТЬ
	|	ВСД.Ссылка КАК Ссылка,
	|	ВСД.Ссылка КАК ВСД
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.ВСД КАК ВСД
	|ГДЕ
	|	ВСД.Ссылка В(&МассивДокументов)";
	
КонецФункции

Процедура ВывестиQRКодВСД(ИдентификаторВСД, ОбластьПечати)
	
	СсылкаДляФормированияQRКода = ИнтеграцияВетисAPIОбработкаПартий.ПолучитьПутьПроверкиВСД(ИдентификаторВСД);
	Если СсылкаДляФормированияQRКода <> "" Тогда
		ДанныеQRКода = УправлениеПечатью.ДанныеQRКода(СсылкаДляФормированияQRКода, 0, 148);
		Если ДанныеQRКода <> Неопределено Тогда
			КартникаQRКода = Новый Картинка(ДанныеQRКода);
			ОбластьПечати.Рисунки.ПолеQRCode.Картинка = КартникаQRКода;
		КонецЕсли;
	КонецЕсли;
	
	Код = ПреобразоватьGUID(ИдентификаторВСД);
	ОбластьПечати.Параметры.Код = Код;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Монопольный обработчик обновления 2.0.5.1
// Заполняет реквизит ""Формат срока годности"", а так же проверяет корректность заполнения реквизита ""Формат даты выработки""
Процедура ЗаполнитьФорматыДатПродукции() Экспорт
	
	ОбработаныВсеВСД = Ложь;
	
	Пока Не ОбработаныВсеВСД Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1000
			|	СтатусыВСДСрезПоследних.ВСД КАК Ссылка
			|ИЗ
			|	РегистрСведений.СтатусыВСД.СрезПоследних КАК СтатусыВСДСрезПоследних
			|ГДЕ
			|	СтатусыВСДСрезПоследних.СтатусВСД = ЗНАЧЕНИЕ(Справочник.СтатусыВСД.Оформлен)
			|	И СтатусыВСДСрезПоследних.ВСД.ФорматСрокаГодности = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияДаты.ПустаяСсылка)";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СвойстваПараметровДат = ОбновлениеИнформационнойБазыУВС.СвойстваПараметровДат();
			ЗаполнитьЗначенияСвойств(СвойстваПараметровДат, Выборка.Ссылка);
			
			ВСДОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ОбновлениеИнформационнойБазыУВС.УстановитьЗначенияФорматовДатОбъекта(ВСДОбъект, СвойстваПараметровДат);
			
			Попытка
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВСДОбъект);
			Исключение
				ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстИсключения = НСтр("ru = 'Не удалось выполнить обновление форматов дат по причине: %ПредставлениеОшибки%.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПредставлениеОшибки%", ПредставлениеОшибки);
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Документы.ВСД,
					Выборка.Ссылка,
					ТекстИсключения);
			КонецПопытки;
			
		КонецЦикла;
			
		КоличествоСсылок = Выборка.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОбработаныВсеВСД = Истина;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Регистрирует данные для обработчика обновления 2.0.5.1
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДокументыВСД.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ВСД КАК ДокументыВСД
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыВСД.СрезПоследних КАК СтатусыВСДСрезПоследних
		|		ПО ДокументыВСД.Ссылка = СтатусыВСДСрезПоследних.ВСД
		|ГДЕ
		|	СтатусыВСДСрезПоследних.СтатусВСД <> ЗНАЧЕНИЕ(Справочник.СтатусыВСД.Оформлен)
		|	И ДокументыВСД.ФорматСрокаГодности = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияДаты.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокументыВСД.Дата УБЫВ";
		
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.ВСД";
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ВСДОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ВСДОбъект = Неопределено Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			
			СвойстваПараметровДат = ОбновлениеИнформационнойБазыУВС.СвойстваПараметровДат();
			ЗаполнитьЗначенияСвойств(СвойстваПараметровДат, Выборка.Ссылка);
			
			ОбновлениеИнформационнойБазыУВС.УстановитьЗначенияФорматовДатОбъекта(ВСДОбъект, СвойстваПараметровДат);
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВСДОбъект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУВС.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает GUID ВСД в отформатированном виде
//
// Параметры;
//	ВСД_GUID - строка - GUID ВСД
//
// Возвращаемое значение:
//	ФорматВСД_GUID - строка - преобразовыванный GUID ВСД в формат (0000-0000-0000-0000-0000-0000-0000-0000-0000)
//
Функция ПреобразоватьGUID(ВСД_GUID)
		
	Если ВСД_GUID = "" Тогда
		Возврат "";
	КонецЕсли;
		
	ИсходнаяСрока = СтрЗаменить(ВСД_GUID, "-", "");
	
	ФорматВСД_GUID = "";
	НачальныйНомер = 1;
	Для Сч = 1 По 8 Цикл
		ФорматВСД_GUID = ФорматВСД_GUID + Сред(ИсходнаяСрока, НачальныйНомер, 4) + ?(Сч < 8, "-", "");
		НачальныйНомер = НачальныйНомер + 4;
	КонецЦикла;
	
	Возврат ВРег(ФорматВСД_GUID);
КонецФункции

Процедура ОформитьНаСервере(Ссылка) Экспорт

	НачатьТранзакцию();
	Попытка
		ДокументОбъект = Ссылка.ПолучитьОбъект();
		ДокументОбъект.ПометкаУдаления = Ложь;
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПроведениеДоступно"        , Истина);
		ДокументОбъект.ДополнительныеСвойства.Вставить("ИгнорироватьКонтрольЗаписи", Истина);
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		ТекущаяДата = ТекущаяДата();
		НаборЗаписей = РегистрыСведений.СтатусыВСД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВСД.Установить(Ссылка);
		НаборЗаписей.Отбор.Период.Установить(Ссылка.Дата);
		
		Запись = НаборЗаписей.Добавить();
		Запись.Период        = Ссылка.Дата;
		Запись.ВСД           = Ссылка;
		Запись.Ответственный = Ссылка.ВыдавшийВСД;
		Запись.СтатусВСД     = Справочники.СтатусыВСД.Оформлен;
		
		НаборЗаписей.ДополнительныеСвойства.Вставить("ИгнорироватьКонтрольЗаписи", Истина);
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ЗаписьЖурналаРегистрации(
			"Ошибка при проведении документа",
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ОписаниеОшибки(),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		ОтменитьТранзакцию();
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	КомандаСоздания = Документы.АннулированиеВСД.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если КомандаСоздания <> Неопределено Тогда
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"ВидВСД",Перечисления.ВидыВСД.Входящий,ВидСравнения.НеРавно);
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"ВидВСД",Перечисления.ВидыВСД.Производственный,ВидСравнения.НеРавно);
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	
	КомандаСоздания = Документы.ВнесениеНомеровТранспортныхСредств.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если КомандаСоздания <> Неопределено Тогда
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"ВидВСД",Перечисления.ВидыВСД.Производственный,ВидСравнения.НеРавно);
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"GUID_Меркурий","",ВидСравненияКомпоновкиДанных.Заполнено);
	КонецЕсли;
	
	КомандаСоздания = Документы.ПриходныеОперации.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если КомандаСоздания <> Неопределено Тогда
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"ВидВСД",Перечисления.ВидыВСД.Производственный,ВидСравнения.НеРавно);
	КонецЕсли;
	
	КомандаСоздания = Документы.ПриходныеОперации.ДобавитьКомандуСоздатьНаОснованииУполномоченноеГашение(КомандыСозданияНаОсновании);
	Если КомандаСоздания <> Неопределено Тогда
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаСоздания,"ВидВСД",Перечисления.ВидыВСД.Исходящий,ВидСравнения.Равно);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли