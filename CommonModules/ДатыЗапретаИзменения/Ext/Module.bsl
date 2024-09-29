﻿#Область ПрограммныйИнтерфейс

// Проверяет, запрещено ли изменение данных при интерактивном редактировании пользователем 
// или при программной загрузке данных из узла плана обмена УзелПроверкиЗапретаЗагрузки.
// Для корректной работы функции требуется предварительная настройка 
// процедуры ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения модуля ДатыЗапретаИзмененияПереопределяемый.
//
// Параметры:
//  ДанныеИлиПолноеИмя  - СправочникОбъект,
//                        ДокументОбъект,
//                        ПланВидовХарактеристикОбъект,
//                        ПланСчетовОбъект,
//                        ПланВидовРасчетаОбъект,
//                        БизнесПроцессОбъект,
//                        ЗадачаОбъект,
//                        ПланОбменаОбъект,
//                        РегистрСведенийНаборЗаписей,
//                        РегистрНакопленияНаборЗаписей,
//                        РегистрБухгалтерииНаборЗаписей,
//                        РегистрРасчетаНаборЗаписей      - проверяемый элемент данных или набор записей.
//                      - Строка - полное имя объекта метаданных, данные которого следует проверить в базе данных.
//                                 Например: "Документ.ПриходнаяНакладная".
//                                 В этом случае, следует указать в параметре ИдентификаторДанных,
//                                 какие именно данные требуется прочитать из базы и проверить.
//
//  ИдентификаторДанных - СправочникСсылка,
//                        ДокументСсылка,
//                        ПланВидовХарактеристикСсылка,
//                        ПланСчетовСсылка,
//                        ПланВидовРасчетаСсылка,
//                        БизнесПроцессСсылка,
//                        ЗадачаСсылка,
//                        ПланОбменаСсылка,
//                        Отбор        - ссылка на элемент данных или отбор набора записей, который нужно проверить.
//                                       При этом значение для проверки будет получено из базы данных.
//                      - Неопределено - если не требуется получать значение для проверки из базы данных,  
//                                       а нужно проверить только данные самого объекта в ДанныеИлиПолноеИмя.
//
//  ОписаниеОшибки    - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                    - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                    - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов,
//                                  подробнее см. функцию ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено, ПланыОбменаСсылка - если Неопределено, то проверить запрет 
//                                изменения данных; иначе - загрузку данных из указанного узла плана обмена.
//
// Возвращаемое значение:
//  Булево - Истина, если изменение данных запрещено.
//
// Варианты вызова:
//   ИзменениеЗапрещено(СправочникОбъект...)         - проверить данные в переданном объекте (наборе записей).
//   ИзменениеЗапрещено(Строка, СправочникСсылка...) - проверить данные, полученные из базы данных 
//      по полному имени объекта метаданных и ссылке (отбору набора записей).
//   ИзменениеЗапрещено(СправочникОбъект..., СправочникСсылка...) - проверить одновременно 
//      данные в переданном объекте и данные в базе (т.е. "до" и "после" записи в базу, если проверка выполняется
//      перед записью объекта).
//
Функция ИзменениеЗапрещено(ДанныеИлиПолноеИмя, ИдентификаторДанных = Неопределено,
	ОписаниеОшибки = Null, УзелПроверкиЗапретаЗагрузки = Неопределено) Экспорт
	
	ПроверкаЗапретаИзменения = УзелПроверкиЗапретаЗагрузки = Неопределено;
	
	Если ТипЗнч(ДанныеИлиПолноеИмя) = Тип("Строка") Тогда
		Если ТипЗнч(ИдентификаторДанных) = Тип("Отбор") Тогда
			МенеджерДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ДанныеИлиПолноеИмя);
			Источник = МенеджерДанных.СоздатьНаборЗаписей();
			Для Каждого ЭлементОтбора Из ИдентификаторДанных Цикл
				Источник.Отбор[ЭлементОтбора.Имя].Установить(ЭлементОтбора.Значение, ЭлементОтбора.Использование);
			КонецЦикла;
			Источник.Прочитать();
		ИначеЕсли Не ЗначениеЗаполнено(ИдентификаторДанных) Тогда
			Возврат Ложь;
		Иначе
			Источник = ИдентификаторДанных.ПолучитьОбъект();
		КонецЕсли;
		
		Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(Источник,
				ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, "") Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат ДатыЗапретаИзмененияСлужебный.ИзменениеЗапрещено(ДанныеИлиПолноеИмя,
			ИдентификаторДанных, ОписаниеОшибки, УзелПроверкиЗапретаЗагрузки);
	КонецЕсли;
	
	ВерсияОбъекта = "";
	Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(ДанныеИлиПолноеИмя,
			 ПроверкаЗапретаИзменения, УзелПроверкиЗапретаЗагрузки, ВерсияОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Источник      = ДанныеИлиПолноеИмя;
	Идентификатор = ИдентификаторДанных;
	
	Если ВерсияОбъекта = "СтараяВерсия" Тогда
		Источник = Метаданные.НайтиПоТипу(ДанныеИлиПолноеИмя).ПолноеИмя();
		
	ИначеЕсли ВерсияОбъекта = "НоваяВерсия" Тогда
		Идентификатор = Неопределено;
	КонецЕсли;
	
	Возврат ДатыЗапретаИзмененияСлужебный.ИзменениеЗапрещено(Источник,
		Идентификатор, ОписаниеОшибки, УзелПроверкиЗапретаЗагрузки);
	
КонецФункции

// Проверяет наличие запрета загрузки элемента данных или набор записей Данные.
// При этом выполняется проверка старой и новой версии данных. 
// Для корректной работы требуется предварительная настройка
// процедуры ДанныеДляПроверкиЗапретаИзменения модуля ДатыЗапретаИзмененияПереопределяемый.
//
// Параметры:
//  Данные              - СправочникОбъект, 
//                        ДокументОбъект, 
//                        ПланВидовХарактеристикОбъект,
//                        ПланСчетовОбъект, 
//                        ПланВидовРасчетаОбъект, 
//                        БизнесПроцессОбъект,
//                        ЗадачаОбъект, 
//                        ПланОбменаОбъект, 
//                        УдалениеОбъекта,
//                        РегистрСведенийНаборЗаписей,
//                        РегистрНакопленияНаборЗаписей,
//                        РегистрБухгалтерииНаборЗаписей,
//                        РегистрРасчетаНаборЗаписей - элемент данных или набор записей.
//
//  УзелПроверкиЗапретаЗагрузки  - ПланОбменаСсылка - узел, для которого требуется проверка.
//
//  Отказ               - Булево - возвращаемый параметр: Истина, если загрузка запрещена.
//
//  ОписаниеОшибки      - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                      - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                      - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов,
//                                    подробнее см. функцию ДатыЗапретаИзменения.НайденЗапретИзмененияДанных.
//
Процедура ПроверитьДатыЗапретаЗагрузкиДанных(Данные, УзелПроверкиЗапретаЗагрузки, Отказ, ОписаниеОшибки = Null) Экспорт
	
	Если ТипЗнч(Данные) = Тип("УдалениеОбъекта") Тогда
		ОбъектМетаданных = Данные.Ссылка.Метаданные();
	Иначе
		ОбъектМетаданных = Данные.Метаданные();
	КонецЕсли;
	
	ИсточникиДанных = ДатыЗапретаИзмененияСлужебный.ИсточникиДанныхДляПроверкиЗапретаИзменения();
	Если ИсточникиДанных.Получить(ОбъектМетаданных.ПолноеИмя()) = Неопределено Тогда
		Возврат; // Для текущего типа объекта не определены запреты по датам.
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПроверкаЗапретаИзменения",    Ложь);
	ДополнительныеПараметры.Вставить("УзелПроверкиЗапретаЗагрузки", УзелПроверкиЗапретаЗагрузки);
	ДополнительныеПараметры.Вставить("ОписаниеОшибки",              ОписаниеОшибки);
	ДополнительныеПараметры.Вставить("СообщитьОЗапрете",            Ложь);
	
	ЭтоРегистр = ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных);
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(Данные,
		Отказ, ЭтоРегистр, ЭтоРегистр, ТипЗнч(Данные) = Тип("УдалениеОбъекта"), ДополнительныеПараметры);
	
	ОписаниеОшибки = ДополнительныеПараметры.ОписаниеОшибки;
	
КонецПроцедуры

// Обработчик события формы ПриЧтенииНаСервере, который встраивается в формы элементов справочников,
// документов, записей регистров и др., чтобы заблокировать форму, если изменение запрещено.
//
// Параметры:
//  Форма               - УправляемаяФорма - форма элемента объекта или записи регистра.
//
//  ТекущийОбъект       - СправочникОбъект,
//                        ДокументОбъект,
//                        ПланВидовХарактеристикОбъект,
//                        ПланСчетовОбъект,
//                        ПланВидовРасчетаОбъект,
//                        БизнесПроцессОбъект,
//                        ЗадачаОбъект,
//                        ПланОбменаОбъект,
//                        РегистрСведенийМенеджерЗаписи,
//                        РегистрНакопленияМенеджерЗаписи,
//                        РегистрБухгалтерииМенеджерЗаписи,
//                        РегистрРасчетаМенеджерЗаписи - менеджер записи.
//
// Возвращаемое значение:
//  Булево - Истина, если проверка запрета изменения была пропущена программно.
//
Функция ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	ДействующиеДаты = ДатыЗапретаИзмененияСлужебный.ДействующиеДатыЗапрета();
	ИсточникиДанных = ДействующиеДаты.ИсточникиДанных.Получить(ПолноеИмя);
	Если ИсточникиДанных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		// Приведение менеджера записи к набору записей с одной записью.
		МенеджерДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		Источник = МенеджерДанных.СоздатьНаборЗаписей();
		Для каждого ЭлементОтбора Из Источник.Отбор Цикл
			ЭлементОтбора.Установить(ТекущийОбъект[ЭлементОтбора.Имя], Истина);
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(Источник.Добавить(), ТекущийОбъект);
	Иначе
		Источник = ТекущийОбъект;
	КонецЕсли;
	
	Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(Источник,
			Истина, Неопределено, "") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ИзменениеЗапрещено(Источник) Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Добавляет строку описания источника данных для проверки запрета изменения.
// Используется в процедуре ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения
// общего модуля ДатыЗапретаИзмененияПереопределяемый.
// 
// Параметры:
//  Данные      - ТаблицаЗначений - передается в процедуру ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
//  Таблица     - Строка - полное имя объекта метаданных, например, "Документ.ПриходнаяНакладная".
//  ПолеДаты    - Строка - имя реквизита объекта или табличной части, например "Дата", "Товары.ДатаОтгрузки".
//  Раздел      - Строка - имя предопределенного элемента ПланВидовХарактеристикСсылка.РазделыДатЗапрета.
//  ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части, например "Организация", "Товары.Склад".
//
Процедура ДобавитьСтроку(Данные, Таблица, ПолеДаты, Раздел = "", ПолеОбъекта = "") Экспорт
	
	НоваяСтрока = Данные.Добавить();
	НоваяСтрока.Таблица     = Таблица;
	НоваяСтрока.ПолеДаты    = ПолеДаты;
	НоваяСтрока.Раздел      = Раздел;
	НоваяСтрока.ПолеОбъекта = ПолеОбъекта;
	
КонецПроцедуры

// Найти даты запрета по проверяемым данным
// для указанного пользователя и/или узла плана обмена.
//
// Параметры:
//  ДанныеДляПроверки - ТаблицаЗначений - возвращается функцией ШаблонДанныхДляПроверки
//                      общего модуля ДатыЗапретаИзменения.
//
//  ОписаниеДанных    - Неопределено - текст сообщения о запрете не формируется.
//                    - Структура - со свойствами:
//                      * НоваяВерсия - Булево - если Истина, то сообщение о запрете
//                                   формировать для новой версии, иначе для старой версии.
//                      * Данные - Ссылка,Объект - ссылка или объект данных для получения
//                                   представления, которое будет использовано в сообщении о запрете.
//                               - НаборЗаписей - набор записей регистра для получения
//                                   представления, которое будет использовано в сообщении о запрете.
//                               - Структура - со свойствами для сообщения о запрете:
//                                   * Регистр - Строка - полное имя регистра.
//                                   *         - НаборЗаписей - набор записей регистра.
//                                   * Отбор   - Отбор - отбор набора записей.
//                               - Строка - подготовленное представление данных,
//                                 которое будет использовано в сообщении о запрете.
//
//  ОписаниеОшибки    - Null      - (значение по умолчанию) - сведения о запретах не требуются.
//                    - Строка    - (возвращаемое значение) - вернуть текстовое описание найденных запретов.
//                    - Структура - (возвращаемое значение) - вернуть структурное описание найденных запретов:
//                        * ПредставлениеДанных - Строка - представление данных, используемое в заголовке ошибки.
//                        * ЗаголовокОшибки     - Строка - строка подобная следующей:
//                                                "Заказ 10 от 01.01.2017 невозможно изменить в запрещенном периоде.".
//                        * Запреты - ТаблицаЗначений - найденные запреты в виде таблицы с колонками:
//                          ** Дата            - Дата         - проверяемая дата.
//                          ** Раздел          - Строка       - имя раздела, по которому выполнялся поиск запретов, если
//                                                 пустая строка, значит выполнялся поиск даты, действующей для всех разделов.
//                          ** Объект          - ЛюбаяСсылка  - ссылка на объект, по которому выполнялся поиск даты запрета.
//                                             - Неопределено - выполнялся поиск даты, действующей для всех объектов.
//                          ** ДатаЗапрета     - Дата         - найденная дата запрета.
//                          ** ОбщаяДата       - Булево       - если Истина, значит найденная дата запрета действует для
//                                                 всех разделов, а не только для раздела, по которому выполнялся поиск.
//                          ** ДляВсехОбъектов - Булево       - если Истина, значит найденная дата запрета действует для
//                                                 всех объектов, а не только для объекта, по которому выполнялся поиск.
//                          ** Адресат         - ОпределяемыйТип.АдресатЗапретаИзменения - пользователь или узел
//                                                 плана обмена, для которого задана найденная дата запрета.
//                          ** Описание        - Строка - строка, подобная следующей:
//                            "Дате 01.01.2017 по объекту ""Склад программ"" раздела ""Складской учет"" соответствует
//                            запрет изменения данных для всех пользователей (установлена общая дата запрета)".
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено - выполнить проверку изменения данных.
//                              - ПланыОбменаСсылка.<Имя плана обмена> - выполнить проверку
//                                загрузки данных для указанного узла.
//
// Возвращаемое значение:
//  Булево - если Истина, значит найден хотя бы один запрет изменения.
//
Функция НайденЗапретИзмененияДанных(Знач ДанныеДляПроверки,
                                    ОписаниеДанных = Неопределено,
                                    ОписаниеОшибки = Null,
                                    УзелПроверкиЗапретаЗагрузки = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ДанныеДляПроверки) = Тип("Структура") Тогда
		ДействующиеДаты   = ДанныеДляПроверки.ДействующиеДаты;
		ДанныеДляПроверки = ДанныеДляПроверки.ДанныеДляПроверки;
	Иначе
		ДействующиеДаты = ДатыЗапретаИзмененияСлужебный.ДействующиеДатыЗапрета();
	КонецЕсли;
	
	ЗапретИспользуется = ?(УзелПроверкиЗапретаЗагрузки = Неопределено,
		ДействующиеДаты.ЗапретИзмененияИспользуется,
		ДействующиеДаты.ЗапретЗагрузкиИспользуется);
	
	Если Не ЗапретИспользуется Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СвойстваРазделов = ДействующиеДаты.СвойстваРазделов;
	ПустойРаздел = ДатыЗапретаИзмененияСлужебный.ПустаяСсылка(
		Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в функции НайденЗапретИзмененияДанных общего модуля ДатыЗапретаИзменения.'")
		+ Символы.ПС
		+ Символы.ПС;
	
	// Приведение данных в соответствие варианту встраивания.
	Для Каждого Строка Из ДанныеДляПроверки Цикл
		
		Если Строка.Раздел = Неопределено Тогда
			Строка.Раздел = ПустойРаздел;
		КонецЕсли;
		
		СвойстваРаздела = СвойстваРазделов.Разделы.Получить(Строка.Раздел);
		Если СвойстваРаздела = Неопределено Тогда
			ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В параметре ДанныеДляПроверки указан несуществующий раздел ""%1"".'"),
				Строка.Раздел);
		КонецЕсли;
		
		Если СвойстваРазделов.БезРазделовИОбъектов Тогда
			Строка.Раздел = ПустойРаздел;
			Строка.Объект = ПустойРаздел;
		Иначе
			Если ЗначениеЗаполнено(СвойстваРазделов.ЕдинственныйРаздел) Тогда
				Строка.Раздел = СвойстваРазделов.ЕдинственныйРаздел;
			Иначе
				Строка.Раздел = СвойстваРаздела.Ссылка;
			КонецЕсли;
			
			Если СвойстваРазделов.ВсеРазделыБезОбъектов
			 Или Не ЗначениеЗаполнено(Строка.Объект) Тогда
				
				Строка.Объект = Строка.Раздел;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	// Свертка лишних строк, чтобы сократить число проверок и сообщений.
	РазделыИОбъекты = ДанныеДляПроверки.Скопировать();
	РазделыИОбъекты.Свернуть("Раздел, Объект");
	Отбор = Новый Структура("Раздел, Объект");
	РазделыИОбъекты.Колонки.Добавить("Дата",
		Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	Для Каждого РазделИОбъект Из РазделыИОбъекты Цикл
		ЗаполнитьЗначенияСвойств(Отбор, РазделИОбъект);
		Строки = ДанныеДляПроверки.НайтиСтроки(Отбор);
		МинимальнаяДата = Неопределено;
		Для Каждого Строка Из Строки Цикл
			ТекущаяДата = НачалоДня(Строка.Дата);
			Если МинимальнаяДата = Неопределено Тогда
				МинимальнаяДата = ТекущаяДата;
			КонецЕсли;
			Если ТекущаяДата < МинимальнаяДата Тогда
				МинимальнаяДата = ТекущаяДата;
			КонецЕсли;
		КонецЦикла;
		РазделИОбъект.Дата = МинимальнаяДата;
	КонецЦикла;
	ДанныеДляПроверки = РазделыИОбъекты;
	
	// Приоритеты дат запрета изменения.
	// 1. Для раздела, объекта и пользователя.
	// 2. Для раздела, объекта и группы пользователей.
	// 3. Для раздела, объекта и любого пользователя.
	// 4. Для раздела, любого объекта (объект = раздел) и пользователя.
	// 5. Для раздела, любого объекта (объект = раздел) и группы пользователей.
	// 6. Для раздела, любого объекта (объект = раздел) и любого пользователя.
	// 7. Для любого раздела (пустой раздел), любого объекта (объект = раздел) и пользователя.
	// 8. Для любого раздела (пустой раздел), любого объекта (объект = раздел) и группы пользователей.
	// 9. Для любого раздела (пустой раздел), любого объекта (объект = раздел) и любого пользователя.
	
	// Приоритеты дат запрета загрузки.
	// 1. Для раздела, объекта и узла.
	// 2. Для раздела, объекта и любого узла.
	// 3. Для раздела, любого объекта (объект = раздел) и узла.
	// 4. Для раздела, любого объекта (объект = раздел) и любого узла.
	// 5. Для любого раздела (пустой раздел), любого объекта (объект = раздел) и узла.
	// 6. Для любого раздела (пустой раздел), любого объекта (объект = раздел) и любого узла.
	
	ЗапретыИзменения = ДанныеДляПроверки.Скопировать(Новый Массив);
	ЗапретыИзменения.Колонки.Добавить("Адресат");
	ЗапретыИзменения.Колонки.Добавить("Данные");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УзелПроверкиЗапретаЗагрузки", УзелПроверкиЗапретаЗагрузки);
	
	// Поиск запретов изменения данных.
	Если УзелПроверкиЗапретаЗагрузки = Неопределено Тогда
		Разделы = ДействующиеДаты.ДляПользователей.Разделы;
		Пользователь = Пользователи.АвторизованныйПользователь();
		ГруппыПользователя = ДействующиеДаты.ГруппыПользователей.Получить(Пользователь);
		Если ГруппыПользователя = Неопределено Тогда
			ГруппыПользователя = Новый Массив;
		КонецЕсли;
		ДополнительныеПараметры.Вставить("Пользователь",       Пользователь);
		ДополнительныеПараметры.Вставить("ГруппыПользователя", ГруппыПользователя);
	Иначе
		Разделы = ДействующиеДаты.ДляИнформационныхБаз.Разделы;
		ДополнительныеПараметры.Вставить("ПустойУзелПланаОбмена",
			ОбщегоНазначения.МенеджерОбъектаПоСсылке(УзелПроверкиЗапретаЗагрузки).ПустаяСсылка());
	КонецЕсли;
	
	Для Каждого Данные Из ДанныеДляПроверки Цикл
		РазделЗапрета = Данные.Раздел;
		ОбъектЗапрета = Данные.Объект;
		
		Объекты = Разделы.Получить(РазделЗапрета);
		Адресаты = Неопределено;
		ДатаЗапрета = Неопределено;
		
		Если Объекты <> Неопределено Тогда
			Адресаты = Объекты.Получить(ОбъектЗапрета);
			Если Адресаты <> Неопределено Тогда
				// Поиск для раздела и объекта.
				ДатаЗапрета = НайтиДатуЗапрета(Адресаты, РазделЗапрета, ОбъектЗапрета, ДополнительныеПараметры);
			КонецЕсли;
			Если ДатаЗапрета = Неопределено Тогда
				ОбъектЗапрета = РазделЗапрета;
				Адресаты = Объекты.Получить(ОбъектЗапрета);
				Если Адресаты <> Неопределено Тогда
					// Поиск для раздела и любого объекта.
					ДатаЗапрета = НайтиДатуЗапрета(Адресаты, РазделЗапрета, ОбъектЗапрета, ДополнительныеПараметры);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ДатаЗапрета = Неопределено Тогда
			РазделЗапрета = ПустойРаздел;
			ОбъектЗапрета = РазделЗапрета;
			Объекты = Разделы.Получить(РазделЗапрета);
			Если Объекты = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Адресаты = Объекты.Получить(ОбъектЗапрета);
			Если Адресаты = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			// Поиск для любого раздела и любого объекта (общая дата).
			ДатаЗапрета = НайтиДатуЗапрета(Адресаты, РазделЗапрета, ОбъектЗапрета, ДополнительныеПараметры);
			Если ДатаЗапрета = Неопределено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ДатаЗапрета < Данные.Дата Тогда
			Продолжить;
		КонецЕсли;
		
		Если УзелПроверкиЗапретаЗагрузки = Неопределено Тогда
			Адресат = Пользователь;
		Иначе
			Адресат = УзелПроверкиЗапретаЗагрузки;
		КонецЕсли;
		
		Строка = ЗапретыИзменения.Добавить();
		Строка.Данные  = Данные;
		Строка.Раздел  = РазделЗапрета;
		Строка.Объект  = ОбъектЗапрета;
		Строка.Адресат = Адресат;
		Строка.Дата    = ДатаЗапрета;
	КонецЦикла;
	
	Если ТипЗнч(ОписаниеДанных)  = Тип("Структура")
	   И ТипЗнч(ОписаниеОшибки) <> Тип("Null")
	   И ЗапретыИзменения.Количество() > 0 Тогда
		
		ОписаниеОшибки = СообщениеОЗапретах(ЗапретыИзменения, ОписаниеДанных, СвойстваРазделов,
			УзелПроверкиЗапретаЗагрузки <> Неопределено, ТипЗнч(ОписаниеОшибки) = Тип("Структура"));
	КонецЕсли;
	
	Возврат ЗапретыИзменения.Количество() > 0;
	
КонецФункции

// Возвращает готовую пустую таблицу значений (с колонками Дата, Раздел, Объект)
// для заполнения и последующей передачи в функцию НайденЗапретИзмененияДанных
// общего модуля ДатыЗапретаИзменения.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица с колонками:
//   * Дата   - Дата   - дата без времени, которую нужно проверить на принадлежность
//                       установленным запретам.
//
//   * Раздел - Строка - одно из имен разделов, указанных
//                       в процедуре ПриЗаполненииРазделовДатЗапретаИзменения
//                       общего модуля ДатыЗапретаИзмененияПереопределяемый.
//
//   * Объект - Ссылка - один из типов объектов, указанных для раздела
//                       в процедуре ПриЗаполненииРазделовДатЗапретаИзменения
//                       общего модуля ДатыЗапретаИзмененияПереопределяемый.
//
Функция ШаблонДанныхДляПроверки() Экспорт
	
	ДанныеДляПроверки = Новый ТаблицаЗначений;
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Дата", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Раздел", Новый ОписаниеТипов("Строка,ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	ДанныеДляПроверки.Колонки.Добавить(
		"Объект", Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип);
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

// Обновляет план видов характеристик РазделыДатЗапретаИзменения по описанию в метаданных.
// Предназначен для вызова из обработчика обновления общих данных (модель сервиса)
// при изменении состава разделов дат запрета изменения или свойств разделов в процедуре
// ПриЗаполненииРазделовДатЗапретаИзменения общего модуля ДатыЗапретаИзмененияПереопределяемый.
//
Процедура ОбновитьРазделыДатЗапретаИзменения() Экспорт
	
	ДатыЗапретаИзмененияСлужебный.ОбновитьРазделыДатЗапретаИзменения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник   - СправочникОбъект,
//               ПланВидовХарактеристикОбъект,
//               ПланСчетовОбъект,
//               ПланВидовРасчетаОбъект,
//               БизнесПроцессОбъект,
//               ЗадачаОбъект,
//               ПланОбменаОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник        - ДокументОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//  Отказ           - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимЗаписи     - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимПроведения - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник   - РегистрСведенийНаборЗаписей, РегистрНакопленияНаборЗаписей - набор записей,
//               передаваемый в подписку на событие ПередЗаписью.
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  Замещение  - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник    - РегистрБухгалтерииНаборЗаписей - набор записей, передаваемый
//                в подписку на событие ПередЗаписью.
//  Отказ       - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  РежимЗаписи - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраБухгалтерии(
		Источник, Отказ, РежимЗаписи) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для проверки запрета изменения.
//
// Параметры:
//  Источник     - РегистрРасчетаНаборЗаписей - набор записей, передаваемый
//                 в подписку на событие ПередЗаписью.
//  Отказ        - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  Замещение    - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ТолькоЗапись - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ЗаписьФактическогоПериодаДействия - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//  ЗаписьПерерасчетов - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраРасчета(
		Источник,
		Отказ,
		Замещение,
		ТолькоЗапись,
		ЗаписьФактическогоПериодаДействия,
		ЗаписьПерерасчетов) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередУдалением для проверки запрета изменения.
//
// Параметры:
//  Источник   - СправочникОбъект,
//               ДокументОбъект,
//               ПланВидовХарактеристикОбъект,
//               ПланСчетовОбъект,
//               ПланВидовРасчетаОбъект,
//               БизнесПроцессОбъект,
//               ЗадачаОбъект,
//               ПланОбменаОбъект - объект данных, передаваемый в подписку на событие ПередЗаписью.
//
//  Отказ      - Булево - параметр, передаваемый в подписку на событие ПередЗаписью.
//
Процедура ПроверитьДатуЗапретаИзмененияПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьДатыЗапретаИзмененияДанных(Источник, Отказ, , , Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для процедур ПроверитьДатуЗапретаИзменения*.
Процедура ПроверитьДатыЗапретаИзмененияДанных(
		Источник, Отказ, ИсточникРегистр = Ложь, Замещение = Истина, Удаление = Ложь)
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ, ИсточникРегистр, Замещение, Удаление);
	
КонецПроцедуры

// Для функции НайденЗапретИзмененияДанных.
Функция НайтиДатуЗапрета(Адресаты, РазделЗапрета, ОбъектЗапрета, ДополнительныеПараметры)
	
	ДатаЗапрета = Неопределено;
	
	Если ДополнительныеПараметры.УзелПроверкиЗапретаЗагрузки = Неопределено Тогда
		Адресат = ДополнительныеПараметры.Пользователь;
		ДатаЗапрета = Адресаты.Получить(Адресат);
		Если ДатаЗапрета = Неопределено Тогда
			Для Каждого Группа Из ДополнительныеПараметры.ГруппыПользователя Цикл
				Дата = Адресаты.Получить(Группа);
				Если ДатаЗапрета = Неопределено Тогда
					ДатаЗапрета = Дата;
					Адресат = Группа;
				ИначеЕсли Дата <> Неопределено И ДатаЗапрета < Дата Тогда
					ДатаЗапрета = Дата;
					Адресат = Группа;
				КонецЕсли;
			КонецЦикла;
			Если ДатаЗапрета = Неопределено Тогда
				Адресат = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей;
				ДатаЗапрета = Адресаты.Получить(Адресат);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Адресат = ДополнительныеПараметры.УзелПроверкиЗапретаЗагрузки;
		ДатаЗапрета = Адресаты.Получить(Адресат);
		Если ДатаЗапрета = Неопределено Тогда
			Адресат = ДополнительныеПараметры.ПустойУзелПланаОбмена;
			ДатаЗапрета = Адресаты.Получить(Адресат);
		КонецЕсли;
		Если ДатаЗапрета = Неопределено Тогда
			Адресат = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз;
			ДатаЗапрета = Адресаты.Получить(Адресат);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДатаЗапрета;
	
КонецФункции

// Для функции НайденЗапретИзмененияДанных.
Функция СообщениеОЗапретах(Запреты,
                           ОписаниеДанных,
                           СвойстваРазделов,
                           ПоискЗапретовЗагрузки,
                           СтруктурноеОписание)
	
	НоваяВерсия = ОписаниеДанных.НоваяВерсия;
	Текст = ПредставлениеДанных(ОписаниеДанных.Данные);
	
	Если СтруктурноеОписание Тогда
		ОписаниеОшибки = Новый Структура;
		ОписаниеОшибки.Вставить("ПредставлениеДанных", Текст);
		ОписаниеОшибки.Вставить("Запреты", Новый ТаблицаЗначений);
		Колонки = ОписаниеОшибки.Запреты.Колонки;
		Колонки.Добавить("Дата",            Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		Колонки.Добавить("Раздел",          Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(100, ДопустимаяДлина.Переменная)));
		Колонки.Добавить("Объект",          Метаданные.ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.Тип);
		Колонки.Добавить("ДатаЗапрета",     Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
		Колонки.Добавить("ОбщаяДата",       Новый ОписаниеТипов("Булево"));
		Колонки.Добавить("ДляВсехОбъектов", Новый ОписаниеТипов("Булево"));
		Колонки.Добавить("Адресат",         Метаданные.ОпределяемыеТипы.АдресатЗапретаИзменения.Тип);
		Колонки.Добавить("Описание",        Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(1000,ДопустимаяДлина.Переменная)));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Если ПоискЗапретовЗагрузки Тогда
			Если НоваяВерсия Тогда
				Шаблон = НСтр("ru = '%1 невозможно загрузить в запрещенный период.'");
			Иначе
				Шаблон = НСтр("ru = '%1 в запрещенном периоде невозможно заменить загружаемыми данными.'");
			КонецЕсли;
		Иначе
			Если НоваяВерсия Тогда
				Шаблон = НСтр("ru = '%1 невозможно поместить в запрещенный период.'");
			Иначе
				Шаблон = НСтр("ru = '%1 в запрещенном периоде невозможно изменить.'");
			КонецЕсли;
		КонецЕсли;
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Текст) + Символы.ПС + Символы.ПС;
	КонецЕсли;
	
	ПустойРаздел = ДатыЗапретаИзмененияСлужебный.ПустаяСсылка(
		Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
	Если СтруктурноеОписание Тогда
		ОписаниеОшибки.Вставить("ЗаголовокОшибки", СокрЛП(Текст));
	КонецЕсли;
	ТекстОшибки = Текст;
	
	Для Каждого Запрет Из Запреты Цикл
		Текст = "";
		Проверка = Запрет.Данные;
		Если Запрет.Раздел = Запрет.Объект Тогда
			Если Запрет.Раздел = ПустойРаздел Тогда
				Текст = Текст + НСтр("ru = 'Дате %1'");
			Иначе
				Текст = Текст + НСтр("ru = 'Дате %1 по разделу ""%2""'");
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(СвойстваРазделов.ЕдинственныйРаздел) Тогда
			Текст = Текст + НСтр("ru = 'Дате %1 по объекту ""%3""'");
		Иначе
			Текст = Текст + НСтр("ru = 'Дате %1 по объекту ""%3"" раздела ""%2""'");
		КонецЕсли;
		Если ПоискЗапретовЗагрузки Тогда
			Текст = Текст + " " + НСтр("ru = 'соответствует запрет загрузки данных'") + " ";
		Иначе
			Текст = Текст + " " + НСтр("ru = 'соответствует запрет изменения данных'") + " ";
		КонецЕсли;
		Если Запрет.Адресат = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей Тогда
			Текст = Текст + НСтр("ru = 'для всех пользователей'");
			
		ИначеЕсли Запрет.Адресат = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз Тогда
			Текст = Текст + НСтр("ru = 'для всех информационных баз'");
			
		ИначеЕсли ТипЗнч(Запрет.Адресат) = Тип("СправочникСсылка.ГруппыПользователей")
		      ИЛИ ТипЗнч(Запрет.Адресат) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			Текст = Текст + НСтр("ru = 'для группы пользователей ""%4""'");
			
		ИначеЕсли ТипЗнч(Запрет.Адресат) = Тип("СправочникСсылка.Пользователи")
		      ИЛИ ТипЗнч(Запрет.Адресат) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			Текст = Текст + НСтр("ru = 'для пользователя ""%4""'");
			
		ИначеЕсли ЗначениеЗаполнено(Запрет.Адресат) Тогда
			Текст = Текст + НСтр("ru = 'для информационной базы ""%4""'");
		Иначе
			Текст = Текст + НСтр("ru = 'для всех информационных баз ""%6""'");
		КонецЕсли;
		Текст = Текст + " " + НСтр("ru = 'по %5'");
		Если Не СвойстваРазделов.БезРазделовИОбъектов Тогда
			Если ЗначениеЗаполнено(Запрет.Раздел) Тогда
				Если Запрет.Объект = Запрет.Раздел Тогда
					Текст = Текст + " " + НСтр("ru = '(запрет установлен на раздел ""%2"")'");
				ИначеЕсли ЗначениеЗаполнено(СвойстваРазделов.ЕдинственныйРаздел) Тогда
					Текст = Текст + " " + НСтр("ru = '(запрет установлен на объект ""%3"")'");
				Иначе
					Текст = Текст + " " + НСтр("ru = '(запрет установлен на объект ""%3"" раздела ""%2"")'");
				КонецЕсли;
			Иначе
				Текст = Текст + " " + НСтр("ru = '(установлена общая дата запрета)'");
			КонецЕсли;
		КонецЕсли;
		Текст = СтрЗаменить(Текст, "%1", Формат(Проверка.Дата, "ДЛФ=Д"));
		Текст = СтрЗаменить(Текст, "%2", Проверка.Раздел);
		Текст = СтрЗаменить(Текст, "%3", Проверка.Объект);
		Текст = СтрЗаменить(Текст, "%4", Запрет.Адресат);
		Текст = СтрЗаменить(Текст, "%5", Формат(Запрет.Дата, "ДЛФ=Д"));
		Текст = СтрЗаменить(Текст, "%6", Запрет.Адресат.Метаданные().Представление());
		
		ТекстОшибки = ТекстОшибки + Текст + Символы.ПС + Символы.ПС;
		
		Если СтруктурноеОписание Тогда
			СтрокаОписанияОшибки = ОписаниеОшибки.Запреты.Добавить();
			СтрокаОписанияОшибки.Дата        = Проверка.Дата;
			СтрокаОписанияОшибки.Раздел      = СвойстваРазделов.Разделы.Получить(Проверка.Раздел).Имя;
			СтрокаОписанияОшибки.Объект      = ?(Проверка.Объект = Проверка.Раздел, Неопределено, Проверка.Объект);
			СтрокаОписанияОшибки.ДатаЗапрета = Запрет.Дата;
			СтрокаОписанияОшибки.ОбщаяДата   = ?(ЗначениеЗаполнено(Запрет.Раздел), Ложь, Истина);
			Если Запрет.Раздел = Запрет.Объект Тогда
				СтрокаОписанияОшибки.ДляВсехОбъектов = Истина;
			Иначе
				СтрокаОписанияОшибки.ДляВсехОбъектов = Ложь;
			КонецЕсли;
			СтрокаОписанияОшибки.Адресат  = Запрет.Адресат;
			СтрокаОписанияОшибки.Описание = Текст;
		КонецЕсли;
	КонецЦикла;
	
	Если Не СтруктурноеОписание Тогда
		ОписаниеОшибки = СокрП(ТекстОшибки);
	КонецЕсли;
	
	Возврат ОписаниеОшибки;
	
КонецФункции

// Для функции СообщениеОЗапретах.
Функция ПредставлениеДанных(Данные)
	
	Если ТипЗнч(Данные) = Тип("Строка") Тогда
		Возврат СокрЛП(Данные);
	КонецЕсли;
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		ЭтоРегистр = Истина;
		Если ТипЗнч(Данные.Регистр) = Тип("Строка") Тогда
			ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(Данные.Регистр);
		Иначе
			ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Данные.Регистр));
		КонецЕсли;
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Данные));
		ЭтоРегистр = ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных);
	КонецЕсли;
	
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Если ЭтоРегистр Тогда
		ПредставлениеДанных = ОбъектМетаданных.Представление();
		
		КоличествоПолей = 0;
		Для каждого ЭлементОтбора Из Данные.Отбор Цикл
			Если ЭлементОтбора.Использование Тогда
				КоличествоПолей = КоличествоПолей + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличествоПолей = 1 Тогда
			ПредставлениеДанных = ПредставлениеДанных
				+ " " + НСтр("ru = 'с полем'")  + " " + Строка(Данные.Отбор);
			
		ИначеЕсли КоличествоПолей > 1 Тогда
			ПредставлениеДанных = ПредставлениеДанных
				+ " " + НСтр("ru = 'с полями'") + " " + Строка(Данные.Отбор);
		КонецЕсли;
	ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		ПредставлениеДанных = Строка(Данные);
	Иначе
		ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)", Строка(Данные), ОбъектМетаданных.Представление());
	КонецЕсли;
		
	Возврат ПредставлениеДанных;
	
КонецФункции

#КонецОбласти
