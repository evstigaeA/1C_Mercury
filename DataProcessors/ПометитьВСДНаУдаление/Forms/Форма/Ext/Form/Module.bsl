﻿
&НаСервере
Процедура ВыполнитьНаСервере()
	
	Обработки.ПометитьВСДНаУдаление.ПоменитьВСДДокументыНаУдаление();
	
КонецПроцедуры

&НаКлиенте
Процедура Выполнитть(Команда)
	ВыполнитьНаСервере();
КонецПроцедуры
