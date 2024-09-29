﻿&НаСервере
Процедура УдалитьКолонкиСНулевойШириной(ТаблицаРезультат)
	Перем МассивПустыхКолонок;
	
	// Найдем пустые колонки.
	МассивПустыхКолонок = Новый Массив;
	Для Каждого Колонка ИЗ ТаблицаРезультат.Колонки Цикл
		Если Колонка.Ширина = 0 Тогда
			МассивПустыхКолонок.Добавить(Колонка.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Удалим пустые колонки.
	Для Каждого ПустаяКолонка ИЗ МассивПустыхКолонок Цикл
		ТаблицаРезультат.Колонки.Удалить(ПустаяКолонка);
	КонецЦикла;
	
КонецПроцедуры

// ПРЕОБРАЗОВАНИЕ СТРОКИ К ТИПИЗОВАННОМУ ЗНАЧЕНИЮ 1С.
&НаСервере
Функция ПреобразоватьПростоеЗначениеИзСтрокиВТипизованноеЗначение1С(Знач ИсходноеЗначение)
	
	Если НЕ ИсходноеЗначение = "" Тогда
		Если ТолькоЦифрыИЗапятаяВСтроке(ИсходноеЗначение, Истина, Ложь) Тогда
			Попытка
				Возврат Число(ИсходноеЗначение);
			Исключение
				Возврат ИсходноеЗначение
			КонецПопытки;
		Иначе
			Если ВРег(ИсходноеЗначение) = "ИСТИНА" ИЛИ ВРег(ИсходноеЗначение) = ("ИСТИНА"+Символы.ПС) ИЛИ ВРег(ИсходноеЗначение) = "TRUE" ИЛИ ВРег(ИсходноеЗначение) = ("TRUE"+Символы.ПС) Тогда
				Возврат Истина;
			ИначеЕсли ВРег(ИсходноеЗначение) = "ЛОЖЬ" ИЛИ  ВРег(ИсходноеЗначение) = ("ЛОЖЬ"+Символы.ПС) ИЛИ ВРег(ИсходноеЗначение) = "FALSE" ИЛИ ВРег(ИсходноеЗначение) = ("FALSE"+Символы.ПС) Тогда
				Возврат Ложь;
			Иначе
				Возврат ПреобразоватьИзСтрокиВДату(ИсходноеЗначение);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИсходноеЗначение
	
КонецФункции

// Проверяет, содержит ли строка только цифры и запятую.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка для проверки
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, если Истина, то ведущие нули пропускаются
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, если Истина, то пробелы при проверке игнорируются
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
&НаСервере
Функция ТолькоЦифрыИЗапятаяВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
	
	Если Сред(СтрокаПроверки, 1, 1) = "-" Тогда
		СтрокаПроверки = Сред(СтрокаПроверки, 2, СтрДлина(СтрокаПроверки));
	КонецЕсли;
	
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы
	Возврат СтрДлина(
	СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
	СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
	СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", ""), ",", "")
	) = 0;
	
КонецФункции

// Преобразование строки вида "01.01.13" или "01.01.2013" к значению типа "дата".
// Возможны другие форматы даты в файле EXCEL.
&НаСервере
Функция ПреобразоватьИзСтрокиВДату(Знач СтрокаДаты)
	Перем ScrptCtrl, OutDate;
	
	Попытка
		ScrptCtrl = Новый COMОбъект("MSScriptControl.ScriptControl");
		ScrptCtrl.Language="vbscript";
		OutDate = ScrptCtrl.Eval("CDate(""" + СтрокаДаты + """)");
		Возврат OutDate;
	Исключение
		//Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат СтрокаДаты;
	
КонецФункции 

// ПОЛУЧЕНИЕ ЗНАЧЕНИЯ ДЛЯ РЕКВИЗИТА ТИПА "ФАЙЛ КАРТИНКИ".
&НаСервере
Функция ПолучитьЗначениеЯчейкиОбластиТабличногоДокументаСКартинками(Знач Область, Знач нСтрока, Знач нКолонка, Знач ПравилоИмяФайлаКартинки = "УИД")
	Перем Рисунок, ит, ИмяФайлаРисунка;
	Перем ЗначениеЯчейки;
	
	ит = 0;
	ЗначениеЯчейки = "";
	Для Каждого Рисунок ИЗ Область.Рисунки Цикл
		ит = ит + 1;
		Если ПравилоИмяФайлаКартинки = "УИД" Тогда
			ИмяФайлаРисунка = КаталогВременныхФайлов() + Новый УникальныйИдентификатор() + ".jpg";
		Иначе
			ИмяФайлаРисунка = КаталогВременныхФайлов() + "С" + нСтрока + "К" + нКолонка + ".jpg";
		КонецЕсли;
		Попытка
			Рисунок.Картинка.Записать(ИмяФайлаРисунка);
			ЗначениеЯчейки = ЗначениеЯчейки + ИмяФайлаРисунка + ?(ит < Область.Рисунки.Количество(), Символы.ПС, "");
		Исключение
			// Поле картинки недоступно для чтения.
		КонецПопытки;
	КонецЦикла;
	
	Возврат ЗначениеЯчейки;
	
КонецФункции

&НаСервере
Функция ЗагрузитьМетодом_EXCEL1C(Знач ФайлEXCEL, Знач ИмяЛиста = "", Знач СтрокаЗаголовка = 1, НачСтрока = 0, КонСтрока = 0, КолвоСтрокФайла = 0, пФорма = Неопределено, пПреобразованиеТипов=Ложь) Экспорт
	Перем ТабличныйДокумент, ОбластьФайла, КолВоКолонокФайла, ИмяКолонки, Область, ТекущаяОбласть, нСтрока, нКолонка, НоваяСтрокаТФ, ЗначениеЯчейки;
	Перем ТаблицаРезультат;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Попытка
		// Выполняется долго на больших файлах.
		ТабличныйДокумент.Прочитать(ФайлEXCEL, СпособЧтенияЗначенийТабличногоДокумента.Значение);    // СпособЧтенияЗначенийТабличногоДокумента - новый параметр платформы 8.3.6. Второе значение "Текст".
	Исключение
		лОписаниеОшибки = ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( лОписаниеОшибки );
		Возврат Новый ТаблицаЗначений;
	КонецПопытки;
	
	Если ПустаяСтрока(ИмяЛиста) Тогда
		ОбластьФайла = ТабличныйДокумент;
	Иначе
		ОбластьФайла = ТабличныйДокумент.ПолучитьОбласть(ИмяЛиста);
	КонецЕсли;
	КолВоСтрокФайла = ОбластьФайла.ПолучитьРазмерОбластиДанныхПоВертикали();
	КолВоКолонокФайла = ОбластьФайла.ПолучитьРазмерОбластиДанныхПоГоризонтали();
	
	// Проверка заполненности листа.
	Если КолвоСтрокФайла = 0 Тогда
		// Завершение работы.
		// Закрытие Объектов.
		ТабличныйДокумент = Неопределено;
		Возврат Новый ТаблицаЗначений;    // В случае ошибки возвращаем пустую таблицу значений.
	КонецЕсли;
	
	// Создание результирующей таблицы, в которую будут записываться считанные из файла данные.
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	// Формирование колонок результирующей таблицы.
	
	// "НомерСтроки" - для наглядности и удобства.
	// В зависимости от разрабатываемой обработки.
	// "Сопоставлено" - может быть другим.
	// Здесь же могут быть добавлены другие колонки, не формируемые из содержимого файла.
	ТаблицаРезультат.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"), "№", 7);
	ТаблицаРезультат.Колонки.Добавить("Сопоставлено", Новый ОписаниеТипов("Булево"), "Сопоставлено", 1);
	
	Для ит = 1 ПО КолВоКолонокФайла Цикл
		нКолонка = СтрЗаменить(ит, Символы.НПП, "");
		ИмяКолонки = "N" + нКолонка;
		ТаблицаРезультат.Колонки.Добавить(ИмяКолонки);
	КонецЦикла;
	
	Если СтрокаЗаголовка <> 0 Тогда
		// 1-я строка. Заголовки.
		НоваяСтрокаТФ = ТаблицаРезультат.Добавить();
		НоваяСтрокаТФ.НомерСтроки = 1;
		Для ит=1 ПО КолВоКолонокФайла Цикл
			нКолонка = СтрЗаменить(ит, Символы.НПП, "");
			ИмяКолонки = "N" + нКолонка;
			НоваяСтрокаТФ[ИмяКолонки] = ОбластьФайла.ПолучитьОбласть("R1" + "C"+нКолонка).ТекущаяОбласть.Текст;
			
			// Используется при формировании таблицы на форме обработки.
			Если пФорма <> Неопределено Тогда
				ШиринаКолонки = ТаблицаРезультат.Колонки[ИмяКолонки].Ширина;
				ДлинаСтроки    = СтрДлина(СокрЛП(НоваяСтрокаТФ[ИмяКолонки]));		ТаблицаРезультат.Колонки[ИмяКолонки].Ширина = ?(ШиринаКолонки < ДлинаСтроки, ДлинаСтроки, ШиринаКолонки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НачСтрока = ?(НачСтрока = 0, 2, НачСтрока);
	КонСтрока = ?(КонСтрока = 0, КолвоСтрокФайла, КонСтрока);
	
	Для нСтрокаТФ = НачСтрока ПО КонСтрока Цикл
		НоваяСтрокаТФ = ТаблицаРезультат.Добавить();
		НоваяСтрокаТФ[0] = нСтрокаТФ;
		нСтрока = СтрЗаменить(нСтрокаТФ, Символы.НПП, "");
		Для нКолонкаТФ = 1 ПО КолВоКолонокФайла Цикл
			нКолонка = СтрЗаменить(нКолонкаТФ, Символы.НПП, "");
			Область = ОбластьФайла.ПолучитьОбласть("R"+нСтрока+"C"+нКолонка);
			ТекущаяОбласть = Область.ТекущаяОбласть;
			Попытка
				ЗначениеЯчейки = ТекущаяОбласть.Значение;        // Число, Дата.
			Исключение
				ЗначениеЯчейки = СокрЛП(ТекущаяОбласть.Текст);    // Строка, Булево. (Булево как строка "ИСТИНА"/"ЛОЖЬ")
				Если пПреобразованиеТипов = Истина Тогда
					Если ЗначениеЗаполнено(ЗначениеЯчейки) Тогда
						ЗначениеЯчейки = ПреобразоватьПростоеЗначениеИзСтрокиВТипизованноеЗначение1С(ЗначениеЯчейки);
						Если ТипЗнч(ЗначениеЯчейки) = Тип("Строка") Тогда
							ЗначениеЯчейки = СокрЛП(ЗначениеЯчейки);
						КонецЕсли;
					Иначе
						ЗначениеЯчейки = Неопределено;
						Если Область.Рисунки.Количество() > 0 Тогда    // Изображение.
							ЗначениеЯчейки = ПолучитьЗначениеЯчейкиОбластиТабличногоДокументаСКартинками(Область, нСтрока, нКолонка, "УИД");
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецПопытки;
			
			ИмяКолонки = "N" + нКолонка;
			//убрать внутренние пробелы
			Попытка
				ЗначениеЯчейкиЧисло = Число(ЗначениеЯчейки);
				ЗначениеЯчейки = СтрЗаменить(СокрЛП(ЗначениеЯчейки)," ","");
				ЗначениеЯчейки = СтрЗаменить(СокрЛП(ЗначениеЯчейки),Символ(160),"");
			Исключение	
				Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЗначениеЯчейки) Тогда
					ЗначениеЯчейки = СтрЗаменить(СокрЛП(ЗначениеЯчейки)," ","");
					ЗначениеЯчейки = СтрЗаменить(СокрЛП(ЗначениеЯчейки),Символ(160),"");
				КонецЕсли;	
			КонецПопытки;	
			НоваяСтрокаТФ[ИмяКолонки] = ЗначениеЯчейки;
			
			// Используется при формировании таблицы на форме обработки.
			ШиринаКолонки = ТаблицаРезультат.Колонки[ИмяКолонки].Ширина;
			ДлинаСтроки    = СтрДлина(СокрЛП(НоваяСтрокаТФ[ИмяКолонки]));
			ТаблицаРезультат.Колонки[ИмяКолонки].Ширина = ?(ШиринаКолонки < ДлинаСтроки, ДлинаСтроки, ШиринаКолонки);
		КонецЦикла;
	КонецЦикла;
	
	// Юзабилити. Удалить пустые колонки.
	Если пФорма <> Неопределено Тогда
		УдалитьКолонкиСНулевойШириной(ТаблицаРезультат);
	КонецЕсли;
	
	Возврат ТаблицаРезультат;
	
КонецФункции
