money = input(':');
exchange = input(':');

dollar = money / exchange;
floor(dollar)
cent = 100*(dollar - floor(dollar));
floor(cent)