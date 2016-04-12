require 'parayaz/version'

module Parayaz
  def parayaz(currency="Türk Lirası")
    @number = self
    @currency = currency

    minus = @number < 0

    @number *= -1 if minus

    price, cents = @number.to_s.split('.')

    text = convert_to_text(price)
    text += " #{@currency}" unless text.empty?

    if cents && cents.to_i > 0
      if cents.size == 1
        cents = (cents.to_i * 10).to_s
      end
      if cents.size > 2
        cents = cents[0..1]
      end
      text += ',' unless text.empty?
      text += convert_to_text(cents) + ((@currency.in?(["Türk Lirası","TRY","TRL","TL"])) ? " Kuruş" : " Cents")
    end
    (minus ? '(Eksi)' : '') + text
  end

  private
  def say_1_digit_text(n)
    one_digits_text = ['', 'Bir', 'İki', 'Üç', 'Dört', 'Beş', 'Altı', 'Yedi', 'Sekiz', 'Dokuz']
    one_digits_text[n]
  end

  def say_2_digit_text(n)
    two_digits_text = ['', 'On', 'Yirmi', 'Otuz', 'Kırk', 'Elli', 'Altmış', 'Yetmiş', 'Seksen', 'Doksan']
    two_digits_text[n[0]] + say_1_digit_text(n[1])
  end

  def say_3_digit_text(n)
    one = n[0] == 1 ? 'Yüz' : say_1_digit_text(n[0])
    one += 'Yüz' unless n[0] == 1 || n[0] == 0
    n.delete_at(0)
    one + say_2_digit_text(n)
  end

  def convert_to_text(number)
    number = number.to_i
    lots = ['', 'Bin', 'Milyon', 'Milyar', 'Trilyon', 'Katrilyon', 'Kentilyon', 'Seksilyon', 'Septilyon']

    text = ''

    i = 0
    while !number.zero?
      number, r = number.divmod(1000)
      size = r.to_s.split('').map(&:to_i).size
      new_text = r == 1 && i == 1 ? '' : eval("say_#{size}_digit_text(#{size == 1 ? r : r.to_s.split('').map(&:to_i)})")

      unless r == 0
        new_text += lots[i]
      end

      text = new_text  +  text
      i += 1
    end
    text
  end
end

class Numeric
  include Parayaz
end
