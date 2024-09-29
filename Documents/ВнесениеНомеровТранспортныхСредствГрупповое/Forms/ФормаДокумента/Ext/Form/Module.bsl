﻿
#Область ОписаниеПеременных

// СтандартныеПодсистемы.ОценкаПроизводительности
&НаКлиенте
Перем ИдентификаторЗамераПроведение, ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Объект.Проведен И Объект.Статус = Перечисления.СтатусыСводныхДокументов.УспешноПогашено Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Статус = Перечисления.СтатусыСводныхДокументов.Новая;
	КонецЕсли;
	
	ЗаполнитьДеревоПунктовПерегрузки();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.ТочкиПерегрузки.Очистить();
	
	Для Каждого ТекВСД Из ВСДИТочкиПерегрузки.ПолучитьЭлементы() Цикл
		
		Для Каждого ТекДанные Из ТекВСД.ПолучитьЭлементы() Цикл
			
			НоваяСтрока = Объект.ТочкиПерегрузки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекДанные);
			НоваяСтрока.ВСД              = ТекВСД.ВСДПункт;
			НоваяСтрока.НазваниеПункта   = ТекДанные.ВСДПункт;
			НоваяСтрока.ДокументВнесения = ТекВСД.ДокументВнесения;
			
		КонецЦикла;
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если Не Объект.Проведен И ВопросБылЗадан = Ложь Тогда
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПроведение", ЭтаФорма, Параметры);
			ПоказатьВопрос(Оповещение, "Документы внесения номеров ТС будут подготовлены к отправке в ИС ""Меркурий""." + Символы.ПС + "Продолжить?", РежимДиалогаВопрос.ДаНет, 0);
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПроведениеДокументаОшибка");
		ОценкаПроизводительностиКлиент.УстановитьПризнакОшибкиЗамера(ИдентификаторЗамераПроведение, Истина);
		
		ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, "ПроведениеДокумента");
		ОценкаПроизводительностиКлиент.УстановитьПризнакОшибкиЗамера(ИдентификаторЗамераПроведение, Ложь);
		
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки, "ПроведениеДокументаНеНужнаРегистрацияОшибки");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
		МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_Органиазация

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Контрагент = ОбщегоНазначенияУВСВызовСервера.КонтрагентПоОрганизации(Объект.Организация);
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_Предприятие

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеПриИзменении(Объект.Контрагент, Объект.Предприятие);
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеНачалоВыбора(Элемент, СтандартнаяОбработка, Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВСДИТочкиПерегрузкиВСДПунктОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВСДИТочкиПерегрузкиДокументВнесенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВСДИТочкиПерегрузкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВСДИТочкиПерегрузкиПередУдалением(Элемент, Отказ)
	
	МассивЗапрещенныхСтатусов = ОбщегоНазначенияУВСВызовСервера.МассивСтатусовСЗапретомРедактированияФормы();
	
	ВыделенныеСтроки = Элемент.ВыделенныеСтроки;
	
	Пока ВыделенныеСтроки.Количество() > 0 Цикл
		
		ВыделеннаяСтрока = ВыделенныеСтроки[0];
		
		ЭлементПункт = ВСДИТочкиПерегрузки.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если ЭлементПункт = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		РодительЭлементаПункта = ЭлементПункт.ПолучитьРодителя();
		Если РодительЭлементаПункта <> Неопределено Тогда
			
			Если МассивЗапрещенныхСтатусов.Найти(РодительЭлементаПункта.СтатусЗаявки) <> Неопределено Тогда
				ВыделенныеСтроки.Удалить(0);
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
			
			КоличествоПодчиненныхСтрок = РодительЭлементаПункта.ПолучитьЭлементы().Количество();
			Если КоличествоПодчиненныхСтрок = 1 Тогда
				
				ВСДИТочкиПерегрузки.ПолучитьЭлементы().Удалить(РодительЭлементаПункта);
				
			Иначе
				
				РодительЭлементаПункта.ПолучитьЭлементы().Удалить(ЭлементПункт);
				
			КонецЕсли;
			
		Иначе
			
			Если МассивЗапрещенныхСтатусов.Найти(ЭлементПункт.СтатусЗаявки) <> Неопределено Тогда
				ВыделенныеСтроки.Удалить(0);
				Отказ = Истина;
				Продолжить;
			КонецЕсли;
			
			ВСДИТочкиПерегрузки.ПолучитьЭлементы().Удалить(ЭлементПункт);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	
	Для Каждого ТекЭлемент Из ВСДИТочкиПерегрузки.ПолучитьЭлементы() Цикл
		Элементы.ВСДИТочкиПерегрузки.Свернуть(ТекЭлемент.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)
	
	Для Каждого ТекЭлемент Из ВСДИТочкиПерегрузки.ПолучитьЭлементы() Цикл
		Элементы.ВСДИТочкиПерегрузки.Развернуть(ТекЭлемент.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВСД(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Организация" , Объект.Организация);
	ПараметрыОтбора.Вставить("НеуказаноТС" , Истина);
	ПараметрыОтбора.Вставить("ТипДокумента", ПредопределенноеЗначение("Справочник.ТипыДокументов.ЭлектронныйДокумент"));
	
	ПараметрыФормы = ПараметрыОткрытияФормыПодбора();
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Документ.ВСД.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ВыполнитьПослеВыбораВСД", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТранспортныхОпераций(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	ПараметрыОтбора.Вставить("Статус"     , ПредопределенноеЗначение("Справочник.СтатусыЗаявок.УспешноОбработана"));
	
	ПараметрыФормы = ПараметрыОткрытияФормыПодбора();
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Документ.ТранспортныеОперации.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ВыполнитьПослеВыбораТранспортнойОперации", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПриходныхОперацийСводно(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Организация", Объект.Организация);
	
	ПараметрыФормы = ПараметрыОткрытияФормыПодбора();
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Документ.ПриходныеОперацииСводно.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ВыполнитьПослеВыбораПриходныхОперацийСводно", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументыВнесения(Команда)
	
	Если ВСДИТочкиПерегрузки.ПолучитьЭлементы().Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выполнение операции невозможно, т.к. список документов пуст.'"));
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		СоздатьДокументыВнесенияНомеровТС();
		Возврат
	КонецЕсли;
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("СформироватьДокументыВнесенияЗавершение", ЭтотОбъект), НСтр("ru = 'Будут созданы документы внесения номеров транспортных средств. Продолжить?'"), Режим, 0);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
		МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
		МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыОткрытияФормыПодбора()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора"           , Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор"    , Истина);
	ПараметрыФормы.Вставить("ПредприятиеОтправитель", Объект.Предприятие);
	ПараметрыФормы.Вставить("ПредприятиеПолучатель" , Объект.Предприятие);
	
	Возврат ПараметрыФормы;
КонецФункции

&НаКлиенте
Процедура ПриИзмененииРеквизита()
	
	Объект.ТочкиПерегрузки.Очистить();
	ВСДИТочкиПерегрузки.ПолучитьЭлементы().Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПунктовПерегрузки()
	
	ВСДИТочкиПерегрузки.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.ВСД,
		|	Таблица.ИдентификаторТочкиМаршрута,
		|	Таблица.НазваниеПункта,
		|	Таблица.ТипТранспорта,
		|	Таблица.Транспорт,
		|	Таблица.ДокументВнесения
		|ПОМЕСТИТЬ ТаблицаРесурс
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаРесурс.ВСД КАК ВСД,
		|	ТаблицаРесурс.ИдентификаторТочкиМаршрута,
		|	ТаблицаРесурс.НазваниеПункта КАК НазваниеПункта,
		|	ТаблицаРесурс.ТипТранспорта КАК ТипТранспорта,
		|	ТаблицаРесурс.Транспорт КАК Транспорт,
		|	ТаблицаРесурс.ДокументВнесения КАК ДокументВнесения, 
		|	ВЫБОР
		|		КОГДА ТаблицаРесурс.ДокументВнесения = ЗНАЧЕНИЕ(Документ.ВнесениеНомеровТранспортныхСредств.ПустаяСсылка)
		|			ТОГДА НЕОПРЕДЕЛЕНО
		|		ИНАЧЕ ТаблицаТекущийСтатусДокумента.Статус
		|	КОНЕЦ КАК СтатусЗаявки
		|ИЗ
		|	ТаблицаРесурс КАК ТаблицаРесурс
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних КАК ТаблицаТекущийСтатусДокумента
		|		ПО ТаблицаРесурс.ДокументВнесения = ТаблицаТекущийСтатусДокумента.ДокументСсылка
		|
		|ИТОГИ
		|	МАКСИМУМ(ДокументВнесения),
		|	МАКСИМУМ(СтатусЗаявки)
		|ПО
		|	ВСД";
	
	Запрос.УстановитьПараметр("Таблица", Объект.ТочкиПерегрузки.Выгрузить());
	
	ВыборкаВСД = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаВСД.Следующий() Цикл
		
		НоваяСтрокаУС = ВСДИТочкиПерегрузки.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаУС, ВыборкаВСД);
		НоваяСтрокаУС.ВСДПункт = ВыборкаВСД.ВСД;
		НоваяСтрокаУС.Уровень  = 0;
		
		ВыборкаДеталей = ВыборкаВСД.Выбрать();
		Пока ВыборкаДеталей.Следующий() Цикл
			
			НоваяСтрока = НоваяСтрокаУС.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДеталей, , "ДокументВнесения, СтатусЗаявки");
			НоваяСтрока.ВСДПункт = ВыборкаДеталей.НазваниеПункта;
			НоваяСтрока.Уровень  = 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораВСД(МассивВСД, ДополнительныеПараметры) Экспорт
	
	Если МассивВСД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеТабличнойЧасти(МассивВСД);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораТранспортнойОперации(МассивТранспортных, ДополнительныеПараметры) Экспорт
	
	Если МассивТранспортных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивВСД = ПолучитьМассивВСД(МассивТранспортных, "ТранспортныеОперации");
	
	ЗаполнитьДанныеТабличнойЧасти(МассивВСД);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораПриходныхОперацийСводно(МассивПриходных, ДополнительныеПараметры) Экспорт
	
	Если МассивПриходных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивВСД = ПолучитьМассивВСД(МассивПриходных, "ПриходныеОперации");
	
	ЗаполнитьДанныеТабличнойЧасти(МассивВСД);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеТабличнойЧасти(МассивВСД)
	
	МассивДобавленныхВСД = Новый Массив;
	
	КоллекцияЭлементовДерева = ВСДИТочкиПерегрузки.ПолучитьЭлементы();
	Для Каждого ТекЭлемент Из КоллекцияЭлементовДерева Цикл
		МассивДобавленныхВСД.Добавить(ТекЭлемент.ВСДПункт);
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВСДТаблицаМаршрутСледования.Ссылка КАК ВСД,
		|	ВСДТаблицаМаршрутСледования.ИдентификаторТочкиМаршрута КАК ИдентификаторТочкиМаршрута,
		|	ВСДТаблицаМаршрутСледования.НазваниеПункта КАК ВСДПункт,
		|	ВСДТаблицаМаршрутСледования.ИнформацияОСледующемТранспорте КАК ТипТранспорта
		|ИЗ
		|	Документ.ВСД.ТаблицаМаршрутСледования КАК ВСДТаблицаМаршрутСледования
		|ГДЕ
		|	ВСДТаблицаМаршрутСледования.Ссылка В(&МассивВСД)
		|	И НЕ ВСДТаблицаМаршрутСледования.Ссылка В (&МассивДобавленныхВСД)
		|	И ВСДТаблицаМаршрутСледования.ОсуществляетсяПерегрузка
		|	И ВСДТаблицаМаршрутСледования.ИнформацияОСледующемТранспорте ССЫЛКА Справочник.ТипыТранспортныхСредств
		|ИТОГИ ПО
		|	ВСД";
	
	Запрос.УстановитьПараметр("МассивВСД"           , МассивВСД);
	Запрос.УстановитьПараметр("МассивДобавленныхВСД", МассивДобавленныхВСД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаВСД = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаВСД.Следующий() Цикл

		НовыйВСД = ВСДИТочкиПерегрузки.ПолучитьЭлементы().Добавить();
		НовыйВСД.ВСДПункт = ВыборкаВСД.ВСД;
		НовыйВСД.Уровень = 0;
	
		Выборка = ВыборкаВСД.Выбрать();
		Пока Выборка.Следующий() Цикл
			НовыйПунктПерегрузки = НовыйВСД.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НовыйПунктПерегрузки, Выборка);
			НовыйПунктПерегрузки.Уровень = 1;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументыВнесенияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьДокументыВнесенияНомеровТС();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивВСД(МассивДокументов, ТипОперации)
	
	Если ТипОперации = "ТранспортныеОперации" Тогда
		
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТранспортныеОперацииТаблицаВСД.ВСД КАК ВСД
			|ИЗ
			|	Документ.ТранспортныеОперации.ТаблицаВСД КАК ТранспортныеОперацииТаблицаВСД
			|ГДЕ
			|	ТранспортныеОперацииТаблицаВСД.Ссылка В(&МассивДокументов)";
		
	Иначе
		
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПриходныеОперацииСводноТаблицаДанных.ВСД КАК ВСД
			|ИЗ
			|	Документ.ПриходныеОперацииСводно.ТаблицаДанных КАК ПриходныеОперацииСводноТаблицаДанных
			|ГДЕ
			|	ПриходныеОперацииСводноТаблицаДанных.Ссылка В(&МассивДокументов)";
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВСД");
	
КонецФункции

&НаСервере
Процедура СоздатьДокументыВнесенияНомеровТС()
	
	НачатьТранзакцию();
	
	НомерПоПорядку = 1;
	Для Каждого СтрокаУС Из ВСДИТочкиПерегрузки.ПолучитьЭлементы() Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаУС.ВСДПункт) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(НСтр("ru = 'В строке %1 не указан ВСД!'"), "%1", Формат(НомерПоПорядку, "ЧГ=0")));
			НомерПоПорядку = НомерПоПорядку + 1;
			Продолжить;
		КонецЕсли;
		
		МассивСтрок = Новый Массив;
		
		Отказ = Ложь;
		Для Каждого Строка Из СтрокаУС.ПолучитьЭлементы() Цикл
			Если Не ЗначениеЗаполнено(Строка.Транспорт) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтрЗаменить(НСтр("ru = 'В строке с ВСД %1 имеются пункты, где не указано транспортное средство!'"), "%1", СтрокаУС.ВСДПункт),
						,
						,
						,
						Отказ);
				Прервать;
			КонецЕсли;
			МассивСтрок.Добавить(Новый Структура("ИдентификаторТочкиМаршрута, НазваниеПункта, ТипТранспорта, Транспорт",
			                     Строка.ИдентификаторТочкиМаршрута, Строка.ВСДПункт, Строка.ТипТранспорта, Строка.Транспорт));
			
		КонецЦикла;
		
		Если Отказ ИЛИ МассивСтрок.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтрЗаменить(НСтр("ru = 'В строке с ВСД %1 документ внесения номеров ТС не создан, т.к. имеются ошибки заполнения!'"), "%1", СтрокаУС.ВСДПункт));
			Продолжить;
		КонецЕсли;
		
		СтруктураОтвета = Документы.ВнесениеНомеровТранспортныхСредствГрупповое.СоздатьДокументВнесения(Объект.Организация, Объект.Контрагент, Объект.Предприятие, СтрокаУС.ВСДПункт, МассивСтрок);
		
		ЗаполнитьЗначенияСвойств(СтрокаУС, СтруктураОтвета);
		
		НомерПоПорядку = НомерПоПорядку + 1;
		
	КонецЦикла;
	
	Попытка
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
	КонецПопытки; 
	
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПроведение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПроведениеДокументаОшибка");
	ОценкаПроизводительностиКлиент.УстановитьПризнакОшибкиЗамера(ИдентификаторЗамераПроведение, Истина);
	
	ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
	
	ВопросБылЗадан = Истина;
	
	Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	
КонецПроцедуры

#КонецОбласти