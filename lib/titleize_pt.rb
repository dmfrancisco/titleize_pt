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

    if title[/[[:lower:]]/]
      # Similar to the existent `titleize` method from ActiveSupport but respect acronyms
      title = title.split.map { |w| /^\p{Upper}*$/.match(w) ? w : w.downcase }.join(' ')
    else
      title.downcase! # If the entire title is all-uppercase, assume it needs to be fixed
    end

    title = title.to_s.gsub(/\b('?[\S])/u) { ActiveSupport::Multibyte::Unicode.apply_mapping $1, :uppercase_mapping }
    words = title.split
    first = words.shift

    if words.empty?
      first # The first word should always be capitalized
    else
      first +" "+ words.map { |w| WORDS[locale].include?(w.downcase) ? w.downcase : w }.join(' ')
    end
  end
end

class String
  def titleize_pt
    TitleizePT.titleize_pt(self.mb_chars)
  end

  def titleize_locale(locale = nil)
    TitleizePT.titleize_locale(self.mb_chars, locale)
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
