﻿
&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	Объект.Предприятия.Очистить();
	ВыполнитьОбработкуНаСервере();
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Завершено");
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбработкуНаСервере()
	
	лЗапрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Предприятия.Ссылка КАК Предприятие,
	|	НастройкиПодключенияКВетисAPI.Контрагент КАК КонтрагентВетисАПИ,
	|	СвязиМеждуКонтрагентамиИПредприятиями.Контрагент КАК КонтрагентСвязи,
	|	Предприятия.КонтрагентСобственник КАК КонтрагентСобственник,
	|	Предприятия.ДМ_ГлобальныйНомер КАК Предприятие_ГлобальныйНомер,
	|	Организации.ДМ_ГлобальныйНомер КАК Организация_ГлобальныйНомер
	|ИЗ
	|	Справочник.Предприятия КАК Предприятия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НастройкиПодключенияКВетисAPI КАК НастройкиПодключенияКВетисAPI
	|			ПО Организации.Ссылка = НастройкиПодключенияКВетисAPI.Организация
	|		ПО Предприятия.ДМ_Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиМеждуКонтрагентамиИПредприятиями КАК СвязиМеждуКонтрагентамиИПредприятиями
	|		ПО (СвязиМеждуКонтрагентамиИПредприятиями.Предприятие = Предприятия.Ссылка)
	|ГДЕ
	|	Предприятия.ДМ_НомерПланта > 0
	|	И СвязиМеждуКонтрагентамиИПредприятиями.Контрагент ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	Предприятия.Наименование"
	);
	лРезультат = лЗапрос.Выполнить();
	Если лРезультат.Пустой() Тогда
	
		Возврат;
	
	КонецЕсли;
	
	лВыборка = лРезультат.Выбрать();
	Пока лВыборка.Следующий() Цикл
	
		лСтруктура = Новый Структура("Контрагент,Предприятие,GLN", лВыборка.КонтрагентВетисАПИ, лВыборка.Предприятие, лВыборка.Предприятие_ГлобальныйНомер );
		Если ЗначениеЗаполнено( лВыборка.КонтрагентСобственник ) Тогда
			лСтруктура.Контрагент = лВыборка.КонтрагентСобственник;
		КонецЕсли;
		Если Не ЗначениеЗаполнено( лСтруктура.GLN ) Тогда
			лСтруктура.GLN = лВыборка.Предприятие_ГлобальныйНомер;
		КонецЕсли;
		Если Не ЗначениеЗаполнено( лСтруктура.GLN ) Тогда
			лСтруктура.GLN = лВыборка.Организация_ГлобальныйНомер;
		КонецЕсли;
		
		РегистрыСведений.СвязиМеждуКонтрагентамиИПредприятиями.ДобавитьЗапись( лСтруктура, Истина );
		
		лСтрокаТЧ = Объект.Предприятия.Добавить();
		лСтрокаТЧ.Предприятие 	= лСтруктура.Предприятие;
		лСтрокаТЧ.ХС			= лСтруктура.Контрагент;
	
	КонецЦикла;
	
КонецПроцедуры
