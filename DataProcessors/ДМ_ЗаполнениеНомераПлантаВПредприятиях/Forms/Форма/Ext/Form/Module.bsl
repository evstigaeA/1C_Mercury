﻿
&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	Объект.Предприятия.Очистить();
	лЗапрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Предприятия.Ссылка КАК Ссылка,
	|	Предприятия.ДМ_НомерПланта КАК ДМ_НомерПланта,
	|	Предприятия.Наименование КАК Наименование,
	|	Предприятия.ДМ_Организация КАК ДМ_Организация
	|ИЗ
	|	Справочник.Предприятия КАК Предприятия
	|ГДЕ
	|	Предприятия.ПометкаУдаления = ЛОЖЬ
	|	И (Предприятия.ДМ_НомерПланта < ""0""
	|			ИЛИ Предприятия.ДМ_Организация = &ДМ_Организация)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование"
	);
	лПустаяОрганизация = Справочники.Организации.ПустаяСсылка();
	лЗапрос.УстановитьПараметр( "ДМ_Организация", лПустаяОрганизация );
	лРезультат = лЗапрос.Выполнить();
	Если лРезультат.Пустой() Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( НСтр("ru = 'Нет предприятий без номера планта'") );
		Возврат;
	
	КонецЕсли;
	
	лВыборка = лРезультат.Выбрать();
	Пока лВыборка.Следующий() Цикл
		
		лНоваяСтрока = Неопределено;
		лНомерПланта = "";
		лОрганизация = лПустаяОрганизация;
		
		Если ПустаяСтрока(лВыборка.ДМ_НомерПланта) Тогда
			лНаименование = СокрЛП(лВыборка.Наименование);
			лНомерПланта = Прав( лНаименование, 5 );
			лНомерПланта = СокрЛП(лНомерПланта);
			Если СтрДлина( лНомерПланта ) = 4 Тогда
				Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке( лНомерПланта ) Тогда
					лНоваяСтрока = Объект.Предприятия.Добавить();
					лНоваяСтрока.ДМ_НомерПланта = лНомерПланта;
				Иначе
					лНомерПланта = "";
				КонецЕсли;
			Иначе
				лНомерПланта = "";
			КонецЕсли;
		Иначе
			лНомерПланта = лВыборка.ДМ_НомерПланта;
		КонецЕсли;
		
		Если лНомерПланта <> "" Тогда
		
			Если лВыборка.ДМ_Организация = лПустаяОрганизация Тогда
			
				лОрганизация = ДМ_СлужебныйПривилегированный.НайтиЭлементСправочникаПоРеквизиту( "Организации", "ДМ_КодSAP", лНомерПланта );
				Если лОрганизация <> лПустаяОрганизация Тогда
					Если лНоваяСтрока <> Неопределено Тогда
						лНоваяСтрока.Организация = лОрганизация;
					Иначе
						лНоваяСтрока = Объект.Предприятия.Добавить();
						лНоваяСтрока.ДМ_НомерПланта = лНомерПланта;
						лНоваяСтрока.Организация = лОрганизация;
					КонецЕсли;
				КонецЕсли;
			
			Иначе
				лОрганизация = лВыборка.ДМ_Организация;
				Если лНоваяСтрока <> Неопределено Тогда
					лНоваяСтрока.Организация = лВыборка.ДМ_Организация;
				КонецЕсли;
			КонецЕсли;
		
		КонецЕсли;
		
		Если лНоваяСтрока <> Неопределено Тогда
			лНоваяСтрока.Обновлять = Истина;
			лНоваяСтрока.Предприятие = лВыборка.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Объект.Предприятия.Количество() = 0 Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( НСтр("ru = 'Нет подходящих данных для заполнения'") );
		Возврат;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	ЗаполнитьТаблицуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСправочникПредприятияНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого лСтрокаТЧ Из Объект.Предприятия Цикл
	
		Если Не лСтрокаТЧ.Обновлять Тогда
			Продолжить;
		КонецЕсли;
		
		лПредприятие = лСтрокаТЧ.Предприятие.ПолучитьОбъект();
		лПредприятие.Заблокировать();
		лПредприятие.ДМ_НомерПланта = лСтрокаТЧ.ДМ_НомерПланта;
		Если ЗначениеЗаполнено( лСтрокаТЧ.Организация ) Тогда
			лПредприятие.ДМ_Организация = лСтрокаТЧ.Организация;
		КонецЕсли;
		лПредприятие.Записать();
		лПредприятие.Разблокировать();
		
		лСтрокаТЧ.Обновлять = Ложь;
		лСтрокаТЧ.Выполнено = Истина;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСправочникПредприятия(Команда)
	ОбновитьСправочникПредприятияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредприятияПредприятиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Элементы.Предприятия.ТекущиеДанные.Предприятие) Тогда
		лЗначенияРеквизитов = ЗначенияРеквизитовПредприятия( Элементы.Предприятия.ТекущиеДанные.Предприятие );
		лНомерПланта = лЗначенияРеквизитов.ДМ_НомерПланта;
		Если ЗначениеЗаполнено(лНомерПланта) Тогда
			Элементы.Предприятия.ТекущиеДанные.ДМ_НомерПланта = лНомерПланта;
		КонецЕсли;
		Если ЗначениеЗаполнено(лЗначенияРеквизитов.ДМ_Организация) Тогда
			Элементы.Предприятия.ТекущиеДанные.Организация = лЗначенияРеквизитов.ДМ_Организация;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значения некоторых реквизитов предприятия
//
// Параметры:
//  пСсылка  - СправочникСсылка.Предприятия - Предприятие, для которого нужно
//                 получить реквизиты
//
// Возвращаемое значение:
//   Структура   - Структура со значениями ревизитов
//
&НаСервереБезКонтекста
Функция ЗначенияРеквизитовПредприятия( пСсылка )

	лЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта( пСсылка, "ДМ_НомерПланта,ДМ_Организация" );
	Возврат лЗначенияРеквизитов;

КонецФункции // ЗначенияРеквизитовПредприятия()

