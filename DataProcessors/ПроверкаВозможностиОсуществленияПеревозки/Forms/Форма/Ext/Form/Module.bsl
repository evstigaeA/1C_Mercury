﻿#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивДокументов") Тогда
		
		ЗаполнитьТаблицуДокументов(Параметры.МассивДокументов);
		
	КонецЕсли;
	
	Организация = ПараметрыСеанса.ТекущийПользователь.ОсновнаяОрганизация;
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаСервере
Функция ВыполнитьПроверкуНаСервере(РезультатФормированияЗапроса)
	
	ДанныеРегионализации = ИнтеграцияВетисAPIОтправкаЗаявокНаОформление.ОтправитьДанныеНаПроверкуВозможностиОсуществленияПеревозки(Организация, ПараметрыСеанса.ТекущийПользователь, ТаблицаДокументов.Выгрузить());
	
	Если ДанныеРегионализации.Свойство("РезультатФормированияЗапроса") Тогда
		//При отправке данных произошла ошибк
		РезультатФормированияЗапроса = ДанныеРегионализации.РезультатФормированияЗапроса;
		Возврат Ложь;
	Иначе
		УсловияПеремещенияПродукции.Загрузить(ДанныеРегионализации.УсловияПеремещенияПродукции);
		РезультатыПроверкиОбщие.Загрузить(ДанныеРегионализации.РезультатыПроверкиОбщие);
		ТаблицаДокументов.Загрузить(ДанныеРегионализации.ТаблицаДанных);
		ЗначениеВРеквизитФормы(ДанныеРегионализации.РезультатыПроверки, "РезультатыПроверки");
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатФормированияЗапроса = Неопределено;
		Если Не ВыполнитьПроверкуНаСервере(РезультатФормированияЗапроса) Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РезультатФормированияЗапроса", РезультатФормированияЗапроса);
			
			ОткрытьФорму("Обработка.ИнформацияОбработкиЗапроса.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	
	Элементы.РезультатыПроверки.Свернуть(Элементы.РезультатыПроверки.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Развернуть(Команда)
	
	Элементы.РезультатыПроверки.Развернуть(Элементы.РезультатыПроверки.ТекущаяСтрока, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТранспортныхОпераций(Команда)
	
	ПараметрыОтобра = Новый Структура();
	
	ПодборДокументовКОбработке("Документ.ТранспортныеОперации.ФормаВыбора", ПараметрыОтобра)
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПриходныхОпераций(Команда)
	
	РазрешенныеРешения = Новый Массив;
	РазрешенныеРешения.Добавить(ПредопределенноеЗначение("Справочник.РешенияОПриемеВходнойПартии.ОформитьВозвратНаВсюПоставку"));
	РазрешенныеРешения.Добавить(ПредопределенноеЗначение("Справочник.РешенияОПриемеВходнойПартии.ПринятьЧастьГруза"));
	
	ПараметрыОтобра = Новый Структура();
	ПараметрыОтобра.Вставить("РешениеОПриемеВходнойПартии", РазрешенныеРешения);
	
	ПодборДокументовКОбработке("Документ.ПриходныеОперации.ФормаВыбора", ПараметрыОтобра)
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборДокументовКОбработке(ИмяФормы, ПараметрыОтобра)
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ПустаяСсылка"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ОшибкаОтправкиЗапроса"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Отклонена"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Черновик"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Подготовлен"));
	
	ПараметрыОтобра.Вставить("Статус"     , МассивСтатусов);
	ПараметрыОтобра.Вставить("Организация", Организация);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора"       , Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("Отбор"             , ПараметрыОтобра);
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Для Каждого ТекЗначение Из ВыбранноеЗначение Цикл
		
		НайденныеДокументы = ТаблицаДокументов.НайтиСтроки(Новый Структура("Документ", ТекЗначение));
		
		Если НайденныеДокументы.Количество() = 0 Тогда
			
			НоваяСтрока = ТаблицаДокументов.Добавить();
			НоваяСтрока.Документ = ТекЗначение;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокументыУсловиями(Команда)
	
	ЗаполнитьДокументыУсловиямиНаСервере();
	
	Оповестить("ПроведенаПроверкаРегионализации");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументыУсловиямиНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаУсловий.ВыполняетсяУсловие КАК ВыполняетсяУсловие,
		|	ТаблицаУсловий.Заболевание КАК Заболевание,
		|	ТаблицаУсловий.НомерБлока КАК НомерБлока,
		|	ТаблицаУсловий.УсловиеПеремещения КАК УсловиеПеремещения,
		|	ТаблицаУсловий.Документ КАК Документ,
		|	ТаблицаУсловий.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
		|ПОМЕСТИТЬ ВТ_ТаблицаУсловий
		|ИЗ
		|	&ТаблицаУсловий КАК ТаблицаУсловий
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РезультатыПроверки.Документ КАК Документ,
		|	РезультатыПроверки.Решение КАК Решение,
		|	РезультатыПроверки.Запись КАК Запись
		|ПОМЕСТИТЬ ВТ_ТаблицаДокументов
		|ИЗ
		|	&РезультатыПроверки КАК РезультатыПроверки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаУсловий.ВыполняетсяУсловие КАК ВыполняетсяУсловие,
		|	ВТ_ТаблицаУсловий.Заболевание КАК Заболевание,
		|	ВТ_ТаблицаУсловий.НомерБлока КАК НомерБлока,
		|	ВТ_ТаблицаУсловий.УсловиеПеремещения КАК УсловиеПеремещения,
		|	ВТ_ТаблицаУсловий.Документ КАК Документ,
		|	ВТ_ТаблицаУсловий.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
		|	ТранспортныеОперацииТаблицаПродукция.GUIDСтроки КАК GUIDСтроки
		|ПОМЕСТИТЬ ВТ_ДанныеДокументов
		|ИЗ
		|	ВТ_ТаблицаУсловий КАК ВТ_ТаблицаУсловий
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТранспортныеОперации.ТаблицаПродукция КАК ТранспортныеОперацииТаблицаПродукция
		|		ПО ВТ_ТаблицаУсловий.Документ = ТранспортныеОперацииТаблицаПродукция.Ссылка
		|			И ВТ_ТаблицаУсловий.ЗаписьСкладскогоЖурнала = ТранспортныеОперацииТаблицаПродукция.ЗаписьСкладскогоЖурнала
		|ГДЕ
		|	ВТ_ТаблицаУсловий.Документ ССЫЛКА Документ.ТранспортныеОперации
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_ТаблицаУсловий.ВыполняетсяУсловие,
		|	ВТ_ТаблицаУсловий.Заболевание,
		|	ВТ_ТаблицаУсловий.НомерБлока,
		|	ВТ_ТаблицаУсловий.УсловиеПеремещения,
		|	ВТ_ТаблицаУсловий.Документ,
		|	ВТ_ТаблицаУсловий.ЗаписьСкладскогоЖурнала,
		|	""""
		|ИЗ
		|	ВТ_ТаблицаУсловий КАК ВТ_ТаблицаУсловий
		|ГДЕ
		|	ВТ_ТаблицаУсловий.Документ ССЫЛКА Документ.ПриходныеОперации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаДокументов.Документ КАК Документ,
		|	ВТ_ТаблицаДокументов.Решение КАК РешениеПоПеревозке,
		|	ВТ_ТаблицаДокументов.Запись КАК ЗаписьСкладскогоЖурнала,
		|	ВТ_ДанныеДокументов.GUIDСтроки КАК GUIDСтроки,
		|	ВТ_ДанныеДокументов.ВыполняетсяУсловие КАК ВыполняетсяУсловие,
		|	ВТ_ДанныеДокументов.Заболевание КАК Заболевание,
		|	ВТ_ДанныеДокументов.НомерБлока КАК НомерБлока,
		|	ВТ_ДанныеДокументов.УсловиеПеремещения КАК УсловиеПеремещения
		|ИЗ
		|	ВТ_ТаблицаДокументов КАК ВТ_ТаблицаДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеДокументов КАК ВТ_ДанныеДокументов
		|		ПО ВТ_ТаблицаДокументов.Документ = ВТ_ДанныеДокументов.Документ
		|			И ВТ_ТаблицаДокументов.Запись = ВТ_ДанныеДокументов.ЗаписьСкладскогоЖурнала
		|ИТОГИ ПО
		|	Документ";

	Запрос.УстановитьПараметр("ТаблицаУсловий"    , УсловияПеремещенияПродукции.Выгрузить());
	Запрос.УстановитьПараметр("РезультатыПроверки", РезультатыПроверкиОбщие.Выгрузить());

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаДокумент.Следующий() Цикл
		
		ДокументОбъект = ВыборкаДокумент.Документ.ПолучитьОбъект();
		ДокументОбъект.УсловияПеремещенияПродукции.Очистить();
		
		ЗаписьСкладскогоЖурнала = Справочники.СвойстваЗаписейСкладскогоЖурнала.ПустаяСсылка();
		ЭтоТранспортнаяОперация = ТипЗнч(ВыборкаДокумент.Документ) = Тип("ДокументСсылка.ТранспортныеОперации");
		
		Выборка = ВыборкаДокумент.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если ЭтоТранспортнаяОперация Тогда
				Если ЗаписьСкладскогоЖурнала <> Выборка.ЗаписьСкладскогоЖурнала Тогда
					НайденныеСтроки = ДокументОбъект.ТаблицаПродукция.НайтиСтроки(Новый Структура("ЗаписьСкладскогоЖурнала", Выборка.ЗаписьСкладскогоЖурнала));
					Если НайденныеСтроки.Количество() > 0 Тогда
						Для Каждого ТекНайденнаяСтрока Из НайденныеСтроки Цикл
							ТекНайденнаяСтрока.РешениеПоПеревозке = Выборка.РешениеПоПеревозке;
						КонецЦикла;
						ЗаписьСкладскогоЖурнала = Выборка.ЗаписьСкладскогоЖурнала
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если Выборка.РешениеПоПеревозке <> Справочники.ВидыТребованийДляПеремещения.ПеремещениеРазрешеноПриУсловии Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ДокументОбъект.УсловияПеремещенияПродукции.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		КонецЦикла;
		
		ДокументОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	СнятьФлажкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СнятьФлажкиНаСервере()

	ТаблицаУсловий = РеквизитФормыВЗначение("УсловияПеремещенияПродукции");
	ТаблицаУсловий.ЗаполнитьЗначения(Ложь, "ВыполняетсяУсловие");
	ЗначениеВРеквизитФормы(ТаблицаУсловий, "УсловияПеремещенияПродукции");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьФлажкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФлажкиНаСервере()
	
	ТаблицаУсловий = РеквизитФормыВЗначение("УсловияПеремещенияПродукции");
	ТаблицаУсловий.ЗаполнитьЗначения(Истина, "ВыполняетсяУсловие");
	ЗначениеВРеквизитФормы(ТаблицаУсловий, "УсловияПеремещенияПродукции");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРезультатыПроверки

&НаКлиенте
Процедура РезультатыПроверкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыПроверкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.РезультатыПроверки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "РезультатыПроверкиУсловияПеремещения" Тогда
		
		Если ТекущиеДанные.Решение <> ПредопределенноеЗначение("Справочник.ВидыТребованийДляПеремещения.ПеремещениеРазрешеноПриУсловии") Тогда
			Возврат;
		КонецЕсли;
		
		Уровень = ПолучитьУровеньСтроки(ТекущиеДанные);
		
		ПараметрыОтбора = Новый Структура;
		
		ТекСтрока = ТекущиеДанные;
		ЗаполнитьПараметрыОтбора(ПараметрыОтбора, ТекСтрока);
		
		АдресХранения = ПоместитьТаблицуВоВременноеХранилище(ПараметрыОтбора);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("АдресХранения"       , АдресХранения);
		ПараметрыФормы.Вставить("ТолькоПросмотр"      , Ложь);
		Если Уровень = 0 Тогда
			ПараметрыФормы.Вставить("ОтображатьПодвид", Истина);
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыОтбора", ПараметрыОтбора);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РезультатыПроверкиВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("Обработка.ПодборУсловийПеремещенияВРамкахРегионализации.Форма.Форма", ПараметрыФормы,,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ПоказатьЗначение(, ТекущиеДанные.Данные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатыПроверкиВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРезультатПроверки(Результат, ДополнительныеПараметры.ПараметрыОтбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаДокументовИнформация" Тогда
		
		ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РезультатФормированияЗапроса", ТекущиеДанные.РезультатФормированияЗапроса);
		ПараметрыФормы.Вставить("РезультатПолученияОтвета", ТекущиеДанные.РезультатПолученияОтвета);
		
		ОткрытьФорму("Обработка.ИнформацияОбработкиЗапроса.Форма.Форма", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПараметрыОтбора(ПараметрыОтбора, ТекущиеДанные)
	
	Если ТипЗнч(ТекущиеДанные.Данные) = Тип("ДокументСсылка.ТранспортныеОперации")
		ИЛИ ТипЗнч(ТекущиеДанные.Данные) = Тип("ДокументСсылка.ПриходныеОперации") Тогда
		ПараметрыОтбора.Вставить("Документ", ТекущиеДанные.Данные);
	ИначеЕсли ТипЗнч(ТекущиеДанные.Данные) = Тип("СправочникСсылка.ПодвидыПродукции") Тогда
		ПараметрыОтбора.Вставить("ПодвидПродукции", ТекущиеДанные.Данные);
	ИначеЕсли ТипЗнч(ТекущиеДанные.Данные) = Тип("СправочникСсылка.СвойстваЗаписейСкладскогоЖурнала") Тогда
		ПараметрыОтбора.Вставить("ЗаписьСкладскогоЖурнала", ТекущиеДанные.Данные);
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанные.ПолучитьРодителя();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	Иначе
		ЗаполнитьПараметрыОтбора(ПараметрыОтбора, ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьУровеньСтроки(СтрокаДерева)

	Родитель = СтрокаДерева.ПолучитьРодителя(); 
	Возврат ?(Родитель = Неопределено, 0, 1 + ПолучитьУровеньСтроки(Родитель));
	
КонецФункции

&НаСервере
Функция ПоместитьТаблицуВоВременноеХранилище(ПараметрыОтбора)
	
	УсловияПеремещения = УсловияПеремещенияПродукции.Выгрузить(ПараметрыОтбора);
	
	УсловияПеремещения.Свернуть("Заболевание, НомерБлока, ПодвидПродукции, УсловиеПеремещения, ВыполняетсяУсловие");
	
	Возврат ПоместитьВоВременноеХранилище(УсловияПеремещения, УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПроверяемыеРеквизиты.Добавить("ТаблицаДокументов");
	
	Для Индекс = 0 По ТаблицаДокументов.Количество()-1 Цикл
		
		СтрокаТаблицы = ТаблицаДокументов.Получить(Индекс);
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
								СтрЗаменить(НСтр("ru = 'Не заполнена колонка ""Документ"" в строке %1 списка ""Документы для проверки""'"), "%1", Индекс + 1),
								,
								"ТаблицаДокументов[" + Индекс + "].Документ",
								,
								Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивДокументов = ТаблицаДокументов.Выгрузить(, "Документ");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТранспортныеОперации.Ссылка КАК Ссылка,
		|	ТранспортныеОперации.Представление КАК Представление,
		|	ТранспортныеОперации.ПредприятиеОтправитель КАК ПредприятиеОтправитель,
		|	ТранспортныеОперации.ПредприятиеПолучатель КАК ПредприятиеПолучатель,
		|	ТранспортныеОперации.ТаблицаМаршрутСледования.(
		|		НомерСтроки КАК НомерСтроки,
		|		НазваниеПункта КАК НазваниеПункта
		|	) КАК ТаблицаМаршрутСледования
		|ИЗ
		|	Документ.ТранспортныеОперации КАК ТранспортныеОперации
		|ГДЕ
		|	ТранспортныеОперации.Ссылка В(&МассивДокументов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриходныеОперации.Ссылка,
		|	ПриходныеОперации.Представление,
		|	ПриходныеОперации.ПредприятиеОтправитель,
		|	ПриходныеОперации.ПредприятиеПолучатель,
		|	ПриходныеОперации.ТаблицаМаршрутСледования.(
		|		НомерСтроки,
		|		НазваниеПункта
		|	)
		|ИЗ
		|	Документ.ПриходныеОперации КАК ПриходныеОперации
		|ГДЕ
		|	ПриходныеОперации.Ссылка В(&МассивДокументов)";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Пока ВыборкаШапка.Следующий() Цикл
		
		ТекстОшибки   = НСтр("ru = 'В документе %1 не заполнено поле %2'");
		ТекстОшибкиТЧ = НСтр("ru = 'В документе %1 в строке %2 списка ""Маршрут следования"" не заполнена колонка ""Название пункта"".'");
		
		Если Не ЗначениеЗаполнено(ВыборкаШапка.ПредприятиеОтправитель) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВыборкаШапка.Представление, "Предприятие отправитель"),
					ВыборкаШапка.Ссылка,
					"ПредприятиеОтправитель",
					,
					Отказ);
			
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(ВыборкаШапка.ПредприятиеПолучатель) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВыборкаШапка.Представление, "Предприятие получатель"),
					ВыборкаШапка.Ссылка,
					"ПредприятиеПолучатель",
					,
					Отказ);
			
		КонецЕсли;
		
		ВыборкаМаршрут = ВыборкаШапка.ТаблицаМаршрутСледования.Выбрать();
		Пока ВыборкаМаршрут.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ВыборкаМаршрут.НазваниеПункта) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибкиТЧ, ВыборкаШапка.Представление, ВыборкаМаршрут.НомерСтроки),
					ВыборкаШапка.Ссылка,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ТаблицаМаршрутСледования", ВыборкаМаршрут.НомерСтроки, "НазваниеПункта"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРезультатПроверки(Результат, ПараметрыОтбора)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРезультатов.ВыполняетсяУсловие КАК ВыполняетсяУсловие,
		|	ТаблицаРезультатов.Заболевание КАК Заболевание,
		|	ТаблицаРезультатов.НомерБлока КАК НомерБлока,
		|	ТаблицаРезультатов.ПодвидПродукции КАК ПодвидПродукции,
		|	ТаблицаРезультатов.УсловиеПеремещения КАК УсловиеПеремещения
		|ПОМЕСТИТЬ ВТ_ТаблицаРезультатов
		|ИЗ
		|	&ТаблицаРезультатов КАК ТаблицаРезультатов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УсловияПеремещенияПродукции.ВыполняетсяУсловие КАК ВыполняетсяУсловие,
		|	УсловияПеремещенияПродукции.Заболевание КАК Заболевание,
		|	УсловияПеремещенияПродукции.НомерБлока КАК НомерБлока,
		|	УсловияПеремещенияПродукции.УсловиеПеремещения КАК УсловиеПеремещения,
		|	УсловияПеремещенияПродукции.ПодвидПродукции КАК ПодвидПродукции,
		|	УсловияПеремещенияПродукции.Документ КАК Документ,
		|	УсловияПеремещенияПродукции.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
		|ПОМЕСТИТЬ ВТ_УсловияПеремещенияПродукции
		|ИЗ
		|	&УсловияПеремещенияПродукции КАК УсловияПеремещенияПродукции
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_УсловияПеремещенияПродукции.Заболевание КАК Заболевание,
		|	ВТ_УсловияПеремещенияПродукции.НомерБлока КАК НомерБлока,
		|	ВТ_УсловияПеремещенияПродукции.УсловиеПеремещения КАК УсловиеПеремещения,
		|	ВТ_УсловияПеремещенияПродукции.ПодвидПродукции КАК ПодвидПродукции,
		|	ВТ_УсловияПеремещенияПродукции.Документ КАК Документ,
		|	ВТ_УсловияПеремещенияПродукции.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала,
		|	ЕСТЬNULL(ВТ_ТаблицаРезультатов.ВыполняетсяУсловие, ВТ_УсловияПеремещенияПродукции.ВыполняетсяУсловие) КАК ВыполняетсяУсловие
		|ИЗ
		|	ВТ_УсловияПеремещенияПродукции КАК ВТ_УсловияПеремещенияПродукции
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТаблицаРезультатов КАК ВТ_ТаблицаРезультатов
		|		ПО ВТ_УсловияПеремещенияПродукции.Заболевание = ВТ_ТаблицаРезультатов.Заболевание
		|			И ВТ_УсловияПеремещенияПродукции.НомерБлока = ВТ_ТаблицаРезультатов.НомерБлока
		|			И ВТ_УсловияПеремещенияПродукции.УсловиеПеремещения = ВТ_ТаблицаРезультатов.УсловиеПеремещения
		|			И ВТ_УсловияПеремещенияПродукции.ПодвидПродукции = ВТ_ТаблицаРезультатов.ПодвидПродукции
		|			И (ВТ_УсловияПеремещенияПродукции.Документ = &Документ)
		|			И (ВТ_УсловияПеремещенияПродукции.ПодвидПродукции = &ПодвидПродукции)
		|			И (ВТ_УсловияПеремещенияПродукции.ЗаписьСкладскогоЖурнала = &ЗаписьСкладскогоЖурнала)";
	
	Запрос.УстановитьПараметр("ТаблицаРезультатов"         , Результат.Выгрузить());
	Запрос.УстановитьПараметр("УсловияПеремещенияПродукции", УсловияПеремещенияПродукции.Выгрузить());
	Запрос.УстановитьПараметр("Документ"                   , ПараметрыОтбора.Документ);
	Если ПараметрыОтбора.Свойство("ПодвидПродукции") Тогда
		Запрос.УстановитьПараметр("ПодвидПродукции"        , ПараметрыОтбора.ПодвидПродукции);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "(ВТ_УсловияПеремещенияПродукции.ПодвидПродукции = &ПодвидПродукции)", "ИСТИНА");
	КонецЕсли;
	Если ПараметрыОтбора.Свойство("ЗаписьСкладскогоЖурнала") Тогда
		Запрос.УстановитьПараметр("ЗаписьСкладскогоЖурнала", ПараметрыОтбора.ЗаписьСкладскогоЖурнала);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "(ВТ_УсловияПеремещенияПродукции.ЗаписьСкладскогоЖурнала = &ЗаписьСкладскогоЖурнала)", "ИСТИНА");
	КонецЕсли;
	
	УсловияПеремещенияПродукции.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументов(МассивДокументов)
	
	УстановитьПривилегированныйРежим(Истина);
	// Отфильтруем документы по которым нельзя выполнять проверку
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ПустаяСсылка"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.ОшибкаОтправкиЗапроса"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Отклонена"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Черновик"));
	МассивСтатусов.Добавить(ПредопределенноеЗначение("Справочник.СтатусыЗаявок.Подготовлен"));

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТранспортныеОперации.Ссылка КАК Документ
		|ИЗ
		|	Документ.ТранспортныеОперации КАК ТранспортныеОперации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних(, ДокументСсылка В (&МассивДокументов)) КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|		ПО ТранспортныеОперации.Ссылка = ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ТранспортныеОперации.Ссылка В(&МассивДокументов)
		|	И ЕСТЬNULL(ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.СтатусыЗаявок.ПустаяСсылка)) В (&МассивСтатусов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриходныеОперации.Ссылка
		|ИЗ
		|	Документ.ПриходныеОперации КАК ПриходныеОперации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних(, ДокументСсылка В (&МассивДокументов)) КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|		ПО ПриходныеОперации.Ссылка = ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка
		|ГДЕ
		|	ПриходныеОперации.Ссылка В(&МассивДокументов)
		|	И ЕСТЬNULL(ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус, ЗНАЧЕНИЕ(Справочник.СтатусыЗаявок.ПустаяСсылка)) В (&МассивСтатусов)
		|	И ПриходныеОперации.РешениеОПриемеВходнойПартии <> ЗНАЧЕНИЕ(Справочник.РешенияОПриемеВходнойПартии.ПринятьВсюПоставку)";
	
	Если МассивДокументов.Количество() > 0 И ТипЗнч(МассивДокументов[0]) = Тип("ДокументСсылка.ПриходныеОперацииСводно") Тогда
		
		СводнаяОперация = МассивДокументов[0];
		МассивДокументов.Очистить();
		Для Каждого ТекДокумент Из СводнаяОперация.ТаблицаДанных Цикл
			МассивДокументов.Добавить(ТекДокумент.ПриходнаяОперация);
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("МассивСтатусов"  , МассивСтатусов);
	
	ТаблицаДокументов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти