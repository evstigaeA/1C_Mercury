﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Организация = ОбщегоНазначенияУВСВызовСервера.ОрганизацияТекущегоПользователя();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация"    , Организация);
	ПараметрыФормы.Вставить("БезПользователя", Истина);
	ПараметрыФормы.Вставить("БезОснования"   , Истина);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("МассивПродукции", ПараметрКоманды);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВводДополнительныхЗначенийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВводаДополнительныхЗначений", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры
&НаКлиенте
Процедура ВводДополнительныхЗначенийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	РезультатВыполненияОперации = ИнтеграцияВетисAPIВызовСервера.ОбновитьДанныеПоПродукции(ДополнительныеПараметры.МассивПродукции, Результат.Организация, Результат.Пользователь);
	
	Если ЗначениеЗаполнено(РезультатВыполненияОперации.ОписаниеОшибки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Операция не выполнена:'") + РезультатВыполненияОперации.ОписаниеОшибки);

	Иначе
		
		ТекстОшибки = НСтр("ru = 'При выполнении операции по продукции <%1> произошли ошибки:
							|%2'");

		ТекстУспешногоВыполнения = НСтр("ru = 'Выполнение операции по продукции <%1> прошло успешно.'");
		
		ДанныеРезультата = РезультатВыполненияОперации.Продукция;
		
		Для Каждого ТекРезультат Из ДанныеРезультата Цикл
			
			Если ЗначениеЗаполнено(ТекРезультат.ОписаниеОшибки) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ТекРезультат.Продукция, ТекРезультат.ОписаниеОшибки), ТекРезультат.Продукция);
							
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстУспешногоВыполнения, ТекРезультат.Продукция), ТекРезультат.Продукция);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Оповестить("ОбновлениеДанныхПродукции");
КонецПроцедуры

#КонецОбласти