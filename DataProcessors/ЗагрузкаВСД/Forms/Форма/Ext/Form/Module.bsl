﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Организация   = Ответственный.ОсновнаяОрганизация;
	Контрагент    = ОбщегоНазначенияУВССервер.КонтрагентПоОрганизации(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.ШагиЗагрузки.ТекущаяСтраница <> Элементы.ОжиданиеЗагрузки
		Или ПодтверждениеЗакрытияФормы = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
	Текст = НСтр("ru = 'Прервать загрузку ВСД?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	//Если запущено регламентное задание по загрузке ВСД, то отменим выполнение данной обработки
	МенеджерСправочника = Справочники.ТипыВСД;
	МассивПроверяемыхЗаданий = Новый Массив;
	Если ТипВСД = МенеджерСправочника.Транспортный Или ТипВСД = МенеджерСправочника.ПустаяСсылка() Тогда
		МассивПроверяемыхЗаданий.Добавить(Метаданные.РегламентныеЗадания.ЗагрузкаТранспортныхВСД);
	КонецЕсли;
	Если ТипВСД = МенеджерСправочника.ПроизводственныйВСД Или ТипВСД = МенеджерСправочника.ПустаяСсылка() Тогда
		МассивПроверяемыхЗаданий.Добавить(Метаданные.РегламентныеЗадания.ЗагрузкаПроизводственныхВСД);
	КонецЕсли;
	
	Для Каждого ТекРегЗадания Из МассивПроверяемыхЗаданий Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("ИмяМетода", ТекРегЗадания.ИмяМетода);
		Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		ФоновыеЗаданияПроверка = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
		
		Если ФоновыеЗаданияПроверка.Количество() > 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(НСтр("ru = 'В данный момент выполняется регламентное задание по загрузке ВСД ""%1"". Выполнение операции отменено.'"), "%1", ТекРегЗадания.Наименование),,,, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВидОперации = 0 Или ВидОперации = 2 Тогда
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("ДатаНачала");
		ИсключаемыеРеквизиты.Добавить("ДатаОкончания");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
		Если ВидОперации = 2 Тогда
			ПроверяемыеРеквизиты.Добавить("СписокГУИДОВ");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийИзмененияРеквизитов

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Контрагент = ОбщегоНазначенияУВСВызовСервера.КонтрагентПоОрганизации(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеПриИзменении(Контрагент, Предприятие);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеНачалоВыбора(Элемент, СтандартнаяОбработка, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ОбщегоНазначенияУВСКлиент.ПредприятиеОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	//Если ВидОперации = 1 Тогда
	Если Ложь Тогда
		Элементы.ТипВСД.РежимВыбораИзСписка = Истина;
		Элементы.ТипВСД.СписокВыбора.Очистить();
		Элементы.ТипВСД.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.ТипыВСД.Транспортный"));
		Элементы.ТипВСД.СписокВыбора.Добавить(ПредопределенноеЗначение("Справочник.ТипыВСД.ПроизводственныйВСД"));
	Иначе
		Элементы.ТипВСД.РежимВыбораИзСписка = Ложь;
		Элементы.ТипВСД.СписокВыбора.Очистить();
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИдентификаторовВСДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("СписокЗначений", СписокИдентификаторовВСД);
	ПараметрыФормы.Вставить("СписокТипов"   , Новый ОписаниеТипов("Строка"));
	ПараметрыФормы.Вставить("Представление" , НСтр("ru = 'Указание списка идентификаторов ВСД.'"));
	ПараметрыФормы.Вставить("Сценарий"      , "ЗагрузкаИдентификаторовВСД");
	
	Оповещение = Новый ОписаниеОповещения("СписокИдентификаторовВСДОкончаниеВыбора", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСписком", ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИдентификаторовВСДОкончаниеВыбора(МассивИдентификаторов, ДополнительныеПараметры) Экспорт
	
	Если МассивИдентификаторов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(МассивИдентификаторов) = Тип("Массив") Тогда
		ОтформатироватьИдентификаторыВСД(МассивИдентификаторов);
		СписокИдентификаторовВСД.ЗагрузитьЗначения(МассивИдентификаторов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипВСДПриИзменении(Элемент)
	
	УстановитьВидимостьСведенийОбОтправителе();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьВСД(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("Организация"  , Организация);
	ПараметрыОперации.Вставить("Контрагент"   , Контрагент);
	ПараметрыОперации.Вставить("Предприятие"  , Предприятие);
	ПараметрыОперации.Вставить("Ответственный", Ответственный);
	Если ВидОперации = 2 Тогда
		ПараметрыОперации.Вставить("СписокИдентификаторовВСД", СписокИдентификаторовВСД);
	Иначе
		Если ЗначениеЗаполнено(ДатаНачала) Тогда
			ПараметрыОперации.Вставить("ДатаНачала"   , ДатаНачала);
		КонецЕсли;
		Если ЗначениеЗаполнено(ДатаОкончания) Тогда
			ПараметрыОперации.Вставить("ДатаОкончания", ДатаОкончания);
		КонецЕсли;
		Если ЗначениеЗаполнено(ТипВСД) Тогда
			ПараметрыОперации.Вставить("ТипВСД"   , ТипВСД);
		КонецЕсли;
		Если ЗначениеЗаполнено(СтатусВСД) Тогда
			ПараметрыОперации.Вставить("СтатусВСД", СтатусВСД);
		КонецЕсли;
		Если ВидОперации = 0 Тогда
			Если ЗначениеЗаполнено(ПредприятиеОтправитель) И ТипВСД <> ПредопределенноеЗначение("Справочник.ТипыВСД.ПроизводственныйВСД") Тогда
				ПараметрыОперации.Вставить("ПредприятиеОтправитель", ПредприятиеОтправитель);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка данных из ИС ""Меркурий""...'");
	
	Если Не ПредприятиеВсе Тогда
		ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
		Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(ПараметрыОперации, ВидОперации, УникальныйИдентификатор);
		
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
		НастройкиОжидания.ПолучатьРезультат    = Истина;
		НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
		
		Обработчик = Новый ОписаниеОповещения("ПослеФоновойЗагрузкиВСД", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	Иначе
		СписокПредприятийКонтрагента = ОбщегоНазначенияУВСВызовСервера.ПредприятияПоКонтрагенту(Контрагент);
		Для Каждого ТекЭлемент Из СписокПредприятийКонтрагента Цикл
			ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);

			ПараметрыОперации.Вставить("Предприятие"  , ТекЭлемент);
			Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(ПараметрыОперации, ВидОперации, УникальныйИдентификатор);
			НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
			НастройкиОжидания.ПолучатьРезультат    = Истина;
			НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
		
			ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, , НастройкиОжидания);
		КонецЦикла; 	
	КонецЕсли;
	
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	// Запущенное
	Элементы.ПрерватьЗагрузку.Доступность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиВСД(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда

		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось выполнить загрузку ВСД
			    |по причине:
				|%1'"), Задание.ПодробноеПредставлениеОшибки);
			
		ВывестиСообщениеОбОшибке(ТекстОшибки);
	ИначеЕсли Задание.Статус = "Выполнено" Тогда
		ОбработатьРезультат(Задание.АдресРезультата);
		ЗавершениеЗагрузки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВывестиСообщениеОбОшибке(Знач ТекстОшибки)
	ОчиститьСообщения();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ПараметрыЗагрузки;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультат(АдресРезультата)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РезультатОперации", АдресРезультата);
	ПараметрыФормы.Вставить("ЗаголовокФормы"   , НСтр("ru = 'Результат загрузки данных по ВСД'"));
	
	ОткрытьФорму("ОбщаяФорма.ФормаРезультатаЗагрузки", ПараметрыФормы, ЭтотОбъект, Новый УникальныйИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузки()
	
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ПараметрыЗагрузки;
	
	Возврат;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуССайтаНаСервере(ПараметрыОперации, ВидОперации, УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка ВСД'");

	Если ВидОперации = 0 Тогда
		
		ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIОтправкаЗаявокНаОформление.ЗагрузкаСпискаВСДПредприятия",
			ПараметрыОперации, ПараметрыВыполнения);
		
	ИначеЕсли ВидОперации = 1 Тогда
		
		ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIОтправкаЗаявокНаОформление.ЗагрузкаВСДЗаПериод",
			ПараметрыОперации, ПараметрыВыполнения);
			
	Иначе
		
		ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIОбработкаПартий.ПолучитьВСДПоСпискуИдентификаторов",
			ПараметрыОперации, ПараметрыВыполнения);
			
	КонецЕсли;
	
	Возврат ФоновоеЗадание;
КонецФункции

&НаКлиенте
Процедура ПрогрессВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Выполняется" Тогда
		Прогресс = ПрочитатьПрогресс(Результат.ИдентификаторЗадания);
		Если Прогресс <> Неопределено Тогда
			ТекстСостоянияЗагрузки = Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ПрерватьЗагрузку(Команда)
	
	Если ИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПрерватьЗагрузкуСервер();
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(ДатаНачала, ДатаОкончания);
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПослеВыбораПериода",ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораПериода(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДатаНачала    = Результат.ДатаНачала;
		ДатаОкончания = Результат.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершение диалога закрытия формы.
&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		ПрерватьЗагрузкуСервер();
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрерватьЗагрузкуСервер()
	
	МодульДлительныеОперации = ОбщегоНазначения.ОбщийМодуль("ДлительныеОперации");
	МодульДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСвойстваЭлементовФормы()
	
	Элементы.СтраницаЗагрузкиВСДПоФильтру.Видимость         = ВидОперации <> 2;
	Элементы.ГруппаЗагрузкаВсехВСД.Видимость                = ВидОперации = 0;
	Элементы.СтраницаЗагрузкиВСДПоИдентификаторам.Видимость = ВидОперации = 2;
	
	Элементы.ДатаНачала.ОтметкаНезаполненного        = ВидОперации = 1;
	Элементы.ДатаНачала.АвтоОтметкаНезаполненного    = ВидОперации = 1;
	Элементы.ДатаОкончания.ОтметкаНезаполненного     = ВидОперации = 1;
	Элементы.ДатаОкончания.АвтоОтметкаНезаполненного = ВидОперации = 1;
	
	Элементы.Предприятие.АвтоВыборНезаполненного = ПредприятиеВсе;
	Элементы.Предприятие.ОтметкаНезаполненного = ПредприятиеВсе;
	
	УстановитьВидимостьСведенийОбОтправителе();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьСведенийОбОтправителе()
	
	Элементы.ГруппаЗагрузкаВсехВСД.Видимость = ТипВСД <> ПредопределенноеЗначение("Справочник.ТипыВСД.ПроизводственныйВСД") И ВидОперации = 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтформатироватьИдентификаторыВСД(ИдентификаторыВСД)
	Перем ИдентификаторВСД, ПозицияВМассивеИдентификаторовВСД;
	
	Для ПозицияВМассивеИдентификаторовВСД = 0 По ИдентификаторыВСД.ВГраница() Цикл
		ИдентификаторВСД = ИдентификаторыВСД[ПозицияВМассивеИдентификаторовВСД];
		ИдентификаторВСД = СтрЗаменить(СокрЛП(Нрег(ИдентификаторВСД)), "-", "");
		ИдентификаторВСД = Сред(ИдентификаторВСД, 1, 8) 
		+ "-" + Сред(ИдентификаторВСД, 9, 4) 
		+ "-" + Сред(ИдентификаторВСД, 13, 4)
		+ "-" + Сред(ИдентификаторВСД, 17, 4)
		+ "-" + Сред(ИдентификаторВСД, 21);
		ИдентификаторыВСД[ПозицияВМассивеИдентификаторовВСД] = ИдентификаторВСД;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ВсеПредприятиеПриИзменении(Элемент)
	 УстановитьСвойстваЭлементовФормы();
КонецПроцедуры

#КонецОбласти