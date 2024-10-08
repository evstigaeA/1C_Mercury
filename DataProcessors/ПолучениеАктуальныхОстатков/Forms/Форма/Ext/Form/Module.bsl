﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

#КонецОбласти

#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Ответственный") Тогда
		Объект.Ответственный = Параметры.Ответственный;
	Иначе
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	Иначе
		Объект.Организация = ?(ЗначениеЗаполнено(Объект.Организация), Объект.Организация, ПараметрыСеанса.ТекущийПользователь.ОсновнаяОрганизация);
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") Тогда
		Объект.Контрагент = Параметры.Контрагент;
	Иначе
		Объект.Контрагент = ОбщегоНазначенияУВССервер.КонтрагентПоОрганизации(Объект.Организация);
	КонецЕсли;
	
	Если Параметры.Свойство("ОтветственныйВидимость") Тогда
		Элементы.Ответственный.Видимость = Параметры.ОтветственныйВидимость;
	КонецЕсли;
	
	Если Параметры.Свойство("ОрганизацияВидимость") Тогда
		Элементы.Организация.Видимость = Параметры.ОрганизацияВидимость;
	КонецЕсли;
	
	Если Параметры.Свойство("КонтрагентВидимость") Тогда
		Элементы.Контрагент.Видимость = Параметры.КонтрагентВидимость;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементовПоВидуОперации();
	
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
	Текст = НСтр("ru = 'Прервать загрузку списка актуальных записей складского журнала?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

#Область ОбработчикиСобытий_Органиазация

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Контрагент = ОбщегоНазначенияУВСВызовСервера.КонтрагентПоОрганизации(Объект.Организация);
	Объект.ТаблицаЗаписейСкладскогоЖурнала.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий_Предприятие

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)

	ОбщегоНазначенияУВСКлиент.ПредприятиеПриИзменении(Объект.Контрагент, Объект.Предприятие);
	Объект.ТаблицаЗаписейСкладскогоЖурнала.Очистить();

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

#Область ОбработчикиСобытий_ВидОперации

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементовПоВидуОперации();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьАктуальныеОстаткиВыполнение()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФильтра = Новый Структура;
	ПараметрыФильтра.Вставить("Организация",      Объект.Организация);
	ПараметрыФильтра.Вставить("Контрагент",       Объект.Контрагент);
	ПараметрыФильтра.Вставить("Предприятие",      Объект.Предприятие);
	ПараметрыФильтра.Вставить("Ответственный",    Объект.Ответственный);
	ПараметрыФильтра.Вставить("ФильтрПоОстаткам", ВидПолучаемыхЗаписей);
	Если ВидОперации = 0 Тогда
		ПараметрыФильтра.Вставить("ДатаНачала"   , Объект.ДатаНачала);
		ПараметрыФильтра.Вставить("ДатаОкончания", Объект.ДатаОкончания);
	ИначеЕсли ВидОперации = 1 Тогда
		ПараметрыФильтра.Вставить("МассивОбновляемыхЗаписей", МассивОбновляемыхЗаписей())
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка данных из ИС ""Меркурий""...'");
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
	Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(ПараметрыФильтра, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	НастройкиОжидания.ПолучатьРезультат = Истина;
	НастройкиОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессеВыполнения;
	
	Обработчик = Новый ОписаниеОповещения("ПослеФоновойЗагрузкиССайта", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
	ИдентификаторЗадания = Задание.ИдентификаторЗадания;
	
	// Запущенное
	Элементы.ПрерватьЗагрузку.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиССайта(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда
		ТекстОшибки = НСтр("ru = 'Загрузка актуальных записей складского журнала не выполнена. Произошла ошибка: '") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
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
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ЗагрузкаОстатков;
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультат(АдресРезультата)
	
	РезультатВыполненияОперации = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	УдалитьИзВременногоХранилища(АдресРезультата);
	
	ОбработатьРезультатВыполненияОперации(РезультатВыполненияОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузки()
	
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ЗагрузкаОстатков;
	
	Возврат;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуССайтаНаСервере(ПараметрыФильтра, УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка актуальных записей складского журнала'");

	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIОтправкаЗаявокНаОформление.ФоновоеЗаданиеЗагрузкаАктуальныхОстатков",
		ПараметрыФильтра, ПараметрыВыполнения);
		
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
Процедура ПолучитьАктуальныеОстатки(Команда)
	
	Если ВидОперации = 0 Тогда
		
		Если Объект.ТаблицаЗаписейСкладскогоЖурнала.Количество() > 0 Тогда
			
			ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?'");
			
			Ответ = Неопределено;
			
			ПоказатьВопрос(Новый ОписаниеОповещения("ПолучитьАктуальныеОстаткиЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Возврат;
			
		КонецЕсли;
		
		Если Не КонтрольНезакрытыхДокументов() Тогда
			
			ТекстВопроса = НСтр("ru='Существуют необработанные заявки. Рекомендуется дождаться их обработки, т.к. возможны расхождения по остаткам. Продолжить?'");
			
			Ответ = Неопределено;
			
			ПоказатьВопрос(Новый ОписаниеОповещения("ПолучитьАктуальныеОстаткиЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПолучитьАктуальныеОстаткиВыполнение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАктуальныеОстаткиЗавершение(Результат, Параметр) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	
	Объект.ТаблицаЗаписейСкладскогоЖурнала.Очистить();
	
	ПолучитьАктуальныеОстаткиВыполнение();
КонецПроцедуры

&НаСервере
Функция КонтрольНезакрытыхДокументов()
	
	СтатусыНезакрытыхДокументов = Новый СписокЗначений;
	СтатусыНезакрытыхДокументов.Добавить(Справочники.СтатусыЗаявок.IDОтправлен);
	СтатусыНезакрытыхДокументов.Добавить(Справочники.СтатусыЗаявок.IDПолучен);
	СтатусыНезакрытыхДокументов.Добавить(Справочники.СтатусыЗаявок.Обрабатывается);
	СтатусыНезакрытыхДокументов.Добавить(Справочники.СтатусыЗаявок.Отправлена);
	СтатусыНезакрытыхДокументов.Добавить(Справочники.СтатусыЗаявок.ОшибкаОбработкиОтвета);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка КАК Ссылка,
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.ДокументСсылка.Представление КАК Представление
		|ИЗ
		|	РегистрСведений.ЖурналРегистрацииСостоянийЗаявокНаОформлениеОпераций.СрезПоследних(
		|			,
		|			ДокументСсылка.Организация = &Организация
		|				И ВЫБОР
		|					КОГДА ДокументСсылка ССЫЛКА Документ.ПриходныеОперации
		|						ТОГДА ДокументСсылка.ПредприятиеПолучатель = &Предприятие
		|					КОГДА ДокументСсылка ССЫЛКА Документ.ПроизводственныеОперации
		|							ИЛИ ДокументСсылка ССЫЛКА Документ.Инвентаризации
		|							ИЛИ ДокументСсылка ССЫЛКА Документ.ОбъединениеЗаписейСкладскогоЖурнала
		|							ИЛИ ДокументСсылка ССЫЛКА Документ.АннулированиеВСД
		|						ТОГДА ДокументСсылка.Предприятие = &Предприятие
		|					КОГДА ДокументСсылка ССЫЛКА Документ.ТранспортныеОперации
		|						ТОГДА ДокументСсылка.ПредприятиеОтправитель = &Предприятие
		|				КОНЕЦ) КАК ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних
		|ГДЕ
		|	ЖурналРегистрацииСостоянийЗаявокНаОформлениеОперацийСрезПоследних.Статус В(&СтатусыНезакрытыхДокументов)";
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Предприятие", Объект.Предприятие);
	Запрос.УстановитьПараметр("СтатусыНезакрытыхДокументов", СтатусыНезакрытыхДокументов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Список необработанных заявок:'"));
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
								Выборка.Представление,
								Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ВвестиКорректировкуОстатков(Команда)
	
	СоздатьДокументКорректировкиОстатковЗаписейСкладскогоЖурнала();
	Если ЗначениеЗаполнено(СсылкаНаДокумент) Тогда
		ПоказатьЗначение(,СсылкаНаДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из Объект.ТаблицаЗаписейСкладскогоЖурнала Цикл
		ТекСтрока.СоздатьКорректировку = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из Объект.ТаблицаЗаписейСкладскогоЖурнала Цикл
		ТекСтрока.СоздатьКорректировку = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоВсемЗаписям(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация"       , Объект.Организация);
	ПараметрыФормы.Вставить("Предприятие"       , Объект.Предприятие);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПодборЗаписейЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.СвойстваЗаписейСкладскогоЖурнала.ФормаВыбора", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткам(Команда)
	
	ПараметрЗаголовок = НСтр("ru = 'Подбор продукции в обработку ""Получение актуальных остатков""'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация"       , Объект.Организация);
	ПараметрыФормы.Вставить("Предприятие"       , Объект.Предприятие);
	ПараметрыФормы.Вставить("Заголовок"         , ПараметрЗаголовок);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПодборЗаписейЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.СвойстваЗаписейСкладскогоЖурнала.Форма.ФормаВыбораСОстатками", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборЗаписейЗавершение(МассивПодобранныхЗаписей, ДополнительныеПараметры) Экспорт
	
	Если МассивПодобранныхЗаписей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПодборЗаписейСкладскогоЖурнала(МассивПодобранныхЗаписей);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(Объект.ДатаНачала, Объект.ДатаОкончания);
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПослеВыбораПериода",ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеВыбораПериода(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.ДатаНачала    = Результат.ДатаНачала;
		Объект.ДатаОкончания = Результат.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗаписейСкладскогоЖурнала

&НаКлиенте
Процедура ТаблицаЗаписейСкладскогоЖурналаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаЗаписейСкладскогоЖурнала.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ТаблицаЗаписейСкладскогоЖурналаЗаписьСкладскогоЖурнала" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.ЗаписьСкладскогоЖурнала) Тогда
			ПоказатьЗначение(, ТекущиеДанные.ЗаписьСкладскогоЖурнала);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ТаблицаЗаписейСкладскогоЖурналаПродукция" Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Продукция) И ТипЗнч(ТекущиеДанные.Продукция) <> Тип("Строка") Тогда
			ПоказатьЗначение(, ТекущиеДанные.Продукция);
		КонецЕсли;
		
	ИначеЕсли Поле.Имя = "ТаблицаЗаписейСкладскогоЖурналаИнформация" Тогда
		
		Если ТекущиеДанные.Информация <> 0 Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РезультатОбработкиЗаявки", ТекущиеДанные.РезультатОбработкиЗаявки);
		
		ОткрытьФорму("Обработка.ИнформацияОбработкиЗапроса.Форма.Форма", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЗаписейСкладскогоЖурналаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСозданияДокументаКорректировкиОстатков

&НаСервере
Процедура СоздатьДокументКорректировкиОстатковЗаписейСкладскогоЖурнала()
	
	Если ВидОперации = 0 Тогда
		ТаблицаЗаписей = Объект.ТаблицаЗаписейСкладскогоЖурнала.Выгрузить(Новый Структура("СоздатьКорректировку", Истина));
	Иначе
		ТаблицаЗаписей = Объект.ТаблицаЗаписейСкладскогоЖурнала.Выгрузить(Новый Структура("СоздатьКорректировку, Статус", Истина, 2));
	КонецЕсли;
	Если ТаблицаЗаписей.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрано записей для создания документа ""Корректировка остатков записей складского журнала"".'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("Организация",		Объект.Организация);
	ПараметрыСоздания.Вставить("Контрагент",		Объект.Контрагент);
	ПараметрыСоздания.Вставить("Предприятие",		Объект.Предприятие);
	ПараметрыСоздания.Вставить("Ответственный",		Объект.Ответственный);
	ПараметрыСоздания.Вставить("СсылкаНаДокумент",	Документы.КорректировкаОстатковЗаписейСкладскогоЖурнала.ПустаяСсылка());
	
	Обработки.ПолучениеАктуальныхОстатков.СоздатьДокументКорректировкиОстатковЗаписейСкладскогоЖурнала(ПараметрыСоздания, ТаблицаЗаписей);
	СсылкаНаДокумент = ПараметрыСоздания.СсылкаНаДокумент;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьРезультатВыполненияОперации(РезультатВыполненияОперации)
	
	ТаблицаЗаписей = РезультатВыполненияОперации.Результат;
	
	Если ВидОперации = 0 Тогда
		
		Объект.ТаблицаЗаписейСкладскогоЖурнала.Загрузить(ТаблицаЗаписей);
		
	Иначе
		
		Для Каждого ТекСтрока Из Объект.ТаблицаЗаписейСкладскогоЖурнала Цикл
			
			НайденнаяСтрока = ТаблицаЗаписей.Найти(ТекСтрока.GUID_Меркурий, "GUID_Меркурий");
			
			ЗаполнитьЗначенияСвойств(ТекСтрока, НайденнаяСтрока);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

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

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЗаписейСкладскогоЖурналаЗаписьСкладскогоЖурнала.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаЗаписейСкладскогоЖурнала.ЗаписьСкладскогоЖурнала");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.СвойстваЗаписейСкладскогоЖурнала.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<в базе не обнаружена>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаЗаписейСкладскогоЖурналаПродукция.Имя);

	СписокНеЗаполненыхЗначений = Новый СписокЗначений;
	СписокНеЗаполненыхЗначений.Добавить(Неопределено);
	СписокНеЗаполненыхЗначений.Добавить(Справочники.Продукция.ПустаяСсылка());
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаЗаписейСкладскогоЖурнала.Продукция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокНеЗаполненыхЗначений;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<четвертый уровень не указан>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЭлементовПоВидуОперации()
	
	Элементы.ТаблицаЗаписейСкладскогоЖурналаПодбор.Видимость       = ВидОперации = 1;
	Элементы.ТаблицаЗаписейСкладскогоЖурналаГруппаСтатус.Видимость = ВидОперации = 1;
	Элементы.ТаблицаЗаписейСкладскогоЖурналаИнформация.Видимость   = ВидОперации = 1;
	Элементы.ПолучаемыеЗаписи.Видимость                            = ВидОперации = 0;
	Элементы.ГруппаПериод.Видимость                                = ВидОперации = 0;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодборЗаписейСкладскогоЖурнала(МассивПодобранныхЗаписей)
	
	Для Каждого ТекЗапись Из МассивПодобранныхЗаписей Цикл
		
		СтруктураПоиска = Новый Структура("ЗаписьСкладскогоЖурнала", ТекЗапись);
		
		НайденныеСтроки = Объект.ТаблицаЗаписейСкладскогоЖурнала.НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТекущаяСтрока = НайденныеСтроки[0];
		Иначе
			ТекущаяСтрока = Объект.ТаблицаЗаписейСкладскогоЖурнала.Добавить();
		КонецЕсли;
		
		ТекущаяСтрока.ЗаписьСкладскогоЖурнала = ТекЗапись;
		ТекущаяСтрока.GUID_Меркурий           = ТекЗапись.GUID_Меркурий;
		ТекущаяСтрока.ЕдиницаИзмерения        = ТекЗапись.ЕдиницаИзмерения;
		ТекущаяСтрока.НомерЗаписиЖурнала      = ТекЗапись.НомерЗаписиЖурнала;
		ТекущаяСтрока.Продукция               = ТекЗапись.Продукция;
		ТекущаяСтрока.Информация              = 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция МассивОбновляемыхЗаписей()
	
	МассивЗаписей = Новый Массив;
	Для Каждого ТекСтрока Из Объект.ТаблицаЗаписейСкладскогоЖурнала Цикл
		МассивЗаписей.Добавить(ТекСтрока.ЗаписьСкладскогоЖурнала);
	КонецЦикла;
	
	Возврат МассивЗаписей;
	
КонецФункции

#КонецОбласти