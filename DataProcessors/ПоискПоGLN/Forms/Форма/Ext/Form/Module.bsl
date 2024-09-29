﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
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
	Текст = НСтр("ru = 'Прервать получение данных?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

&НаКлиенте
Процедура СписокGLNНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("СписокЗначений", СписокGLN);
	ПараметрыФормы.Вставить("СписокТипов"   , Новый ОписаниеТипов("Строка"));
	ПараметрыФормы.Вставить("Представление" , НСтр("ru = 'Указание списка GLN.'"));
	ПараметрыФормы.Вставить("Сценарий"      , "ЗагрузкаGLN");
	
	Оповещение = Новый ОписаниеОповещения("СписокGLNОкончаниеВыбора", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСписком", ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокGLNОкончаниеВыбора(МассивИдентификаторов, ДополнительныеПараметры) Экспорт
	
	Если МассивИдентификаторов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(МассивИдентификаторов) = Тип("Массив") Тогда
		СписокGLN.ЗагрузитьЗначения(МассивИдентификаторов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка данных из ИС ""Меркурий""...'");
	
	ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ПрогрессВыполнения", ЭтотОбъект);
	Задание = ЗапуститьФоновуюЗагрузкуССайтаНаСервере(СписокGLN, УникальныйИдентификатор);
	
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
Процедура ПрерватьЗагрузку(Команда)
	
	Если ИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПрерватьЗагрузкуСервер();
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновойЗагрузкиССайта(Задание, ДополнительныеПараметры) Экспорт

	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Задание.Статус = "Ошибка" Тогда
		ТекстОшибки = НСтр("ru = 'При получении списка пар хозяйствующий субъект предприятие: '") + Символы.ПС + Задание.КраткоеПредставлениеОшибки;
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
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ПоискДанных;
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультат(АдресРезультата)
	
	РезультатВыполненияОперации = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если РезультатВыполненияОперации.КоличествоНайденных = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ничего не найдено. Уточните список GLN для поиска.'"));
	Иначе
		ТаблицаДанных.Загрузить(РезультатВыполненияОперации.Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеЗагрузки()
	
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ПоискДанных;
	Элементы.ЗагрузитьВыбранные.КнопкаПоУмолчанию = Истина;
	ТекущийЭлемент = Элементы.ЗагрузитьВыбранные;
	
	Возврат;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновуюЗагрузкуССайтаНаСервере(СписокGLN, УникальныйИдентификатор)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка списка пар хозяйствующий субъект предприятие'");

	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне("ИнтеграцияВетисAPIКонтрагентыПредприятия.ФоновоеЗаданиеПолучениеСвязиКонтрагентПредприятиеПоGLN",
		СписокGLN, ПараметрыВыполнения);
		
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
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из ТаблицаДанных Цикл
		Если ТекСтрока.Статус = 2 Тогда
			ТекСтрока.Загружать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из ТаблицаДанных Цикл
		ТекСтрока.Загружать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыбранные(Команда)
	
	ЗагрузитьВыбранныеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВыбранныеНаСервере()
	
	ДанныеДляЗагрузки = ТаблицаДанных.НайтиСтроки(Новый Структура("Загружать, Статус", Истина, 2));
	
	Если ДанныеДляЗагрузки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбраны данные для загрузки.'"));
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	ИнтеграцияВетисAPIКонтрагентыПредприятия.ЗагрузитьСвязиКонтрагентовПредприятийПоGLN(ДанныеДляЗагрузки, ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПредставлениеОшибки = НСтр("ru = 'При загрузке произошли ошибки:'") + Символы.ПС + ТекстОшибки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Загрузка завершена.'"));
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

#КонецОбласти