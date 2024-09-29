﻿
#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем внутренние флаги.
	МожноДобавлятьВСправочник = УправлениеКонтактнойИнформациейСлужебный.ЕстьПравоДобавления();
	
	Если Параметры.РазрешитьДанныеКлассификатора=Неопределено Тогда
		РазрешитьДанныеКлассификатора = Истина;
	Иначе
		ТипБулево = Новый ОписаниеТипов("Булево");
		РазрешитьДанныеКлассификатора = ТипБулево.ПривестиЗначение(Параметры.РазрешитьДанныеКлассификатора);
	КонецЕсли;
	
	ТолькоДанныеКлассификатора = Параметры.ТолькоДанныеКлассификатора;
	Параметры.Свойство("РежимВыбора", РежимВыбора);
	
	// Разрешаем элементы
	Элементы.Список.РежимВыбора = РежимВыбора;
	Элементы.СписокВыбрать.Видимость         = РежимВыбора;
	Элементы.СписокВыбрать.КнопкаПоУмолчанию = РежимВыбора;
	
	Элементы.Создать.Видимость = МожноДобавлятьВСправочник;
	
	// По флагам определяем режим
	Если РежимВыбора Тогда
		Если РазрешитьДанныеКлассификатора Тогда
			Если ТолькоДанныеКлассификатора Тогда
				Если МожноДобавлятьВСправочник Тогда 
					// Выбор только стран классификатора.
					ОткрытьФормуКлассификатора = Истина
					
				Иначе
					// Показываем только пересечение справочника и классификатора.
					УстановитьОтборПересеченияСКлассификатором();
					// Кнопки классификатора скрываем.
					Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
					Элементы.СписокКлассификатор.Видимость           = Ложь;
				КонецЕсли;
				
			Иначе
				Если МожноДобавлятьВСправочник Тогда 
					// Показываем справочник и кнопку выбора из классификатора (установки по умолчанию).
				Иначе
					// Кнопки классификатора скрываем.
					Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
					Элементы.СписокКлассификатор.Видимость           = Ложь;
				КонецЕсли;
			КонецЕсли;
			
		 Иначе
			// Показываем только элементы справочника.
			Элементы.СписокКлассификатор.Видимость = Ложь;
			// Кнопки классификатора скрываем.
			Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
			Элементы.СписокКлассификатор.Видимость           = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрытьФормуКлассификатора Тогда
		// Выбор только стран классификатора, открываем его форму для выбора.
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора",        Истина);
		ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
		ПараметрыОткрытия.Вставить("ТекущаяСтрока",      Элементы.Список.ТекущаяСтрока);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкна",  РежимОткрытияОкна);
		ПараметрыОткрытия.Вставить("ТекущаяСтрока",      Элементы.Список.ТекущаяСтрока);
		
		ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, ВладелецФормы);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="Справочник.СтраныМира.Изменение" Тогда
		ОбновитьОтображениеСпискаСтран();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		// Выбор из классификатора
		ОповеститьОВыборе(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	ОбновитьОтображениеСпискаСтран();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

&НаКлиенте
Процедура ОткрытьКлассификатор(Команда)
	// Открываем на просмотр
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	
	// Открываем для выбора
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("РежимОткрытияОкна", РежимОткрытияОкна);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, Элементы.Список,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

&НаКлиенте
Процедура ОбновитьОтображениеСпискаСтран()
	
	Если ИдентификаторЭлементаОтбораСсылки<>Неопределено Тогда
		// Был наложен дополнительный отбор, который надо обновить.
		УстановитьОтборПересеченияСКлассификатором();
	КонецЕсли;
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПересеченияСКлассификатором()
	ОтборСписка = Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	
	Если ИдентификаторЭлементаОтбораСсылки=Неопределено Тогда
		ЭлементОтбора = ОтборСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование    = Истина;
		
		ИдентификаторЭлементаОтбораСсылки = ОтборСписка.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
	Иначе
		ЭлементОтбора = ОтборСписка.ПолучитьОбъектПоИдентификатору(ИдентификаторЭлементаОтбораСсылки);
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Код, Наименование
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Классификатор
		|ИНДЕКСИРОВАТЬ ПО
		|	Код, Наименование
		|;////////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	Ссылка
		|ИЗ
		|	Справочник.СтраныМира КАК СтраныМира
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Классификатор КАК Классификатор
		|ПО
		|	СтраныМира.Код = Классификатор.Код
		|	И СтраныМира.Наименование = Классификатор.Наименование
		|");
	Запрос.УстановитьПараметр("Классификатор", УправлениеКонтактнойИнформацией.ТаблицаКлассификатора());
	ЭлементОтбора.ПравоеЗначение = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецПроцедуры

#КонецОбласти
