﻿
&НаСервере
Функция ПолучитьСтруктуру()
	
	СтруктуОтбора = Новый Структура;
	КонтрагентПустой = Справочники.Контрагенты.ПустаяСсылка();
	ПредприятиеПустой = Справочники.Предприятия.ПустаяСсылка();
	ПриходнаяОперация = Документы.ПриходныеОперации.ПустаяСсылка();
	СтруктуОтбора.Вставить("Организация", Объект.Организация);
	СтруктуОтбора.Вставить("ДатаНачало", Объект.ДатаНачала);
	СтруктуОтбора.Вставить("ДатаОкончания", Объект.ДатаОкончания);
	СтруктуОтбора.Вставить("Организация", Объект.Организация);
	СтруктуОтбора.Вставить("ВидВСД", Объект.ВидВСД);
	СтруктуОтбора.Вставить("ТипВСД", Объект.ТипВСД);	
	СтруктуОтбора.Вставить("КонтрагентПолучатель", Объект.КонтрагентПолучатель);
	СтруктуОтбора.Вставить("ПредприятиеПолучатель", Объект.ПредприятиеПолучатель);
	СтруктуОтбора.Вставить("КонтрагентОтправитель",  Объект.КонтрагентОтправитель);
	СтруктуОтбора.Вставить("ПредприятиеОтправитель", Объект.ПредприятиеОтправитель);
	СтруктуОтбора.Вставить("КонтрагентПустой", КонтрагентПустой);
	СтруктуОтбора.Вставить("ПредприятиеПустой", ПредприятиеПустой);
	СтруктуОтбора.Вставить("ЕстьКонтрагентПолучатель", Не Объект.КонтрагентПолучатель = КонтрагентПустой);
	СтруктуОтбора.Вставить("ЕстьПредприятиеПолучатель",Не Объект.ПредприятиеПолучатель = ПредприятиеПустой);
	СтруктуОтбора.Вставить("ЕстьКонтрагентОтправитель", Не Объект.КонтрагентОтправитель = КонтрагентПустой);
	СтруктуОтбора.Вставить("ЕстьПредприятиеОтправитель", Не Объект.ПредприятиеОтправитель = ПредприятиеПустой);
	СтруктуОтбора.Вставить("ПриходнаяОперация", ПриходнаяОперация);

	Возврат СтруктуОтбора;
	
КонецФункции

Функция ПолучитьТаблицуВСД(СтруктуОтбора)  Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВСД.Ссылка КАК ВСД,
	|	&ПриходнаяОперация КАК ПриходнаяОперация
	|ИЗ
	|	Документ.ВСД КАК ВСД
	|ГДЕ
	|	ВСД.Дата МЕЖДУ &ДатаНачало И &ДатаОкончания
	|	И НЕ ВСД.ПометкаУдаления
	|	И ВСД.Проведен
	|	И ВСД.Организация = &Организация
	|	И ВЫБОР
	|			КОГДА &ЕстьКонтрагентПолучатель
	|				ТОГДА ВСД.КонтрагентПолучатель = &КонтрагентПолучатель
	|			ИНАЧЕ ВСД.КонтрагентПолучатель <> &КонтрагентПустой
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ЕстьКонтрагентОтправитель
	|				ТОГДА ВСД.КонтрагентОтправитель = &КонтрагентОтправитель
	|			ИНАЧЕ ВСД.КонтрагентОтправитель <> &КонтрагентПустой
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ЕстьПредприятиеПолучатель
	|				ТОГДА ВСД.ПредприятиеПолучатель = &ПредприятиеПолучатель
	|			ИНАЧЕ ВСД.ПредприятиеПолучатель <> &ПредприятиеПустой
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ЕстьПредприятиеОтправитель
	|				ТОГДА ВСД.ПредприятиеОтправитель = &ПредприятиеОтправитель
	|			ИНАЧЕ ВСД.ПредприятиеОтправитель <> &ПредприятиеПустой
	|		КОНЕЦ
	|	И ВСД.ВидВСД = &ВидВСД
	|	И ВСД.ТипВСД = &ТипВСД
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВСД.Ссылка";
	Запрос.УстановитьПараметр("Организация", СтруктуОтбора.Организация);
	Запрос.УстановитьПараметр("ДатаНачало", СтруктуОтбора.ДатаНачало);
	Запрос.УстановитьПараметр("ДатаОкончания", СтруктуОтбора.ДатаОкончания);
	Запрос.УстановитьПараметр("Организация", СтруктуОтбора.Организация);
	Запрос.УстановитьПараметр("ВидВСД", СтруктуОтбора.ВидВСД);
	Запрос.УстановитьПараметр("ТипВСД", СтруктуОтбора.ТипВСД);	
	Запрос.УстановитьПараметр("КонтрагентПолучатель", СтруктуОтбора.КонтрагентПолучатель);
	Запрос.УстановитьПараметр("ПредприятиеПолучатель", СтруктуОтбора.ПредприятиеПолучатель);
	Запрос.УстановитьПараметр("КонтрагентОтправитель",  СтруктуОтбора.КонтрагентОтправитель);
	Запрос.УстановитьПараметр("ПредприятиеОтправитель", СтруктуОтбора.ПредприятиеОтправитель);
	Запрос.УстановитьПараметр("КонтрагентПустой", СтруктуОтбора.КонтрагентПустой);
	Запрос.УстановитьПараметр("ПредприятиеПустой", СтруктуОтбора.ПредприятиеПустой);
	Запрос.УстановитьПараметр("ЕстьКонтрагентПолучатель", СтруктуОтбора.ЕстьКонтрагентПолучатель);
	Запрос.УстановитьПараметр("ЕстьПредприятиеПолучатель",СтруктуОтбора.ЕстьПредприятиеПолучатель);
	Запрос.УстановитьПараметр("ЕстьКонтрагентОтправитель", СтруктуОтбора.ЕстьКонтрагентОтправитель);
	Запрос.УстановитьПараметр("ЕстьПредприятиеОтправитель", СтруктуОтбора.ЕстьПредприятиеОтправитель);
	Запрос.УстановитьПараметр("ПриходнаяОперация", СтруктуОтбора.ПриходнаяОперация);
	
	Объект.СписокВСД.Загрузить(Запрос.Выполнить().Выгрузить());
	Возврат Истина;
	
КонецФункции


Процедура ВыписатьВСДСписком()
	Для Каждого СтрокаВСД Из Объект.СписокВСД Цикл
		НовойПриход = Документы.ПриходныеОперации.СоздатьДокумент();
		НовойПриход.Заполнить(СтрокаВСД.ВСД);
		НовойПриход.Записать(РежимЗаписиДокумента.Проведение);
		СтрокаВСД.ПриходнаяОперация = НовойПриход.Ссылка;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Объект.СписокВСД.Очистить();
	ТаблицаВСД = ПолучитьТаблицуВСД(ПолучитьСтруктуру());

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.КонтрагентПолучатель = ОбщегоНазначенияУВСВызовСервера.КонтрагентПоОрганизации(Объект.Организация);
КонецПроцедуры


&НаКлиенте
Процедура КонтрагентОтправительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентНачалоВыбора(Элемент, СтандартнаяОбработка,, Объект.ПредприятиеОтправитель);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтправительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.ПредприятиеОтправитель, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтправительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.ПредприятиеОтправитель, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентНачалоВыбора(Элемент, СтандартнаяОбработка,, Объект.ПредприятиеПолучатель);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПолучательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.ПредприятиеПолучатель, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПолучательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.КонтрагентОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.ПредприятиеПолучатель, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОтправительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеНачалоВыбора(Элемент, СтандартнаяОбработка,, Объект.КонтрагентОтправитель, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОтправительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.КонтрагентОтправитель, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеОтправительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка,, Объект.КонтрагентОтправитель, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеНачалоВыбора(Элемент, СтандартнаяОбработка, Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПолучательАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПолучательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ОбщегоНазначенияУВСКлиент.ПредприятиеОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка, Объект.Организация);
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


&НаКлиенте
Процедура Очистить(Команда)
	Объект.СписокВСД.Очистить();
КонецПроцедуры


&НаКлиенте
Процедура ВыписатьВСД(Команда)
	
	ВыписатьВСДСписком();
	
КонецПроцедуры

