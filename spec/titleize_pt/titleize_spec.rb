# -*- encoding: utf-8 -*-

require "spec_helper"

# Some of the following tests were taken from the original module (git.io/i0UnkA)
describe "TitleizePT module" do
  it "should return a string if a string is given" do
    "this".titleize_locale.must_be_instance_of String
  end

  it "should return an ActiveSupport::Multibyte::Chars object if one is given" do
    "this".mb_chars.titleize_locale.must_be_instance_of ActiveSupport::Multibyte::Chars
  end

  it "should properly capitalize titles that contain unicode characters" do
    "café périferôl".titleize_pt.must_equal "Café Périferôl"
    "órgão partidário".titleize_pt.must_equal "Órgão Partidário"
  end

  it "should return the same result for `string.titleize_pt` and `mb_chars.titleize_pt`" do
    "café périferôl".titleize_pt.must_equal "café périferôl".mb_chars.titleize_pt.to_s
  end

  it "should fix all-caps titles" do
    "GUIA DE SOBREVIVÊNCIA".titleize_pt.must_equal "Guia de Sobrevivência"
  end

  it "should capitalize the first letter of regular words" do
    "cat beats monkey".titleize_locale.must_equal "Cat Beats Monkey"
  end

  it "should not capitalize listed words" do
    TitleizePT::WORDS[:en].each do |word|
      "first #{ word } last".titleize_locale.must_equal "First #{ word } Last"
    end
  end

  it "should downcase a listed word if it is capitalized" do
    TitleizePT::WORDS[:en].each do |word|
      "first #{ word.capitalize } last".titleize_locale.must_equal "First #{ word } Last"
    end
  end

  it "should not think a quotation mark makes a dot word" do
    "'quoted.' yes.".titleize_locale.must_equal "'Quoted.' Yes."
    "ends with 'quotation.'".titleize_locale.must_equal "Ends With 'Quotation.'"
  end

  it "should not capitalize words that start with a number" do
    "2lmc".titleize_locale.must_equal "2lmc"
  end

  it "should handle hyphenated words" do
    "the la-la land".titleize_locale.must_equal "The La-La Land"
  end

  it "should handle non-breaking hyphens" do
    "non‑breaking hyphen".titleize_locale.must_equal "Non‑Breaking Hyphen"
  end

  it "should capitalize a listed word if it is the first word" do
    TitleizePT::WORDS[:en].each do |word|
      "#{ word } is listed".titleize_locale.must_equal "#{ word.capitalize } Is Listed"
    end
  end

  it "should leave all-uppercase words untouched" do
    "um pedido HTTP".titleize_pt.must_equal "Um Pedido HTTP"
  end

  it "should not modify its receiver" do
    title = "olá, mundo"
    title.titleize_pt.must_equal "Olá, Mundo"
    title.must_equal "olá, mundo"

    title = "OLÁ, MUNDO"
    title.titleize_pt.must_equal "Olá, Mundo"
    title.must_equal "OLÁ, MUNDO"
  end
end
