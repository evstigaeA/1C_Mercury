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
	
	Возврат Результат;
	
КонецФункции

// Добавляет команду создания документа "Внесение номеров транспортных средств".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВнесениеНомеровТранспортныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВнесениеНомеровТранспортныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.ИзменяетВыбранныеОбъекты = Ложь;
		КомандаСоздатьНаОсновании.Представление = ИнтеграцияВетисAPIСервер.ПредставлениеОбъекта(Метаданные.Документы.ВнесениеНомеровТранспортныхСредств);
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
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
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюУВСКлиент.СформироватьПечатнуюФормуВетеринарнойСправки";
	КомандаПечати.Порядок = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "";
	КомандаПечати.Идентификатор = "НастройкаПечатиДокументов";
	КомандаПечати.Представление = НСтр("ru = 'Настройка печати документов'");
	КомандаПечати.СписокФорм = "ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Обработчик = "УправлениеПечатьюУВСКлиент.НастройкаПечатиДокументов";
	КомандаПечати.Порядок = 2;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ВнесениеНомеровТранспортныхСредств";
	КомандаПечати.Идентификатор = "СжатоеСИнформацией";
	КомандаПечати.Представление = НСтр("ru = 'Штрих-коды ВСД с дополнительной информацией'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматMXL;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 3;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ВнесениеНомеровТранспортныхСредств";
	КомандаПечати.Идентификатор = "Сжатое";
	КомандаПечати.Представление = НСтр("ru = 'Штрих-коды ВСД'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ФорматMXL;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 4;
	
КонецПроцедуры

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
	        "СжатоеСИнформацией", "Штрих-коды ВСД с дополнительной информацией", Документы.ВСД.СформироватьПечатнуюФормуСжатогоВСДСИнформацией(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Сжатое") Тогда
	    // Формируем табличный документ и добавляем его в коллекцию печатных форм.
	    УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	        "Сжатое", "Штрих-коды ВСД", Документы.ВСД.СформироватьПечатнуюФормуСжатогоВСД(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;

КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает статус документа "ВнесениеНомеровТранспортныхСредствГрупповое" в зависимости от того,
// сколько операций внесения номеров успешно обработано.
// Вызывается перед установкой статуса УспешноОбработана операции внесения номеров,
// т.о., как минимум одна операция из группового документа "УспешноОбработана", но статус ей еще не присвоен
Процедура УстановитьСтатусыСводныхДокументов(СсылкаНаДокумент) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВнесениеНомеровТочкиПерегрузки.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТ_СводныеДокументы
		|ИЗ
		|	Документ.ВнесениеНомеровТранспортныхСредствГрупповое.ТочкиПерегрузки КАК ВнесениеНомеровТочкиПерегрузки
		|ГДЕ
		|	ВнесениеНомеровТочкиПерегрузки.ДокументВнесения = &ДокументВнесения
		|	И ВнесениеНомеровТочкиПерегрузки.Ссылка.Проведен = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка) КАК Количество,
		|	ВнесениеНомеровТочкиПерегрузки.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ВнесениеНомеровТранспортныхСредствГрупповое.ТочкиПерегрузки КАК ВнесениеНомеровТочкиПерегрузки
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка КАК ДокументСсылка
		|		ИЗ
		|			РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|		ГДЕ
		|			ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус <> &Статус) КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|		ПО ВнесениеНомеровТочкиПерегрузки.ДокументВнесения = ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ВнесениеНомеровТочкиПерегрузки.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТ_СводныеДокументы.Ссылка
		|			ИЗ
		|				ВТ_СводныеДокументы КАК ВТ_СводныеДокументы)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВнесениеНомеровТочкиПерегрузки.Ссылка";
	
	Запрос.УстановитьПараметр("ДокументВнесения", СсылкаНаДокумент);
	Запрос.УстановитьПараметр("Статус", Справочники.СтатусыЗаявок.УспешноОбработана);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		СсылкиНаДокументы = РезультатЗапроса.Выгрузить();
		Для Каждого СводныйДокумент Из СсылкиНаДокументы Цикл
			Если СводныйДокумент.Количество = 1 Тогда
				ОбъектГрупповойОперации = СводныйДокумент.Ссылка.ПолучитьОбъект();
				ОбъектГрупповойОперации.Статус = Перечисления.СтатусыСводныхДокументов.УспешноПогашено;
					Попытка
						ОбъектГрупповойОперации.Записать(РежимЗаписиДокумента.Запись);
					Исключение
					КонецПопытки;
			ИначеЕсли СводныйДокумент.Ссылка.Статус = Перечисления.СтатусыСводныхДокументов.Новая Тогда
				ОбъектГрупповойОперации = СводныйДокумент.Ссылка.ПолучитьОбъект();
				ОбъектГрупповойОперации.Статус = Перечисления.СтатусыСводныхДокументов.ЧастичноПогашено;
				Попытка
					ОбъектГрупповойОперации.Записать(РежимЗаписиДокумента.Запись);
				Исключение
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#КонецЕсли