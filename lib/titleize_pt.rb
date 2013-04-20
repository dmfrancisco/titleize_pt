# -*- encoding: utf-8 -*-

require 'active_support/multibyte'
require 'active_support/core_ext/string'

# Creates properly capitalized titles (original implementation found at git.io/i0UnkA).
# For example, "a lovely and talented title" becomes "A Lovely and Talented Title".
#
# Supports unicode characters (using ActiveSupport::Multibyte::Chars).
# For example, "OLÁ MUNDO" becomes "Olá Mundo" instead of "OlÁ Mundo".
#
module TitleizePT
  WORDS = {
    # List of words from the "New York Times Manual of Style"
    en: %w{ a an and as at but by en for if in of on or the to v v. via vs vs. },

    # Portuguese words that should not be capitalized. To improve the list, the
    # "Acordo Ortográfico de 1945" document may be a good resource.
    # Wikipedia also has guidelines on this: http://goo.gl/28T0h
    pt: %w{ a as da das de do dos e em na nas no nos o os para por sobre um uns uma umas }
  }

  def self.titleize_pt(title)
    titleize_locale(title, :pt)
  end

  def self.titleize_locale(title, locale = nil)
    locale = (WORDS.key?(I18n.locale) ? I18n.locale : :pt) if locale.blank?

    title = title.mb_chars

    # If the title is all-uppercase, assume it needs to be fixed and downcase it entirely
    title.downcase! unless title[/[[:lower:]]/]

    title.split(/(\b)/).each_with_index.map do |word, index|
      if word =~ /^\p{Upper}{2,}$/ # Respect acronyms
        word
      elsif WORDS[locale].include? word.downcase and not index.zero?
        word.downcase!
      else
        word.capitalize!
      end
    end.join($1)
  end
end

class String
  def titleize_pt
    TitleizePT.titleize_pt(self)
  end

  def titleize_locale(locale = nil)
    TitleizePT.titleize_locale(self, locale)
  end

  alias_method :titlecase_pt, :titleize_pt
  alias_method :titlecase_locale, :titleize_locale
end

module ActiveSupport::Multibyte
  class Chars
    def titleize_pt
      chars TitleizePT.titleize_pt(self)
    end

    def titleize_locale(locale = nil)
      chars TitleizePT.titleize_locale(self, locale)
    end

    alias_method :titlecase_pt, :titleize_pt
    alias_method :titlecase_locale, :titleize_locale
  end
end
